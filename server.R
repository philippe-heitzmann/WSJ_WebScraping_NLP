library(shiny)
library(dplyr)
library(ggplot2)
library(wordcloud)
library(tidyverse)
library(tidytext)
library(shinythemes)
library(shiny)

shinyServer(function(input, output){
  output$rq1 <- renderUI({
    HTML("Research Questions: <br> <br> 1) Number of Comments <br> Can a statistically significant, causal relationship be demonstrated between a Wall Street Journal (\"WSJ\") article's degree of subjectivity/objectivity and positivity/negativity in its writing (as defined by widely used sentiment analysis libraries), and the number of online comments posted by readers for that article? <br> <br> 2) S&P 500 <br> Can a statistically significant causal relationship be demonstrated between the WSJ's coverage of financial news, specifically WSJ articles’ degree of subjectivity/objectivity and positivity/negativity polarity on a given day t as a whole, and stock price movements from the S&P 500 Index on that same day t? ")
  })
  output$rq2 <- renderText({
    paste0("Theory: Information dissemination is key component of markets efficiency Efficient Markets Hypothesis states share prices should reflect all relevant information, and media outlets like the WSJ play a key in disseminating information.")
  })
  output$rq3 <- renderUI({
    HTML("Hypothesis #1: I would expect articles that score higher on the subjectivity and polarity indices to be more likely to be shared widely as I would expect those more biased & emotional articles to engender a greater response and to be shared more widely amongst groups that share similar political opinions and views in a sort of \"echo chamber\" effect, therefore having a higher likelihood of being read and commented on. <br> <br> Hypothesis #2: Given the WSJ’s wide readership in the financial world, its wide coverage of financial news and previous findings in the literature indicating a weak relationship between frequency, objectivity and emotionality of media coverage and financial markets performance, I would expect some sort of weak relationship between WSJ news coverage and stock market performance.")
  })
  output$rq4 <- renderText({
    paste0("Our evidence clearly indicates that crash frequency increases with media coverage and its seasonal concentration. This key finding supports the notion that intensive media reports on a firm provoke extremely large reactions in the market to corporate news.")
  })
  output$rq5 <- renderText({
    paste0("A positive relation of the amount of coverage and emotionality with the fluctuation of stock prices was detected for Shell and Philips. In addition, corporate topics were found to positively Granger cause stock price fluctuation, particularly for Philips. The study advances past research in showing that the prediction of stock price fluctuation based on media coverage can be improved by including sentiment, emotionality, and corporate topics.")
  })
  output$rq6 <- renderText({
    paste0("For all earnings announcements of S&P 500 Index firms, we find that local media coverage strongly predicts local trading, after controlling for earnings, investor, and newspaper characteristics. Moreover, local trading is strongly related to the timing of local reporting, a particular challenge to nonmedia explanations.")
  })
  output$rq7 <- renderText({
    paste0("With the goal of collecting as much text data as possible for sentiment analysis, 22,772 full text WSJ articles published between 2019-2020 were scraped off the Wall Street Journal's 'News Archive' section.")
  })
  output$rq8 <- renderText({
    paste0("As the end goal for our S&P regression analysis was to concatenate all paragraph text data for a given day as a single cell value linked to a single day, empty text observations did not have to be deleted, which reduced data processing time considerably. Text data of paragraphs published on the same day were concatenated using groupby and by applying a lambda join function. The resulting data was merged with a dataframe of stock prices and trading volumes for a given day for our S&P regression analysis.")
  })
  output$rq9 <- renderUI({
    HTML("DataFrame1: Scraped dataframe of 232 unique dates with scraped WSJ paragraph text, headline text, sub-headline text, date published, author name, section name and number of comments data <br> <br> DataFrame2: A dataframe of historical SPX data of open, close, volumes from finance.yahoo.com <br> <br> Merged DataFrame: Using an inner join of the two dataframes, the resulting dataframe has 158 unique observations with article text and SPX data <br> <br> The merged dataframe necessarily has less observations due to equity markets being closed on weekends and holidays.")
  })
  output$rq10 <- renderUI({
    HTML("TextBlob: Python API for common NLP tasks such as part-of-speech tagging, noun phrase extraction, sentiment analysis, classification, translation <br> <br> Polarity: float lying in the range of [-1,1] where 1 means positive statement and -1 means a negative statement <br> <br> Subjectivity: float lying in the range of [0,1] where 1 means subjective statement and 0 means an objective statement.")
  })
  output$rq11 <- renderUI({
    HTML("Valence Aware Dictionary and sEntiment Reasoner (“VADER”): NLP sentiment analysis model available through NLTK package that outputs polarity (positive/negative) and intensity of emotion <br> <br> Negative: float in the range [0,1] representing negativity score <br> <br> Neutral: float in the range [0,1] representing neutrality score <br> <br> Positive: float in the range [0,1] representing positivity score <br> <br> Compound: Computed by normalizing the negative, neutral and positive scores. ")
  })
  output$rq12 <- renderText({
    paste0("The Adj R^2 values of ~0.01 and high p-values shows these are poor models with low predictive power, even with the VADER neutral values and SPX Volume numbers added as extra independent variables. As expected, our results show WSJ sentiment analysis has low predictive power in relation to SPX moves, although, quite interestingly, TextBlob polarity of WSJ article is significant to the 10% level. This finding is interesting  in the context of our previous EDA of polarity vs number of comments of article comments which had a quasi-flat relationship. Perhaps articles that score higher on the polarity index fall on more volatile days in the stock market, leading to more emotionally polarized articles. There needs to be more data points in our analysis, however, to drive better, more statistically significant results, as a next step for this analysis going forward.")
  })
  output$rq13 <- renderText({
    paste0("As a next step, I would want to increase the number of datapoints and limiting our text data to only scraping headlines of the WSJ and other publications in order to see if this approach would yield more interesting and statistically significant results...")
  })
  output$plot2 <- renderPlot({ 
    head(sectionsdf, input$sections) %>% ggplot(., aes(reorder(SectionName, AverageComments), AverageComments)) + geom_bar(aes(fill = AverageComments), stat = 'identity') + theme(axis.text.x = element_text(angle = 90)) + ggtitle("WSJ Sections with Highest Average Number of Comments per article") + xlab('Section Name') + ylab("Average Number of Comments per article")
  })
  output$rq14 <- renderText({
    paste0("Interestingly, the sections with the highest average number of comments per article are the Opinion, Politics, U.S. and Influencers sections, which can all be commonly thought of as rubrics dealing with more polarizing and rhetorically biased topics that tend to generate a lot of online discussion and commentary.")
  })
  output$plot3 <- renderPlot({ 
    wsj2 %>% ggplot(., aes(Comments. , polarity)) + geom_point(shape=18, color="blue") + theme(axis.text.x = element_text(angle = 90)) + ggtitle("WSJ Polarity Score vs Number of Comments") + xlab('Number of Comments') + ylab("Polarity score") + geom_smooth(method=lm,  linetype="dashed", color="darkred", fill="blue")
  })
  output$plot4 <- renderPlot({ 
    wsj2 %>% ggplot(., aes(Comments. , subjectivity)) + geom_point(shape=18, color="blue") + theme(axis.text.x = element_text(angle = 90)) + ggtitle("WSJ Subjectivity Score vs Number of Comments") + xlab('Number of Comments') + ylab("Subjectivity score") + geom_smooth(method=lm,  linetype="dashed", color="darkred", fill="blue")
  })
  output$plot5 <- renderPlot({ 
    wsj3 %>% ggplot(., aes(Comments. , positive)) + geom_point(shape=18, color="green") + theme(axis.text.x = element_text(angle = 90)) + ggtitle("WSJ Positivity Score vs Number of Comments") + xlab('Number of Comments') + ylab("Positivity score") + geom_smooth(method=lm,  linetype="dashed", color="darkred", fill="blue")
  })
  output$plot6 <- renderPlot({ 
    wsj3 %>% ggplot(., aes(Comments. , negative)) + geom_point(shape=18, color="green") + theme(axis.text.x = element_text(angle = 90)) + ggtitle("WSJ Negativity Score vs Number of Comments") + xlab('Number of Comments') + ylab("Negativity score") + geom_smooth(method=lm,  linetype="dashed", color="darkred", fill="blue")
  })
  output$rq15 <- renderText({
    paste0("Polarity of an article doesn't seem to have as much explanatory power in relation to the number of comments generated. Polarity scores for WSJ articles also seem to be very tightly distributed around the mean.")
  })
  output$rq16 <- renderText({
    paste0("Subjectivity of an article seems to explain more of the variation in number of comments posted on that article. Subjectivity scores also appear to vary more widely than polarity scores and seem to have more outliers, which may have to be addressed later on.")
  })
  #CommentsRegressionDiscussion 
  output$rq17 <- renderText({
    paste0("Subjectivity of an article seems to explain more of the variation in number of comments posted on that article. Subjectivity scores also appear to vary more widely than polarity scores and seem to have more outliers, which may have to be addressed later on.")
  })
  output$rq18 <- renderText({
    paste0("Placeholder")
  })
  output$rq19 <- renderText({
    paste0("The relationship between positivity score and number of comments is weaker than I expected as I would have thought that more optimistic and feel-good articles would be shared more widely, while the below graph seems to show there is close to no relationship between VADER positivity score and number of comments posted on that article.")
  })
  output$rq20 <- renderText({
    paste0("A seemingly high positive correlation between VADER negativity score and number of comments was perhaps the most interesting and surprising finding, at least at first glance, as I would have initially theorized that more pessimistic and negative articles would be read and shared less amongst groups and therefore lead to a lower number of posted comments for that article.")
  })
  output$rq21 <- renderUI({
    HTML("As evidenced by the very low adj R^2 of 0.01 this is a poor model for explaining the variance in number of comments posted on WSJ articles. <br> We cannot reject the null hypothesis that the beta coefficiens of the polarity, subjectivity and positivity variables are zero based on the below. <br> <br> Interestingly however, as I had expected from our EDA of VADER negativity scores in pt3, negativity scores are statistically significant to the 1% level in predicting the number of comments posted on WSJ articles. ")
  })
  output$rq22 <- renderUI({
    HTML("Unsurprisingly, a standalone linear regression model with just the negativity score as a predictor yields a model with a similarly low Adj R^2 value. <br> Although this would still be a poor model for predicting the number of comments on WSJ articles, the simplicity of this model makes it preferable to the linear model with all sentiment analysis variables included. The fact that an article scoring high on the negativity index has a positive & significant relationship to number of comments may be because articles published by the WSJ that score high on negativity may be more likely to announce events that would see a public showing of grief or support, such as for the announcement of the death of a public figure or some other tragedy that would affect large numbers of people and would therefore generate more comments on that article.")
  })
  
  output$table1 <- DT::renderDataTable(formatStyle(datatable(variabledata), rownames=FALSE, columns = 1:3, color = 'white'))
  
  output$wordcloud1 <- renderPlot(wordcloud(docs, scale=c(5,0.5), max.words=input$maxwords, random.order=FALSE, rot.per=0.35, use.r.layout=FALSE, colors=brewer.pal(8, 'Dark2')))
})
