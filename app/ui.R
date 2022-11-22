library(DT)
library(shinydashboard)
library(devtools)
library(shinythemes)
library(dashboardthemes)
library(wordcloud)
library(tidyverse)
library(tidytext)
library(shinythemes)
library(shiny)

options(width = 1000)

shinyUI(dashboardPage(
  dashboardHeader(title = "Web Scraping Project #2" , titleWidth = 250),
  
  dashboardSidebar(
    width = 300,
    sidebarUserPanel(h5("Philippe Heitzmann"), subtitle = "NYCDSA Bootcamp student" ,image = 'philippeheitzmann.jpeg' ),
    sidebarMenu(
      menuItem("Research Questions & Literature", tabName = 'research1', icon = icon('question'),  badgeLabel = "pt1", badgeColor = "teal"),
      menuItem("Full Text Article Scraping", icon = icon("window-maximize"), tabName = "proj1",  
               badgeLabel = "pt1", badgeColor = "teal"),
      menuItem("WSJ Data - EDA", icon = icon("window-maximize"), tabName = "wsj",  
               badgeLabel = "pt2", badgeColor = "light-blue"),
      menuItem("Data Cleaning & NLP", icon = icon("window-maximize"), tabName = "wsj2",  
               badgeLabel = "pt2", badgeColor = "light-blue"),
      menuItem("TextBlob NLP Analysis ", icon = icon("window-restore"), tabName = "proj2",
               badgeLabel = "pt3", badgeColor = "purple"),
      menuItem("VADER NLP Analysis", icon = icon("window-maximize"), tabName = "wsj4",  
               badgeLabel = "pt3", badgeColor = "purple"),
      menuItem("Regression Analysis: Comments", icon = icon("window-maximize"), tabName = "wsj5",  
               badgeLabel = "pt4", badgeColor = "blue"),
      menuItem("Regression Analysis: S&P 500", icon = icon("window-maximize"), tabName = "wsj3",  
               badgeLabel = "pt4", badgeColor = "blue"))
  ),
  dashboardBody(
    shinyDashboardThemes(theme = "purple_gradient"),
    tabItems(
      tabItem(tabName = 'research1',
              fluidRow(box(title = "Research Questions", status = "info", solidHeader = TRUE, collapsible = TRUE, width = 12,
                           background = 'light-blue', htmlOutput('rq1'))),
              fluidRow(box(title = "Theory", status = "info", solidHeader = TRUE, collapsible = TRUE, width = 12,
                           background = 'light-blue', textOutput('rq2'))),
              fluidRow(box(title = "Hypothesis", status = "info", solidHeader = TRUE, collapsible = TRUE, width = 12,
                           background = 'light-blue', htmlOutput('rq3'))),
              column(4, box(title = "Aman, 2013", status = "primary", solidHeader = TRUE, collapsible = TRUE, width = 12,
                            background = 'teal', img(src = 'Aman 2013.png', height = 150, width = 290,textOutput('rq4')))),
              column(4, box(title = "Strycharz et al., 2018", status = "primary", solidHeader = TRUE, collapsible = TRUE, width = 12,
                            background = 'teal', img(src = 'Strycharz et al., 2018.png', height = 150, width = 290, textOutput('rq5')))),
              column(4, box(title = "Engelberg & Parsons, 2011", status = "primary", solidHeader = TRUE, collapsible = TRUE, width = 12,
                            background = 'teal', img(src = 'Engelberg & Parsons, 2011 .png', height = 150, width = 290, textOutput('rq6'))))),
      
      tabItem(tabName = 'proj1', 
              fluidRow(box(title = "Scraping Process", status = "info", solidHeader = TRUE, collapsible = TRUE, width = 12,
                           background = 'light-blue', textOutput('rq7'))),
              column(6, box(title = "Single Day WSJ News Archive", status = "info", solidHeader = TRUE, collapsible = TRUE, width = 12,
                            background = 'light-blue', img(src = 'WSJ Archives.png', height = 300, width = 475))),
              column(6, box(title = "WSJ News Article", status = "info", solidHeader = TRUE, collapsible = TRUE, width = 12,
                            background = 'light-blue', img(src = 'WSJ Article.png', height = 300, width = 475))),
              column(12, box(title = "Types of Variables Scraped", status = "primary", solidHeader = TRUE, collapsible = TRUE, width = 12,
                             background = 'teal', (DT::dataTableOutput("table1"))))),
      tabItem(tabName = 'wsj', 
              fluidRow(box(title = "Wall Street Journal Exploratory Data Analysis", status = "info", solidHeader = TRUE, collapsible = TRUE, width = 12, background = 'light-blue', textOutput('rq14'))),
              
              column(6, (box(sliderInput('maxwords', '# of words', min = 50, max = 400, value = 400), width = 12))),
              
              column(6, (box(sliderInput('sections', '# of sections', min = 5, max = 15, value = 10), width = 12))),
              
              column(6, (box(plotOutput("wordcloud1"), width = 12))),
              
              column(6, (box(plotOutput("plot2"), width = 12)))),
      tabItem(tabName = 'wsj2', 
              fluidRow(box(title = "Wall Street Journal Data - Cleaning & Merging Process", status = "info", solidHeader = TRUE, collapsible = TRUE, width = 12, background = 'light-blue', textOutput('rq8'))),
              column(6, box(title = 'Downloading SPX Data from Yahoo Finance', status = "primary", solidHeader = TRUE, background = 'light-blue', collapsible = TRUE, width = 12, img(src='Yahoo Finance.png', height = 240, width = 475))),
              column(6, box(title = 'Merging the dataframes', status = "primary", solidHeader = TRUE, collapsible = TRUE, background = 'light-blue', width = 12, htmlOutput('rq9'))),
              column(6, box(title = 'NLP Analysis - TextBlob', status = "primary", solidHeader = TRUE, collapsible = TRUE, background = 'light-blue', width = 12, htmlOutput('rq10'))),
              column(6, box(title = 'NLP Analysis - VADER', status = "primary", solidHeader = TRUE, collapsible = TRUE, background = 'light-blue', width = 12, htmlOutput('rq11')))),
      tabItem(tabName = 'wsj3', 
              fluidRow(box(title = "S&P Regression Analysis", status = "info", solidHeader = TRUE, collapsible = TRUE, width = 12, background = 'light-blue', textOutput('rq12'))),
              column(4, box(title = "TextBlob Independent Variables Only", status = "primary", solidHeader = TRUE, collapsible = TRUE, width = 12, background = 'light-blue', img(src = "WSJ Paragraph Results.png", height = 300, width = 290))),
              column(4, box(title = "VADER Independent Variables Only", status = "primary", solidHeader = TRUE, collapsible = TRUE, background = 'light-blue', img(src = 'vaderonlyspx.png', height = 300, width = 290), width = 12)),
              column(4, box(title = "All Sentiment Analysis Variables", status = "primary", solidHeader = TRUE, collapsible = TRUE, background = 'light-blue', img(src = 'allvariablesspx.png', height = 300, width = 290), width = 12))),
      tabItem(tabName = 'proj2', 
              column(6, box(title = "TextBlob Polarity Scores", status = "info", solidHeader = TRUE, collapsible = TRUE, textOutput('rq15'), background = 'light-blue', width = 12)),
              column(6, box(title = "TextBlob Subjectivity Scores", status = "info", solidHeader = TRUE, collapsible = TRUE, textOutput('rq16'), background = 'light-blue', width = 12)),
              column(6, box(plotOutput('plot3'), width = 12)),
              column(6, box(plotOutput('plot4'), width = 12))),
      tabItem(tabName = 'wsj5', 
              column(6, box(title = "All NLP Variables as Independent Variables", status = "info", solidHeader = TRUE, collapsible = TRUE, background = 'light-blue', htmlOutput('rq21'), width = 12)),
              column(6, box(title = "VADER Negativity only as Independent Variable", status = "info", solidHeader = TRUE, collapsible = TRUE, background = 'light-blue', htmlOutput('rq22'), width = 12)),
              column(6, box(title = "All NLP Variables as Independent Variables", status = "primary", solidHeader = TRUE, collapsible = TRUE, background = 'light-blue', img(src = 'allvars.png', height = 400, width = 475), width = 12)),
              column(6, box(title = "VADER Negativity only as Independent Variable", status = "primary", solidHeader = TRUE, collapsible = TRUE, background = 'light-blue', img(src = 'negativeonly.png', height = 400, width = 475), width = 12))),
      tabItem(tabName = 'wsj4', 
              column(6, box(title = "VADER Positivity Score", status = "info", solidHeader = TRUE, collapsible = TRUE, background = 'light-blue', textOutput('rq19'), width = 12)),
              column(6, box(title = "VADER Negativity Score", status = "info", solidHeader = TRUE, collapsible = TRUE, background = 'light-blue', textOutput('rq20'), width = 12)),
              column(6, box(plotOutput('plot5'), width = 12)),
              column(6, box(plotOutput('plot6'), width = 12)))
    ))
))

