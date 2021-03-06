# #TESTING check.morpho

context("check.morpho")

test_that("check.morpho works", {

    set.seed(1)
    #Get a random tree
    random.tree <- rcoal(10)
    #Get a random matrix
    random.matrix <- sim.morpho(random.tree, characters = 50, model = "HKY", rates = c(rgamma, 1, 1), substitution = c(runif, 2, 2))
    #Erros
    expect_error(
        check.morpho("a", parsimony = "fitch", first.tree = c(phangorn::dist.hamming, phangorn::NJ), orig.tree, distance = phangorn::RF.dist)
        )
    expect_error(
        check.morpho(matrix, parsimony = "a", first.tree = c(phangorn::dist.hamming, phangorn::NJ), orig.tree, distance = phangorn::RF.dist)
        )
    expect_error(
        check.morpho(matrix, parsimony = "fitch", first.tree = "a", orig.tree, distance = phangorn::RF.dist)
        )
    expect_error(
        check.morpho(matrix, parsimony = "fitch", first.tree = c(phangorn::dist.hamming, phangorn::NJ), "a", distance = phangorn::RF.dist)
        )
    expect_error(
        check.morpho(matrix, parsimony = "fitch", first.tree = c(phangorn::dist.hamming, phangorn::NJ), orig.tree, distance = "a")
        )

    #Output
    set.seed(1)
    test <- check.morpho(random.matrix, parsimony = "sankoff", orig.tree = random.tree)
    expect_equal(
        dim(test), c(4,1)
        )
    expect_equal(
       test[1,], 48
        )
    expect_equal(
       test[2,], 0.6875
        )
    expect_equal(
       round(test[3,], digit = 4), round(0.7580645, digit = 4)
        )
    expect_equal(
       test[4,], 0
        )

    #Test example (seed 10)
    set.seed(10)
    random.tree <- rcoal(10)
    random.matrix <- sim.morpho(random.tree, characters = 50, model = "ER", rates = c(rgamma, 1, 1))
    test <- check.morpho(random.matrix, orig.tree = random.tree)
    expect_equal(
        dim(test), c(4,1)
        )
    expect_equal(
       test[1,], 57
        )
    expect_equal(
       round(test[2,], digit = 4), round(0.6666667, digit = 4)
        )
    expect_equal(
       round(test[3,], digit = 4), round(0.7031250, digit = 4)
        )
    expect_equal(
       test[4,], 2
        )    

})
