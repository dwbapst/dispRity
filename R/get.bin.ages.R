#' @title Get time bins ages
#'
#' @description Gets time bins for a specific tree using stratigraphy
#'
#' @param tree A \code{phylo} object with a \code{$root.time} component
#' @param what Which data to output. Can be \code{"Start"}, \code{"End"} (default), \code{"Range"} or \code{"Midpoint"}.
#' @param type The type of stratigraphic frame. Can be \code{"Age"} (default), \code{"Eon"}, \code{"Epoch"}, \code{"Era"} or \code{"Period"}.
#' @param ICS The reference year of the International Commission on Stratigraphy (default = \code{2015}).
#' 
#' @examples
#' ## Loading the data
#' data(BeckLee_tree)
#' data(BeckLee_mat50)
#' 
#' ## Getting the stratigraphic data
#' stratigraphy <- get.bin.ages(BeckLee_tree)
#' 
#' ## Making stratigraphic time subsamples
#' time.subsamples(BeckLee_mat50, tree = BeckLee_tree, method = "discrete",
#'                 time = stratigraphy)
#'
#' @seealso \code{\link{time.subsamples}}
#' 
#' @author Thomas Guillerme
#' @import geoscale timescales
#' @export

get.bin.ages <- function(tree, what = "End", type = "Age", ICS = 2015) {    
    ## Tree
    # check.class(tree, "phylo")
    if(is.null(tree$root.time)) {
        stop("The tree must have a root time element (tree$root.time).")
    }

    ## What
    check.method(what, c("Start", "End", "Range", "Midpoint"), msg = "'what' argument")

    ## Type
    check.method(type, c("Age", "Eon", "Epoch", "Era", "Period"), msg = "'type' argument")

    ## ICS
    check.class(ICS, "numeric")
    check.length(ICS, 1, errorif = FALSE, msg = " must be a year from 2008 to the present.")
    ICS_available <- match(paste0("ICS", ICS), names(geoscale::timescales))
    if(is.na(ICS_available)) {
        stop(paste0("No stratigraphic data found for ", paste0("ICS", ICS), ".\nAvailable years are: ", paste(names(geoscale::timescales), collapse = ", "), "."))
    } else {
        ## Selecting the ICS
        stratigraphy <- geoscale::timescales[[paste0("ICS", ICS)]]
        ## Selecting the column of interest
        what <- which(colnames(stratigraphy) == what)
        ## Selecting the types of interests
        stratigraphy <- stratigraphy[which(as.character(stratigraphy$Type) == type),]
    }

    ## Get all the strats covered by the tree
    strats <- which(stratigraphy$End < tree$root.time)

    ## Remove eventual recent strats for trees not containing living taxa
    recent <- which(stratigraphy$End[strats] < min(node.depth.edgelength(tree)))
    if(length(recent) > 0) {
        strats <- strats[-recent]
    }

    ## Extract the stratigraphic data
    return(rev(stratigraphy[strats, what]))
}