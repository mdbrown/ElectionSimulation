library(shiny)
library(shinyIncubator)
# Define UI for application that plots random distributions 
shinyUI(pageWithSidebar(
  
  # Application title
  headerPanel("Election Simulator"),
  
  # Sidebar with a slider input for number of observations
  sidebarPanel(
    
    wellPanel( strong("Votes Counted"), br(), 
    numericInput("Avotes", 
                 "Number of votes for candidate A:", 
                 value = 2110), 
    numericInput("Bvotes", 
                 "Number of votes for candidate B:", 
                 value = 2783) 
    ), 
    wellPanel( strong("Votes Remaining"), br(), 
    numericInput("remainingVotes", 
                 "Number of votes to be counted:", 
                 value = 4000), 
    uiOutput("AprobInput"), p(HTML("<em>Note: the above probability defaults to the observed probability of A votes</em>"))
               
        
    ), 
    wellPanel(
      sliderInput("simulationN", 
                  "Number of simulations:", 
                  min = 1,
                  max = 500, 
                  value = 100),
      
      actionButton("GoSim", "Run Simulation")
      ) 
  ),
  
  # Show a plot of the generated distribution
  mainPanel(
    tags$head(tags$style(type="text/css",
                         '#progressIndicator {',
                         '  position: fixed; top: 8px; right: 8px; width: 200px; height: 50px;',
                         '  padding: 8px; border: 1px solid #CCC; border-radius: 8px;',
                         '}'
    )),
   plotOutput("myplot"), br(), 
   htmlOutput("mytext"),
    br(),
   conditionalPanel("updateBusy() || $('html').hasClass('shiny-busy')",
                    id='progressIndicator',
                    "Calculation IN PROGRESS...",
                    div(id='progress',includeHTML("timer.js"))
   )
   
   
  )
))