#TESTING plot.dispRity

context("plot.dispRity (non-graphic)") 

## Loading the data
data("disparity")

#######################
#Testing
#######################

## Default settings
test_that("set.default works", {
    sum_data <- summary(disparity)
    expect_error(
        set.default("1", disparity, elements = FALSE, ylim = "default", xlab = "default", ylab = "default", col = "default", rarefaction = FALSE)
        )
    expect_error(
        set.default(sum_data, "1", elements = FALSE, ylim = "default", xlab = "default", ylab = "default", col = "default", rarefaction = FALSE)
        )
    test <- set.default(sum_data, disparity, elements = FALSE, ylim = "default", xlab = "default", ylab = "default", col = "default", rarefaction = FALSE)
    expect_equal(
        round(test[[1]], 5)
        , round(c(0.96824, 2.02266), 5))
    expect_equal(
        test[[2]]
        , "Subsamples")
    expect_equal(
        test[[3]]
        , "c(median, centroids)")
    expect_equal(
        test[[4]]
        , c("black", "#BEBEBE", "#D3D3D3"))

    test <- set.default(sum_data, disparity, elements = TRUE, ylim = c(1,2), xlab = "Bla", ylab = c("Bli", "Blu"), col = c("pink", "knip"), rarefaction = FALSE)
    expect_equal(
        round(test[[1]], 5)
        , round(c(1, 2), 5))
    expect_equal(
        test[[2]]
        , "Bla")
    expect_equal(
        test[[3]]
        , c("Bli", "Blu"))
    expect_equal(
        test[[4]]
        , c("pink", "knip", "#BEBEBE"))
})

test_that("extract.from.summary works", {
    sum_data <- summary(disparity)
    expect_error(
        extract.from.summary("sum_data", what = 4, rarefaction = FALSE)
        )
    expect_null(
        extract.from.summary(sum_data, what = "4", rarefaction = FALSE)
        )
    expect_equal(
        length(extract.from.summary(sum_data, what = 4, rarefaction = 99))
        , 0)
    expect_equal(
        length(extract.from.summary(sum_data, what = 4, rarefaction = FALSE))
        , length(extract.from.summary(sum_data, what = "rows", rarefaction = FALSE)))
    expect_equal(
        extract.from.summary(sum_data, what = 1, rarefaction = FALSE)
        , as.factor(c(90,80,70,60,50,40,30)))
    expect_equal(
        extract.from.summary(sum_data, what = 2, rarefaction = 10)
        ,rep(10, 7))
    expect_equal(
        extract.from.summary(sum_data, what = 3, rarefaction = 5)
        ,as.numeric(rep(NA, 7)))
    expect_equal(
        extract.from.summary(sum_data, what = 4, rarefaction = FALSE)
        ,c(1.776, 1.808, 1.881, 1.880, 1.902, 1.885, 1.823))
})

test_that("transpose.box works", {

    expect_error(
        transpose.box("disparity", rarefaction = FALSE)
        )
    expect_error(
        transpose.box(disparity, rarefaction = 99)
        )
    expect_equal(
        dim(transpose.box(disparity, rarefaction = FALSE))
        ,c(100, 7))
    expect_equal(
        dim(transpose.box(disparity, rarefaction = 5))
        ,c(100, 7))

    test <- transpose.box(disparity, rarefaction = FALSE)
    for(subsamples in 1:length(disparity$subsamples)) {
        expect_equal(
            test[,subsamples]
            ,as.vector(disparity$disparity[[subsamples]][[2]]))
    }
})

test_that("split.summary.data works", {

    data(disparity)
    sum_data <- summary(disparity)
    subsamples <- unique(sum_data$subsamples)

    for(sub in 1:length(subsamples)) {
        ## Create a split
        split <- split.summary.data(subsamples[sub], sum_data)
        ## test
        expect_is(split, "data.frame")
        expect_equal(dim(split), c(length(which(sum_data$subsamples == subsamples[sub])),8))
    }
})


test_that("plot.dispRity examples work", {

    data(disparity)

    ## Discrete plotting
    expect_null(plot(disparity, type = "box"))
    expect_null(plot(disparity, type = "polygon", quantiles = c(10, 50, 95),cent.tend = mode.val))
    expect_null(plot(disparity, type = "line", elements = TRUE, ylim = c(0, 5),xlab = ("Time (Ma)"), ylab = "disparity"))
    expect_null(plot(disparity, type = "continuous"))
    expect_null(plot(disparity, type = "continuous", time.subsamples = FALSE,elements = TRUE, col = c("red", "orange", "yellow")))
    expect_null(plot(disparity, rarefaction = TRUE))
    
})
