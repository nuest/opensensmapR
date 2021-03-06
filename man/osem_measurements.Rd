% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/measurement.R
\name{osem_measurements}
\alias{osem_measurements}
\alias{osem_measurements.default}
\alias{osem_measurements.bbox}
\alias{osem_measurements.sensebox}
\title{Get the Measurements of a Phenomenon on opensensemap.org}
\usage{
osem_measurements(x, ...)

\method{osem_measurements}{default}(x, ...)

\method{osem_measurements}{bbox}(x, phenomenon, exposure = NA, from = NA,
  to = NA, columns = NA, ..., endpoint = osem_endpoint(), progress = T)

\method{osem_measurements}{sensebox}(x, phenomenon, exposure = NA,
  from = NA, to = NA, columns = NA, ..., endpoint = osem_endpoint(),
  progress = T)
}
\arguments{
\item{x}{Depending on the method, either
\enumerate{
  \item a \code{chr} specifying the phenomenon, see \code{phenomenon}
  \item a \code{\link[sf]{st_bbox}} to select sensors spatially,
  \item a \code{sensebox data.frame} to select boxes from which
    measurements will be retrieved,
}}

\item{...}{see parameters below}

\item{phenomenon}{The phenomenon to retrieve measurements for}

\item{exposure}{Filter sensors by their exposure ('indoor', 'outdoor', 'mobile')}

\item{from}{A \code{POSIXt} like object to select a time interval}

\item{to}{A \code{POSIXt} like object to select a time interval}

\item{columns}{Select specific column in the output (see openSenseMap API documentation)}

\item{endpoint}{The URL of the openSenseMap API}

\item{progress}{Whether to print download progress information}
}
\value{
An \code{osem_measurements data.frame} containing the
  requested measurements
}
\description{
Measurements can be retrieved either for a set of boxes, or through a spatial
bounding box filter. To get all measurements, the \code{default} function applies
a bounding box spanning the whole world.
}
\section{Methods (by class)}{
\itemize{
\item \code{default}: Get measurements from \strong{all} senseBoxes.

\item \code{bbox}: Get measurements by a spatial filter.

\item \code{sensebox}: Get measurements from a set of senseBoxes.
}}

\examples{
# get measurements from all boxes
m1 = osem_measurements('Windrichtung')

# get measurements from sensors within a bounding box
bbox = structure(c(7, 51, 8, 52), class = 'bbox')
m2 = osem_measurements(bbox, 'Temperatur')

points = sf::st_multipoint(matrix(c(7.5, 7.8, 51.7, 52), 2, 2))
bbox2 = sf::st_bbox(points)
m3 = osem_measurements(bbox2, 'Temperatur', exposure = 'outdoor')

# get measurements from a set of boxes
b = osem_boxes(grouptag = 'ifgi')
m4 = osem_measurements(b, phenomenon = 'Temperatur')

# ...or a single box
b = osem_box('57000b8745fd40c8196ad04c')
m5 = osem_measurements(b, phenomenon = 'Temperatur')

}
\seealso{
\href{https://docs.opensensemap.org/#api-Measurements-getDataMulti}{openSenseMap API documentation (web)}

\code{\link{osem_boxes}}
}
