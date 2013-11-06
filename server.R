library(shiny)
library(shinyIncubator)
library(ggplot2)
source("subroutines.R")


# Define server logic required to generate and plot a random distribution
shinyServer(function(input, output) {
  
  output$AprobInput <- renderUI({
    sliderInput("probA", 
                 "Probability of A votes for remaining ballots", 
                min = 0, 
                max = 1, 
                 value = ifelse(input$Avotes+input$Bvotes>0, round(input$Avotes/(input$Avotes+input$Bvotes), 2), .5)
    )
    
  })
  
  runSimulation <- reactive({
    if(input$GoSim!=0){
      
      return(isolate({
        doSimulation(input$Avotes, 
                     countedN = input$Avotes + input$Bvotes,  
                     nextN = input$remainingVotes, 
                     nextProb = input$probA, 
                     sNum = input$simulationN)
      }))
    }
  })
  
  output$myplot <- renderPlot({
    if(!is.null(runSimulation())){  
     isolate({
    tmp <- data.frame(runSimulation())
    names(tmp) <- c("numVotes", "ProbA", "Win", "simIndex")
    
    p <- ggplot(tmp, aes(x = numVotes, y = ProbA, colour = factor(Win), group = factor(simIndex)))
    p <- p + geom_line() + 
        # xlim(0, input$Avotes+input$Bvotes + input$remainingVotes) +
         #ylim(0, 1)  + 
         geom_hline(yintercept = 0.5) + 
         xlab("Number of votes") +
         ylab("Proportion of votes for candidate A")+ 
         scale_color_discrete(name = "", 
                              breaks = c(0, 1), 
                              labels = c("A wins", "B wins")) #+ 
                            #  geom_rect(xmin = -Inf, xmax = input$Avotes + input$Bvotes, 
                             #           ymin = -Inf, ymax = Inf, fill = "grey50", alpha = I(.2), color = "grey50") + 
                            #  annotate("text", x = (input$Avotes + input$Bvotes)/2, y = input$Avotes/(input$Avotes + input$Bvotes), label = "votes already counted")
         
    })
    print(p)
      
    }
  })
  
  output$mytext <- renderText({
    if(is.null(runSimulation())) return(NULL)
    
    HTML(paste("<h4>Based on", input$simulationN,"simulations, the probability that candidate A wins is:<strong>", mean(runSimulation()[,3]),"</strong></h4>"))
    
  })
  
 
})