library(httr)
library(rjson)
library(shiny)
library(readr)
library(dplyr)
library(shinythemes)

options(shiny.host = "0.0.0.0")
options(shiny.port = 5000)

ui <- fluidPage(
  theme = shinytheme("slate"),
  fluidRow(
    column(4, wellPanel(
      textInput("title", "Potential title:", "Disentangling the numbers behind agriculture-driven tropical
deforestation"),
      textInput("key", "Key words:", ""), 
      textInput("sentence", "Teaser:", "A Review disentangles the numbers behind agriculture-driven deforestation and
explains the different forms it can take."), 
      br(),
      actionButton("goButton", "Run")
    )),
    column(8,
      h4("List of the best journals according to the information provided:"),
        # span(textOutput("answer"), style="color:white font-size:large")
        tableOutput("answer")
    )
  )
)

server <- function(input,output) {
  
output$answer <- renderTable({
    input$goButton
    
    isolate({
      # Set the PaLM API URL and headers.
      url = paste0("https://generativelanguage.googleapis.com/v1beta2/models/text-bison-001:generateText?key=",Sys.getenv("GC_KEY"))
      headers <-list("Content-Type" = "application/json")

      # Create the request body.
      list_object <- list()
      list_object$prompt <- list(text = paste0("Return a table with a maximum of eigth of the most suitable scientific journals 
                                                for paper publication, and their respective impact factors and link to the journal
                                                website. Consider how the journal scope is aligned to a paper with a potential title '",
                                               input$title,
                                               "' consider that the main key words are '",
                                               input$key,
                                               "' and also that a very short description of the paper is '",
                                               input$sentence,
                                               "'."))
      list_object$temperature <- 0.5
      list_object$candidateCount <- 2

      body = toJSON(list_object)

      # Send the request and get the response.
      response <- httr::POST(url, headers = headers, body = body, encode = "json")
      json <- fromJSON(rawToChar(response$content))
      tab <- data.frame(read_delim(json$candidates[[1]]$output, delim = '|', col_names=TRUE, show_col_types = FALSE))
      tab <- tab %>% select(where(~!all(is.na(.))))
      colnames(tab) <- gsub(colnames(tab), pattern = "X...|\\...", replacement = "")  

      tab <- tab[-1,]

    })

  })

}

shinyApp(ui, server)