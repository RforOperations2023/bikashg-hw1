#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

# Let's see if this sentence makes it to GitHub Desktop and GitHUb Online

library(shiny)
library(ggplot2)
library(rjson)
library(DT)

siraha <- read.csv('gis_siraha_data.csv')
#siraha <- data.frame(siraha)

#json_data <- toJSON(siraha)

ui <- fluidPage(
  
  #shinythemes::themeSelector(),
  theme = shinythemes::shinytheme("readable"),
  
  titlePanel("Learn more about Siraha"),
  
  sidebarLayout(position="left",
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
                  choices = c("perc_dmws_coveredwell_kuwa", 
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
                  selected = "literacy_rate"),
      
      checkboxInput("show_data",
                    label="Show data table",
                    value=TRUE),
      
      downloadButton("download_siraha", "Download"),
      h6("To download, click the download button above")
      
      #sliderInput("range", 
      #label = "Range of interest:",
      #min = 0, max = 100, value = c(0, 100))
    ),
    
    mainPanel(
      h4("The Marginal Nepal: the Story of Siraha"),
      br(),
      p('Siraha is one of the backward districts in the country.
        It has some of the worst socio-economic statistics. Much
        of this contributed to the centralized nature of the state. Some
        could be the involvement of the society, where caste system led
        upper castes to monopolize the resources'),
      br(),
      div('In light of this, it is important to see the statistics and see
          where things are in the country', style='color:blue'),
      br(),
      br(),
      img(src = "siraha_pic.jpeg", height = 300, width = 500),
      textOutput("selected_var_x"),
      textOutput("selected_var_y"),
      #textOutput("min_max"),
      plotOutput(outputId="scatterplot"),
      br(),
      DT::dataTableOutput("show_table_out")
      
      
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
  
  #output$scatterplot <- renderPlot({
   # ggplot(json_data=data, aes(x=input$x, y=input$y) + geom_point())
  #})
  
  output$scatterplot <- renderPlot({
    ggplot(siraha, aes_string(x=input$x, y=input$y)) + geom_point()
  })
  
  output$show_table_out <- DT::renderDataTable(
    if(input$show_data){
      DT::datatable(data=siraha[,1:5],
                    options=list(pageLength=5),
                    rownames=FALSE)
    }
  )
  
  output$download_siraha <- downloadHandler(
    filename = function() {
      paste("siraha_stats", Sys.Date(), ".csv", sep="")
    },
    content = function(file) {
      write.csv(siraha, file)
    }
  )
  
  #output$min_max <- renderText({ 
  #paste("You have chosen a range that goes from",
  #    input$range[1], "to", input$range[2])
  #})
  
}

shinyApp(ui, server)