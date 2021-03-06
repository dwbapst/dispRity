## TESTING time.subsamples

context("time.subsamples")

## Change the loading data to a simplified version of Beck???
load("test_data.Rda")
tree <- test_data$tree_data
data <- test_data$ord_data_tips
FADLAD <- test_data$FADLAD_data

test_that("adjust.FADLAD works", {

    ## Test FADLAD
    expect_equal(adjust.age(1, 1), 1)
    expect_equal(adjust.age(1, 12), 1)

    ages_tree <- adjust.FADLAD(FADLAD, tree, data)

    ## Class is list
    expect_is(
        ages_tree
        ,"list")
    ## Length is 2 (FAD and LAD)
    expect_equal(
        names(ages_tree)
        ,c("FAD", "LAD"))
    ## Length each is 50*2
    expect_equal(
        as.vector(unlist(lapply(ages_tree, dim)))
        ,c(50,2,50,2))
    ## Values match the FADLAD table
    for(taxon in 1:nrow(FADLAD)) {
        match_taxon <- match(rownames(FADLAD)[taxon], ages_tree$FAD$elements)
        expect_equal(
            c(ages_tree$FAD$ages[match_taxon], ages_tree$LAD$ages[match_taxon])
            , as.numeric(FADLAD[taxon,]))
    }
})

## time.subsamples.discrete
time = c(120, 80, 40)
model = NULL
inc.nodes = FALSE
verbose = FALSE

time_subsamples <- time.subsamples.discrete(data, tree, time, FADLAD, inc.nodes, verbose = FALSE)

## Test
test_that("time.subsamples.discrete works properly without nodes", {
    ## Test get.interval
    # expect_equal(
    #     as.vector(unlist(get.interval(1, time, adjust.FADLAD(FADLAD, tree, data), inc.nodes = FALSE)))
    #     , c(5,4,6,8,43,10,11,42))

    ## class is list
    expect_is(
        time_subsamples, "list"
        )
    ## length list is 2
    expect_equal(
        length(time_subsamples)
        , 2)
    ## elements per subsamples
    subsamples_1 <- c("Daulestes","Bulaklestes","Uchkudukodon","Asioryctes","unnamed_cimolestid","Kulbeckia","Zhangolestes","unnamed_zalambdalestid")
    subsamples_2 <- c("Kennalestes","Asioryctes","Ukhaatherium","Cimolestes","Maelestes","Batodon","Zalambdalestes","Barunlestes","Gypsonictops","Oxyclaenus",
        "Protungulatum","Oxyprimus","Todralestes","Pezosiren","Tribosphenomys","Paramys","Rhombomylus","Gomphos","Mimotona","Purgatorius",
        "Plesiadapis","Notharctus","Protictis","Vulpavus","Miacis","Icaronycteris","Eoryctes")
    expect_equal(
        rownames(data[time_subsamples[[1]]$elements,])
        , subsamples_1)
    expect_equal(
        rownames(data[time_subsamples[[2]]$elements,])
        , subsamples_2)
})

## With nodes
inc.nodes = TRUE
data <- test_data$ord_data_tips_nodes

time_subsamples <- time.subsamples.discrete(data, tree, time, FADLAD, inc.nodes, verbose = FALSE)

## Test
test_that("time.subsamples.discrete works properly with nodes", {
    ## class is list
    expect_is(
        time_subsamples
        , "list")
    ## length list is 2
    expect_equal(
        length(time_subsamples)
        , 2)
    ## elements per subsamples
    expect_equal(
        length(time_subsamples[[1]]$elements)
        , 32)
    expect_equal(
        length(time_subsamples[[2]]$elements)
        , 47)
})


## time.subsamples.continuous
data <- test_data$ord_data_tips_nodes
time = c(120, 80, 40)
verbose = FALSE

## DELTRAN
time_subsamples <- time.subsamples.continuous(data, tree, time, model = "deltran", FADLAD, verbose)

## Test
test_that("time.subsamples.continuous works properly with deltran model", {
    
    ## Get slice
    # expect_equal(
    #     as.vector(na.omit(unlist(get.slice(1, time[2], "ACCTRAN", adjust.FADLAD(FADLAD, tree, data), data, verbose = FALSE))))
    #     , c(7, 8, 9, 1, 2, 3, 12, 13, 14, 15, 44, 70, 73, 76, 79, 85, 48, 90, 47, 95, 46, 98))

    ## class is list
    expect_is(
        time_subsamples
        , "list")
    ## length list is 3
    expect_equal(
        length(time_subsamples)
        , 3)
    ## elements per subsamples
    subsamples_1 <- c("n1","n5","n11", "Zhangolestes")
    subsamples_2 <- c("n6","Asioryctes","n7","n8","n10","n15","n17","n19","n22","n25","n34","n39","n44","n47")
    subsamples_3 <- c("n17","n23","n27","n28","n29","n31","n32","n39","n42","n44","n48","n49")
    expect_equal(
        rownames(data[time_subsamples[[1]]$elements,])
        , subsamples_1)
    expect_equal(
        rownames(data[time_subsamples[[2]]$elements,])
        , subsamples_2)
    expect_equal(
        rownames(data[time_subsamples[[3]]$elements,])
        , subsamples_3)
})

