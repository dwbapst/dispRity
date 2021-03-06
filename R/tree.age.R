#' @title Calculating the age of nodes and tips in a tree.
#'
#' @description Calculates the age of each node and tip in a tree give the height of the tree or some specified age.
#'
#' @param tree A \code{phylo} object.
#' @param age The age of the tree. If missing the age is set to be the tree height.
#' @param order Either "past" if the units express time since the present (e.g. million years ago), or "present" if the unit is expressed in time since the root.
#'
#' @examples
#' ## A dated random phylogeny with a root 50 units of time old.
#' tree.age(rtree(10), age = 50)
#' ## A random tree with the distance since the root.
#' tree.age(rtree(10), order = 'present')
#'
#' @seealso \code{\link{slice.tree}}, \code{\link{time.subsamples}}.
#'
#' @author Thomas Guillerme

#Modified from [R-sig-phylo] nodes and taxa depth II - 21/06/2011 - Paolo Piras - ppiras(at)uniroma3.it

tree.age <- function(tree, age, order = 'past'){

#SANITYZING

    #tree
    check.class(tree, 'phylo', ' must be a phylo object.')

    #age
    if(missing(age)) {
    	#Using the tree height as age if age is missing
        age <- max(dist.nodes(tree)[, Ntip(tree)+1])
    }
    check.class(age, 'numeric', ' must be a numerical value.')
    check.length(age, '1', ' must a a single value.')

    #order
    check.class(order, 'character', ' must be \'past\' or \'present\'.')
    if(order != 'past') {
        if(order != 'present') {
            stop('order must be \'past\' or \'present\'.')
        }
    }

#CALCULATE THE EDGES AGE

    if(age != 0) {
        ages.table <- tree.age_scale(tree.age_table(tree), age)
    } else {
        ages.table <- tree.age_table(tree)
    }

    #Type
    if(order != 'past') {
        ages.table$ages <- round(ages.table$ages, digits = 7)
    } else {
        tree.height <- max(ages.table$ages)
        ages.table$ages <- round(abs(ages.table$ages - tree.height), digits = 3)
    }

    #Output
    #ages.table <- round(ages.table[1, ], digits = 3)
    return(ages.table)
}
