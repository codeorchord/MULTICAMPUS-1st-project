library(rJava)
library(DBI)
library(RJDBC)
library(ggmap)
library(geojsonio)
library(broom)
library(viridis)
library(ggplot2)
library(dplyr)
library(cowplot)


#env
path <- "REPLACEME_WD"
setwd(path)
options(digits=16)


#condition-----------------------
bounds <- c(
  REPLACEME_BOTTOM,
  REPLACEME_LEFT,
  REPLACEME_RIGHT,
  REPLACEME_TOP
)
names(bounds) <- c("bottom", "left", "right", "top")
adjust <- 0.002

map.lat <- mean(c(bounds['bottom'], bounds['top']))
map.long <- mean(c(bounds['left'], bounds['right']))
map.width <- bounds['right'] - bounds['left']
map.height <- bounds['top'] - bounds['bottom']
map.ratio.wh <- map.height / map.width
map.ratio.geo <- 1/cos(37.335887*pi/180)


json.slice <- 101

vector_h <- seq(bounds['left'], bounds['right'], length.out = json.slice)
vector_v <- seq(bounds['top'], bounds['bottom'], length.out = ceiling(json.slice * map.ratio.wh))

cell.r = (vector_h[2] - vector_h[1]) / 2
cell.range.cctv <- 0.0009629990225690221 * REPLACEME_INFLUENCE #cell.r * 7
cell.range.station <- 0.001650855467261181 * REPLACEME_INFLUENCE #cell.r * 12


#get DB data in bounds
drv <- JDBC("oracle.jdbc.driver.OracleDriver","REPLACEME_ORACLEDRIVER")
conn <- dbConnect(drv, "jdbc:oracle:thin:@REPLACEME_DBSERVER", "hr", "oracle")

stations <- dbGetQuery(conn, paste("SELECT ps_id as id, 0 as type, longitude, latitude FROM prj_pstations WHERE (longitude between", bounds["left"]-adjust, "and", bounds["right"]+adjust, ") and (latitude between", bounds["bottom"]-adjust, "and", bounds["top"]+adjust, ") order by id"))

cctvs <- dbGetQuery(conn, paste("SELECT cctv_id as id, 1 as type, longitude, latitude FROM prj_cctvs WHERE (longitude between", bounds["left"]-adjust, "and", bounds["right"]+adjust, ") and (latitude between", bounds["bottom"]-adjust, "and", bounds["top"]+adjust, ") order by id"))

spots <- rbind(stations, cctvs)
rm(list = c("stations", "cctvs"))
rm(list = c('conn', 'drv'))


# make geojson
sink("tmp.geojson")
cat("{\"type\": \"FeatureCollection\", \"features\": [");

i <- 0
lenI <- length(vector_v)
lenJ <- length(vector_h)
nID <- 0
for(v in vector_v){
  i <- i + 1
  
  if(i == lenI) break;
  
  j <- 0
  for(h in vector_h) {
    j <- j + 1
    if(j == lenJ) break;
    
    nID <- nID + 1;
    cat("\n{ \"type\": \"Feature\", \"properties\": { \"code\": \"")
    cat(nID)
    cat("\", \"name\": \"n\", \"name_eng\": \"n\", \"base_year\": ")
    cat("\"2019\" }, \"geometry\": { \"type\": \"Polygon\", ")
    cat("\"coordinates\": [ [")
    
    cat("["); cat(vector_h[j]); cat(", "); cat(vector_v[i]); cat("],");
    cat("["); cat(vector_h[j+1]); cat(", "); cat(vector_v[i]); cat("],");
    cat("["); cat(vector_h[j+1]); cat(", "); cat(vector_v[i+1]); cat("],");
    cat("["); cat(vector_h[j]); cat(", "); cat(vector_v[i+1]); cat("],");
    cat("["); cat(vector_h[j]); cat(", "); cat(vector_v[i]); cat("]");
    
    if( i == lenI-1 && j == lenJ-1)
      cat("] ] } }\n")
    else
      cat("] ] } },")
  }
}
cat("] }")
sink()
rm(list=c('i','nID', 'lenI', 'lenJ'))

# read geojson 
spdf <- geojson_read("tmp.geojson",  what = "sp")
spdf_fortified <- tidy(spdf, region = "code")

#make security point data
nID <- 0
ID <- c(0)
density <-c(0)
for(p in spdf@polygons){
  nID <- nID + 1
  
  coords <- p@Polygons[[1]]@coords;
  left <-  coords[1, 1]
  top <- coords[1, 2]
  right <- coords[3, 1]
  bottom <- coords[3, 2]
  
  p.lat <- mean(c(top, bottom))
  p.long <- mean(c(left, right))
  
  cctv_sub <- subset(spots, 
      TYPE == 1 &
      sqrt( (p.lat - LATITUDE)^2 + (p.long/map.ratio.geo - LONGITUDE/map.ratio.geo)^2) < cell.range.cctv
  )
  
  station_sub <- subset(spots,
      TYPE == 0  &
      sqrt( (p.lat - LATITUDE)^2 + (p.long/map.ratio.geo - LONGITUDE/map.ratio.geo)^2) < cell.range.station
  )
  
  if(nID == 1) {
    ID[1] <-  as.character(nID ) 
    density[1] <- nrow(cctv_sub) + nrow(station_sub) *10
  }
  else {
    ID <- c(ID, as.character(nID ))
    density <- c(density, nrow(cctv_sub) + nrow(station_sub) *10)
  }
  
}
rm(list=c('left', 'top', 'right', 'bottom', 'coords', 'p.lat', 'p.long'))
data <- data.frame(ID, density);
#normalization
#data$density <- ( (data$density -min(data$density))/(max(data$density) -min(data$density)))

# Make the merge
spdf_fortified = spdf_fortified %>% left_join(. , data, by=c("id"="ID")) 

# drow poygons
result <- ggplot() + 
geom_polygon(
  show.legend = FALSE,
  data = spdf_fortified, 
#  alpha = 0.3,
  aes(
    #alpha = density,
    fill = density, 
    x = long, 
    y = lat, 
    group = group,
  )
) +  
  scale_fill_viridis(trans = "log", option="D", na.value = "red", breaks=c(1, 5, 10, 20, 50, 100), direction = 1) +
  theme_void() +  
  coord_map() +
  coord_fixed(ylim=c(bounds["bottom"], bounds["top"]),xlim=c(bounds["left"], bounds["right"]), ratio=map.ratio.geo) + guides(colour=FALSE) +
  scale_x_continuous(expand=c(0,0)) +
  scale_y_continuous(expand=c(0,0)) +
  cowplot::theme_nothing() +
  theme(aspect.ratio=1) 

filename <- "REPLACEME_FILENAME.png"
URI <- paste("REPLACEME_CDNURL", filename, sep="")
ggsave( filename, result, device="png", dpi=300, scale=1)#, width=map.ratio.geo, height=1) 

print(URI);
