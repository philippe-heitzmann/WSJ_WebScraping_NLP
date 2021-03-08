### Project Overview

In this project I web-scraped news and opinion articles from the **Wall Street Journal (“WSJ”)** in order to investigate a possible relationship between article emotionality, subjectivity, positivity/negativity and **user engagement**, captured through number of comments posted on articles, as well as **S&P 500 returns for that day**. To answer these questions, I web scraped 22,772 full text WSJ articles published between Jan-19 and July-20 from the Wall Street Journal’s [news archives](https://www.wsj.com/news/archive/years) using Python's Selenium library. For each article, I scraped the article text, headline, sub-headline, date published, author name, number of comments and rubric name in order to gather as much text data as possible for sentiment analysis.

### Research Questions 

1. Can a statistically significant, causal relationship be demonstrated between a WSJ article's degree of subjectivity/objectivity and positivity/negativity in its writing (as defined by widely used Python sentiment analysis libraries), and the number of online comments posted by readers for that article?

1. To the degree that the WSJ enjoys a wide readership in the financial world and that previous findings in the literature indicate a weak linkage between objectivity, emotionality, frequency of media coverage and financial markets fluctuations, can a statistically significant causal relationship be demonstrated between the WSJ's coverage of financial news, specifically WSJ articles’ degree of subjectivity/objectivity and positivity/negativity polarity on a given day t, and stock price movements from the S&P 500 Index on day t + n for 0 <= n <= 1?


### Natural Language Processing Scores

Valence Aware Dictionary and sEntiment Reasoner (“VADER”) and TextBlob, were used to perform sentiment analysis on the combined data. The first, VADER, is a Natural Language Processing sentiment analysis model available through the Python nltk package that outputs polarity (positive/negative) and intensity of emotion scores. VADER output variables incude *negative*, *neutral*, *positive* and *compound* and can be read more about [here](https://pypi.org/project/vaderSentiment/). TextBlob is a Python API used for common NLP tasks such as part-of-speech tagging, noun phrase extraction, sentiment analysis, classification, and translation. Textblob output variables incude *polarity* and *subjectivity* and can be read more about [here](https://textblob.readthedocs.io/en/dev/).

### Research Insights & Conclusion 

Our simple linear regression analysis of the sentiment analysis variables on number of comments yielded a very low adj R^2 of **0.014**, showing this is a poor model for explaining the variance in number of comments posted on WSJ articles. We cannot reject the null hypothesis that the beta coefficients of the polarity, subjectivity, positivity and negativity variables are zero based on the Prob (F-stat) of 0.2045. Our results therefore show WSJ sentiment analysis has low predictive power in relation to number of comments posted on WSJ articles, although, quite interestingly, VADER negativity scores are shown to be statistically significant to the 1% level in our models.  One possible explanation for this positive & significant relationship between number of comments and negativity score may be that WSJ articles with higher negativity scores may be more likely to announce events that would entail a public showing of grief or support. These tragic events, such as the announcement of the death of a public figure or some other calamity that would affect large numbers of people, could therefore generate more comments on that article. Further investigation is needed to pinpoint some of the reasons driving this relationship.

To answer our second research question, a total of four simple linear regression analyses of the sentiment analysis variables against (i) same-day percentage change in the S&P 500 and (ii) following day percentage change in S&P 500 were made. The first three models respectively regressed same-day S&P 500 percentage change against (i) TextBlob variables only, (ii) VADER variables only, and (iii) all variables combined. Low Adj R^2 values of **~0.01** and high p-values for all three regressions show these are poor models with low predictive power, even with the VADER neutral values and SPX Volume numbers further added as extra independent variables. Our results therefore show WSJ sentiment analysis has low predictive power in relation to same-day SPX moves, although, quite interestingly, TextBlob polarity of WSJ article is significant to the 10% level. 

[Link to R Shiny app](https://philippe1.shinyapps.io/WSJApp2/)

[Link to blog post](https://nycdatascience.com/blog/student-works/scraping-wall-street-journal-article-data-to-measure-online-reader-engagement-an-nlp-analysis/)

