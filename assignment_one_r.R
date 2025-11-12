#   1 A sequence of number from 2 to 6, stored in a vector named a. 
vector_a = c(2,3,4,5,6)
vector_a

#we could also use
#vector_a <- 2:6

#  A twofold repetition of the vector c(2, -5.1, -33), stored in a vector named b.
vector_b = rep(c(2,-5.1,-33), times=2)
vector_b


# 2 Extract the first and last elements of the vectors created in step (1), and store them in new objects 
#named a1 and b1.

#a1
#Recall the vector
vector_a = c(2,3,4,5,6)
#create variables to store the values the first and last values

last_a = vector_a[length(vector_a)]
last_a
first_a = vector_a[1]
first_a

# create a variable called a1 to store last_a and first

a1 = c(first_a, last_a)
a1

#b1
#Recall the vector
vector_b = rep(c(2,-5.1,-33), times=2)
vector_b
#create variables to store the values for last and penultimate (pen) values

last_b = vector_b[length(vector_b)]
last_b
first_b = vector_b[1]
first_b

#create a variable called a1 to store last_b and first_b

b1 = c(first_b, last_b)
b1

#we can do this also in a single line
#a1 <- c(vector_a[1], vector_a[length(vector_a)])
#b1 <- c(vector_b[1], vector_b[length(vector_b)])

#Create new objects by omitting the first and last elements of the vectors from step (1). Store these as a2 and b2.

#a2
#recall the vector 
vector_a = c(2,3,4,5,6)
#Find the length of the vector 
length_a = length(vector_a)
length_a


a2 = c(vector_a[2:4])
a2

#b2
#recall the vector 
vector_b = rep(c(2,-5.1,-33), times=2)
#Find the length of the vector 
length_b = length(vector_b)
length_b

#if the length of the vector is 6, therefore to create a new vector omitting the first and last element all we need to to is create a new vector from vector_b 
#from position 2 to 5

b2 = c(vector_b[2:5])
b2

#4) Recreate vector a by combining the objects from steps (2) and (3). Save the result as a new object called a_1.

#in simple terms we join a1 and a2

#recall both vectors
a1 = c(first_a, last_a)
a2 = c(vector_a[2:4])

a_1 =  c(a1, a2)
a_1

#we can do the same for b_1 
b_1 = c(b1, b2)
b_1

#5) Again, using only the objects from steps (2) and (3), recreate vector a, sort the values in ascending 
#order, and save the result as a new object called a_2.

#we have above a new vector a_1 that holds the values of a1 and a2, we could sort these values in ascending order and simply assign the sorted values to a new variable
#called a_2

#my fist attempt did not work out because this syntax is for python
#a_2 = sort(a_1, reverse=false)
#a_2
#Let me look up the correct R syntax

a_2 = sort(a_1)
a_2

#alternatively we could sort in descending order
a_3 = sort(a_1, decreasing = TRUE)
a_3






