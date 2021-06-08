library(shiny)
library(DT)
library(dplyr)
library(tidyverse)
library(nycflights13)
library(plotly)
library(ggplot2)
library(maps)
library(hexbin)


#read data from csv
qairports = read.csv("file/data-set/airports2.csv", header=F, stringsAsFactor=F, encoding="UTF-8", sep=",")
colnames(qairports) = c("no", "name", "city_name","country","faa","icao","lat","lon","elevation","utc","u","tzone","type","our")
#colnames(qairports) = c("faa","name","lat","lon","alt","tz","dst","tzone")

#Create local dataframes
flight <- nycflights13::flights[1:50000, ]
airline <- nycflights13::airlines
airport <- nycflights13::airports
plane <- nycflights13::planes
weather_1 <- nycflights13::weather

#Changing type to factor for filter in Data Explorer
flight$tailnum <- NULL
flight$air_time <- NULL
flight$hour <- NULL
flight$minute <- NULL
flight$carrier <- as.factor(flight$carrier)
flight$year <- as.factor(flight$year)
flight$month <- as.factor(flight$month)
flight$day <- as.factor(flight$day)

airline$carrier <- as.factor(airline$carrier)
airline$name <- as.factor(airline$name)

airport$faa <- as.factor(airport$faa)
airport$name <- as.factor(airport$name)
airport$tzone <- as.factor(airport$tzone)

plane$tailnum <- as.factor(plane$tailnum)
plane$type <- as.factor(plane$type)
plane$manufacturer <- as.factor(plane$manufacturer)
plane$model <- as.factor(plane$model)
plane$engine <- as.factor(plane$engine)

weather_1$origin <- as.factor(weather$origin)

flight$origin <- as.factor(flight$origin)
flight$dest <- as.factor(flight$dest)


data <- flights %>%
  dplyr::select(origin, month, day , arr_delay, dep_delay) %>%
  filter(arr_delay >= 0, dep_delay >= 0) %>%
  group_by(origin, month, day) %>%
  summarise(avg_delay =  mean(arr_delay, na.rm = TRUE) +
              mean(dep_delay, na.rm = TRUE)) %>%
  ungroup() %>%
  arrange(-avg_delay)

data$date <- with(data, ISOdate(year = 2013, month, day))

flights_1 <- flights
weather_2 <- weather
flights_1$hour <- ifelse(flights_1$hour == 24, 0, flights_1$hour)
flights_weather <- left_join(flights_1, weather_2)
flights_weather$arr_delay <- ifelse(flights_weather$arr_delay >= 0,
                                    flights_weather$arr_delay, 0)
flights_weather$dep_delay <- ifelse(flights_weather$dep_delay >= 0,
                                    flights_weather$dep_delay, 0)
flights_weather$total_delay <-
  flights_weather$arr_delay + flights_weather$dep_delay


cor_data <-
  dplyr::select(
    flights_weather,
    total_delay,
    temp,
    dewp,
    humid,
    wind_dir,
    wind_speed,
    wind_gust,
    precip,
    pressure,
    visib
  )

cor_data$Temperature <- cor_data$temp
cor_data$Pressure <- cor_data$pressure
cor_data$Humidity <- cor_data$humid
cor_data$Windspeed <- cor_data$wind_speed
cor_data$Precipitation <- cor_data$precip
# ================================================================

