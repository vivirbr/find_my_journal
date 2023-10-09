# Loading packages
library(httr)
library(rjson)
library(shiny)
library(readr)
library(dplyr)
library(shinythemes)

# Setting a very simple page with a left panel with the input for the prompt
# the output of the function will return as a table in the right panel
# The action button Run will allow you to control the function and require a new run of the prompt

ui <- fluidPage(
  theme = shinytheme("slate"),
  fluidRow(
    column(4, wellPanel(
      br(),
      textInput("title", "Potential title:", "Disentangling the numbers behind agriculture-driven tropical deforestation"),
      textInput("key", "Key words:", ""), 
      textInput("sentence", "Teaser:", "A Review disentangles the numbers behind agriculture-driven deforestation and explains the different forms it can take."), 
      br(),
      actionButton("searchButton", "Search")
    )),
    column(8,
      h4("List of the best journals according to the information provided:"),
        tableOutput("answer")
    )
  )
)

# Server function holds the main application feature - isolate guarantees that it runs only after input searchButton is activated
# Because I am using here a simple Sys.getenv - you will have to add it as R environment in the apps directory

server <- function(input,output) {
  
  output$answer <- renderTable({
      input$searchButton
      
      isolate({
        # Set the PaLM API URL and headers.
        url = paste0("https://generativelanguage.googleapis.com/v1beta2/models/text-bison-001:generateText?key=",Sys.getenv("GC_KEY"))
        headers <-list("Content-Type" = "application/json")

        # Create the request body.
        list_object <- list()
        list_object$prompt <- list(text = paste0("Return a table with eigth rows, each one containting the most suitable scientific journal 
                                                  for paper publication. The first column will be the name of the journal, the second column
                                                  will be the impact factor, the third column will be the link t the journal webpage.
                                                  To evaluate the most suitable journal, consider how the journal scope and previous publications
                                                  are aligned to a paper which the potential title is '",
                                                  input$title,
                                                  "', the main key words are '",
                                                  input$key,
                                                  "', and the paper's sentence teaser is '",
                                                  input$sentence,
                                                  "'."))
        list_object$temperature <- 0.1 # Setting a more restrictive model temperature to avoid top journals to be repeated every time
        list_object$candidateCount <- 1 # Candidate is already set as 1 considering that the table produced will always return top eight journals

        body = toJSON(list_object) # It is important that the body is a json instead of a simple list

        response <- httr::POST(url, headers = headers, body = body, encode = "json") # Send the request and get the response.
        json <- fromJSON(rawToChar(response$content)) # Returning the response content

        # reading the only answer provided in a data.frame format
        tab <- data.frame(read_delim(json$candidates[[1]]$output, delim = '|', col_names=TRUE, show_col_types = FALSE)) 
        tab <- tab %>% select(where(~!all(is.na(.)))) # removing columns that are purely NAs
        # colnames(tab) <- gsub(colnames(tab), pattern = "X...|\\...", replacement = "")  
        colnames(tab) <- c("Journal","Impact Factor", "Link")
        tab <- tab[-1,] #removing first empty row

    })

  })

}

shinyApp(ui, server)
