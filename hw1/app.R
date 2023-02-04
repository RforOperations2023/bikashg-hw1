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
library(DT)
library(stringr)
library(dplyr)
library(tools)
library(shinythemes)
library(readr)

siraha <- read.csv('gis_siraha_data.csv')
#siraha <- data.frame(siraha)

#json_data <- toJSON(siraha)


ui <- fluidPage(
  
  #shinythemes::themeSelector(),
  theme = shinythemes::shinytheme("readable"),
  
  titlePanel((title=div(img(height = 105, width = 200, src="mithila_painting.png"), "A Window Into Siraha")), windowTitle = "A Window into Siraha"),
  #titlePanel("Learn more about Siraha"),
  
  sidebarLayout(position="left",
    sidebarPanel(
     # helpText("Nepali Census Bureau gathers data on various 
                #socio-economic indicators. Choose two of your likings."),
      
      h3('The Map of Siraha'),
      p('Siraha lies in the southern-east part of Nepal. 
        The district is in the Madhes province. 
        It has a total area of 1,888 km2 and a population of over 600,000 per the 2011 census. 
        On the southern plank, it borders India. It has 17 municipalities as demonstrated by the colorful map below.'),
      br(),
      
      img(src = "siraha_map.jpg", height = 200, width = 350),
      br(),
      hr(),
      
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
                  choices = c("Percentage of Uncovered Wells"= "perc_dmws_coveredwell_kuwa", 
                              "Percentage of Households that use firewoods to cook"="perc_cookingfuel_wood_firewood",
                              "Percent Cable TV"="perc_cableTV", 
                              "Percentage with Cycle"="perc_cycle"),
                  selected = "perc_cycle"),
      
      selectInput("x", 
                  label = "Choose a variable to display",
                  choices = c("Literacy Rate" = "literacy_rate", 
                              "Percentage of Households that use firewoods to cook" = "perc_cookingfuel_wood_firewood",
                              "Household Size" = "household_size", 
                              "Percentage SLC Equivalent"="perc_SLC_equiv"),
                  selected = "literacy_rate"),
      
      
      checkboxInput("show_data",
                    label="Show data table",
                    value=TRUE),
      
      hr(),
      
      downloadButton("download_siraha", "Download"),
      h6("To download, click the download button above")
      
      #sliderInput("range", 
      #label = "Range of interest:",
      #min = 0, max = 100, value = c(0, 100))
    ),
    
    mainPanel(
      
      tabsetPanel(
        type="tab",
        tabPanel("Siraha Statistics"),   
        tabPanel("Bar Charts"),   
        tabPanel("Nepal") 
      ),
      
      h4("Marginal Nepal: The Story of Siraha"),
      br(),
      p('While Siraha was one of the first few districts to boast a college and a high school outside Kathmandu, 
        it lags behind various educational indicators including the school enrollment rates. 
        Other socio-economic indicators also don’t paint a rosy picture for the district. 
        It has one of the highest poverty rates in the country and in absence of employment 
        opportunities, youths flee the country in droves to foreign countries, 
        often as laborers in the gulf countries, where they have to work under exploitative conditions.'),
      br(),
      #img(src = "siraha_pic.jpeg", height = 300, width = 500),
      div(img(src = "siraha_pic.jpeg", height = 300, width = 500), style="text-align: center;"),
      #HTML('<center><img(src = "siraha_pic.jpeg" width = "500"></center>'),
      br(),
      br(),
      p('Much of the district’s backwardness can be attributed to the (previously) centralized nature 
        of the state and the state’s exclusionary and step-motherly attitude towards people living 
        in the southern plains. The caste system complicates the picture further. 
        Within the district, the ruthless hierarchy of the caste system ensures that
        few upper-caste groups continue to monopolize resources and reign over the historical inequalities.'),
      p('Nepal Census Bureau collects data on various attributes such as material endowment rate
        and literacy rate at the household level. Using the drop-down menus on the sidebar, 
        choose a variable for the x-axis and y-axis, and see the interconnection between them via scatterplot.', style='color:blue'),
      #br(),
      #br(),
      #div('In light of this, it is important to see the statistics and see
      #   where things are in the country', style='color:blue'),
      #br(),
      #br(),
      #br(),
      #br(),
      #textOutput("selected_var_x"),
      #textOutput("selected_var_y"),
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
    ggplot(siraha, aes_string(x=input$x, y=input$y)) + geom_point() +
      #ggtitle("Comparing Two Census Attributes") +
      xlab("Date") +
      labs(title="Comparing Two Census Attributes",
          x=toTitleCase(str_replace_all(input$x,"_", " ")),
           y=toTitleCase(str_replace_all(input$y,'_'," "))) +
      theme_classic()+
      theme(plot.title = element_text(face = "bold", size=20, color="darkgreen", hjust=0.5)) +
      theme(axis.title = element_text(color = "black", size = 15, face = "bold"),
            axis.title.y = element_text(face = "bold"))
  }, height=400, width=600)
  
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