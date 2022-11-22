import csv
import logging
import os
import sys
import time

from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.chrome.options import Options
from selenium.common.exceptions import (
    NoSuchElementException,
    StaleElementReferenceException,
)
from webdriver_manager.chrome import ChromeDriverManager

logging.basicConfig(
    format="%(asctime)s, %(msecs)d %(levelname)-8s [%(filename)s:%(lineno)d] %(message)s",
    datefmt="%Y-%m-%d:%H:%M:%S",
    level=logging.INFO,
    stream=sys.stdout,
)

URL = "https://www.wsj.com/news/archive/2020/march"
ARG_WINDOW_SIZE = "--window-size=1920,1080"


class SeleniumScraper:
    def __init__(self):
        self.url = URL
        self.driver = self.create_driver()

    def _create_options(self):
        # Set Chrome browser options
        self.chrome_options = Options()
        self.chrome_options.add_argument(ARG_WINDOW_SIZE)
        prefs = {"profile.managed_default_content_settings.images": 2}
        self.chrome_options.add_experimental_option("prefs", prefs)
        return self.chrome_options

    def create_driver(self):
        # Create Chrome browser options
        self._create_options()
        # Create webdriver
        driver = webdriver.Chrome(
            ChromeDriverManager().install(), options=self.chrome_options
        ).get(URL)
        return driver

    def wait(self, secs=2):
        time.sleep(secs)


class ScrapeFlow(SeleniumScraper):
    def __init__(self):
        super().__init__()
        self.user = os.environ.get("USER")
        self.pw = os.environ.get("PASS")
        self._prep_output_file("wsj_articles.csv")

    def main(self):
        self.signin()
        self.wait(1)
        self.get_daylinks()
        self.wait(2)
        self.parse_daylinks()

    def _prep_output_file(self, filename):
        self.csv_file = open(filename, "w", encoding="utf-8", newline="")
        self.writer = csv.writer(self.csv_file)

    def signin(self):
        """Send username and password env vars to signin form fields and press submit button"""
        # Click signin button
        sign_in_link = self.driver.find_element_by_link_text("Sign In")
        sign_in_link.click()
        self.wait(2)
        # Find username and pw fields
        username = WebDriverWait(self.driver, 10).until(
            EC.element_to_be_clickable((By.ID, "username"))
        )
        password = WebDriverWait(self.driver, 10).until(
            EC.element_to_be_clickable((By.ID, "password"))
        )
        # Input username and pw
        username.send_keys(self.user)
        password.send_keys(self.pw)
        # Find and click submit button once username and pw inputted
        submit_button = self.driver.find_element_by_xpath(
            ".//button[@type='submit'][@class='solid-button basic-login-submit']"
        )
        submit_button.click()

    def get_daylinks(self):
        self.daylinks = self.driver.find_elements_by_xpath(
            '//a[@class="WSJTheme--day-link--19pByDpZ "][@href]'
        )

    def find_text_by_xpath(self, pattern: str) -> str:
        """Helper for finding text stored under xpath pattern"""
        try:
            text_output = self.driver.find_element_by_xpath(pattern).text
        except (NoSuchElementException, StaleElementReferenceException):
            text_output = ""
        return text_output

    def parse_daylinks(self):
        """Iterate over scraped daylinks to get fields of interest for each article"""
        for i in range(11, len(self.daylinks)):
            # Get all sub daylinks by xpath
            daylinks2 = WebDriverWait(self.driver, 10).until(
                EC.presence_of_all_elements_located(
                    (By.XPATH, '//a[@class="WSJTheme--day-link--19pByDpZ "][@href]')
                )
            )
            logging.info("DayLinks2 is:", daylinks2)
            self.wait(1)
            daylinks2[i].click()
            self.wait(1.5)

            # Find headline links
            linkslist1 = None
            while not linkslist1:
                try:
                    linkslist1 = self.driver.find_elements_by_xpath(
                        './/h2[@class="WSJTheme--headline--unZqjb45 undefined WSJTheme--heading-3--2z_phq5h typography--serif-display--ZXeuhS5E "]//a[@href]'
                    )
                except:
                    continue
            logging.info("Length of linkslist1 is:", len(linkslist1))
            self.wait(2)

            for i in range(0, len(linkslist1)):
                self.wait(2)
                linkslist = None
                while not linkslist:
                    try:
                        linkslist = self.driver.find_elements_by_xpath(
                            './/h2[@class="WSJTheme--headline--unZqjb45 undefined WSJTheme--heading-3--2z_phq5h typography--serif-display--ZXeuhS5E "]//a[@href]'
                        )
                    except:
                        continue
                logging.info("Length of linkslist is:", len(linkslist))
                self.wait(2)
                try:
                    linkslist[i].click()
                    logging.info(
                        "Trying to click the following web element:", linkslist[i]
                    )
                    self.wait(1)
                    try:
                        article_string = ""
                        text1 = self.driver.find_elements_by_xpath(
                            ".//div[@class='article-content ']//p"
                        )
                        for ele in text1:
                            article_string += ele.text
                    except (
                        NoSuchElementException,
                        StaleElementReferenceException,
                    ) as e:
                        article_string = ""
                        pass

                    # Get article fields of interest
                    article_headline = self.find_text_by_xpath(
                        './/h1[@class="wsj-article-headline"]'
                    )
                    article_subheadline = self.find_text_by_xpath(
                        './/h2[@class="sub-head"]'
                    )
                    article_published_date = self.find_text_by_xpath(
                        ".//time[@class='timestamp article__timestamp flexbox__flex--1']"
                    )
                    article_author = self.find_text_by_xpath(
                        './/button[@class="author-button"]'
                    )
                    article_topic = self.find_text_by_xpath(
                        './/li[@class="article-breadCrumb"][1]/a'
                    )
                    article_number_comments = self.find_text_by_xpath(
                        './/a[@id ="article-comments-tool"]/span'
                    )
                    # Prepare row output
                    article_dict = {
                        "article_body_text": article_string,
                        "article_headline": article_headline,
                        "article_subheadline": article_subheadline,
                        "article_published_date": article_published_date,
                        "author": article_author,
                        "topic": article_topic,
                        "article_number_comments": article_number_comments,
                    }
                    # Write results
                    self.writer.writerow(article_dict.values())
                    self.driver.back()
                except:
                    logging.info("Failed to click on", linkslist[i])
                    continue
            self.driver.back()


if __name__ == "__main__":
    start_time = time.time()
    sf = ScrapeFlow()
    sf.main()
    logging.info(f'{time.time() - start_time} sec to scrape articles')
