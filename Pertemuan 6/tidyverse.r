library(dslabs)
library(dplyr)
data("murders")

murders = mutate(murders, rate= total/population*100000, pupulasi_ribuan= population/1000)

murders = mutate(murders, tipe= ifelse(rate > 2,"Tinggi","Rendah"))

filter(murders, population > 1000000, rate < 2, region == "Northeast")

select(murders, state,region, rate)

murders %>% select(state,population,total) %>% filter(population >2000000) %>% mutate(red = "red")

data("heights")
s = heights %>%
  filter(sex == "Male") %>%
  summarize(average = mean(height),max = max(height),min = min(height), standard_deviation = sd(height))
s

heights %>% group_by(sex)

murders %>% arrange(desc(rate)) %>% head()

heights %>% arrange(height,sex)

murders %>% top_n(10,rate)
  