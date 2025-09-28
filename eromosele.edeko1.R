#a) Construct and store a 4 × 2 matrix that’s filled row-wise with the values 4.3, 3.1, 8.2, 8.2, 3.2, 0.9, 
#1.6, and 6.5, in that order and name it exc_mat. 

exc_mat <- matrix(c( 4.3, 3.1, 8.2, 8.2, 3.2, 0.9,1.6,6.5), nrow = 4, ncol = 2, byrow = TRUE)
exc_mat

#b) Find the location (array indices) of the smallest element in the matrix.

my_minimum <- min(exc_mat)
my_minimum

#or we could do this without necessarily declaring a variable



#next we find the array index of the minimum

min_indices <- which(exc_mat == my_minimum, arr.ind = TRUE)
min_indices

#c) Replace the second column of the matrix from part (a) with the same column, but sorted from 
#the smallest value to the largest.

#3 step process approach


#Step1 extract  second column
second_col_extract <- exc_mat[, 2]
second_col_extract

#Step2 sort extract
sorted_second_col_extract <- sort(second_col_extract)
sorted_second_col_extract

#Step3 rewrite original matrix with the sorted column

exc_mat[, 2] <- sorted_second_col_extract
exc_mat

#One Step approach, quite long but efficient
exc_mat[, 2] <- sort(exc_mat[, 2])
exc_mat


#d) What does R return if you delete the fourth row and the first column from (b)? Use matrix() to 
# the result is a single-column matrix, rather than a vector.

altered_matrix <- exc_mat[-4, -1]
altered_matrix 
#the above returns a vector which was not what was asked, lets return a matrix

altered_matrix <- matrix(exc_mat[-4, -1])
altered_matrix
#we can improve also on the first approach by adding the argument drop = FALSE this preserves the matrix form 

altered_matrix <- exc_mat[-4, -1, drop=FALSE]
altered_matrix 



