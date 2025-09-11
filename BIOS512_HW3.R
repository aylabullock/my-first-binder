
#Homework 03 - Nonstandard Evaluation and Git
#Nonstandard Evaluation
#Question 1

#Imagine we have a data frame called data, with a type column. Which one works and why?
  #Function 1:
  
  group_and_tally <- function(df, column){
    df %>% group_by({{ column }}) %>% tally();
  }
group_and_tally(data, type);

  #Function 2:
  
  group_and_tally <- function(df, column){
    df %>% group_by(column) %>% tally();
  }
group_and_tally(data, type);


#Function 1 works. In function 2, the computer is trying to use something literally named "column" to group the data, and that
#doesn't exist in this dataframe.  The double curly brackets are how you "inject" a column name into the function using tidy evaluation. 
#Using the curly brackets tells the computer to take the second argument in the function and look for a column in the data frame with that name. 



##Git

#For the questions below, please add the commands you used to complete these steps.

#Question 2

#Set up your git repo on your local computer. If you already make a git repo on GitHub, but it isn’t on your local computer - clone it.

#First I opened gitbash, then I typed the following:
cd "C:\Users\bulla\Downloads\HW2 GIT REPO"
git init
echo "#Homework 2" > README.md
git add README.md
git commit -m "initial commit"
  

#Question 3

#Set up your SSH key.

ssh-keygen -t ed25519 -C "aylab@ad.unc.edu"
I then typed in my passcode

#Question 4

a) Add a HW2 directory to your git repo through the terminal with a HW2.md file that says "This is for homework 2."
mkdir homework2
cd homework2
echo "This is for Homework 2" > HW2.md

#b) Add HW2.md to the staging area. Then, use the command to see which files have been modified, staged for commit, or are untracked. What does it show? They should copy paste the terminal response after git status, and show that key used the commands below.

# git add HW2.md
# git status

On branch master
Changes to be committed:
  (use "git restore --staged <file>..." to unstage)
new file:   HW2.md


#c) Save file changes to the main branch.

$ git commit -m "adding hw.md"


#d) Now, edit the HW2.md file to give it a title.

nano hw2.md

I then typed "TITLE: This is my title" into Nano, then hit ctrl+o, enter, ctrl+x

cat hw2.md
Title: This is my title

This is for Homework 2

#e) Use the command that compares current, unsaved changes to the main branch. What does it say?
  
git diff master
warning: in the working copy of 'homework2/HW2.md', LF will be replaced by CRLF the next time Git touches it
diff --git a/homework2/HW2.md b/homework2/HW2.md
index 6dbdf24..9629bfa 100644
--- a/homework2/HW2.md
+++ b/homework2/HW2.md
@@ -1 +1,4 @@
  +
  +TITLE: This is my title
+
  This is for homework 2

#f) Use the command that checks the status of the working directory and the staging area again. What does it say?

git status
On branch master
Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
(use "git restore <file>..." to discard changes in working directory)
modified:   HW2.md

no changes added to commit (use "git add" and/or "git commit -a")

  
g)# Once again, add HW2.md to the staging area and save the file changes to the main branch. Then, get use the command that gives you project history and paste the output in your homework.

git add hw2.md
git commit -m "Add title to HW2.md"
git log
commit 1fba22a0a44489020dab6d7b58bab73282c76e18 (HEAD -> master)
Author: Ayla Bullock <bull.ayla@gmail.com>
  Date:   Wed Sep 10 12:54:51 2025 -0400

Add title to HW2.md

commit 7e50ac1dea6583999f61c46d69836bcb6ff344be
Author: Ayla Bullock <bull.ayla@gmail.com>
  Date:   Wed Sep 10 12:48:53 2025 -0400

adding hw2.md

commit b6ce8b814767800c8103687ad5e23d42089de17a
Author: Ayla Bullock <bull.ayla@gmail.com>
  Date:   Wed Sep 10 12:32:25 2025 -0400

initial commit


#h) Do some searching... What git command will provide you documentation on other commands? Use that command to find documentation on git log and git show. What does --since mean in regards to git log? Copy and paste what is written in the documentation.
git help <command> provides documentation on individual commands. 
git help log
git help show

"Using more options generally further limits the output (e.g. --since=<date1> limits to commits newer than <date1>, and using it with --grep=<pattern> further limits to commits whose log message has a line that matches <pattern>), unless otherwise noted."


##Tidyverse

#Note: Please make sure Binder is set up correctly to run this section. You can follow the instructions here: https://github.com/rjenki/BIOS512.

#Please show your code for this section! Before completing this section, please run the following.

library(tidyverse)
if (!dir.exists("intermediate")) dir.create("intermediate", recursive = TRUE)
if (!exists("mdpre")) mdpre <- function(x) { print(x) }
if (!exists("ggmd"))  ggmd  <- function(p) { print(p) }


Question 5

Download the patient_names.csv and patient_properties.csv files from Canvas and read them into R. Manually set the date columns to be date variables. Print the first 10 observations of each.

getwd()

#I had a bunch of issues and long story short had to rename the csv file to patient_names3.csv

names <- read_csv("patient_names3.csv",
    col_types = cols(
      BIRTHDATE = col_character(),
      DEATHDATE = col_character()
      ))

names <- names %>%
  mutate(
    BIRTHDATE = parse_date(BIRTHDATE, "%m/%d/%y"),
    BIRTHDATE = if_else(BIRTHDATE > as.Date("2020-12-31"), BIRTHDATE - years(100), BIRTHDATE),
    DEATHDATE = parse_date(DEATHDATE, "%m/%d/%y"),
    DEATHDATE = if_else(DEATHDATE > as.Date("2020-12-31"), DEATHDATE - years(100), DEATHDATE)
  )

