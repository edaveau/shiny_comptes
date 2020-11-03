dashboardPage(
  
  title = "ImaUnicorn",
  skin = "green",
  
  # Content of the app header
  dashboardHeader(
    title = span(textOutput("header_title"), 
                 style = "font-weight: bold;")
  ),
  
  # Content of the app sidebar
  dashboardSidebar(
    sidebarMenu(
      # Content of the first menu item
      menuItem(text = "Voir les factures", 
               tabName = "bills", 
               icon = icon(name = "credit-card", lib = "glyphicon"), 
               selected = TRUE),
      br(),
      actionButton(inputId = "save", 
                   label = "Sauvegarder", 
                   icon = icon(name = "save", lib = "glyphicon")),
      tags$style(type='text/css', "button#save {margin-left: 40%;}")
      )
  ),
  
  # Content of the app body
  dashboardBody(
    tabItems(
      tabItem(tabName = "bills",
              fluidRow(column(width = 10, dataTableOutput("bills"),
                              actionButton(inputId = "addrow", 
                                           label = "Nouvelle facture", 
                                           icon = icon(name = "plus-circle", lib = "font-awesome")),
                              actionButton(inputId = "delrow", 
                                           label = "Supprimer la sélection", 
                                           icon = icon(name = "minus-circle", lib = "font-awesome"))),
                       column(width = 2, 
                              valueBoxOutput("bills_total", width = 12)))
      )
    ),
    tags$head(tags$link(rel = "shortcut icon", href = "favicon.ico"))
  )
)