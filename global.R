# Load libraries
library(dplyr)
library(shiny)
library(DT)
library(shinydashboard)
library(lubridate)

values <- reactiveValues()

values$df <- read.csv(file = "www/data.csv", 
               header = TRUE, 
               sep = ",", 
               stringsAsFactors = FALSE) %>%
  mutate(jour = as.numeric(jour)) %>%
  mutate(montant = as.numeric(montant)) %>%
  arrange(jour)

current_day <- day(today())
