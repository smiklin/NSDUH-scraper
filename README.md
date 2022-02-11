# NSDUH scraper

[National Survey on Drug Use and Health](https://pdas.samhsa.gov/#/) collects a broad array of data, but the current structure of the website makes it difficult to compare values across different years.

The code in 'data-scraper.R' uses RSelenium to download the requested cross-tabs for each year. You should determine which years haveyour variables of interest available before running the analysis.

In progress: 'data-combined.R' which will combine the disparate datasets for analysis. 
