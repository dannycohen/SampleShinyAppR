#rm(list=ls()) # clean up environment variables
#install.packages("shiny")



library(shiny)
shinyUI(pageWithSidebar(
    headerPanel("Travelling at the Speed of light: Time Dilation Calculator"),
    sidebarPanel(
        sliderInput('percent', 'Speed (% of speed of light)',value = 50, min = 0, max = 99.9, step = 0.1,),
        sliderInput('duration', 'Duration of travel (in years, from the traveler perspective)',value = 50, min = 0, max = 100, step = 1,)
        ),
    mainPanel(
        plotOutput('dilationCalc')
    )
))
