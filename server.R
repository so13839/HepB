library(shiny)
library(flexdashboard)
library(shinydashboard)
library(shinyWidgets)
library(dplyr)

# Load the trained GBM model
model <- readRDS("model_DTC.RDS")

server <- function(input, output, session) {
  observeEvent(input$predictButton, {
    # Create a new data frame with user inputs
    new_data <- data.frame(
      Gender = as.factor(input$Gender),
      AGE = input$AGE,
      GROUP = as.factor(input$GROUP),
      RH = as.factor(input$RH),
      DONATION = as.factor(input$DONATION),
      HCV = as.factor(input$HCV),
      HIV = as.factor(input$HIV),
      TPHA = as.factor(input$TPHA)
    )
    
    # Predict Hepatitis B using the GBM model with probabilities
    probabilities <- predict(model, new_data, type = 'prob')
    reactive_probability <- probabilities[,"REACTIVE"]
    reactive_probability <- data.frame(reactive_probability)
    names(reactive_probability) <- "REACTIVE"
    # Get the probability for being "REACTIVE"
    
    output$predictionText <- renderText({
      paste("Probability of being POSITIVE for Hepatitis B virus:", reactive_probability)
    })
  })
  
  observeEvent(input$resetButton, {
    # Reset all input values to their initial state
    updateSelectInput(session, "Gender", selected = NULL)
    updateSliderInput(session, "AGE", value = 0)
    updateSelectInput(session, "RH", selected = NULL)
    updateSelectInput(session, "DONATION", selected = NULL)
    updateSelectInput(session, "GROUP", selected = NULL)
    updateSelectInput(session, "HCV", selected = NULL)
    updateSelectInput(session, "HIV", selected = NULL)
    updateSelectInput(session, "TPHA", selected = NULL)
    # Clear the prediction result
    output$predictionText <- renderText("")
  })
}


