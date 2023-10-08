server <- function(input, output) {
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
    probabilities <- predict(model, new_data, type = 'response')
    probabilities <- data.frame( probabilities)
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