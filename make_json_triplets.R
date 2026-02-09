#install.packages("rjson")
library("rjson")
#install.packages("jsonlite")
library("jsonlite")
library("gtools")
#install.packages("gtools")

setwd("/Users/czimnicki/Documents/GitHub/motion_triplets/img")


# Set the directory containing the images
image_dir <- "~/Documents/GitHub/motion_triplets/img"  # Change this to your actual folder path

# List all files in the directory matching your naming pattern
image_files <- list.files(image_dir, pattern = "dot*", full.names = TRUE)

# Sort files to ensure correct renaming order
#image_files <- sort(image_files)

# Generate new names (gabor0, gabor10, ..., gabor350)
#new_names <- paste0(image_dir, "/gabor", seq(0, 350, by = 10), ".png")  # Change extension if needed

# Rename the files
#file.rename(image_files, new_names)

# Check renamed files
#print(new_names)


#make a list of all gabors, with format gaborMap[10]
# Generate a sequence from 10 to 350, increasing by 10
#tilt_values <- seq(0, 350, by = 10)
# Create the list of strings
#gabor_list <- paste0("gaborMap['gabor", tilt_values, "']")
# Print the result
#print(gabor_list)

#make json of validation triplets
# Generate all combinations of 3 from the vector
all_combinations <- combn(image_files, 3)

#generate permutations
#all_permutations <- combn(18, 3, image_files, repeats.allowed=F)
all_combinations <- gsub("/Users/czimnicki/Documents/GitHub/motion_triplets/", "\\1", all_combinations)

# Randomly sample 25 sets of combinations
set.seed(123)  # Set seed for reproducibility
sampled_sets <- all_combinations[, sample(ncol(all_combinations), 70)]#validation trials

#we ultimately want 42 check trials but these repeat so we will remove some
check_sample <- all_combinations[, sample(ncol(all_combinations), 30)]#check trials

# View the sampled sets
#print(sampled_sets)

# Convert the sampled_sets matrix to a list of lists
sets_list <- lapply(1:ncol(sampled_sets), function(i) {
  triplet <- sampled_sets[, i]
  list(paste("head:", triplet[1]), paste("choice_1:", triplet[2]), paste("choice_2:",triplet[3]))
})

#Convert the sampled_sets matrix to a list of lists
# This time, though, choice_1 = head
#there will also be code below where choice_2 = head
check_list_1 <- lapply(1:10, function(i) {
  triplet <- check_sample[, i]
  list(paste("head:", triplet[1]), paste("choice_1:", triplet[1]), paste("choice_2:",triplet[3]), "correct_choice:0")
})

check_list_2 <- lapply(11:20, function(i) {
  triplet <- check_sample[, i]
  list(paste("head:", triplet[1]), paste("choice_1:", triplet[2]), paste("choice_2:",triplet[1]), "correct_choice:1")
})


# Format as an object without the outer array
json_output2 <- gsub("\\\\", "",check_list_1)
json_output2 <- gsub("^\\[\n|\\]\\s*$", "",json_output2)
json_output2 <- gsub("list(", "",json_output2, fixed=TRUE)
json_output2 <- gsub("\\\\", "",json_output2)
json_output2 <- unique(json_output2)
json_output2
json_output2 <- json_output2[1:7]

json_output1 <- gsub("\\\\", "",check_list_2)
json_output1 <- gsub("^\\[\n|\\]\\s*$", "",json_output1)
json_output1 <- gsub("list(", "",json_output1, fixed=TRUE)
json_output1 <- gsub("\\\\", "",json_output1)
json_output1 <- unique(json_output1)
json_output1
json_output1 <- json_output1[1:8]

json_output <- c(json_output2, json_output1)

json_output0 <- gsub("\\\\", "",sets_list)
json_output0 <- gsub("^\\[\n|\\]\\s*$", "",json_output0)
json_output0 <- gsub("list(", "",json_output0, fixed=TRUE)
json_output0 <- gsub("\\\\", "",json_output0)
json_output0 <- unique(json_output0)
json_output0 <- json_output0[1:60]

# Convert the list to JSON
json_output_final <- toJSON(json_output, auto_unbox=TRUE, pretty = TRUE)

# View the JSON output
#cat(json_output)
write(json_output_final, "~/Documents/GitHub/motion_triplets/checkTrials.json")


