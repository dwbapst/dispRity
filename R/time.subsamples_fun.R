
## Internal function for adjust.FADLAD
adjust.age <- function(FADLAD, ages_tree) {
    return(ifelse(FADLAD != ages_tree, FADLAD, ages_tree))
}

## Get adjusted FADLAD
## FAD argument is whether to adjust FAD (TRUE) or LAD (FALSE)
adjust.FADLAD <- function(FADLAD, tree, data) {
    ## Get the tree ages
    ages_tree <- tree.age(tree)

    ## Match the ages_tree_FAD/LAD with the FADLAD table
    names_match <- match(rownames(FADLAD), ages_tree[,2])
    ages_tree_tmp <- ages_tree[names_match,]

    ## Adjust the FAD/LAD
    ages_tree_FAD <- ages_tree_LAD <- ages_tree_tmp
    ages_tree_FAD[,1] <- mapply(adjust.age, as.list(FADLAD[,1]), as.list(ages_tree_tmp[,1]))
    ages_tree_LAD[,1] <- mapply(adjust.age, as.list(FADLAD[,2]), as.list(ages_tree_tmp[,1]))

    ## Combine all ages
    ages_tree_FAD <- rbind(ages_tree_FAD, ages_tree[-names_match,])
    ages_tree_LAD <- rbind(ages_tree_LAD, ages_tree[-names_match,])

    ## Match the ages with the data
    row_order <- match(rownames(data), ages_tree_FAD$elements)

    return(list("FAD" = ages_tree_FAD[row_order,], "LAD" = ages_tree_LAD[row_order,]))
}


## Discrete time subsamples
time.subsamples.discrete <- function(data, tree, time, FADLAD, inc.nodes, verbose) {
    
    ## lapply function for getting the interval
    get.interval <- function(interval, time, ages_tree, inc.nodes, verbose) {
        if(verbose) message(".", appendLF = FALSE)
        if(inc.nodes) {
            return( list("elements" = as.matrix(which(ages_tree$FAD$ages >= time[interval+1] & ages_tree$LAD$ages <= time[interval]) )))
        } else {
            one_interval <- which(ages_tree$FAD$ages >= time[interval+1] & ages_tree$LAD$ages <= time[interval])
            matching <- match(tree$tip.label, rownames(data[one_interval,]))
            ## Only remove NAs if present
            if(any(is.na(matching))) {
                elements_out <- list("elements" = as.matrix(one_interval[matching[-which(is.na(matching))]]) )
            } else {
                elements_out <- list("elements" = as.matrix(one_interval[matching]))
            }
            return(elements_out)
        }
    }

    ## Verbose
    if(verbose) {
        message("Creating ", length(time)-1, " time bins through time:", appendLF = FALSE)
    }

    ## ages of tips/nodes + FAD/LAD
    ages_tree <- adjust.FADLAD(FADLAD, tree, data)

    ## Attribute each taxa/node to its interval
    interval_elements <- lapply(as.list(seq(1:(length(time)-1))), get.interval, time, ages_tree, inc.nodes, verbose)

    ## Get the names of the intervals
    names(interval_elements) <- paste(time[-length(time)], time[-1], sep = " - ")

    if(verbose) message("Done.\n", appendLF = FALSE)


    ## If interval is empty, send warning and delete the interval
    for (interval in 1:length(interval_elements)) {
        if(nrow(interval_elements[[interval]]$elements) == 0) {
            warning("The interval ", names(interval_elements)[interval], " is empty.", call. = FALSE)
            interval_elements[[interval]]$elements <- matrix(NA)
        }
    }

    return(interval_elements)
}

## Continuous time subsamples
time.subsamples.continuous <- function(data, tree, time, model, FADLAD, verbose) {

    ## lapply function for getting the slices
    get.slice <- function(slice, time, model, ages_tree, data, verbose) {

        ## Verbose
        if(verbose) message(".", appendLF = FALSE)

        ## Get the subtree
        if(time[slice] == 0) {
            ## Select the tips to drop
            taxa_to_drop <- ages_tree$LAD[which(ages_tree$LAD[1:Ntip(tree),1] != 0),2]
            ## drop the tips
            sub_tree <- drop.tip(tree, tip = as.character(taxa_to_drop))
        } else {
            ## Subtree
            sub_tree <- slice.tree(tree, time[slice], model, FAD = ages_tree$FAD, LAD = ages_tree$LAD)
        }

        if(class(sub_tree) !=  "phylo" && is.na(sub_tree)) {
            warning("The slice ", time[slice], " is empty.", call. = FALSE)
            return(list("elements" = matrix(NA)))
        }

        ## Select the tips 
        tips <- sub_tree$tip.label

        ## Add any missed taxa from the FADLAD
        taxa <- rownames(data)[which(ages_tree$FAD$ages > time[slice] & ages_tree$LAD$ages < time[slice])]

        ## Getting the list of elements
        return( list("elements" = as.matrix(match(unique(c(tips, taxa)), rownames(data))) ))
    }

    ## ages of tips/nodes + FAD/LAD
    ages_tree <- adjust.FADLAD(FADLAD, tree, data)
    
    ## verbose
    if(verbose) {
        message("Creating ", length(time), " time samples through the tree:", appendLF = FALSE)
    }

    ## Get the slices elements
    slices_elements <- lapply(as.list(seq(1:length(time))), get.slice, time, model, ages_tree, data, verbose)

    ## verbose
    if(verbose) {
        message("Done.\n", appendLF = FALSE)
    }

    ## naming the slices
    names(slices_elements) <- time

    return(slices_elements)
}

## Making the origin subsamples for a disparity_object
make.origin.subsamples <- function(data) {
    origin <- list("elements" = as.matrix(seq(1:nrow(data))))
    origin_subsamples <- list("origin" = origin)
    return(origin_subsamples)
}