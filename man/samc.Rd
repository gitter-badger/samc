% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/samc.R
\docType{methods}
\name{samc}
\alias{samc}
\alias{samc,RasterLayer,RasterLayer,RasterLayer,logical,function-method}
\alias{samc,RasterLayer,RasterLayer,missing,logical,function-method}
\alias{samc,matrix,matrix,matrix,missing,function-method}
\alias{samc,matrix,matrix,missing,missing,function-method}
\title{Create an samc object}
\usage{
samc(resistance, absorption, fidelity, latlon, tr_fun, ...)


  \S4method{samc}{RasterLayer,RasterLayer,RasterLayer,logical,`function`}(resistance,
  absorption, fidelity, latlon, tr_fun, override = FALSE)


  \S4method{samc}{RasterLayer,RasterLayer,missing,logical,`function`}(resistance,
  absorption, latlon, tr_fun, override = FALSE)

\S4method{samc}{matrix,matrix,matrix,missing,`function`}(resistance,
  absorption, fidelity, tr_fun, override = FALSE)

\S4method{samc}{matrix,matrix,missing,missing,`function`}(resistance,
  absorption, tr_fun, override = FALSE)
}
\arguments{
\item{resistance}{A \code{\link[raster]{RasterLayer-class}} or \code{\link[base]{matrix}}}

\item{absorption}{A \code{\link[raster]{RasterLayer-class}} or \code{\link[base]{matrix}}}

\item{fidelity}{A \code{\link[raster]{RasterLayer-class}} or \code{\link[base]{matrix}}}

\item{latlon}{Logical (\code{TRUE} or \code{FALSE}) indicating whether the rasters use latitude/longitude}

\item{tr_fun}{A function to calculate the transition values in the \code{\link[gdistance]{transition}} function}

\item{...}{Placeholder}

\item{override}{Optional flag to prevent accidentally running memory intensive functions. Defaults to \code{FALSE}}
}
\value{
A spatial absorbing Markov chain object
}
\description{
Create an samc object that contains the absorbing Markov chain data
}
\details{
This function is used to create a \code{\link{samc-class}} object from
landscape data. Some of the inputs are mandatory, whereas others are
optional. The different landscape data inputs must be the same type (a matrix
or RasterLayer), and have identical properties, including dimensions,
location of NA cells, and CRS (if using RasterLayers).

The resistance and absorption inputs are always mandatory, whereas the
fidelity input is optional. If the fidelity input is not provided, then it it
is assumed that there is no site fidelity (i.e., individuals will always move
to an adjacent cell each time step).

The latlon parameter is required if the landscape data inputs are RasterLayer
objects. The package does not attempt to determine this automatically, and it
does not assume a default. Users must set it to TRUE if they are using
latitude and longitude data.

The tr_fun parameter is mandatory. It used when calculating the values for
the transition matrix. Internally, this is passed to the \code{\link[gdistance]{transition}}
function in the gdistance package to create the transition matrix.

The override parameter is optional. To prevent users from unintentionally
running memory intensive versions of functions that could make their systems
non-responsive or crash software, it is set to FALSE by default. For various
reasons, it can be set to TRUE. In particular, a user might do this if they
are using a very small landscape dataset, or perhaps for a moderately sized
dataset if they have access to a system with exceptionally large amounts of
RAM. Before setting this to TRUE, users should read the Performance vignette/
article to understand the expected memory requirements. They should also
consider starting with scaled down version of their data and then gradually
scaling back up while monitoring their memory usage as a means to gauge what
is reasonable for their system.
}
\examples{
# "Load" the data. In this case we are using data built into the package.
# In practice, users will likely load raster data using the raster() function
# from the raster package.
res_data <- samc::ex_res_data
abs_data <- samc::ex_abs_data
occ_data <- samc::ex_occ_data


# Make sure our data meets the basic input requirements of the package using
# the check() function.
check(res_data, abs_data)
check(res_data, occ_data)


# Create a `samc-class` object with the resistance and absorption data using
# the samc() function. We use the recipricol of the arithmetic mean for
# calculating the transition matrix. Note, the input data here are matrices,
# not RasterLayers. If using RasterLayers, the latlon parameter must be set.
samc_obj <- samc(res_data, abs_data, tr_fun = function(x) 1/mean(x))


# Convert the occupancy data to probability of occurrence
occ_prob_data <- occ_data / sum(occ_data, na.rm = TRUE)


# Calculate short- and long-term metrics using the analytical functions
short_mort <- mortality(samc_obj, occ_prob_data, time = 50)
short_dist <- distribution(samc_obj, origin = 3, time = 50)
long_disp <- dispersal(samc_obj, occ_prob_data)
visit <- visitation(samc_obj, dest = 4)
surv <- survival(samc_obj)


# Use the map() function to turn vector results into RasterLayer objects.
short_mort_map <- map(samc_obj, short_mort)
short_dist_map <- map(samc_obj, short_dist)
long_disp_map <- map(samc_obj, long_disp)
visit_map <- map(samc_obj, visit)
surv_map <- map(samc_obj, surv)
}