## ACCTRAN
time_subsamples <- time.subsamples.continuous(data, tree, time, model = "acctran", FADLAD, verbose)

## Test
test_that("time.subsamples.continuous works properly with acctran model", {
    subsamples_1 <- c("n2","n6","n8","n12","n16", "Zhangolestes")
    subsamples_2 <- c("Kennalestes","Asioryctes","Ukhaatherium","Cimolestes","Maelestes","Batodon","Zalambdalestes","Barunlestes","Gypsonictops","Leptictis","Oxyclaenus","n20","n23","n26","n29","n35","Cynocephalus","n40","Patriomanis","n45","Icaronycteris","n48")
    subsamples_3 <- c("Leptictis","Dasypodidae","n24","Potamogalinae","Dilambdogale","Widanelfarasia","Rhynchocyon","Procavia","Moeritherium","Trichechus","Cynocephalus","Adapis","Patriomanis","Soricidae","Solenodon")
    expect_equal(
        rownames(data[time_subsamples[[1]]$elements,])
        , subsamples_1)
    expect_equal(
        rownames(data[time_subsamples[[2]]$elements,])
        , subsamples_2)
    expect_equal(
        rownames(data[time_subsamples[[3]]$elements,])
        , subsamples_3)
})

## time.subsamples
data = test_data$ord_data_tips_nodes
tree = test_data$tree_data
method = "continuous"
model = "acctran"
inc.nodes = TRUE
FADLAD = test_data$FADLAD_data
verbose = FALSE

## Sanitizing
test_that("Sanitizing works for time.subsamples (wrapper)", {
    ## Data
    expect_error(
        time.subsamples(data = "A", tree, method, time, model, inc.nodes, FADLAD, verbose = FALSE)
        )
    expect_error(
        time.subsamples(data = 1, tree, method, time, model, inc.nodes, FADLAD, verbose = FALSE)
        )
    expect_error(
        time.subsamples(data = matrix(NA, nrow = 2, ncol = 3), tree, method, time, model, inc.nodes, FADLAD, verbose = FALSE)
        )
    ## tree
    expect_error(
        time.subsamples(data, tree = "A", method, time, model, inc.nodes, FADLAD, verbose = FALSE)
        )
    expect_error(
        time.subsamples(data, tree = 1, method, time, model, inc.nodes, FADLAD, verbose = FALSE)
        )
    expect_error(
        time.subsamples(data, tree = rtree(5), method, time, model, inc.nodes, FADLAD, verbose = FALSE)
        )
    ## method
    expect_error(
        time.subsamples(data, tree, method = 1, time, model, inc.nodes, FADLAD, verbose = FALSE)
        )
    expect_error(
        time.subsamples(data, tree, method = "a", time, model, inc.nodes, FADLAD, verbose = FALSE)
        )
    expect_error(
        time.subsamples(data, tree, method = c("c","d"), time, model, inc.nodes, FADLAD, verbose = FALSE)
        )
    ## time
    expect_error(
        time.subsamples(data, tree, method, time = "time", model, inc.nodes, FADLAD, verbose = FALSE)
        )
    ## model
    expect_error(
        time.subsamples(data, tree, method, time, model = 3, inc.nodes, FADLAD, verbose = FALSE)
        )
    expect_error(
        time.subsamples(data, tree, method, time, model = c("acctran","deltran"), inc.nodes, FADLAD, verbose = FALSE)
        )
    ## FADlAD
    expect_error(
        time.subsamples(data, tree, method, time, model, inc.nodes, FADLAD = data.frame(nrow = 2, ncol = 3), verbose = FALSE)
        )

    ## t0
    expect_error(
        time.subsamples(data, tree, method, time, model, inc.nodes, FADLAD = data.frame(nrow = 2, ncol = 3), verbose = FALSE, t0 = "a")
        )
    expect_error(
        time.subsamples(data, tree, method, time, model, inc.nodes, verbose = FALSE, t0 = c(1,2))
        )
})

## Output
test_that("Output format is correct", {
    out_test <- time.subsamples(data, tree, method, time, model, inc.nodes, FADLAD)
    ## Class
    expect_is(
        out_test, "dispRity"
        )
    ## Length
    expect_equal(
        length(out_test)
        , 3)
    ## Names
    expect_equal(
        names(out_test)
        , c("matrix", "call", "subsamples")
        )
})


