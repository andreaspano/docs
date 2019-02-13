
# clean up
rm(list =  ls())

# require
require(dplyr)
require(sparklyr)


# fire  spark context 
sc <- spark_connect(master = "local")

# load data into spark
path <-  '/data/dataexpo/'
ontime  <- spark_read_csv(sc = sc, 
                          name = 'ontime', 
                          path = path, 
                          header = T,
                          delimiter = ',')

# how much data 
howmuch <- ontime %>% summarise(n = n())

# Query  
show_query(howmuch)


# colect
delay <-  ontime %>% 
  group_by(Year, Month) %>% 
  summarise(n = n() , 
            avg_dep_delay = mean(DepDelay, na.rm = T)) %>% 
  collect()

# subset 
ontime_clean <-  ontime %>% 
  select(DepDelay,  ArrDelay) %>% 
  filter ( !is.na(DepDelay), 
           !is.na(ArrDelay))

# linear regression
fm <- ml_linear_regression(ontime_clean, formula = ArrDelay~DepDelay)
summary(fm)

# close context 
spark_disconnect(sc)

# the old approach ---------------------------------------------- 
require(readr)
require(dplyr)
require(ggplot2)

path <-  '/data/dataexpo/'
file_list <- list.files(path, full = T )

#first attempt and subsequent 
#col_spec <- read_delim(file_list[[i]], delim = ',', n_max = 1000) %>% spec()
source('~/dev/docs/col_spec.R')

n <-  length(file_list)
df <-NULL
for (i in 1:n){
  tmp <- read_delim(file_list[[i]], delim = ',', n_max = Inf, col_types = col_spec)
  tmp <-  sample_n(tmp, 10000)
  df <-  bind_rows(df, tmp)
  
}

# check data
nrow(df)

# plot 
df %>% 
  filter (  DepDelay > -10 ) %>%
  mutate(Month =  factor(Month), 
         Year = factor(Year)) %>%  
  ggplot(aes(DepDelay, ArrDelay, group = Month, color =  Month)) + 
  geom_point() +
  facet_wrap(.~Year) +
  theme_dark()

# model 
fm1 <- lm(ArrDelay ~ DepDelay, data = df)
summary(fm1)

