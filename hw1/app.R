#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(ggplot2)
library(rjson)

data <- read.csv("gis_siraha_data.csv")
data <- data.frame(data)

json_data <- toJSON(data)

ui <- fluidPage(
  titlePanel("Learn more about Siraha"),
  
  sidebarLayout(
    sidebarPanel(
      helpText("Nepali Census Bureau gathers data on various 
                socio-economic indicators. Choose two of your likings."),
      
      #selectInput("y", 
      #           label = "Choose a variable to display",
      #          choices = c("Percentage of Uncovered Wells"= "perc_dwms_uncoveredwell_kuwa", 
      #                     "Percentage of Households that use firewoods to cook" = "perc_cookingfuel_wood_firewood",
      #                    "Percent Cable TV" = "perc_cableTV", 
      #                   "Percentage with Cycle" = "perc_cycle"),
      #      selected = "Percentage with Cycle"),
      
      #selectInput("x", 
      #          label = "Choose a variable to display",
      #         choices = c("Literacy Rate" = "literacy_rate", 
      #                  "Percentage of Households that use firewoods to cook" = "perc_cookingfuel_wood_firewood",
      #                 "Household Size" = "household_size", 
      #                "Percentage SLC Equivalent"="perc_SLC_equiv"),
      #   selected = "Literacy Rate")
      
      selectInput("y", 
                  label = "Choose a variable to display",
                  choices = c("perc_dwms_uncoveredwell_kuwa", 
                              "perc_cookingfuel_wood_firewood",
                              "perc_cableTV", 
                              "perc_cycle"),
                  selected = "perc_cycle"),
      
      selectInput("x", 
                  label = "Choose a variable to display",
                  choices = c("literacy_rate", 
                              "perc_cookingfuel_wood_firewood",
                              "household_size", 
                              "perc_SLC_equiv"),
                  selected = "literacy_rate")
      
      #sliderInput("range", 
      #label = "Range of interest:",
      #min = 0, max = 100, value = c(0, 100))
    ),
    
    mainPanel(
      textOutput("selected_var_x"),
      textOutput("selected_var_y"),
      #textOutput("min_max"),
      plotOutput(outputId="scatterplot")
      
      
    )
  )
)

server <- function(input, output) {
  
  output$selected_var_x <- renderText({ 
    paste("You have selected", input$x)
  })
  
  output$selected_var_y <- renderText({ 
    paste("You have selected", input$y)
  })
  
  output$scatterplot <- renderPlot({
    ggplot(json_data=data, aes(x=input$x, y=input$y) + geom_point())
  })
  
  
  #output$min_max <- renderText({ 
  #paste("You have chosen a range that goes from",
  #    input$range[1], "to", input$range[2])
  #})
  
}

shinyApp(ui, server)