## Example TESTING
test_that("Example works", {
    data(BeckLee_tree) ; data(BeckLee_mat50) ; data(BeckLee_mat99) ; data(BeckLee_ages)
    ex1 <- time.subsamples(data = BeckLee_mat50, tree = BeckLee_tree, method = "discrete", time = c(120, 80, 40), inc.nodes = FALSE, FADLAD = BeckLee_ages)
    expect_equal(
        length(ex1)
        , 3)
    expect_is(
        ex1$matrix
        ,"matrix")
    expect_equal(
        dim(ex1$matrix)
        ,c(50,48))
    expect_equal(
        nrow(ex1$subsamples[[1]]$elements)
        ,8)
    expect_equal(
        nrow(ex1$subsamples[[2]]$elements)
        ,27)

    ex2 <- time.subsamples(data = BeckLee_mat99, tree = BeckLee_tree, method = "discrete", time = c(120, 80, 40), inc.nodes = TRUE, FADLAD = BeckLee_ages)
    expect_equal(
        length(ex2)
        , 3)
    expect_is(
        ex2$matrix
        ,"matrix")
    expect_equal(
        dim(ex2$matrix)
        ,c(99,97))
    expect_equal(
        nrow(ex2$subsamples[[1]]$elements)
        ,32)
    expect_equal(
        nrow(ex2$subsamples[[2]]$elements)
        ,47)

    ex3 <- time.subsamples(data = BeckLee_mat99, tree = BeckLee_tree, method = "continuous", model = "acctran", time = 5, FADLAD = BeckLee_ages)
    expect_equal(
        length(ex3)
        , 3)
    expect_is(
        ex3$matrix
        ,"matrix")
    expect_equal(
        dim(ex3$matrix)
        ,c(99,97))
    expect_equal(
        nrow(ex3$subsamples[[1]]$elements)
        ,3)
    expect_equal(
        nrow(ex3$subsamples[[2]]$elements)
        ,15)
    expect_equal(
        nrow(ex3$subsamples[[3]]$elements)
        ,23)
})

test_that("make.origin.subsamples works (internal fun)", {
    test_out <- make.origin.subsamples(matrix(rnorm(25), 5, 5))
    expect_is(test_out, "list")
    expect_equal(names(test_out), "origin")
    expect_equal(names(test_out[[1]]), "elements")
    expect_equal(dim(test_out[[1]][[1]]), c(5,1))
})


test_that("time.subsamples works without tree", {

    FAD_LAD_data <- tree.age(BeckLee_tree)[1:50,]
    rownames(FAD_LAD_data) <- FAD_LAD_data[,2]
    colnames(FAD_LAD_data) <- c("FAD", "LAD")
    FAD_LAD_data[, 2] <- FAD_LAD_data[, 1]

    ## Missing the FADLAD argument
    expect_error(
        time.subsamples(BeckLee_mat50, method = "discrete", time = 5)
        )

    no_tree <- time.subsamples(BeckLee_mat50, method = "discrete", time = c(130, 90, 45, 0), FADLAD = FAD_LAD_data)
    with_tree <- time.subsamples(BeckLee_mat50, method = "discrete", time = c(130, 90, 45, 0), tree = BeckLee_tree)

    ## Right object
    expect_is(no_tree, "dispRity")
    ## Right subsamples
    expect_equal(
        names(no_tree$subsamples)
        ,names(with_tree$subsamples))
    ## Right subsamples values
    for(sub in 1:3) {
        expect_true(
            all(sort(unlist(no_tree$subsamples[[sub]])) == sort(unlist(with_tree$subsamples[[sub]])))
            )
    }
})

test_that("t0 works", {
    data <- test_data$ord_data_tips_nodes
    test <- time.subsamples(data, tree, method = "continuous", model = "acctran", inc.nodes = TRUE, FADLAD = FADLAD, t0 = 100, time = 11)
    expect_is(test, "dispRity")
    expect_equal(names(test$subsamples), as.character(rev(seq(from = 0, to = 100, by = 10))))
})

test_that("time.subsamples works for empty subsamples", {
    data <- test_data$ord_data_tips
    time <- c(145, 140, 139, 0)

    ## Discrete
    warnings <- capture_warnings(test <- time.subsamples(data, tree, method = "discrete", time = c(145, 140, 139, 0)))
    expect_equal(warnings, c("The interval 145 - 140 is empty.", "The interval 140 - 139 is empty."))
    expect_equal(test$subsamples[[1]][[1]][,1], NA)
    expect_equal(test$subsamples[[2]][[1]][,1], NA)
    expect_equal(test$subsamples[[3]][[1]][,1], c(5, 4, 6, 7, 8, 9, 1, 43, 2, 3, 10, 11, 42, 12, 13, 14, 15, 44, 17, 18, 36, 37, 38, 41, 32, 39, 40, 33, 34, 35, 49, 50, 24, 25, 26, 27, 28, 48, 16, 21, 22, 23, 47, 45, 19, 20, 46, 29, 30, 31))

    ## Continuous
    data <- test_data$ord_data_tips_nodes
    warnings <- capture_warnings(test <- time.subsamples(data, tree, model = "acctran", method = "continuous", time = c(145, 140, 139, 0)))
    expect_equal(warnings, c("The slice 145 is empty.", "The slice 140 is empty."))
    expect_equal(test$subsamples[[1]][[1]][,1], NA)
    expect_equal(test$subsamples[[2]][[1]][,1], NA)
    expect_equal(test$subsamples[[3]][[1]][,1], c(52,54))
    expect_equal(test$subsamples[[4]][[1]][,1], c(36, 37, 38, 32, 33, 34, 50, 48, 29, 30))
})