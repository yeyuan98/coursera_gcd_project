library("tidyverse")

# --------------------- STEP. 1 ---------------------------
# First, read in data:
featureLabels <- read_delim("UCI_HAR/features.txt", delim = " ", col_names = FALSE)
motionLabels <- read_delim("UCI_HAR/activity_labels.txt", delim = " ", col_names = FALSE)

data.test <- read_delim("UCI_HAR/test/X_test.txt", delim = " ", trim_ws = TRUE,
                        col_names = featureLabels %>% pull(X2))
data.train <- read_delim("UCI_HAR/train/X_train.txt", delim = " ", trim_ws = TRUE,
                        col_names = featureLabels %>% pull(X2))
## Note that there are duplicated labels in the features.txt.
##       To check what are the duplicated labels:
dup <- table(featureLabels$X2)
dup <- dup[dup > 1]
print(names(dup))
##       Which means that only bandsEnergy columns are duplicated.
##       Does not affect our processing.

# Next, merge two data sets
## First we need to add the y_test and subject_test data
## Let's define a function to to this
add_meta <- function(data.set, paths, setType = "test"){
        # paths[1] = y_test, paths[2] = subject_test
        subjID <- read_delim(paths[2], delim = " ", trim_ws = TRUE,
                             col_names = c("subjectid"))
        data.set <- bind_cols(data.set, subjID)
        movementLabel <- read_delim(paths[1], delim = " ", trim_ws = TRUE,
                             col_names = c("movementlabel"))
        data.set <- bind_cols(data.set, movementLabel)
        data.set %>% mutate(settype = setType)
}
## Add meta datas to the two sets
data.test <- add_meta(data.test, c(
        "UCI_HAR/test/y_test.txt",
        "UCI_HAR/test/subject_test.txt"
        ))
data.train <- add_meta(setType = "train", data.train, c(
        "UCI_HAR/train/y_train.txt",
        "UCI_HAR/train/subject_train.txt"
        ))
## Merge together
data.full <- bind_rows(data.test,data.train)
## Some clean up - remove intermediate variables
rm(featureLabels, data.test, data.train, dup, add_meta)

# --------------------- STEP. 2 ----------------------------------
coln <- names(data.full)
coln <- str_detect(coln, "(mean\\(\\)|std\\(\\))|(subjectid|movementlabel)")
data.full <- data.full[,coln]
## Clean-up
rm(coln)

# --------------------- STEP. 3 ----------------------------------
## We just need to join the movementlabels tibbles.
data.full <- data.full %>%
        inner_join(motionLabels, by = c("movementlabel" = "X1")) %>%
        select(-movementlabel) %>%
        rename(movementlabel = X2)

# -------------------- STEP. 4 ----------------------------------
## Rename the column with the following criteria
##      <time/freq><measurementName><mean/std><x/y/z/norm>
coln <- names(data.full)
coln <- str_match(coln,
                  "(t|f)([a-zA-Z]+?)-(mean|std)\\(\\)-?(X|Y|Z)?")
colnames(coln) <- c(as.character(1:5))
coln <- as_tibble(coln)
coln <- filter_all(coln,any_vars(!is.na(.)))
coln <- paste0(
        ifelse(pull(coln, 2) == "t","time","freq"),
        tolower(pull(coln,3)),
        tolower(pull(coln,4)),
        ifelse(is.na(pull(coln,5)),"norm", tolower(pull(coln,5)))
)
data.full <- rename_at(data.full, vars(-(67:68)),
                        ~{coln})
## Clean-up
rm(coln)

# ------------------- STEP. 5 -------------------------------------
data.mean <- data.full %>%
        group_by(subjectid,movementlabel) %>%
        summarize_all(mean)
write.table(data.mean, file = "tidyset.txt", row.names = FALSE)