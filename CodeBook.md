# Modifications

The original data is modified by
- The training and testing sets are merged to create one single set.
- Only mean() and std() measurements are selected.
- Activity names are changed from numerical IDs to descriptive characters from the `activity_labels.txt` file.
- Column names are changed by removing special characters and adopting an all-lowercase style.
- The dataset is finally grouped by subject IDs and activity types and summarized by `mean`.

# Descriptions
Below is information on the varaibles in the final output `tidyset.txt`.

## Identifiers

`subjectid` and `movementlabel` are two ID columns.

## Measurements

The original column names are transformed into the described style. The relationship between transformed and origianl column names should be clear enough. Hence, a detailed description of what each column is will be omitted here.

As an example, column name `timegravityaccmeanx` means time domain signal of gravity acceleration mean value, X-axis component.

As another example, column name `timebodyaccmagmeannorm` means time domain signel of body accelereation mean value, taken magnitude by norm.

In R `stringr` package the transform is:

```R
#First, extract time/frequency, mean/std, X/Y/Z information
coln <- str_match(coln,
                  "(t|f)([a-zA-Z]+?)-(mean|std)\\(\\)-?(X|Y|Z)?")
#Then, transform to new column name style
coln <- paste0(
        ifelse(pull(coln, 2) == "t","time","freq"),
        tolower(pull(coln,3)),
        tolower(pull(coln,4)),
        ifelse(is.na(pull(coln,5)),"norm", tolower(pull(coln,5)))
)
```

The final column names are:
- timebodyaccmeanx
- timebodyaccmeany
- timebodyaccmeanz
- timebodyaccstdx
- timebodyaccstdy
- timebodyaccstdz
- timegravityaccmeanx
- timegravityaccmeany
- timegravityaccmeanz
- timegravityaccstdx
- timegravityaccstdy
- timegravityaccstdz
- timebodyaccjerkmeanx
- timebodyaccjerkmeany
- timebodyaccjerkmeanz
- timebodyaccjerkstdx
- timebodyaccjerkstdy
- timebodyaccjerkstdz
- timebodygyromeanx
- timebodygyromeany
- timebodygyromeanz
- timebodygyrostdx
- timebodygyrostdy
- timebodygyrostdz
- timebodygyrojerkmeanx
- timebodygyrojerkmeany
- timebodygyrojerkmeanz
- timebodygyrojerkstdx
- timebodygyrojerkstdy
- timebodygyrojerkstdz
- timebodyaccmagmeannorm
- timebodyaccmagstdnorm
- timegravityaccmagmeannorm
- timegravityaccmagstdnorm
- timebodyaccjerkmagmeannorm
- timebodyaccjerkmagstdnorm
- timebodygyromagmeannorm
- timebodygyromagstdnorm
- timebodygyrojerkmagmeannorm
- timebodygyrojerkmagstdnorm
- freqbodyaccmeanx
- freqbodyaccmeany
- freqbodyaccmeanz
- freqbodyaccstdx
- freqbodyaccstdy
- freqbodyaccstdz
- freqbodyaccjerkmeanx
- freqbodyaccjerkmeany
- freqbodyaccjerkmeanz
- freqbodyaccjerkstdx
- freqbodyaccjerkstdy
- freqbodyaccjerkstdz
- freqbodygyromeanx
- freqbodygyromeany
- freqbodygyromeanz
- freqbodygyrostdx
- freqbodygyrostdy
- freqbodygyrostdz
- freqbodyaccmagmeannorm
- freqbodyaccmagstdnorm
- freqbodybodyaccjerkmagmeannorm
- freqbodybodyaccjerkmagstdnorm
- freqbodybodygyromagmeannorm
- freqbodybodygyromagstdnorm
- freqbodybodygyrojerkmagmeannorm
- freqbodybodygyrojerkmagstdnorm
