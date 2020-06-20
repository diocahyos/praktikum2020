library(ggplot2)
library(here)
# untuk memanggil data avocado.csv
avocado_df = read.csv(here("data-raw","avocado.csv"))
# untuk mengetahui nilai seperti mean median max min pada setiap variable
summary(avocado_df)
# untuk mengetahui tipe data pada setiap variable
str(avocado_df)
# untuk mengetahui nilai max min quantile 1 median quantile 3 pada 1 variable saja
quantile(avocado_df$Total.Volume)
# untuk mengetahui nilai median pada 1 variable saja
median(avocado_df$Total.Volume)
# untuk mengetahui nilai min pada 1 variable saja
min(avocado_df$Total.Volume)
# untuk mengetahui nilai max pada 1 variable saja
max(avocado_df$Total.Volume)
# untuk mengetahui nilai mean pada 1 variable saja
mean(avocado_df$Total.Volume)

# untuk membuat sebuah plot, disini membuat beberapa plot berdasarkan tahun
ggplot(avocado_df, aes(x = AveragePrice, y = Total.Bags)) +
  geom_point(aes(colour = type), alpha = 0.2) +
  facet_wrap(~year, scales = "free")