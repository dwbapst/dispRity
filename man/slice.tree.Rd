% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/slice.tree.R
\name{slice.tree}
\alias{slice.tree}
\title{Time slicing a tree.}
\usage{
slice.tree(tree, age, model, FAD, LAD)
}
\arguments{
\item{tree}{A \code{phylo} object with a \code{root.time} element.}

\item{age}{A single \code{numeric} value indicating where to perform the slice.}

\item{model}{One of the following models: \code{"acctran"}, \code{"deltran"}, \code{"punctuated"} or \code{"gradual"}. Is ignored if \code{method = "discrete"}.}

\item{FAD, LAD}{The first and last occurrence data.}
}
\description{
Time slicing through a phylogenetic tree (function modified from paleotree::timeSliceTree).
}
\examples{
set.seed(1)
## Generate a random ultrametric tree
tree <- rcoal(20)

## Add some node labels
tree$node.label <- letters[1:19]

## Add its root time
tree$root.time <- max(tree.age(tree)$ages)

## Slice the tree at age 0.75
tree_75 <- slice.tree(tree, age = 0.75, "deltran")

}
\seealso{
\code{\link[paleotree]{timeSliceTree}}, \code{\link{time.subsamples}}.
}
\author{
Thomas Guillerme
}
