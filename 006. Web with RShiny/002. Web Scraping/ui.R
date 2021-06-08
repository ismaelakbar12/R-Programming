library(shiny)
library(shinythemes)
library(DT)
library(dplyr)
library(plotly)

ui = fluidPage(theme = shinytheme("cerulean"), titlePanel(' ', windowTitle = 'MIT UIN WebScraping'),
               navbarPage(
                   "WS-UIN",
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
                   
                   # Awal Data
                   tabPanel("Data",
                            h3("Informasi Data Jaringan Keselamatan Penerbangan"),
                            hr(),
                            fluidRow(
                                column(
                                    3,
                                    class="bg-primary",
                                    br(),
                                    selectInput(inputId = "tahun",
                                                label = "Pilih Tahun",
                                                choices = c("2018", "2019", "2020", "2021"),
                                                selected = "2020"),
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
                                                 plotlyOutput("FlightsGrafik")
                                        )
                                    )
                                )
                            )
                            
                   ),
                   # Akhir Penerbangan
                   
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