#PACKAGES
library(tidyverse)

#DOWNLOADS AND FORMATS FILE WITH LINKS TO PATHWAYS
download.file("http://rest.kegg.jp/list/pathway", destfile = "C:/Users/Caleb/Desktop/Work/Microbiome/KeggMap/koManifest.tsv")
map <- read.delim("C:/Users/Caleb/Desktop/Work/Microbiome/KeggMap/koManifest.tsv", sep = "\t", header = F)

#FOR EACH OF THE PATHWAYS, FIND THE KO GENES THAT MAP TO THAT PATHWAY
urlList <- c()
for (s in map$V1)
{
  add <- s
  #...AND REMOVE SOME EXCESS TEXT SO WE JUST HAVE THE MAPPING NUMBER
  add <- str_replace_all(add, "path:", "")
  urlList <- append(urlList, add)
}

#CREATES AN EMPTY DATA FRAME
finalOut <- data.frame(Mapping=character(0), KeggIDs=numeric(0))

#FOR EACH OF THESE PATHWAYS
for (i in 1:length(urlList)){
  #WAIT 3 SECONDS TO AVOID DOS
  Sys.sleep(3)
  #CREATE A URL LINK TO THE MAPPING PATHWAY
  link <- paste("http://rest.kegg.jp/link/ko/", urlList[i], sep = "")
  #DOWNLOAD IT
  download.file(link, destfile = "C:/Users/Caleb/Desktop/Work/Microbiome/KeggMap/map.tsv")
  temp <- NULL
  try(temp <- read.delim("C:/Users/Caleb/Desktop/Work/Microbiome/KeggMap/map.tsv", sep = "\t", header = F), silent = T)
  
  if (is.null(temp) == F){
    #CREATE THE STRING FOR THIS ROW
    row <- c()
    tabBool <- T
  
    #REMOVE EXCESS CHARACTERS
    for (s in temp$V2){
      add <- s
      add <- str_replace_all(add, "ko:", "")
      #FOR FORMATTING, THE FIRST SEPARATOR IS REMOVED
      if (tabBool == T){
        row <- paste(row, add, sep = "")
        tabBool <- F
      }
      else{
        row <- paste(row, add, sep = " ")
      }
    }
  
    bind <- data.frame(Mapping=urlList[i], KeggIDs=row) 
    finalOut <- rbind(finalOut, bind)
  }
}

