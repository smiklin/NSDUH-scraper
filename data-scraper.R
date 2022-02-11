library(tidyverse)
library(rvest)
library(RSelenium)

###SETUP

# scraper setup

# replace the following with the directory into which you want to download the data
# the code will create a folder for each year of data downloaded and then later combine it
target_directory <- "/Users/suikai/Desktop/suicide attempt:ideation"

#the code uses Firefox—make sure you have it installed to run the code
fprof <- makeFirefoxProfile(list(browser.download.dir = dirdownload,
                                 browser.download.folderList = 2L,
                                 browser.download.manager.showWhenStarting = FALSE,
                                 browser.helperApps.neverAsk.saveToDisk = "application/x-bzip2"))

# data setup
# NSDUH allows you to chose a row and a column variable
# row should be the names of variables of interests
# columns should be different demographic
# also enable potential 'control variable' which will split data e.g. by sex
# current code allows for a single control variable only

year_start <- 2008
year_end <- 2018

row <- c("SUICPLAN", "SUICTRY", "SUICTHNK")
column <- c("CATAG3", "AGE2")

control = "" #optional

#ignore this bit
if (nchar(control)>0){
  control <-  paste0("&control=", control) 
}
 
for (year in year_start:year_start){
  
  #create the year folder into which we're downloading the data
  dirdownload <- paste0(target_directory, "/",year)
  dir.create(dirdownload)
  
  #this setup downloads automatically upon clicking
  fprof <- makeFirefoxProfile(list(browser.download.dir = dirdownload,
                                   browser.download.folderList = 2L,
                                   browser.download.manager.showWhenStarting = FALSE,
                                   browser.helperApps.neverAsk.saveToDisk = "text/csv"))
  
  #start session
  rD <- rsDriver(browser="firefox", port=4545L, verbose=F, extraCapabilities = fprof)
  Sys.sleep(5)
  remDr <- rD$client
  
  #grab data for each column-row combination
  for (c in column){
    for (r in row){
      #set relevant url
      url = paste0("https://pdas.samhsa.gov/#/survey/NSDUH-", year,
                   "-DS0001/crosstab/?column=",c,control,"&results_received=true&row=",r,
                   "&run_chisq=false&weight=ANALWT_C")
      
      #navigate to neutral website (sometimes variables do not refresh without this step)
      remDr$navigate("https://google.com")
      Sys.sleep(2)
      
      #navigate to data website—waiting times could be shortened but 10 seconds allows everythin to load
      remDr$navigate(url)
      Sys.sleep(10)
      
      #generate table
      remDr$findElement(using = "id", value = "button-crosstab")$clickElement()
      Sys.sleep(10)
      
      # download table
      remDr$findElement(using = "xpath", value = "/html/body/div/div/div[3]/main/div/div[2]/div[1]/div[3]/div/div[3]/div/div[1]/div[1]/div[2]/a[2]/div")$clickElement()
      Sys.sleep(2)
      }
  }
  ## end session
  remDr$close()
  rD$server$stop()  
}


  