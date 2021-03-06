#' @title Time slicing a tree.
#'
#' @usage slice.tree(tree, age, model, FAD, LAD)
#' 
#' @description Time slicing through a phylogenetic tree (function modified from paleotree::timeSliceTree).
#'
#' @param tree A \code{phylo} object with a \code{root.time} element.
#' @param age A single \code{numeric} value indicating where to perform the slice.
#' @param model One of the following models: \code{"acctran"}, \code{"deltran"}, \code{"punctuated"} or \code{"gradual"}. Is ignored if \code{method = "discrete"}.
#' @param FAD,LAD The first and last occurrence data.
#' 
#' @seealso \code{\link[paleotree]{timeSliceTree}}, \code{\link{time.subsamples}}.
#'
#' @examples
#' set.seed(1)
#' ## Generate a random ultrametric tree
#' tree <- rcoal(20)
#' 
#' ## Add some node labels
#' tree$node.label <- letters[1:19]
#' 
#' ## Add its root time
#' tree$root.time <- max(tree.age(tree)$ages)
#' 
#' ## Slice the tree at age 0.75
#' tree_75 <- slice.tree(tree, age = 0.75, "deltran")
#'
#' @author Thomas Guillerme
#' @export
#' 

# DEBUG
# warning("DEBUG slice.tree")
# source("sanitizing.R")

#Function modified from paleotree::timeSliceTree
slice.tree <- function(tree, age, model, FAD, LAD) {

    #For adding modules (i.e. models) follow the format
    # tree_slice<-timeSliceTree(tree, age, drop.extinct = TRUE, plot = FALSE)
    # for (tip in 1:Ntip(tree_slice)) {
    #   tree_sliced$tip.label[tip]<-module(tree, tree_slice$tip.label[tip], tree_slice)
    # }

    #SANITIZING
    check.class(tree, "phylo")
    check.class(age, c("numeric", "integer"), " must be a single numeric value.")
    check.length(age, 1, " must be a single numeric value.")
    check.class(model, "character", " must be one of the following: acctran, deltran, punctuated, gradual.")
    model <- tolower(model)
    check.method(model, c("acctran", "deltran", "punctuated", "gradual"), "Slicing model")

    #FAD/LAD
    if(missing(FAD)) {
        FAD <- tree.age(tree)
    }
    if(missing(LAD)) {
        LAD <- tree.age(tree)
    }

    #SLICING A TREE
    #Creating the tree.age matrix
    tree_age <- tree.age(tree)

    #Running the timeSliceTree function (remove warning, called as a message in the original function)
    if(age > max(tree_age[,1])) {
        ## Don't slice the tree if age is too old
        return(NA)
    } else {
        suppressMessages(
            tree_slice <- paleotree::timeSliceTree(tree, age, drop.extinct = TRUE, plot = FALSE)
        )
    }

    #renaming the tree_slice
    tree_sliced <- tree_slice

    #Correcting the sliced tree
    for (tip in 1:Ntip(tree_slice)) {

        #Check if the tree is not sliced at the exact age of a tip (e.g. time=0)
        if(tree_age[which(tree_age[, 2] == tree_slice$tip.label[tip]), 1] != age) {

            #Check if the age of the tip is not in between the FAD/LAD
            if(!FAD[which(FAD[, 2] == tree_slice$tip.label[tip]),1] >= age & LAD[which(LAD[, 2] == tree_slice$tip.label[tip]), 1] <= age) {

                #Chose the tip/node following the given model
                if(model == "punctuated") {
                    selected_model <- sample(c("deltran", "acctran"), 1)
                } else {
                    selected_model <- model
                }

                if(selected_model == "deltran") {
                    #Parent
                    tree_sliced$tip.label[tip] <- slice.tree_DELTRAN(tree, tree_slice$tip.label[tip], tree_slice)
                }

                if(selected_model == "acctran") {
                    #Offspring
                    tree_sliced$tip.label[tip] <- slice.tree_ACCTRAN(tree, tree_slice$tip.label[tip], tree_slice)
                }

                if(selected_model == "gradual") {
                    #Closest
                    tree_sliced$tip.label[tip] <- slice.tree_GRADUAL(tree, tree_slice$tip.label[tip], tree_slice)
                }              
            }
        } 
    }

    return(tree_sliced)

}