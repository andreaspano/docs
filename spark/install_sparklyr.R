

# data
# wget http://stat-computing.org/dataexpo/2009/2008.csv.bz2
# wget http://stat-computing.org/dataexpo/2009/2007.csv.bz2
# wget http://stat-computing.org/dataexpo/2009/2006.csv.bz2
# wget http://stat-computing.org/dataexpo/2009/2005.csv.bz2
# wget http://stat-computing.org/dataexpo/2009/2004.csv.bz2
# 
# 
# bunzip2 2008.csv.bz2
# bunzip2 2007.csv.bz2
# bunzip2 2006.csv.bz2
# bunzip2 2005.csv.bz2
# bunzip2 2004.csv.bz2

rm(list =  ls())

require(readr)
require(dplyr)
require(ggplot2)
path <-  '/data/dataexpo/'
file_list <- list.files(path, full = T )

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
df %>% 
  filter (  DepDelay > -10 ) %>%
  mutate(Month =  factor(Month), 
         Year = factor(Year)) %>%  
  ggplot(aes(DepDelay, ArrDelay, group = Month, color =  Month)) + 
  geom_point() +
  facet_wrap(.~Year) +
  theme_dark()

fm1 <- lm(ArrDelay ~ DepDelay, data = df)
summary(fm1)

# java 8 
#add the WebUpd8 repository to your sources list:

$ sudo add-apt-repository ppa:webupd8team/java
$ sudo apt update
$ sudo apt install oracle-java8-installer

# Check java alternatives
$ update-java-alternatives --list

# set java version
$ sudo update-java-alternatives --set /usr/lib/jvm/java-8-oracle/

# ref https://spark.rstudio.com/
# install and  load sparklyr 
install.packages("sparklyr")


rm(list = ls())
require(sparklyr)

# install  spark locally
spark_install(version = "2.1.0")


# initialise spark session
sc <- spark_connect(master = "local")

# load dat ainto spark
path <-  '/data/dataexpo/'
ontime  <- spark_read_csv(sc = sc, 
                          name = 'ontime', 
                          path = path, 
                          header = T )

howmuch <-ontime %>% summarise(n = n())
show_query(howmuch)

ontime  <- ontime %>% mutate(DepDelay = as.numeric(DepDelay),
                             ArrDelay = as.numeric(ArrDelay))

ontime %>%  
  filter ( DepDelay >= 300) %>% 
  select (Year,  Month, DepDelay) 


delay <-  ontime %>% 
  group_by(Year, Month) %>% 
  summarise(n = n() , 
            avg_dep_delay = mean(DepDelay, na.rm = T)) %>% 
  collect()

ontime_clean <-  ontime %>% 
  select(DepDelay,  ArrDelay) %>% 
  filter ( !is.na(DepDelay), 
           !is.na(ArrDelay))


fm <- ml_linear_regression(ontime_clean, formula = ArrDelay~DepDelay)
summary(fm)

### h2O
require(rsparkling)
require(sparklyr)
require(dplyr)
require(h2o)

ontime_clean_h2o <- as_h2o_frame(sc, 
                                 ontime, 
                                 strict_version_check = FALSE)

ontime_fm_h20  <- h2o.glm(x = "DepDelay", 
                      y = "ArrDelay",
                      training_frame = ontime_clean,
                      lambda_search = F,
                      lambda = 0,
                      family = 'gaussian'
                      )

