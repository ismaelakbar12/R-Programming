library(shiny)
library(shinythemes)
library(DT)
library(dplyr)
library(tidyverse)
library(nycflights13)
library(plotly)
library(ggplot2)
library(maps)
library(hexbin)

ui = fluidPage(theme = shinytheme("cerulean"), titlePanel(' ', windowTitle = 'MIT-UIN'),
       navbarPage(
         "FDA-UIN",
         # awal beranda
         tabPanel(
           "Beranda", 
            fluidRow(
              column(
                12,
                uiOutput("homefile"),
                align="left")
            )
          
          ),
         # akhir beranda
         
         # awal Data
         tabPanel("Data",
            h3("Data Informasi Penerbangan Kota New York "),
            hr(),
            column(
              12, 
              tabsetPanel(
                id = 'tabs1',
                tabPanel(
                  "Maskapai",
                  br(),
                  DT::dataTableOutput("AirlinesData")
                ),
                tabPanel(
                  "Bandara US",
                  br(),
                  DT::dataTableOutput("AirportsData")
                ),
                tabPanel(
                  "Pesawat",
                  br(),
                  DT::dataTableOutput("PlanesData")
                ),
                tabPanel("Cuaca",
                  br(),
                  DT::dataTableOutput("WeathersData")
                )
            )
            )
         ),
         # akhir Data
         
         # Awal Penerbangan
         tabPanel("Penerbangan",
            h3("Informasi Penerbangan"),
            hr(),
            fluidRow(
              column(
                3,
                class="bg-primary",
                br(),
                selectInput(inputId = "airport",
                            label = "Pilih Bandara",
                            choices = c("EWR", "LGA", "JFK"),
                            selected = "JFK"),
                selectInput(inputId = "month",
                            label = "Pilih Bulan",
                            choices = c(1:12),
                            selected = "1"),
                selectInput(inputId = "day",
                            label = "Pilih Tanggal",
                            choices = c(1:31),
                            selected = "1"),
                br()
            ),
            column(
              9, 
              tabsetPanel(
                id = 'tabs2',
                tabPanel("Data",
                   br(), uiOutput("info_2"),
                   DT::dataTableOutput("FlightsData")
                ),
                tabPanel("Grafik",
                   br(),
                   h4('Berapa banyak penerbangan tiap hari ?'),
                   plotlyOutput("graph_flight_count")
                ),
                tabPanel("Maps",
                   br(),
                   plotlyOutput("flightmap")
                )
              )
            )
          )
                  
         ),
         # Akhir Penerbangan
         
         # awal Delay
         tabPanel("Info Delay",
            h3("Data Informasi Delay Penerbangan Kota New York "),
            hr(),
            fluidRow(
              column(12,class="bg-primary",
                  column(
                    6, br(),
                    selectInput(inputId = "airport1",
                                label = "Pilih Bandara",
                                choices = c("EWR", "LGA", "JFK"),
                                selected = "JFK")
                  ),
                  column(
                    6, br(),
                    selectInput(inputId = "month1",
                                label = "Pilih Bulan",
                                choices = c(1:12),
                                selected = "1")
                  ),
                  br()
              )
            ), # fluid row
            br(),
            fluidRow(
              column(12, tabsetPanel(id = 'tabs2',
                   tabPanel("Data Delay Keberangkatan",
                            br(),
                            h4("Data Delay Keberangkatan"),
                            DT::dataTableOutput("Delay_Dep_Data")
                            
                   ),
                  tabPanel("Grafik Keberangkatan",
                           br(),
                           h4("Delay Keberangkatan oleh Operator"),
                           DT::dataTableOutput("Delay_Dep_Data_Sumarry"),
                           br(),
                           plotlyOutput("dep_graph_count"),
                           br(),
                           br(),
                           fluidRow(column(6,
                                           plotlyOutput("dep_graph_time")),
                                    column(6,
                                           plotlyOutput("dep_graph_avgtime"))
                           )
                           
                  ),
                  tabPanel("Data Delay Kedatangan",
                           br(),
                           h4("Data Delay Kedatangan"),
                           DT::dataTableOutput("Delay_Arr_Data")
                  ),
                  tabPanel("Grafik Kedatangan",
                           br(),
                           h4("Delay Kedatangan oleh Operator"),
                           DT::dataTableOutput("Delay_Arr_Data_Sumarry"),
                           br(),
                           plotlyOutput("arr_graph_count"),
                           br(),
                           fluidRow(column(6,
                                           plotlyOutput("arr_graph_time")),
                                    column(6,
                                           plotlyOutput("arr_graph_avgtime"))
                           )
                           
                  )
                )
              )
            )
         ),
         # akhir Delay
         
         # awal Weather
         tabPanel("Delay v/s Cuaca",
            h3("Pengaruh Cuaca pada Total Delay"),
            hr(),
            
            fluidRow(
              column(
                3,
                class="bg-primary",
                br(),
                selectInput(inputId = "var1",
                            label = "Pilih Elemen Cuaca",
                            choices = c("Temperature", "Pressure", "Humidity","Windspeed","Precipitation"),
                            selected = "Temperature"),
                br()
              ),
              column(
                9, 
                tabsetPanel(
                  id = 'tabs2',
                  tabPanel("Kondisi Cuaca",
                           br(),
                           plotOutput('weather_plot')
                  )
                )
              )
            )
         ),
         # akhir Weather
         
         # awal About
         tabPanel(
           "Profil", 
           fluidRow(
             column(
               12,
               uiOutput("profilfile"),
               align="left")
           )
           
         )
         # akhir About
       )
)