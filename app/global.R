library(dplyr)
library(forcats)
library(tm)
library(wordcloud)
library(memoise)
library(SnowballC)
library(RColorBrewer) 
library(ggplot2)

# 
variabledata <- read.csv("data/variabletypes.csv")
# wsjtextdata = readLines('data/wsjtextdata.txt')
# docs <- Corpus(VectorSource(wsjtextdata))

docs <- Corpus(DirSource('text/'))

#docs <- tm_map(docs, stripWhitespace)

#docs <- tm_map(docs, tolower)

#docs <- tm_map(docs, stemDocument)

sectionsdf <- read.csv('data/wsjsections.csv')
sectionsdf = sectionsdf[order(-sectionsdf$AverageComments),]

wsj2 = read.csv('data/wsj2.csv')

wsj3 = read.csv('data/wsj3.csv')




