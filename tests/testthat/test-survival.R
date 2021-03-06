context("Survival")

library(raster)


# Create the samc object
samc_obj <- samc(res, abs, fid, tr_fun = function(x) 1/mean(x), override = TRUE)

# Extract Q
Q <- samc_obj@p[-nrow(samc_obj@p), -ncol(samc_obj@p)]
Q <- as.matrix(Q)

# Create an indentity matrix
I <- diag(nrow(Q))

# Prepare the occupancy data
occ_ras <- raster(occ)
pv <- as.vector(occ_ras)
pv <- pv[is.finite(pv)]


# Run the tests
test_that("Testing survival(samc)", {
  r1 <- survival(samc_obj)

  v1 <- numeric(nrow(Q))
  v1[] <- 1

  r2 <- solve(I - Q) %*% v1

  # Verify equality
  expect_equal(as.vector(r1), as.vector(r2))
})

test_that("Testing survival(samc, occ)", {
  # Calculate psi*z using survival(samc, occ)
  r1 <- survival(samc_obj, occ)

  v1 <- numeric(nrow(Q))
  v1[] <- 1

  r2 <- pv %*% solve(I - Q) %*% v1

  # Verify equality
  expect_equal(as.vector(r1), as.vector(r2))
})
