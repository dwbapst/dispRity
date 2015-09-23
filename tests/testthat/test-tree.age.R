#TEST tree.age

context("tree.age")

#Testing tree.age_table
#example
tree<-rtree(10)
table_1<-tree.age_table(tree)

#Test
test_that("tree.age_table works", {
    #class
    expect_is(table_1, 'data.frame')
    #col.names
    expect_that(colnames(table_1), equals(c('ages', 'elements')))
    #row lengths
    expect_that(nrow(table_1), equals(Ntip(tree)+Nnode(tree)))
    #ages are numeric
    expect_is(table_1[,1], 'numeric')
    #elements are factors
    suppressWarnings({
    same_names<-length(which(as.character(table_1[,2]) == as.character(tree$tip.label)))})
    expect_equal(same_names, Ntip(tree))
})


#Testing tree.age
#example
tree_age<-tree.age(rtree(10), age=1)

#Test
test_that("tree.age works", {
    #table
    expect_is(tree_age, 'data.frame')
    #min age is 0
    expect_equal(min(tree_age[,1]), 0)
    #max age is 1 (age)
    expect_equal(max(tree_age[,1]), 1)
})