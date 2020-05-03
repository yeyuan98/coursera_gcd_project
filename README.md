# Getting and Cleaning Data Course Project

This repo is the course project for Getting and Cleaning Data Coursera course. The R library `tidyverse` is used. R script `run_analysis.R` does the following:

1. Load the training and testing datasets in `./UCI_HAR` folder and test for duplicated column labels. Merge the two datasets using `bind_rows` and attach metadata (*i.e.* subject IDs and motion types) to the dataset.
2. Select only the mean/std columns using `str_detect`.
3. Get descriptive activity names by performing an `inner_join` between the dataset tibble and the `activity_labels.txt` tibble.
4. Parse and rename the columns using more descriptive names. The names follow the rules taught in lectures - no caps/special characters while keeping it easily readable.
5. Create a second data set with the average of each variable for each activity and each subject using `group_by` and `summarize_all`.
