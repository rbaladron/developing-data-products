# User interface for Shiny application of Coursera's MOOC Developing Data Products
# Car Data Analysis
# This application does analysis of mtcars dataset in R (courtesy Motor Trend)
# The application lets you select a car filtered with Weight restrictions and Engine Capacity
# Result shows how the car you selected stands in comparison with other cars with same criteria

# Load required libraries
library(shiny)

# Load  mtcars data
data(mtcars)

# Template for UI with pagewithSidebar, a sidebarPanel with 3 inputs
# Input 1: Slide to restrict the maximum weight in units of 1000lbs
# Input 2: Slide to restrict the maximum engine capacity in cubic inches
# Input 3: List of cars that satisfy the filtering criteria from Input 1 & 2
# Output produces a grid of 4 plots which compares data with text at bottom with explanation

shinyUI(fluidPage(
  
  # Application title
  titlePanel("Car Data Analysis"),
  
  # Sidebar with 2 slider input an a filtered list
  sidebarLayout(
    sidebarPanel(
      h3('Configure your car'),
      p(''),
      p('-select range of weight-'),
      sliderInput('wt', 
                  'Car Weight in 1000 lbs', 
                  min(mtcars$wt), 
                  max(mtcars$wt), 
                  c(min(mtcars$wt),
                    max(mtcars$wt))),
      p(''),
      p('-select range of engine size-'),
      sliderInput('disp', 
                  'Car Engine size in Cu.In.', 
                  min(mtcars$disp), 
                  max(mtcars$disp), 
                  c(min(mtcars$disp),
                    max(mtcars$disp))),
      p(''),
      p('-select a car to compare -'),
      uiOutput("listaCoches"),
      p(''),
      strong('Information'),
      p('The User interface will help you select
               the car based on filtering selection for weight
               and engine size.'),
      p('Filtering weight and engine size also eliminates
               data in plot that do not fit your criteria.')
    ),
    mainPanel(
      p('This app analyzes mtcars dataset in R (courtesy of MotorTrend) comparing miles per gallon and speed of selected car.'),
      p('The next graphs shows where the selected car are respect of others.'), 
      plotOutput("mtplot",height="100%"),
      h3('Results'),
      textOutput("lineaTexto2"),
      textOutput("lineaTexto3")
    ))
  )
)