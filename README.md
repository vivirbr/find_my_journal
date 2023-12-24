## Find my journal - A quick adventure mixing PaLM AI 2 and R Shiny apps
### An PaLM AI based application that finds you the most suitable scientific journal for your publication, based on components such as title, keywords, and short descriptions.

Welcome to the episode one of Rcandoit! 
This repository was born during the Makersuite and PaLM API sprint for Google Developer Experts - and wants to share a quick tutorial of less widespread applications of R. 

Watch the youtube tutorial:

___
### About R
R is a popular programming language for data analysis and visualization, but the community often does not fully explore its possibilities and simplicity for building cutting-edge technology apps to increase productivity or design MRVs for more elaborate applications
Many 

### Shiny apps
Shiny apps are interactive web applications that can be created using R, and they offer a simple way to deploy those applications, often without costs associated.

### PaLM API
LLM-based applications can be extremely helpful in increasing productivity by generating a huge variety of texts, such as code and language translations, and reducing the cost and time of searches. PaLM API gives you easy access to generative AI, allowing the power of this technology to be easily included in your solutions


In this tutorial, I will show you how to use PaLM AI and R Shiny app to build a simple web platform to support decision-making on the best scientific periodicals to submit your research.
___
### Three + One important elements

Clone this repo to access all the files described below to make the most of the tutorial

1. **The app.R**
   1. Server: The R code that runs behind the scenes to generate the output of the app. It is responsible for handling user input, processing data, and generating output.
   2. UI: The UI is the user interface of the app. It is responsible for displaying the input and output of the app to the user.
   
   Server and UI can be described in separate file or in the same file as shown in this tutorial, as long as the main function `shinyApp()` shows both parameters

   3. Prompt: Provide model the information needed to generate the output - it is a natural language request with instructions and contextual information that allows the model to process the request. In this application both the content and the output format is delimited by the prompt provided to the API. See in the `app.R` file how the prompt request a specific number of rows and columns to the output table
   
2. **.Renviron**
   The .Renviron is one of the most important components to get the app running in cases when you need to provide an API key. You don't need, and neither is recommended that you add the key directly to the `app.R` code, instead you can start a text file with the name .Renviron (accept the file with a name . if asked) with the name of the env variable and the key. The file will look a bit like this:
   
   ```
   API_KEY=paste_your_api_key_here_without_quotation_marks
   ```
   The file should be added in your .gitignore - which I recommend all R users to ask for the automatic R .gitignore when creating the repo on GitHub

3. **deploy.md**
   No secrets here, there is no easier way than following the [shinyapp tutorial](https://www.shinyapps.io/admin/#/dashboard) just make sure to have an account first

4. **Bonus: embedding the application in a website the easy way**
    This repo has a very primitive html css website prototype with the main focus on the `index.html` file, showing how Shiny apps can be easily embedded into your application as an iframe
___

_Lots to develop here, but I hope any of these steps can help making your life simple with you future applications and generative AI journey_