server = function(input, output, session)
{
  #awal beranda
  output$homefile <- renderUI({
    includeHTML("file/beranda.html")
  })
  #end beranda
  
  #awal Data
    #Tab Awal Airlines
    output$AirlinesData <- DT::renderDataTable(
    DT::datatable({
      airlines
    },
    options = list(lengthMenu=list(c(10,20,50),c('10','20','50')),pageLength=10,scrollY = "100%",searchHighlight = TRUE,order = list(1, 'asc'),
                   initComplete = JS(
                     "function(settings, json) {",
                     "$(this.api().table().header()).css({'background-color': '#B5E4FF', 'color': '000000'});",
                     "}"),
                   autowidth = TRUE,
                   columnDefs = list(list(targets=c(0), visible=TRUE, width='5%'),
                                     list(targets=c(1), visible=TRUE, width='20%'),
                                     list(targets=c(2), visible=TRUE, width='75%'),
                                     list(className='dt-center',targets="_all")
                   )
    ),
    rownames = TRUE,
    colnames = c("No","Carrier","Name")
    ))
    #Tab Akhir Airlines
    
    #Tab Awal Airports
    output$AirportsData <- DT::renderDataTable(
      DT::datatable({
        airports
      },
      options = list(lengthMenu=list(c(10,20,50),c('10','20','50')),pageLength=10,scrollY = "100%",searchHighlight = TRUE,order = list(1, 'asc'),
                     initComplete = JS(
                       "function(settings, json) {",
                       "$(this.api().table().header()).css({'background-color': '#B5E4FF', 'color': '000000'});",
                       "}"),
                     autowidth = TRUE,
                     columnDefs = list(list(targets=c(0), visible=TRUE, width='5%'),
                                       list(targets=c(1), visible=TRUE, width='10%'),
                                       list(targets=c(2), visible=TRUE, width='25%'),
                                       list(targets=c(3), visible=TRUE, width='15%'),
                                       list(targets=c(4), visible=TRUE, width='15%'),
                                       list(targets=c(5), visible=TRUE, width='5%'),
                                       list(targets=c(6), visible=TRUE, width='5%'),
                                       list(targets=c(7), visible=TRUE, width='5%'),
                                       list(targets=c(8), visible=TRUE, width='15%'),
                                       list(className='dt-center',targets="_all")
                     )
      ),
      rownames = TRUE,
      colnames = c("No","Faa","Name","Lat","Lon","Alt","Tz","Dst","Tzone")
      ))
    #Tab Akhir Airports
    
    
    #Tab Awal Planes
    output$PlanesData <- DT::renderDataTable(
      DT::datatable({
        planes
      },
      options = list(lengthMenu=list(c(10,20,50),c('10','20','50')),pageLength=10,scrollY = "100%",searchHighlight = TRUE,order = list(1, 'asc'),
                     initComplete = JS(
                       "function(settings, json) {",
                       "$(this.api().table().header()).css({'background-color': '#B5E4FF', 'color': '000000'});",
                       "}"),
                     autowidth = TRUE,
                     columnDefs = list(list(targets=c(0), visible=TRUE, width='5%'),
                                       list(targets=c(1), visible=TRUE, width='30%'),
                                       list(targets=c(2), visible=TRUE, width='15%'),
                                       list(targets=c(3), visible=TRUE, width='30%'),
                                       list(targets=c(4), visible=TRUE, width='5%'),
                                       list(targets=c(5), visible=TRUE, width='5%'),
                                       list(targets=c(6), visible=TRUE, width='5%'),
                                       list(targets=c(7), visible=TRUE, width='5%'),
                                       list(targets=c(8), visible=TRUE, width='10%'),
                                       list(className='dt-center',targets="_all")
                     )
      ),
      rownames = TRUE,
      colnames = c("No","Tailnum","Year","Type","Manufacturer","Model","Engines","Seats","Speed","Engine")
      ))
    #Tab Akhir Planes
    
    #Tab Awal Weathers
    output$WeathersData <- DT::renderDataTable(
      DT::datatable({
        weather %>%
          select(time_hour,origin,temp,dewp,humid,wind_dir,wind_speed,pressure,visib)%>%
          mutate(time_hour = format(time_hour, "%Y-%m-%d %H:%M:%S"))
      },
      options = list(lengthMenu=list(c(10,20,50),c('10','20','50')),pageLength=10,scrollY = "100%",searchHighlight = TRUE,order = list(1, 'asc'),
                     initComplete = JS(
                       "function(settings, json) {",
                       "$(this.api().table().header()).css({'background-color': '#B5E4FF', 'color': '000000'});",
                       "}"),
                     autowidth = TRUE,
                     columnDefs = list(list(targets=c(0), visible=TRUE, width='20%'),
                                       list(targets=c(1), visible=TRUE, width='30%'),
                                       list(targets=c(2), visible=TRUE, width='15%'),
                                       list(targets=c(3), visible=TRUE, width='15%'),
                                       list(targets=c(4), visible=TRUE, width='5%'),
                                       list(targets=c(5), visible=TRUE, width='5%'),
                                       list(targets=c(6), visible=TRUE, width='5%'),
                                       list(targets=c(7), visible=TRUE, width='5%'),
                                       list(targets=c(8), visible=TRUE, width='10%'),
                                       list(className='dt-center',targets="_all")
                     )
      ),
      rownames = FALSE,
      colnames = c("Date Time","Origin","Temp","Dewp","Humid","Wind Dir","Wind Speed","Pressure","Visib")
      ))
    #Tab Akhir Weathers
  #end Data
  
  #Awal Penerbangan
    flight_data <- reactive({
      qfl <- flights %>%
        filter(origin==input$airport & month==input$month & day==input$day) %>%
        left_join(qairports,by=c("origin"="faa"))  %>%
        rename(c('origin_name'='name','origin_lat'='lat','origin_lon'='lon')) %>%
        left_join(qairports,by=c("dest"="faa"))  %>%
        rename(c('dest_name'='name','dest_lat'='lat','dest_lon'='lon')) %>%
        select(time_hour,flight,carrier,tailnum,origin,dest,dep_time,sched_dep_time,dep_delay,arr_time,sched_arr_time,arr_delay,origin_name,origin_lat,origin_lon,flight,tailnum,dest_name,dest_lat,dest_lon)
      qfl
    })
    
    flight_airports <- reactive({
      flight_data <- flight_data()
      qfl_airports <- flight_data %>% distinct(dest,dest_name,origin) %>% select(dest,dest_name,origin)
      airport1 <- qfl_airports %>%
        left_join(qairports,by=c('dest'='faa'))%>%
        select(dest,dest_name,lat,lon,origin)
      airport1
    })
    
    output$info_2 <- renderUI({
      bln <- as.numeric(input$month)
      dsp_info = sprintf("<h4>Penerbangan dari  %s pada %s, %s </h4>",input$airport,input$day,month.name[bln])
      HTML(dsp_info)
    })
    
    # Tab Awal Data
    output$FlightsData <- DT::renderDataTable(
      DT::datatable({
        flight_data() %>%
          select(time_hour,dep_time,sched_dep_time,dep_delay,arr_time,sched_arr_time,arr_delay,origin,dest,flight,carrier,tailnum) %>% mutate(time_hour = format(time_hour, "%Y-%m-%d %H:%M:%S"))
      },
      fillContainer = T,
      options = list(lengthMenu=list(c(10,20,50),c('10','20','50')),pageLength=10,scrollY = "100%",searchHighlight = TRUE,order = list(1, 'asc'),
                     initComplete = JS(
                       "function(settings, json) {",
                       "$(this.api().table().header()).css({'background-color': '#B5E4FF', 'color': '000000'});",
                       "}"),
                     autowidth = TRUE,
                     columnDefs = list(list(targets=c(0), visible=TRUE, width='10%'),
                                       list(targets=c(1), visible=TRUE, width='10%'),
                                       list(targets=c(2), visible=TRUE, width='15%'),
                                       list(targets=c(3), visible=TRUE, width='15%'),
                                       list(targets=c(4), visible=TRUE, width='5%'),
                                       list(targets=c(5), visible=TRUE, width='5%'),
                                       list(targets=c(6), visible=TRUE, width='5%'),
                                       list(targets=c(7), visible=TRUE, width='5%'),
                                       list(targets=c(8), visible=TRUE, width='5%'),
                                       list(targets=c(9), visible=TRUE, width='5%'),
                                       list(targets=c(10), visible=TRUE, width='5%'),
                                       list(targets=c(11), visible=TRUE, width='5%'),
                                       list(className='dt-center',targets="_all")
                     )
      ),
      rownames = FALSE,
      colnames = c("time_hour","dep_time","sched_dep_time","dep_delay","arr_time","sched_arr_time","arr_delay","origin","dest","flight","carrier","tailnum")
      ))
    # Tab End Data
    
    # Tab Awal Grafik
    output$graph_flight_count <- renderPlotly({
      q1 <- flights %>%
        filter(origin==input$airport & month==input$month & day==input$day) %>%
        group_by(origin,dest) %>%
        summarise(total.count=n())
      
      fig <- plot_ly()
      fig <- fig %>%
        add_trace(
          type = 'scatter',
          mode = 'lines+markers',
          x = q1$dest,
          y = q1$total.count,
          text = paste(q1$origin, q1$dest, sep=" - "),
          hovertemplate = paste('<b>%{text}</b> : %{y} flights'),
          showlegend = TRUE
        )
      fig
    })
    # Tab End Grafik
    
    # Tab Awal Maps
    output$flightmap <-renderPlotly({
      flight_airports<-flight_airports()
      flight_data <- flight_data()
      
      geo <- list(
        scope = 'north america',
        projection = list(type = 'azimuthal equal area'),
        showland = TRUE,
        #landcolor = toRGB("white"),
        landcolor = toRGB("black"),
        #countrycolor = toRGB("gray80")
        countrycolor = toRGB("white")
      )
      
      fig <- plot_geo(locationmode = 'USA-states', color = I("red"))
      fig <- fig %>% add_markers(
        data =  flight_airports, x = ~lon, y = ~lat, text = ~dest_name,
        hoverinfo = "text", alpha = 0.5
      )
      fig <- fig %>% add_segments(
        data =  flight_data,
        x = ~origin_lon, xend = ~dest_lon,
        y = ~origin_lat, yend = ~dest_lat,
        alpha = 0.3, size = I(1), hoverinfo = "none"
      )
      fig <- fig %>% layout(
        title = 'Jalur Penerbangan Kota New York',
        geo = geo, showlegend = FALSE
      )
      fig
    })
    # Tab End Maps
  #End Penerbangan
    
  #Awal Info Delay
    #Tab Departure Awal Graph (Grafik Keberangkatan)
    qdelay_dep_data <- reactive({
      dep_carrier <- flights %>%
        filter(origin==input$airport1 & month==input$month1 & dep_delay>0 ) %>%
        left_join(weather,by=c("origin"="origin","time_hour"="time_hour"))  %>%
        left_join(airlines,by=c('carrier'='carrier')) %>%
        select(time_hour,dep_time,sched_dep_time,dep_delay,origin,dest,flight,carrier,name,tailnum,temp,dewp,humid,wind_dir,wind_speed,pressure,visib)
      dep_carrier
    })
    
    qdelay_dep_data_1 <- reactive({
      q <- qdelay_dep_data() %>%
        group_by(origin,carrier,name) %>%
        summarise(total_count=n(),
                  sum_time=sum(as.numeric(dep_delay), na.rm = TRUE),
                  avg_time=mean(as.numeric(dep_delay), na.rm = TRUE),
                  .groups = 'drop'
                  
        ) %>%
        select(origin,carrier,name,total_count,sum_time,avg_time)
      q
    })
    
    output$Delay_Dep_Data_Sumarry <- DT::renderDataTable(
      DT::datatable({
        qdelay_dep_data_1()
      },
      fillContainer = T,
      options = list(lengthMenu=list(c(10,20,50),c('10','20','50')),pageLength=10,scrollY = "100%",searchHighlight = TRUE,order = list(1, 'asc'),
                     initComplete = JS(
                       "function(settings, json) {",
                       "$(this.api().table().header()).css({'background-color': '#B5E4FF', 'color': '000000'});",
                       "}"),
                     autowidth = TRUE,
                     #columnDefs=list(list(className='dt-center',targets="_all")),
                     columnDefs = list(list(targets=c(0), visible=TRUE, width='10%'),
                                       list(targets=c(1), visible=TRUE, width='10%'),
                                       list(targets=c(2), visible=TRUE, width='20%'),
                                       list(targets=c(3), visible=TRUE, width='20%'),
                                       list(targets=c(4), visible=TRUE, width='20%'),
                                       list(targets=c(4), visible=TRUE, width='20%'),
                                       
                                       list(className='dt-center',targets="_all")
                     )
      ),
      rownames = FALSE,
      colnames = c("airport","carrier","name","total_count","sum_time","avg_time")
      ))
    #Awal Grafik Jumlah Total Keberangkatan
    output$dep_graph_count <-  renderPlotly({
      fig <- plot_ly(qdelay_dep_data_1(), x = ~carrier, y = ~total_count, type = 'bar', name = 'Jumlah Total Penundaan Keberangkatan oleh Operator',marker = list(color = 'rgb(8, 171, 204)', line = list(color = 'rgb(8, 171, 204)', width = 1)))
      fig <- fig %>% layout(title ='
Jumlah Total Penundaan Keberangkatan oleh Operator',xaxis = list(title = 'Operator'),yaxis = list(title = 'Nilai Delay Keberangkatan'))
      fig
    })
    #End Grafik Jumlah Total Keberangkatan
    
    #Awal Grafik Jumlah Keberangkatan
    output$dep_graph_time <-  renderPlotly({
      fig <- plot_ly(qdelay_dep_data_1(), x = ~carrier, y = ~sum_time, type = 'bar', name = 'Jumlah Waktu (dalam menit) Penundaan Keberangkatan oleh Operator',marker = list(color = 'rgb(59, 119, 217)', line = list(color = 'rgb(59, 119, 217)', width = 1)))
      fig <- fig %>% layout(title ='Jumlah Delay Keberangkatan Oleh Operator',xaxis = list(title = 'Operator'),yaxis = list(title = 'Jumlah Delay Keberangkatan (menit)'))
    })
    #End Grafik Jumlah Keberangkatan
    
    #Awal Grafik Rat-Rata Keberangkatan
    output$dep_graph_avgtime <-  renderPlotly({
      fig <- plot_ly(qdelay_dep_data_1(), x = ~carrier, y = ~avg_time, type = 'bar', name = 'Rata-Rata Waktu (dalam menit) Penundaan Keberangkatan oleh Operator',marker = list(color = 'rgb(22, 42, 219)', line = list(color = 'rgb(22, 42, 219)', width = 1)))
      fig <- fig %>% layout(title ='Rata-Rata Delay Keberangkatan Oleh Operator',xaxis = list(title = 'Operator'),yaxis = list(title = 'Rata-Rata Delay Keberangkatan (menit)'))
    })
    #End Grafik Rat-Rata Keberangkatan
    
    #Tab Departure End Graph (Grafik Keberangkatan)
    
    #Tab Data Departure Awal (Data Delay Keberangkatan)
    output$Delay_Dep_Data <- DT::renderDataTable(
      DT::datatable({
        qdelay_dep_data() %>%  mutate(time_hour = format(time_hour, "%Y-%m-%d %H:%M:%S"))
      },
      fillContainer = T,
      options = list(lengthMenu=list(c(10,20,50),c('10','20','50')),pageLength=10,scrollY = "100%",searchHighlight = TRUE,order = list(0, 'asc'),
                     initComplete = JS(
                       "function(settings, json) {",
                       "$(this.api().table().header()).css({'background-color': '#B5E4FF', 'color': '000000'});",
                       "}"),
                     autowidth = TRUE,
                     #columnDefs=list(list(className='dt-center',targets="_all")),
                     columnDefs = list(list(targets=c(0), visible=TRUE, width='10%'),
                                       list(targets=c(1), visible=TRUE, width='10%'),
                                       list(targets=c(2), visible=TRUE, width='15%'),
                                       list(targets=c(3), visible=TRUE, width='15%'),
                                       list(targets=c(4), visible=TRUE, width='5%'),
                                       list(targets=c(5), visible=TRUE, width='5%'),
                                       list(targets=c(6), visible=TRUE, width='5%'),
                                       list(targets=c(7), visible=TRUE, width='5%'),
                                       list(targets=c(8), visible=TRUE, width='5%'),
                                       list(targets=c(9), visible=TRUE, width='5%'),
                                       list(targets=c(10), visible=TRUE, width='5%'),
                                       list(targets=c(11), visible=TRUE, width='5%'),
                                       list(targets=c(12), visible=TRUE, width='5%'),
                                       list(targets=c(13), visible=TRUE, width='5%'),
                                       list(targets=c(14), visible=TRUE, width='5%'),
                                       list(targets=c(15), visible=TRUE, width='5%'),
                                       
                                       list(className='dt-center',targets="_all")
                     )
      ),
      rownames = FALSE,
      colnames = c("time_hour","dep_time","sched_dep_time","dep_delay","origin","dest","flight","carrier","name","tailnum","temp","dewp","humid","wind_dir","wind_speed","pressure","visib")
      ))
    #Tab Data Departure End (Data Delay Keberangkatan)
    # ===========================================================================================
    #Tab Data kedatangan Awal
    qdelay_arr_data <- reactive({
      arr_carrier <- flights %>%
        filter(arr_delay>0 & origin==input$airport1 & month==input$month1) %>%
        left_join(weather,by=c("origin"="origin","time_hour"="time_hour"))  %>%
        left_join(airlines,by=c('carrier'='carrier')) %>%
        select(time_hour,arr_time,sched_arr_time,arr_delay,origin,dest,flight,carrier,name,tailnum,temp,dewp,humid,wind_dir,wind_speed,pressure,visib)
      arr_carrier
    })
    
    qdelay_arr_data_1 <- reactive({
      q <- qdelay_arr_data() %>%
        group_by(origin,carrier,name) %>%
        summarise(total_count=n(),
                  sum_time=sum(as.numeric(arr_delay), na.rm = TRUE),
                  avg_time=mean(as.numeric(arr_delay), na.rm = TRUE),
                  .groups = 'drop'
                  
        ) %>%
        select(origin,carrier,name,total_count,sum_time,avg_time)
      q
    })
    
    output$Delay_Arr_Data_Sumarry <- DT::renderDataTable(
      DT::datatable({
        qdelay_arr_data_1()
      },
      fillContainer = T,
      options = list(lengthMenu=list(c(10,20,50),c('10','20','50')),pageLength=10,scrollY = "100%",searchHighlight = TRUE,order = list(1, 'asc'),
                     initComplete = JS(
                       "function(settings, json) {",
                       "$(this.api().table().header()).css({'background-color': '#B5E4FF', 'color': '000000'});",
                       "}"),
                     autowidth = TRUE,
                     #columnDefs=list(list(className='dt-center',targets="_all")),
                     columnDefs = list(list(targets=c(0), visible=TRUE, width='10%'),
                                       list(targets=c(1), visible=TRUE, width='10%'),
                                       list(targets=c(2), visible=TRUE, width='20%'),
                                       list(targets=c(3), visible=TRUE, width='20%'),
                                       list(targets=c(4), visible=TRUE, width='20%'),
                                       list(targets=c(4), visible=TRUE, width='20%'),
                                       
                                       list(className='dt-center',targets="_all")
                     )
      ),
      rownames = FALSE,
      colnames = c("airport","carrier","name","total_count","sum_time","avg_time")
      ))
    
    #Awal Grafik Jumlah Total Kedatangan
    output$arr_graph_count <-  renderPlotly({
      fig <- plot_ly(qdelay_arr_data_1(), x = ~carrier, y = ~total_count, type = 'bar', name = 'Jumlah Total Penundaan Kedatangan oleh Operator',marker = list(color = 'rgb(8, 171, 204)', line = list(color = 'rgb(8, 171, 204)', width = 1)))
      fig <- fig %>% layout(title ='Jumlah Total Penundaan Kedatangan oleh Operator',xaxis = list(title = 'Operator'),yaxis = list(title = 'Nilai Delay Kedatangan'))
      fig
    })
    #End Grafik Jumlah Total Kedatangan
    
    #Awal Grafik Jumlah Kedatangan
    output$arr_graph_time <-  renderPlotly({
      fig <- plot_ly(qdelay_dep_data_1(), x = ~carrier, y = ~sum_time, type = 'bar', name = 'Jumlah Waktu (dalam menit) Penundaan Kedatangan oleh Operator',marker = list(color = 'rgb(59, 119, 217)',line = list(color = 'rgb(59, 119, 217)', width = 1)))
      fig <- fig %>% layout(title ='Jumlah Delay Kedatangan Oleh Operator',xaxis = list(title = 'Operator'),yaxis = list(title = 'Jumlah Delay Kedatangan (menit)'))
    })
    #End Grafik Jumlah Kedatangan
    
    #Awal Grafik Rata-Rata Kedatangan
    output$arr_graph_avgtime <-  renderPlotly({
      fig <- plot_ly(qdelay_dep_data_1(), x = ~carrier, y = ~avg_time, type = 'bar', name = 'Rata-Rata Waktu (dalam menit) Penundaan Kedatangan oleh Operator',marker = list(color = 'rgb(22, 42, 219)', line = list(color = 'rgb(22, 42, 219)', width = 1)))
      fig <- fig %>% layout(title ='Rata-Rata Delay Kedatangan Oleh Operator',xaxis = list(title = 'Operator'),yaxis = list(title = 'Rata-Rata Delay Kedatangan (menit)'))
    })
    #End Grafik Rata-Rata Kedatangan
    
    #Tab Data kedatangan Awal (Data Delay kedatangan)
    output$Delay_Arr_Data <- DT::renderDataTable(
      DT::datatable({
        qdelay_arr_data() %>%  mutate(time_hour = format(time_hour, "%Y-%m-%d %H:%M:%S"))
      },
      fillContainer = T,
      options = list(lengthMenu=list(c(10,20,50),c('10','20','50')),pageLength=10,scrollY = "100%",searchHighlight = TRUE,order = list(0, 'asc'),
                     initComplete = JS(
                       "function(settings, json) {",
                       "$(this.api().table().header()).css({'background-color': '#B5E4FF', 'color': '000000'});",
                       "}"),
                     autowidth = TRUE,
                     #columnDefs=list(list(className='dt-center',targets="_all")),
                     columnDefs = list(list(targets=c(0), visible=TRUE, width='10%'),
                                       list(targets=c(1), visible=TRUE, width='10%'),
                                       list(targets=c(2), visible=TRUE, width='15%'),
                                       list(targets=c(3), visible=TRUE, width='15%'),
                                       list(targets=c(4), visible=TRUE, width='5%'),
                                       list(targets=c(5), visible=TRUE, width='5%'),
                                       list(targets=c(6), visible=TRUE, width='5%'),
                                       list(targets=c(7), visible=TRUE, width='5%'),
                                       list(targets=c(8), visible=TRUE, width='5%'),
                                       list(targets=c(9), visible=TRUE, width='5%'),
                                       list(targets=c(10), visible=TRUE, width='5%'),
                                       list(targets=c(11), visible=TRUE, width='5%'),
                                       list(targets=c(12), visible=TRUE, width='5%'),
                                       list(targets=c(13), visible=TRUE, width='5%'),
                                       list(targets=c(14), visible=TRUE, width='5%'),
                                       list(targets=c(15), visible=TRUE, width='5%'),
                                       
                                       list(className='dt-center',targets="_all")
                     )
      ),
      rownames = FALSE,
      colnames = c("time_hour","arr_time","sched_arr_time","arr_delay","origin","dest","flight","carrier","name","tailnum","temp","dewp","humid","wind_dir","wind_speed","pressure","visib")
      ))
    #Tab Data kedatangan End (Data Delay kedatangan)
    #Tab Data kedatangan End
    
  #End Info Delay
    
    # Awal Delay v/s cuaca
    output$weather_plot <- renderPlot({
      g <-
        ggplot(cor_data,
               aes_string(y = input$var1, x = cor_data$total_delay)) + ggtitle(paste("Total Delay v/s", input$var1)) + theme(plot.title = element_text(hjust = 0.5))
      g + geom_smooth() + ylab(input$var1) +
        xlab("Total Delay (menit)")
    })
    # End Delay v/s cuaca
    
    #awal profil
    output$profilfile <- renderUI({
      includeHTML("file/profile.html")
    })
    #end profil
  
}