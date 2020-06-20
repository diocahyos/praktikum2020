library(dslabs)
library(tidyverse)
data("murders")
murders %>% group_by(region)

class(as_tibble(murders))
as_tibble(murders)
class(murders[,4])
class(as_tibble(murders)$population)
class(as_tibble(murders[,4]))

murders$Population
as_tibble(murders)$Population

tibble(id = c(1, 2, 3), func = c(mean, median, sd)) 
grades <- tibble(names = c("John", "Juan", "Jean", "Yao"), exam_1 = c(95, 80, 90, 85), exam_2 = c(90, 85, 85, 90))
grades1 <- data.frame(names = c("John", "Juan", "Jean", "Yao"), exam_1 = c(95, 80, 90, 85), exam_2 = c(90, 85, 85, 90), stringsAsFactors = FALSE)
class(grades1$names)

rates <-filter(murders, region == "South") %>% mutate(rate = total / population * 10^5) %>% .$rate
rates

compute_s_n <- function(n){
  x <- 1:n
sum(x)
}
n <- 1:25
s_n <- sapply(n, compute_s_n)

s_nmap = map(n, compute_s_n)
s_nmapdpl = map_dbl(n, compute_s_n)

compute_s_n <- function(n){   
  x <- 1:n
tibble(sum = sum(x))
}
s_nmapdf <- map_df(n, compute_s_n)
s_nmapdf

x <- c(-2, -1, 0, 1, 2)
case_when(x < 0 ~ "Negative", x > 0 ~ "Positive", TRUE ~ "Zero")

murders %>%
  mutate(group = case_when( abb %in% c("ME", "NH", "VT", "MA", "RI", "CT") ~ "New England", abb %in% c("WA", "OR", "CA") ~ "West Coast",  region == "South" ~ "South", TRUE ~ "Other")) %>%
group_by(group) %>%
summarize(rate = sum(total) / sum(population) * 10^5)

between(5,1,9)