#the above code is written based on the HW3 hint that says "Because they are formatted in MM/DD/YY instead of MM/DD/YYYY, R automatically assumes some of the dates are in the 2000s instead of the 1900s, giving us some dates in the future. It does this for all the birthdates past 2020."

properties <- read_csv("patient_properties.csv")

View(properties)
View(names)


Question 6

In the data frame pulled from patient_properties, you'll notice that the data is long, not wide. Do a pivot to make the properties their own columns. Print the first 10 observations after you do so.

properties_wide <- pivot_wider(data=properties, id_cols = ID, names_from = property, values_from = value)
slice_head(properties_wide, n=10)

Question 7

Perform a left join of the names and properties_wide data frames by the ID column and print the first 10 rows.

names_prop_left <- names %>%
  left_join(properties_wide, by = "ID")

slice_head(names_prop_left, n=10)
  
View(names_prop_left)


Question 8

Notice something interesting about the names in our data set. Fix the name formatting and print the first 10 observations.

#looking at the names with the weird symbols
weirdnames <- names_prop_left %>%
  filter(
    str_detect(coalesce(FIRST, ""), fixed("√")) |
    str_detect(coalesce(LAST, ""), fixed("√"))
    )
  View(weirdnames)

#writing function to replace weird symbols with the right spanish vowels (I know hard coding isn't the best approach but I tried every way of re-encoding under the sun and couldn't get it fixed that way)
fix_checks <- function(y) {
  map <- c(
    "√°" = "á",
    "√©" = "é",
    "√≠" = "í",
    "√≥" = "ó",
    "√∫" = "ú",
    "√±" = "ñ",
    "\u00A0" = " "
  )
  y <- str_replace_all(y, map)
  y
}

#applying function to names
names_fixed <- names_prop_left %>%
  mutate(across(c(FIRST, LAST), fix_checks))
  
View(names_fixed) #checking to make sure it worked

#writing function to remove the numbers from the names columns
library(stringr)
simplify_strings <- function(s){
  s <- str_trim(s)
  s <- str_replace_all(s, "[0-9]", "")
  s
}

#applying to names
str_df <- names_fixed %>%
  mutate(across(c(FIRST, LAST), simplify_strings))
  View(str_df) #checking to make sure it worked

slice_head(str_df, n=10)


Question 9

Using a for statement to loop through the categorical variables 
(excluding name and ID), print the counts of each unique value in descending order, 
using the mdpre() function for formatting.


categorical_vars <- c("CITY", "STATE", "MARITAL", "RACE", "ETHNICITY", "GENDER")

for (x in categorical_vars) {
        unique_vals <- str_df %>% 
        count(.data[[x]], name = "n") %>%
        arrange(desc(n))
        mdpre(unique_vals)
        }

Question 10

If you see any weird values, get rid of the ones that don't make sense, 
and combine the ones that are formatted wrong. 
Don't forget ot check the dates! 
Print the new tables for categorical values, and print the date ranges.

#fixing demographic typos
tidy_clean <- str_df %>%
  mutate(
    RACE = recode (RACE,"asiann" = "asian"),
    CITY = recode (CITY, "North Scituate" = "Scituate"),
    GENDER = recode (GENDER, Female = "F", Male = "M", female = "F"),
    ETHNICITY = recode (ETHNICITY, nonhispani = "nonhispanic", hispani = "hispanic"),
    MARITAL = if_else(MARITAL %in% c("M", "S"), MARITAL, NA_character_)
  )
  
  View(tidy_clean)


#printing tables for categorical vars
for (x in categorical_vars) {
        unique_vals <- tidy_clean %>% 
        count(.data[[x]], name = "n") %>%
        arrange(desc(n))
        mdpre(unique_vals)
        } 

#NOTE TO REBECCA: I fixed the date formatting problems in question 5's code

#printing date ranges
birthrange <- range(tidy_clean$BIRTHDATE, na.rm = TRUE)
deathrange <- range(tidy_clean$DEATHDATE, na.rm = TRUE)

sum(is.na(tidy_clean$MARITAL))
#MARITAL has 3 "NA" values 

#printing date ranges
mdpre(birthrange)
mdpre(deathrange)

Question 11

Make a histogram of the ages of patients by gender.

ages <- tidy_clean %>%
  mutate(
    age = interval(BIRTHDATE, coalesce(DEATHDATE, Sys.Date())) / years(1)
  )

View(ages)

library(ggplot2)

ggplot(ages, aes(x = age)) +
  geom_histogram(fill = "pink", color = "white") +
  facet_wrap(~ GENDER, labeller = as_labeller(c(M = "Male", F = "Female"))) +
    labs(
    title = "Distribution of Age by Gender (M/F)",
    x = "Age",
    y = "Count"
  ) +
  theme_minimal()


Question 12

Make a scatterplot of birthdate by martial status.

library(ggplot2)

ggplot(tidy_clean, aes(x = BIRTHDATE, y = factor (MARITAL, levels = c("S", "M"), labels = c("Single", "Married")), color = MARITAL)) +
  geom_jitter(alpha = .3, height = .2) +
  labs(
    title = "Scatterplot of Birthdates by Marital Status",
    x = "Birthdate",
    y = "Marital Status"
  ) +
  theme_minimal()

#I did not apply width jitter because I wanted to keep the position on the X axis accurate to 
#the actual birthdate
