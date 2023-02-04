library(shiny)
library(ggplot2)
library(DT)
library(stringr)
library(dplyr)
library(tools)
library(shinythemes)
library(readr)
library(dplyr)
library(base)

# Uploading data for a district in Nepal -----------
siraha <- read.csv('gis_siraha_data.csv')


# Define UI for application that plots features of the district -----------
ui <- fluidPage(
  
  
  # Choosing the shiny theme "readable" for journalistic reading--------------
  theme = shinythemes::shinytheme("readable"),
  
  
  # Choosing the title for the page and the movie ---------------------
  titlePanel((title=div(img(height = 105, width = 200, src="mithila_painting.png"), 
                        "A Window Into Siraha")), windowTitle = "A Window into Siraha"),
  
  
  # Sidebar layout with a input and output definitions --------------
  sidebarLayout(position="left",
                
                
    # Making a sidebar Panel with info on the district --------------            
    sidebarPanel(

      
    # Choosing the Title of the Sidebar ---------------------------- 
      h3('The Map of Siraha'),
      
    
      # Writing a paragraph on Siraha -----------------------------
      p('Siraha lies in the southern-east part of Nepal. 
        The district is in the Madhes province. 
        It has a total area of 1,888 km2 and a population of over 600,000 per the 2011 census. 
        On the southern plank, it borders India. 
        It has 17 municipalities as demonstrated by the colorful map below.'),
    
    
      # Breaking lines for visual separation--------------------------
      br(),
      
    
      # Adding the official map of Nepal--------------------------
      img(src = "siraha_map.jpg", height = 250, width = 400),
    
    
      # Some more visual separation--------------------------
      br(),
    
    
      # Drawing a line to separate various components within the sidebar
      hr(),
    
      p('For the scatterplot on the main panel, choose your variables below:'),
      
      # Select variable for y-axis ----------------------------------
      selectInput("y", 
                  label = "Choose a variable to display for Y-axis",
                  choices = c("Percentage of Uncovered Wells"= "perc_dmws_coveredwell_kuwa", 
                              "Percentage of Households that use firewoods to cook"="perc_cookingfuel_wood_firewood",
                              "Percent Cable TV"="perc_cableTV", 
                              "Percentage with Cycle"="perc_cycle",
                              "House ownership percentage" = "perc_owned_house"),
                  selected = "perc_cycle"),
      
    
      # Select variable for x-axis ----------------------------------
      selectInput("x", 
                  label = "Choose a variable to display for X-axis",
                  choices = c("Literacy Rate" = "literacy_rate", 
                              "Percentage of Households that use firewoods to cook" = "perc_cookingfuel_wood_firewood",
                              "Household Size" = "household_size", 
                              "Percentage SLC Equivalent"="perc_SLC_equiv",
                              "Percentage Without Toilet" = 'perc_householdsans_toilet'),
                  selected = "literacy_rate"),
    
    hr(),
    
    # Enter text for plot title ---------------------------------------------
    textInput("plot_title", 
              label = "Plot title", 
              placeholder = "Enter text to be used as plot title"),
    
    
      hr(),
      strong("About this App:", style='color:blue'),
      p('In the future versions, the users will be able to employ additional
        widgets (such as one below) to find relationships between various attributes.'), 
      p('Furthermore, there will be two additional tabs dedicated to help users
        learn more about statistics at the provincial and the federal level.'),
    
      em('An example of a future widget:', style='color:green'),
    
      # Select variable for z ---------------------------------------
      radioButtons(inputId = "z",
                   label = "Select to make pie chart of:",
                   choices = c("Dalit Percentage in a Municipality" = "perc_dalit_total", 
                               "Municipality's share of Population" = "pop_perc" ),
                   selected = "pop_perc"),
     
    
      # Visual separation-------------------------------------------
      hr(),

    
      # Download button to download the district's data--------------------------
      downloadButton("download_siraha", "Download"),
      h6("To download, click the download button above"),
    
    # Show data table ---------------------------------------------
    checkboxInput("show_data",
                  label="Show the data table in addition to scatterplot.",
                  value=TRUE),
      
    ),
    
    
    
    # Output: -------------------------------------------------------
    mainPanel(
      
      # Adding multiple tabs for future purposes. I could not make this run
      # this time owing to some technical errors--------------------------
      
      tabsetPanel(
        type="tab",
        tabPanel("Siraha Statistics"),   
        tabPanel("Madhes Statistics"), 
        tabPanel("Nepal Statistics") 
      ),
      
      # Adding select Input to be used for future purposes--------------------------
      #selectInput("column", "Select Column:", choices = c("perc_dalit_total", "pop_perc")),
      
      
      # The Header for the Main Page--------------------------
      h4("Marginal Nepal: The Story of Siraha"),
      
      
      # Visual separation---------------------------------------
      br(),
      
      
      # Another detailed paragraph on the district--------------------------
      
      p('While Siraha was one of the first few districts to boast a college and a high school outside Kathmandu, 
        it lags behind various educational indicators including the school enrollment rates. 
        Other socio-economic indicators also don’t paint a rosy picture for the district. 
        It has one of the highest poverty rates in the country and in absence of employment 
        opportunities, youths flee the country in droves to foreign countries, 
        often as laborers in the gulf countries, where they have to work under exploitative conditions.'),
      
      
      # Visual separation--------------------------
      br(),
      
      
      # Image of people in a locality in the district--------------------------
      div(img(src = "siraha_pic.jpeg", height = 300, width = 500), style="text-align: center;"),
      
      
      # Adding photo description--------------------------
      div(em("Photo: The locality of Siraha Municipality"),style="text-align: center;"),

      
      # Breaking line for visual distinction--------------------------
      br(),
      
      
      # Breaking line for visual distinction--------------------------
      br(),
      
      
      # Another paragraph on the district--------------------------
      
      p('Much of the district’s backwardness can be attributed to the (previously) centralized nature 
        of the state and the state’s exclusionary and step-motherly attitude towards people living 
        in the southern plains. The caste system complicates the picture further. 
        Within the district, the ruthless hierarchy of the caste system ensures that
        few upper-caste groups continue to monopolize resources and reign over the historical inequalities.'),
      
      
      # Wrap-up paragraph--------------------------
      p('Nepal Census Bureau collects data on various attributes such as material endowment rate
        and literacy rate at the household level. Using the drop-down menus on the sidebar, 
        choose a variable for the x-axis and y-axis, and see the interconnection between them via scatterplot.', style='color:blue'),
      
      
      # To show users what they selected for each axis on the sidebar 
      textOutput("selected_var_x"),
      
      textOutput("selected_var_y"),
      
      
      # Breaking line for visual distinction--------------------------
      br(),
      
      
      # Outputting here the scatterplot--------------------------
      plotOutput(outputId="scatterplot"),
      
      
      # Breaking line for visual distinction--------------------------
      br(),
      
      # Show Data Table--------------------------
      DT::dataTableOutput("show_table_out"),

    )
  )
)

# Defining a server function  to create the scatter plot ---------
server <- function(input, output) {
  
  output$selected_var_x <- renderText({ 
    paste("From the sidebar, you selected", input$x, "for x-axis.")
  })
  
  output$selected_var_y <- renderText({ 
    paste("Similarly, you selected", input$y, "for y-axis.
          Let's see the scatterplots.")
  })
  
  
  # Convert plot_title toTitleCase ----------------------------------
  pretty_plot_title <- reactive({ toTitleCase(input$plot_title) })
  
  
  # Create scatterplot object the plotOutput function is expecting --
  output$scatterplot <- renderPlot({
    ggplot(siraha, aes_string(x=input$x, y=input$y)) + geom_point() +
      labs(title= pretty_plot_title(), #"Comparing Two Census Attributes",
          x=toTitleCase(str_replace_all(input$x,"_", " ")),
           y=toTitleCase(str_replace_all(input$y,'_'," "))) +
      theme_classic()+
      theme(plot.title = element_text(face = "bold", size=20, color="darkgreen", hjust=0.5)) +
      theme(axis.title = element_text(color = "black", size = 15, face = "bold"),
            axis.title.y = element_text(face = "bold"))
  }, height=400, width=600)
  
  
  # Print data table if checked -------------------------------------
  output$show_table_out <- DT::renderDataTable(
    if(input$show_data){
      DT::datatable(data=siraha[,1:5],
                    options=list(pageLength=5),
                    rownames=FALSE)
    }
  )

  
  # Help user download the data if clicked -------------------------------------
  output$download_siraha <- downloadHandler(
    filename = function() {
      paste("siraha_stats", Sys.Date(), ".csv", sep="")
    },
    content = function(file) {
      write.csv(siraha, file)
    }
  )
  
}

shinyApp(ui, server)