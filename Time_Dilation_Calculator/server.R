library(shiny)

getSpeedOfLight <- function(){
    speedOfLight <- 299792458 / 1000 # speed of light (In KiloMeter Per Second) in vacuum    
    speedOfLight
}

calculateTimeDilation <- function(speed){
    sol <- getSpeedOfLight()
    return (1 / sqrt(1 - (speed^2 / sol^2) ))
}

calculateSpeed <- function(percent){
    sol <- getSpeedOfLight()
    return (sol * (percent / 100))
}


generateData <- function(){
    p<- c(seq(0, 99.9, by=0.1))
    sol <- getSpeedOfLight()
    
    df <- data.frame(speed=NA, timeDilation=NA, speedOfLight=sol, percent=p)
    df$speed <- calculateSpeed(df$percent)
    df$timeDilation <- calculateTimeDilation(df$speed)                
    df 
}

df <- generateData()

shinyServer(
    function(input, output) {
        output$dilationCalc <- renderPlot({
            duration <- input$duration
            xpercent <- input$percent
            speed <- calculateSpeed(xpercent)
            
            ytimedilation <- calculateTimeDilation(speed)
            point <- data.frame(x = xpercent, y= ytimedilation)
            library(ggplot2)
            g <- ggplot(data=df, aes(x=percent, y=timeDilation, group=1))
            g <- g + geom_line(size=1.3) + xlim(0, 100) 
            g <- g + coord_cartesian(xlim = c(0, 100)) 
            g <- g + ylab("Time Dilation") 
            g <- g + xlab("% of speed of light")
            g <- g + theme(legend.position="none")
            g <- g + geom_point(data=point, aes(x=x, y=y , colour="red", size=y*5)) + scale_size_area() 
            g <- g + annotate("text", x = xpercent - 3, y = ytimedilation + 2 , label = round(ytimedilation,2),  colour = "red", size = 5)
            
            # format message
            msgx <- 5
            msgy <- 18
            # sprintf("second %2$1.0f, first %1$5.2f, third %3$1.0f", pi, 2, 3)
            msgTravelingSpeed <- sprintf("Traveling speed: %s killometers per second \n(%2$1.1f%% percent of speed of light)", format(speed, big.mark=","), xpercent)
            g <- g + annotate("text", x = msgx, y = msgy , label = msgTravelingSpeed,  colour = "black", size = 5, hjust = 0)
            
            msgTimeDilation <- sprintf("Time dilation at this speed is %1$1.2f \n(for the traveler, a year dilates to %1$1.2f years)", ytimedilation)
            g <- g + annotate("text", x = msgx, y = msgy - 4 , label = msgTimeDilation,  colour = "black", size = 5, hjust = 0)

            msgTravelTime <- sprintf("As a treveler travels at this speed for %1$1.0f years,\n%2$1.2f years elapse for a stationary observer" , duration , ytimedilation * duration)
            g <- g + annotate("text", x = msgx, y = msgy - 8 , label = msgTravelTime,  colour = "black", size = 5, hjust = 0)

            g
        })
        
    }
)



