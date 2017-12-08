library(rvest)
library(tidyverse)
library(ggthemes)

oc <- read_html('https://en.wikipedia.org/wiki/Overseas_Chinese') %>% 
  html_nodes(xpath='//*[@id="mw-content-text"]/div/table[2]') %>% 
  html_table() %>% 
  as.data.frame() 
oc <- oc %>% filter(Overseas.Chinese.population!='')

# https://www.r-bloggers.com/world-map-panel-plots-with-ggplot2-2-0-ggalt/
world <- map_data("world")
world <- world[world$region != "Antarctica",] # intercourse antarctica

centroids<-read.csv("./country_centroids/country_centroids_all.csv",  header=T, sep="\t")

oc$Overseas.Chinese.population <- parse_number(oc$Overseas.Chinese.population)

anti_join(oc,centroids , by=c('Continent...country'='SHORT_NAME'))
# tells us which aren't named correctly
oc[21,1]<-"Democratic Republic of the Congo"
oc[9,1]<-"Republic of the Congo"
oc[99,1]<-"Trinidad and Tobago"
oc[8,1]<-"Reunion"
oc[42,1]<-"Burma"
oc[26,1]<-"Cote d'Ivoire"
oc_loc <- left_join(oc, centroids, by=c('Continent...country'='SHORT_NAME')) 
# oc_loc$Overseas.Chinese.population<-as.numeric(oc_loc$Overseas.Chinese.population)

ggplot()+
  geom_map(data=world, map=world,
           aes(x=long, y=lat, map_id=region),
           color="white", fill="#7f7f7f", size=0.05, alpha=1/4)+
  theme_map() +
  geom_point(data=oc_loc2, aes(x=LONG, y=LAT, size=Overseas.Chinese.population, col=over1m)) +
  ggtitle("The Chinese Diaspora by country")

oc_loc2<-oc_loc %>% mutate(
  over1m = ifelse(Continent...country=='Malaysia', 1, 0)
  # over1m = ifelse(Overseas.Chinese.population>1000000, 1, 0)
)
