# Server R code for Shiny application of Coursera's MOOC Developing Data Products
# Car Data Analysis
# This application does an analysis of mtcars dataset in R (courtesy Motor Trend)
# The application lets you select a car filtered with Weight restrictions and Engine Capacity
# Result shows how the car you selected stands in comparison with other cars with same criteria

# Load required libraries
library(shiny)
library(ggplot2)
library(gridExtra)

# Loading data
data(mtcars)

# Define server logic 
shinyServer(function(input, output) {
  
  # datoscoches reactively returns subset of data.
  datoscoches <- reactive({
    subset(mtcars, disp>=input$disp[1] & disp<=input$disp[2] & wt>=input$wt[1] & wt<=input$wt[2])
  })
  # coche reactively returns values for a car if it is selected  
  coche <- reactive({
    validate(
      need(input$coche != "", "Select a car")
      )
    mtcars[input$coche,]
  })
  # Dynamically build list based on selection
  output$listaCoches <- renderUI({
    coches <- rownames(datoscoches())
    numcoches <- length(coches)
    etiqueta <- paste("Car list filtered - available (", numcoches, ")")
    selectInput('coche', etiqueta, c(coches))
  }) 
  
  output$mtplot <- renderPlot({
    # Plot mtcars data mpg against wt group by cylinders
    grafico1 <- ggplot(datoscoches(), 
                     aes(x=wt, y=mpg)) + 
      geom_point(stat="identity", 
                 aes(color=factor(cyl))) +
      geom_point(x=coche()$wt,
                 y=coche()$mpg, 
                 shape=13,
                 size=5) +
      ylab("Miles per gallon") +
      xlab("Weight of car in 1000lbs") +
      ggtitle("Mileage chart by Weight")
    
    # Plot mtcars data mpg against disp group by cylinders
    grafico2 <- ggplot(datoscoches(), 
                     aes(x=disp, y=mpg)) + 
      geom_point(stat="identity", 
                 aes(color=factor(cyl))) +
      geom_point(x=coche()$disp,
                 y=coche()$mpg, 
                 shape=13,
                 size=5) +
      ylab("Miles per gallon") +
      xlab("Engine size Cu. In.") +
      ggtitle("Mileage chart by Engine Size")
   
    # Plot mtcars data qsec against wt group by cylinders
    grafico3 <- ggplot(datoscoches(), 
                     aes(x=wt, 
                         y=qsec)) + 
      geom_point(stat="identity", 
                 aes(color=factor(cyl))) +
      geom_point(x=coche()$wt,
                 y=coche()$qsec, 
                 shape=13,
                 size=5) +
      ylab("1/4 mile in seconds") +
      xlab("Weight of car in 1000lbs") +
      ggtitle("Speed of cars by weight")
   
    # Plot mtcars data qsec against disp group by cylinders
    grafico4 <- ggplot(datoscoches(), 
                     aes(x=disp, 
                         y=qsec)) + 
      geom_point(stat="identity", 
                 aes(color=factor(cyl))) +
      geom_point(x=coche()$disp,
                 y=coche()$qsec, 
                 shape=13,
                 size=5) +
      ylab("1/4 mile in seconds") +
      xlab("Engine size Cu. In.") +
      ggtitle("Speed of cars by engine size")
    
    # All plots  are arranged in a grid
    grid.arrange(grafico1,
                 grafico2,
                 grafico3,
                 grafico4,
                 ncol=2)

  },
  height=460, 
  width=600)
  
  # Print information explaining data
  output$lineaTexto2 <- renderPrint({
    cat(input$coche)
    cat(" weights ")
    cat(coche()$wt*1000)
    cat(" lbs with engine capacity ")
    cat(coche()$disp)
    cat(" cubic inches and has ")
    cat(coche()$cyl)
    cat(" cylinders.")
  })
  output$lineaTexto3 <- renderPrint({
    cat(input$coche)
    cat(" can go 1/4 mile in ")
    cat(coche()$qsec)
    cat(" seconds and has an economy of ")
    cat(coche()$mpg)
    cat(" miles per gallon.")
  })
})