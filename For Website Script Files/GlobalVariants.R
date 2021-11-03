#Global Variants

#Goal for website: on line 18, have the location filter as a drop down menu. 
setwd("~/covid-vaccines/CSVs")
variants <- read.csv("covid-variants.csv")


variants_date <- variants %>%
  mutate(year = year(as_date(date))) %>%
  mutate(month = month(as_date(date))) %>%
  mutate(day = day(as_date(date))) %>%
  filter(variant == "Alpha" | variant == "Delta" | variant == "Gamma" | variant == "Iota" | variant == "Beta" | 
           variant == "Eta" | variant == "Lambda")


variants_popular <- variants_date %>%
  #have this be an input for country
  filter(location == "Argentina") %>%
  group_by(variant, year, month) %>%
  summarise(
    n = sum(num_sequences, na.rm = TRUE)
  ) %>%
  mutate(month = as.factor(month)) %>%
  mutate(month_write = ifelse(month == 1, "Jan",
                              ifelse(month == 2, "Feb",
                                     ifelse(month == 3, "Mar",
                                            ifelse(month == 4, "Apr",
                                                   ifelse(month == 5, "May",
                                                          ifelse(month == 6, "Jun",
                                                                 ifelse(month == 7, "Jul",
                                                                        ifelse(month == 8, "Aug",
                                                                               ifelse(month == 9, "Sep",
                                                                                      ifelse(month == 10, "Oct",
                                                                                             ifelse(month == 11, "Nov",
                                                                                                    ifelse(month == 12, "Dec", NA))))))))))))) %>%
  mutate(month_write = factor(month_write, levels = c("Dec", "Nov", "Oct", "Sep", "Aug", "Jul", "Jun", "May", "Apr", "Mar", "Feb", "Jan")))


ggplot(variants_popular, aes(month_write, n, fill = variant)) +
  geom_bar(stat = "identity") +
  facet_wrap(~year) +
  coord_flip() +
  theme_classic() +
  labs(title = "Covid-19 Variant Prevelance By Year", y = "Month", x = "Relevant Prevelance", fill = "Variant")
