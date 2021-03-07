# Introduction to tableone

## Load tableone package
```{r}
library(tableone)
library(distill)
```

## Load survival package for Mayo Clinic's PBC data
```{r}
library(survival)
data(pbc)
```

## Single group summary
### Simplest use case
Involves summarising the entire dataset. You feed in the data frame to the main workhorse function CreateTableOne().
```{r}
CreateTableOne(data = pbc)
```
### Categorical variable conversion
Most of the categorical variables in this dataset are coded numerically, so we either have to transform them to factors in the dataset or use factorVars argument to transform them as we go. It's better practice to specify which variables to summarise by the vars argument and exclude the ID variable(s). In this case, we are saving the result object in a variable.
#### Get variable names
```{r}
dput(names(pbc))
```

#### Vector of variables to summarise
```{r}
myVars <- c("time", "status", "trt", "age", "sex", "ascites", "hepato", "spiders", "edema", "bili", "chol", "albumin", "copper", "alk.phos", "ast", "trig", "platelet", "protime", "stage")
```
#### Vector of categorical variables that need transformation
```{r}
catVars <- c("status", "trt", "ascites", "hepato", "spiders", "edema", "stage")
```
#### Create a TableOne object
```{r}
tab2 <- CreateTableOne(vars = myVars, data = pbc, factorVars = catVars)
```
Now it is more interpretable. Binary categorical variables are summarised as counts and percentages of the second level. If it is coded as 0 and 1, the "1" level is summarised. For 3+ category variables all levels are summarised. NB: Percentages are calculated after excluding missing values.

### Showing all levels for categorical variables
To show all levels, use showAllLevels argument to the print() method.
```{r}
print(tab2, showAllLevels = TRUE, formatOptions = list(big.mark = ","))
```
### Detailed information including missingness
If you require more detailed information including the number/proportion missing. Use the summary() method on the result object. Continuous variables are shown first, categorical variables second.
```{r}
summary(tab2)
```
### Summarising nonnormal variables
For this dataset, most of the continuous variables are highly skewed (biomarkers are usually distributed with strong positive skews). To summarise them as such, use the nonnormal argument to the print() method. If you just say nonnormal = TRUE, all variables are summarised the "nonnormal" way.
```{r}
biomarkers <- c("bili", "chol", "copper", "alk.phos", "trig", "protime")
print(tab2, nonnormal = biomarkers, formatOptions = list(big.mark = ","))
```
## Multiple group summary
When you want to group subjects and summarise group by group. Grouping by exposure categories is probably the most common way, so here we'll do it by the treatment variable.
```{r}
tab3 <- CreateTableOne(vars = myVars, strata = "trt", data = pbc, factorVars = catVars)
print(tab3, nonnormal = biomarkers, formatOptions = list(big.mark = ","))
```
### Testing
When there are two or more groups, group comparison p-values are printed along with the table. Very small p-values are shown with the less than sign. The hypothesis test functions used by default are chisq.test() for categorical variables (with continuity correction) and oneway.test() for continuous variables (with equal variance assumption, i.e., regular ANOVA). Two-group ANOVA is the equivalent of a t-test.
If you're concerned about the nonnormal variables and small cell counts in the stage variable, use the nonnormal argument as above with the exact (test) argument in the print() method. kruskal.test() is used for the nonnormal continuous variables and fisher.test() is used for categorical variables specified in the exact argument. kruskal.test() is equivalent to wilcox.test() in the two-group case. The column named test is to indicate which p-values were calculated using the non-default tests.
To also show standardised mean differences, use the smd option.
```{r}
print(tab3, nonnormal = biomarkers, exact = "stage", smd = TRUE)
```
## Miscellaneous
### Categorical or continuous variables-only
You may want to see only categorical or continuous variables. Do this by accessing the CatTable part and ContTable parts of the TableOne object. summary() methods are defined for both as well as print() method with various arguments. 

#### Categorical part only
```{r}
tab3$CatTable
```
#### Continuous part only
```{r}
print(tab3$ContTable, nonnormal = biomarkers)
```

