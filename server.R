function(input, output, session){
  
  # Render a reactive datatable
  output$bills <- renderDT({
    # Here, we create the datatable object
    datatable(data = values$df,
              editable = "cell",                     # Make the cells editable
              rownames = FALSE,                      # Hide the rownames (linkd with "bills_cell_edit")
              colnames = c("Prélèvement", "Jour", "Montant"),
              options = list(lengthChange = FALSE,   # Hide Unnecessary information
                             searching = FALSE)) %>%
      formatStyle(columns = "jour",
                  target = "row",
                  backgroundColor = styleInterval(cuts = current_day, values = c("#06D59A", "white"))) %>%
      formatStyle(columns = c("libelle", "montant"), fontWeight = "bold")
  })
  
  # Here's what happens when we edit a cell
  observeEvent(input$bills_cell_edit, {
    cellinfo <- input$bills_cell_edit             # Retrieve edited data
    values$df <<- editData(data = values$df,      # Edit values$df with the retrieved data
                           info = cellinfo, 
                           proxy = "bills", 
                           rownames = FALSE) 
    values$df <- values$df %>% 
      mutate(jour = as.numeric(jour)) %>%
      mutate(montant = as.numeric(montant)) %>%
      arrange(jour)
  })

  # Render the reactive valueBox for the money left to pay
  output$bills_total <- renderValueBox({
    valueBox(value = paste0(as.character(sum(values$df$montant)), "€"), 
             subtitle = "Montant total",
             color = "olive",
             icon = icon(name = "wallet", lib = "font-awesome"))
  })
    
  # On clicking "Save", replace the original csv data with the new data
  observeEvent(input$save, {
    tryCatch({
      write.csv(x = values$df, file = "www/data.csv", row.names = FALSE)
      # If the data have been correctly written, we display an OK message
      showModal(modalDialog(
        title = "Sauvegarde OK",
        "Les données ont correctement été sauvegardées!",
        easyClose = TRUE))
    },
    error = function(cond){
      showModal(modalDialog(
        title = "Sauvegarde KO",
        "Une erreur est survenue lors de la sauvegarde des données!",
        easyClose = TRUE))
    })
  })

  # Add a new row with default values on "addrow" action button click
  observeEvent(input$addrow, {
    values$df <<- rbind(values$df, c("Default", 31, 0))    # Add an empty row
  })
  
  # Delete selected row on "deleterow" action button click
  observeEvent(input$delrow, {
    selected_rows <- input$bills_rows_selected  # Catch selected rows
    values$df <<- values$df[-selected_rows,]    # Remove selected rows
    })
  
  output$header_title <- renderText(expr = paste("Reste à payer: ", 
                                                 sum(values$df %>% 
                                                       mutate(montant = as.numeric(montant)) %>%
                                                       filter(jour > current_day) %>%
                                                       select(montant)), 
                                                 "€"))
}