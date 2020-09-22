
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
import csv
import re
import time
from selenium.webdriver.chrome.options import Options
from webdriver_manager.chrome import ChromeDriverManager
import os 
from bs4 import BeautifulSoup 
from selenium.common.exceptions import NoSuchElementException
from selenium.common.exceptions import ElementNotInteractableException
from selenium.common.exceptions import ElementClickInterceptedException
from selenium.common.exceptions import StaleElementReferenceException

url = 'https://www.wsj.com/news/archive/2020/march'

chrome_options = Options()
chrome_options.add_argument("--window-size=1920,1080")
prefs = {"profile.managed_default_content_settings.images": 2}
chrome_options.add_experimental_option("prefs", prefs)
driver = webdriver.Chrome(ChromeDriverManager().install(), options=chrome_options)
# url_article = requests(url)


driver.get(url)

sign_in_link = driver.find_element_by_link_text('Sign In')
sign_in_link.click()

username = WebDriverWait(driver, 10).until(EC.element_to_be_clickable((By.ID, 'username')))
password = WebDriverWait(driver, 10).until(EC.element_to_be_clickable((By.ID, 'password')))

user1 = os.environ.get("USER")
pass1 = os.environ.get("PASS")

soup = BeautifulSoup(driver.page_source, 'lxml')

username.send_keys(user1)
password.send_keys(pass1)


submit_button = driver.find_element_by_xpath(".//button[@type='submit'][@class='solid-button basic-login-submit']")
submit_button.click()

csv_file = open('wsj_articles.csv', 'w', encoding='utf-8', newline='')
writer = csv.writer(csv_file)

time.sleep(2)

daylinks = driver.find_elements_by_xpath('//a[@class="WSJTheme--day-link--19pByDpZ "][@href]')
time.sleep(2)

for i in range(11,len(daylinks)):

	daylinks2 = WebDriverWait(driver, 10).until(EC.presence_of_all_elements_located((By.XPATH, '//a[@class="WSJTheme--day-link--19pByDpZ "][@href]')))
	print("DayLinks2 is:",daylinks2)
	time.sleep(1)
	
	daylinks2[i].click()
	
	time.sleep(1.5)

	linkslist1 = None

	#set a timer, if i is greater than this many times, then break. Time.time function is useful for this 
	while not linkslist1:
		try:
			linkslist1 = driver.find_elements_by_xpath('.//h2[@class="WSJTheme--headline--unZqjb45 undefined WSJTheme--heading-3--2z_phq5h typography--serif-display--ZXeuhS5E "]//a[@href]')
		except:
			continue	
	print("Length of linkslist1 is:",len(linkslist1))

	time.sleep(2)
	
	for i in range(0,len(linkslist1)):
		
		article_dict = {}
		time.sleep(2)

		linkslist = None
		while not linkslist:	
			try:
				linkslist = driver.find_elements_by_xpath('.//h2[@class="WSJTheme--headline--unZqjb45 undefined WSJTheme--heading-3--2z_phq5h typography--serif-display--ZXeuhS5E "]//a[@href]')
			except:
				continue

		time.sleep(2)

		print("Length of linkslist is:",len(linkslist))

		try:
			linkslist[i].click()
			print("Trying to click the following web element:", linkslist[i])

			time.sleep(1)

		#replace these with beautifulSoup parsing functions 
			try:
				article_string = ''
				text1 = driver.find_elements_by_xpath(".//div[@class='article-content ']//p")
				for ele in text1:
					article_string += ele.text
					# article_string = article_string.encode('utf-8')
			except (NoSuchElementException, StaleElementReferenceException) as e:
				article_string = ''
				pass

			try:
				headline1 = driver.find_element_by_xpath('.//h1[@class="wsj-article-headline"]')
				article_headline = headline1.text
			except (NoSuchElementException, StaleElementReferenceException) as e:
				article_headline = ''
				pass

			try:
				headline2 = driver.find_element_by_xpath('.//h2[@class="sub-head"]')
				article_subheadline = headline2.text
			except (NoSuchElementException, StaleElementReferenceException) as e:
				article_subheadline = ''
				pass

			try:
				time1 = driver.find_element_by_xpath(".//time[@class='timestamp article__timestamp flexbox__flex--1']")
				article_published_date = time1.text
			except (NoSuchElementException, StaleElementReferenceException) as e:
				article_published_date = ''
				pass

			try:
				author1 = driver.find_element_by_xpath('.//button[@class="author-button"]')
				article_author = author1.text
			except (NoSuchElementException, StaleElementReferenceException) as e:
				article_author = ''
				pass

			try:
				topic1 = driver.find_element_by_xpath('.//li[@class="article-breadCrumb"][1]/a')
				article_topic = topic1.text
			except (NoSuchElementException, StaleElementReferenceException) as e:
				article_topic = ''
				pass

			try:
				number_comments1 = driver.find_element_by_xpath('.//a[@id ="article-comments-tool"]/span')
				article_number_comments = number_comments1.text
			except (NoSuchElementException, StaleElementReferenceException) as e:
				article_number_comments = ''
				pass

			article_dict['article_body_text'] = article_string
			article_dict['article_headline'] = article_headline
			article_dict['article_subheadline'] = article_subheadline
			article_dict['article_published_date'] = article_published_date	
			article_dict['author'] = article_author
			article_dict['topic'] = article_topic
			# article_dict['link'] = article_link1
			article_dict['article_number_comments'] = article_number_comments

			writer.writerow(article_dict.values())

			driver.back()

		except:
			print("Failed to click on", linkslist[i])
			continue

	driver.back()
