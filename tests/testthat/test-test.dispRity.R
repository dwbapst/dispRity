#TESTING boot.matrix

context("test.dispRity")

test_that("test.list.lapply.distributions internal fun", {
    my_list_of_comp <- list(c(1,2), c(2,1))
    my_data <- list(list(rnorm(10), rnorm(10)), list(rnorm(10), rnorm(10)))
    my_test <- t.test

    #Errors
    expect_error(
        test.list.lapply.distributions(1, my_data, my_test)
        )
    expect_error(
        test.list.lapply.distributions(my_list_of_comp, 1, my_test)
        )
    expect_error(
        test.list.lapply.distributions(my_list_of_comp, my_data, 1)
        )

    #Right output
    expect_is(
        test.list.lapply.distributions(my_list_of_comp, my_data, my_test)
        , "list")
    expect_equal(
        length(test.list.lapply.distributions(my_list_of_comp, my_data, my_test))
        ,2)
    expect_equal(
        length(test.list.lapply.distributions(my_list_of_comp, my_data, my_test)[[1]])
        ,2)
    expect_equal(
        unique(unlist(lapply(test.list.lapply.distributions(my_list_of_comp, my_data, my_test), lapply, class)))
        ,"htest")
})

test_that("set.sequence internal fun", {
    expect_error(
    	set.sequence("a")
    	)
    expect_is(
    	set.sequence(4)
        , "matrix")
    expect_equal(
    	dim(set.sequence(4))
        , c(2,3))
    expect_equal(
    	min(set.sequence(4))
        , 1)
    expect_equal(
    	max(set.sequence(4))
        , 4)
})

test_that("convert.to.numeric internal fun", {
    expect_true(
    	is.na(unlist(convert.to.numeric("a", "b")))
    	)
    expect_is(
    	convert.to.numeric(list(c("a", "b"), c("b", "a")), list("a"=1, "b"=2))
        , "list")
    expect_equal(
    	length(convert.to.numeric(list(c("a", "b"), c("b", "a")), list("a"=1, "b"=2)))
        , 2)
    expect_equal(
    	unlist(convert.to.numeric(list(c("a", "b"), c("b", "a")), list("a"=1, "b"=2)))
        , c(1,2,2,1))
})

test_that("convert.to.character internal fun", {

    expect_equal(names.fun(c(1,2,4), list("a"=1, "b"=1, "c"=1, "d"=1)), c("a", "b", "d"))

    expect_true(
    	is.null(unlist(convert.to.character(1,1)))
    	)
    expect_is(
    	convert.to.character(list(c(1,2), c(2,1)), list("a"=rnorm(5),"b"=rnorm(5)))
        , "list")
    expect_equal(
    	length(convert.to.character(list(c(1,2), c(2,1)), list("a"=rnorm(5),"b"=rnorm(5))))
        , 2)
    expect_equal(
    	unlist(convert.to.character(list(c(1,2), c(2,1)), list("a"=rnorm(5),"b"=rnorm(5))))
        , c("a", "b", "b", "a"))
})

test_that("list.to.table internal fun", {

    expect_equal(rep.names("a", 2), c("a", "a"))

    expect_is(
    	list.to.table(list("a"=rnorm(5),"b"=rnorm(5),"c"=rnorm(5)))
        , "data.frame")
    expect_equal(
    	dim(list.to.table(list("a"=rnorm(5),"b"=rnorm(5),"c"=rnorm(5))))
        , c(15,2))
    expect_equal(
    	unique(list.to.table(list("a"=rnorm(5),"b"=rnorm(5),"c"=rnorm(5)))[,2])
        , as.factor(c("a","b","c")))
})

test_that("htest.to.vector internal fun", {

    set.seed(1)
    expect_equal(
        round(get.element("statistic", t.test(rnorm(10), rnorm(10))), digit = 5)
        , c("t"=-0.27858)) 

    expect_error(
    	htest.to.vector(t.test(rnorm(10), rnorm(10)), print="NA")
    	)
    set.seed(1)
    expect_equal(
    	htest.to.vector(t.test(rnorm(10), rnorm(10)), print="p.value")
        , 0.7840382)
    set.seed(1)
    expect_equal(
    	htest.to.vector(t.test(rnorm(10), rnorm(10)), print=list("p.value"))
        , 0.7840382)
    set.seed(1)
    test <- htest.to.vector(t.test(rnorm(10), rnorm(10)), print=list("parameter", "p.value", "statistic"))
    expect_is(
    	test
        , "numeric")
    expect_equal(
    	as.vector(test)
        , c(16.4689565,0.7840382,-0.2785755))
})


