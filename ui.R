library(shiny)
library(flexdashboard)
library(shinydashboard)
library(shinyWidgets)
library(dplyr)

# Load the trained GBM model
model <- readRDS("Logistic_Model.RDS")

ui <- dashboardPage(
  dashboardHeader(title = "Hepatitis B Prediction"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Prediction", tabName = "prediction")
    )
  ),
  dashboardBody(
    tabItems(
      tabItem(
        tabName = "prediction",
        fluidPage(
          sidebarPanel(
            selectInput("Gender", "Gender:", choices = c("M", "F")),
            sliderInput("AGE", "Age:", min = 0, max = 100, value = 0),
            selectInput("RH", "RH:", choices = c("POSITIVE", "NEGATIVE")),
            selectInput("DONATION", "TYPE OF DONATION:", choices = c("NEW", "REPEAT", "REGULAR")),
            selectInput("GROUP", "GROUP:", choices = c("A", "B", "AB", "O")),
            selectInput("HCV", "HCV:", choices = c("REACTIVE", "NONREACTIVE")),
            selectInput("HIV", "HIV:", choices = c("REACTIVE", "NONREACTIVE")),
            selectInput("TPHA", "TPHA:", choices = c("REACTIVE", "NONREACTIVE")),
            actionButton("predictButton", "Predict"),
            actionButton("resetButton", "Reset")
          ),
          mainPanel(
            h3("Hepatitis B Machine learning Risk Stratification Tool (Prototype)"),
            h4("Hepatitis B virus (HBV) infection is a major global public health concern, with Uganda facing one of the highest burdens of the disease, leading to 1,250 reported deaths in 2022 and 6% of the population chronically infected. To address this, the proposal advocates for the use of machine learning (ML) in developing a cost-effective web-based risk stratification tool, utilizing medical records of blood donors from Mengo Hospital blood bank in Uganda over the past five years."),
            
            h4("•	The aim is to accurately identify individuals at high risk of hepatitis B, enabling targeted screening efforts in a resource-constrained environment."),
            h4(tags$b("How to assess the risk:")),
            h4("Select gender, blood type, RH factor, type of donation, blood group, and the status regarding HCV, HIV, and TPHA using the dropdown menus. Input age by sliding the window."),
            
            h4(tags$b("Assess risk:")),
            h4("Click on the Predict Risk button to display the probability of having hepatitis B. Click Reset to predict a new individual"),    
            textOutput("predictionText")
          )
        )
      )
    )
  )
)

