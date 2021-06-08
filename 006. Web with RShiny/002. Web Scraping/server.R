library(shiny)
library(ralger)
library(DT)
library(dplyr)
library(plotly)

server = function(input, output, session)
{
    #awal beranda
    output$homefile <- renderUI({
        includeHTML("www/beranda.html")
    })
    #end beranda
    
    flight_data <- reactive({
        select_tahun = input$tahun
        url = "https://aviation-safety.net/database/dblist.php?Year="
        
        url_tahun <- paste0(url, select_tahun)
        tabel_hasil = table_scrap(url_tahun)
        tabel_hasil
    })
    
    output$info_2 <- renderUI({
        dsp_info = sprintf("<h4>Data Jaringan Keselamatan Penerbangan Tahun  %s </h4>",input$tahun)
        HTML(dsp_info)
    })
    
    # Tab Awal Data
    output$FlightsData <- DT::renderDataTable(
    DT::datatable({
        #flight_data()
        select_tahun = input$tahun
        url = "https://aviation-safety.net/database/dblist.php?Year="
        
        url_tahun <- paste0(url, select_tahun)
        tabel_hasil = table_scrap(url_tahun)
        tabel_hasil
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
                                     list(targets=c(5), visible=TRUE, width='30%'),
                                     list(targets=c(6), visible=TRUE, width='5%'),
                                     list(targets=c(7), visible=TRUE, width='5%'),
                                     list(targets=c(8), visible=TRUE, width='5%'),
                                     list(className='dt-center',targets="_all")
                   )
    ),
    rownames = FALSE,
        colnames = c("date","type","registration","operator","fat","location","country","pic","cat")
    ))
    # Tab End Data
    
    # Tab Awal Grafik
    output$FlightsGrafik <- renderPlotly({
        select_tahun = input$tahun
        url = "https://aviation-safety.net/database/dblist.php?Year="
        
        url_tahun <- paste0(url, select_tahun)
        tabel_hasil = table_scrap(url_tahun)
        tabel_hasil
        
        q1 <- tabel_hasil
        
        fig <- plot_ly()
        fig <- fig %>%
            add_trace(
                type = 'scatter',
                mode = 'lines+markers',
                x = q1$date,
                y = q1$fat.,
                text = paste(q1$select_tahun, q1$date, sep=" - "),
                hovertemplate = paste('<b>%{text}</b> : %{y} Insiden'),
                showlegend = TRUE
            )
        fig
    })
    # Tab End Grafik
    
    
    #awal profil
    output$profilfile <- renderUI({
        includeHTML("www/profile.html")
    })
    #end profil
    
}