test_that("set.comparisons.list internal fun", {
    my_data <- list(list(rnorm(10), rnorm(10)), list(rnorm(10), rnorm(10)), list(rnorm(10), rnorm(10)))

    #Errors
    expect_error(
        set.comparisons.list("custom", my_data)
        )

    #Custom output
    expect_equal(
        set.comparisons.list("custom", 1, c(1,2,2,3))
        ,c(1,2,2,3))
    expect_equal(
        set.comparisons.list("custom", 1, TRUE)
        ,TRUE)
    #Pairwise output
    expect_equal(
        set.comparisons.list("pairwise", my_data, 1)
        ,list(c(1,2), c(1,3), c(2,3)))
    #Sequential output
    expect_equal(
        set.comparisons.list("sequential", my_data, 1)
        ,list(c(1,2), c(2,3)))
    #Referential output
    expect_equal(
        set.comparisons.list("referential", my_data, 1)
        ,list(c(1,2), c(1,3)))
})

test_that("save.comparison.list internal fun", {
    my_data <- list(list(rnorm(10), rnorm(10)), list(rnorm(10), rnorm(10)), list(rnorm(10), rnorm(10)))
    names(my_data) <- c("X", "Y")
    my_comp_subsamples <- list(c(1,2), c(2,1))

    expect_equal(
        save.comparison.list(list(c(1,2), c(2,1)), my_data)
        ,c("X : Y", "Y : X"))
    expect_equal(
        save.comparison.list(list(c(1,2), c(1,2)), my_data)
        ,c("X : Y", "X : Y"))
    expect_equal(
        save.comparison.list(list(c(1,2)), my_data)
        ,c("X : Y"))
    expect_equal(
        save.comparison.list(1, my_data)
        ,c("X"))
})

test_that("lapply.lm.type internal fun", {

    ## Dummy lm
    dummy_matrix <- as.data.frame(matrix(c(c(rep(1, 5), rep(2, 5)), rnorm(10)), ncol = 2))
    colnames(dummy_matrix) <- c("data", "subsamples")
    lm_out <- lapply.lm.type(dummy_matrix, test = lm)
    
    expect_is(lm_out, "lm")
})

test_that("get.quantiles.from.table internal fun", {
    my_table <- matrix(rnorm(50), nrow = 5)

    expect_error(
        get.quantiles.from.table(1, mean, c(0.45, 0.55))
        )

    expect_error(
        get.quantiles.from.table(my_table, mean, 2)
        )

    expect_is(
        get.quantiles.from.table(my_table, mean, c(0.45, 0.55))
        ,"matrix")
    expect_equal(
        dim(get.quantiles.from.table(my_table, mean, c(0.45, 0.55)))
        ,c(5,3))
})

## Set up data for tests
data(disparity)
extracted_data <- extract.dispRity(disparity, observed = FALSE, rarefaction = FALSE, concatenate = TRUE)
## Set up data for sequential test
comp_subsamples <- set.comparisons.list("sequential", extracted_data, "sequential")

test_that("output.numeric.results internal fun", {
    ## Run test
    details_out <- test.list.lapply.distributions(comp_subsamples, extracted_data, bhatt.coeff)

    ## Get results
    test_out <- output.numeric.results(details_out, "bhatt.coeff",comp_subsamples, conc.quantiles=c(0.25, 0.75), con.cen.tend = mean)

    expect_is(test_out, "matrix")
    expect_equal(colnames(test_out), c("bhatt.coeff", "25%", "75%"))
    expect_equal(rownames(test_out), unlist(lapply(comp_subsamples, paste, collapse = ":")))

})

test_that("output.htest.results internal fun", {
    ## Run test
    details_out <- test.list.lapply.distributions(comp_subsamples, extracted_data, t.test)

    ## Get results
    test_out <- lapply.output.test.elements("statistic", details_out, comp_subsamples, conc.quantiles=c(0.25, 0.75), con.cen.tend = mean)

    expect_is(test_out, "matrix")
    expect_equal(colnames(test_out), c("statistic", "25%", "75%"))
    expect_equal(rownames(test_out), unlist(lapply(comp_subsamples, paste, collapse = ":")))

    ## Wrapping function
    test_out <- output.htest.results(details_out, comp_subsamples, conc.quantiles=c(0.25, 0.75), con.cen.tend = mean, correction = "none")

    expect_is(test_out, "list")
    expect_equal(length(test_out), 3)

    elements_names <- c("statistic", "parameter", "p.value")
    comp_names <- unlist(lapply(comp_subsamples, paste, collapse = ":"))
    
    for(element in 1:3) {
        expect_equal(colnames(test_out[[element]]), c(elements_names[element], "25%", "75%"))
        expect_equal(rownames(test_out[[element]]), comp_names)
    }
})

