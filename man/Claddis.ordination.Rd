% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/Claddis.ordination.R
\name{Claddis.ordination}
\alias{Claddis.ordination}
\title{Imports data from Claddis}
\usage{
Claddis.ordination(data, distance = "Gower", transform = "arcsine_sqrt", k,
  ...)
}
\arguments{
\item{data}{Data from Claddis::ReadMorphNexus.}

\item{distance}{Distance type to be computed by \code{\link[Claddis]{MorphDistMatrix}}. Can be either \code{"Gower"}, \code{"GED"}, \code{"Max"}, \code{"Comp"}}

\item{transform}{Whether to transform the proportional distances (for Gower and Max). Options are \code{"none"}, \code{"sqrt"}, or \code{"arcsine_sqrt"} (the default).}

\item{k}{The number of dimensions in the ordination. If left empty, the number of dimensions is set to number of rows - 1.}

\item{...}{Any optional arguments to be passed to \code{\link[stats]{cmdscale}}.}
}
\description{
Takes Claddis data and computes both the distance and the ordination matrix
}
\examples{
\dontrun{
require(Claddis)

## Creating an ordination of the distance matrix of Claddis example data
Claddis.ordination(Claddis::Michaux1989)
}

}
\seealso{
\code{\link[Claddis]{MorphDistMatrix}}, \code{\link[Claddis]{ReadMorphNexus}}, \code{\link[Claddis]{MakeMorphNexus}}, \code{\link[stats]{cmdscale}}, \code{\link{custom.subsamples}}, \code{\link{time.subsamples}}, \code{\link{boot.matrix}}, \code{\link{dispRity}}.
}
\author{
Thomas Guillerme
}
