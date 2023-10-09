server <- function(input, output, session) {
  # Create an observer for the Reset button
  observeEvent(input$resetButton, {
    # Reset all input values to their initial states
    updateSelectInput(session, "Gender", selected = "")
    updateSliderInput(session, "AGE", value = 0)
    updateSelectInput(session, "ADDRESS", selected = "")
    updateSelectInput(session, "RH", selected = "")
    updateSelectInput(session, "DONATION", selected = "")
    updateSelectInput(session, "GROUP", selected = "")
    updateSelectInput(session, "HCV", selected = "")
    updateSelectInput(session, "HIV", selected = "")
    updateSelectInput(session, "TPHA", selected = "")
  })
  
  observeEvent(input$predictButton, {
    # Create a new data frame with user inputs
    new_data <- data.frame(
      Gender = as.factor(input$Gender),
      AGE = input$AGE,
      GROUP = as.factor(input$GROUP),
      ADDRESS = as.factor(input$ADDRESS),
      RH = as.factor(input$RH),
      DONATION = as.factor(input$DONATION),
      HCV = as.factor(input$HCV),
      HIV = as.factor(input$HIV),
      TPHA = as.factor(input$TPHA)
    )
    
    # Predict Hepatitis B using the GBM model with probabilities
    probabilities <- predict(model, new_data, type = 'response')
    probabilities <- data.frame(probabilities)
    names(probabilities) <- "REACTIVE"
    # Get the probability for being "REACTIVE"
    reactive_probability <- probabilities[,"REACTIVE"]
    
    output$predictionText <- renderText({
      if (reactive_probability < 0.0) {
        paste("Probability of being NON POSITIVE for Hepatitis B virus:", reactive_probability)
      } else {
        paste("Probability of being POSITIVE for Hepatitis B virus:", 1-reactive_probability)
      }
    })
  })
}