# test_that("output.lm.results internal fun", {
#     ## Set up data for lm test
#     list_of_data <- list()
#     for(bootstrap in 1:length(extracted_data[[1]])) {
#         list_of_data[[bootstrap]] <- lapply(extracted_data, `[[`, bootstrap)
#     }
#     list_of_data <- lapply(list_of_data, list.to.table)

#     ## Run test
#     details_out <- lapply(list_of_data, lapply.lm.type, lm)

#     ## Wrapping function
#     test_out <- output.lm.results(details_out,  conc.quantiles=c(0.25, 0.75), con.cen.tend = mean)

#     expect_is(test_out, "list")
#     expect_equal(length(test_out), 5)

    
#     elements_names <- c("Df", "Sum Sq", "Mean Sq", "F value", "Pr(>F)")
#     comp_names <- c("subsamples", "Residuals")
    
#     for(element in 1:5) {
#         expect_equal(colnames(test_out[[element]]), c(elements_names[element], "25%", "75%"))
#         expect_equal(rownames(test_out[[element]]), comp_names)
#     }
# })

test_that("example works fine", {
    set.seed(1)
    ## Load the Beck & Lee 2014 data
    data(BeckLee_mat50)

    ## Calculating the disparity from a customised subsamples
    ## Generating the subsamples
    groups <- as.data.frame(matrix(data = c(rep(1, 12), rep(2, 13), rep(3, 25)), dimnames =list(rownames(BeckLee_mat50))), ncol = 1)
    customised_subsamples <- custom.subsamples(BeckLee_mat50, groups)
    ## Bootstrapping the data
    bootstrapped_data <- boot.matrix(customised_subsamples, bootstraps=100)
    ## Caculating the sum of ranges
    sum_of_ranges <- dispRity(bootstrapped_data, metric=c(sum, ranges))

    ## Measuring the subsamples overlap
    expect_is(
    	test.dispRity(sum_of_ranges, bhatt.coeff, "pairwise")
        , "data.frame")
    expect_equal(
    	dim(test.dispRity(sum_of_ranges, bhatt.coeff, "pairwise"))
        , c(3,1))
    expect_equal(
    	sum(test.dispRity(sum_of_ranges, bhatt.coeff, "pairwise"))
        , 0.67027)

    ## Measuring differences from a reference_subsamples
    expect_is(
    	test.dispRity(sum_of_ranges, wilcox.test, "referential")
        , "list")
    expect_equal(
    	length(test.dispRity(sum_of_ranges, wilcox.test, "referential"))
        , 2)
    expect_equal(
    	sum(test.dispRity(sum_of_ranges, wilcox.test, "referential")[[1]][,1])
        , 1543)
    expect_equal(
    	sum(test.dispRity(sum_of_ranges, wilcox.test, "referential")[[2]][,1])
        , 3.025477e-17)

    ## Measuring disparity as a distribution
    disparity_var <- dispRity(bootstrapped_data, metric = variances)
    test1 <- test.dispRity(disparity_var, test = t.test, comparisons = "pairwise", concatenate = TRUE)
    expect_is(
        test1
        ,"list")
    expect_equal(
        unique(unlist(lapply(test1, class)))
        ,"data.frame")
    expect_equal(
        unique(unlist(lapply(test1, dim)))
        ,c(3,1))
    test2 <- test.dispRity(disparity_var, test = t.test, comparisons = "pairwise", concatenate = FALSE)
    expect_is(
        test2
        ,"list")
    expect_equal(
        unique(unlist(lapply(test2, class)))
        ,"matrix")
    expect_equal(
        unique(unlist(lapply(test2, dim)))
        ,c(3,5))

    ## Testing the effect of the groups
    expect_is(
        test.dispRity(sum_of_ranges, lm, "all")
        , "lm")
    expect_equal(
        test.dispRity(sum_of_ranges, lm, "all")$rank
        , 3)
    expect_equal(
        as.vector(test.dispRity(sum_of_ranges, lm, "all")$coefficients)
        , c(24.048441,2.053728,9.798655))
})
