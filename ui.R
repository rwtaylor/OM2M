library(shiny)
library(shinyBS)

info <- function(label = "Label", info_content = "add content") {
  div(
    p(label,
      popify(icon("info-circle"), title = NULL, content = info_content, placement = "right", trigger = "hover")
    )
  )
}

shinyUI(fluidPage(
  # Application title
  titlePanel("Genetic Management of Fragmented Populations"),
  # Sidebar with a slider input for the number of bins

  fluidRow(
    column(3,
      tabsetPanel(type = "tabs",
        tabPanel("Demographics",
          # br(),
          # submitButton("Update Plot", icon("refresh")),
          # br(),
          sliderInput("L", info("Number of demes:", "The number of isolated populations."),
            min   = 1,
            max   = 50,
            value = 5
            ),
          numericInput("N",
            "Individuals (Ne) per deme:",
            min   = 1,
            value = 100
            ),
          numericInput("Ntot0",
            info("Original population size:", "The estimated population size prior to anthropogenic population decline."),
            min   = 1,
            value = 1e5
            ),
          sliderInput("G_t",
            info("Generations:", "The number of generations to run the simulation for"),
            min   = 10,
            max   = 5000,
            value = 3000
            ),
          numericInput("mu",
            info("Mutation rate:", "Microsattelite ~ 1e-5, SNP ~ 1e-8"),
            step = 1e-8,
            value = 1e-5
            )
        ),
        tabPanel("Scenarios",
          # br(),
          # submitButton("Update Plot", icon("refresh")),
          # br(),
          h3("Choose scenarios to plot"),
          checkboxGroupInput("scenarios",
          label = NULL,
            choiceNames = list(
              info("No migration", "All populations are isolated in perpetuity."),
              info("Full admixture", "The populations fully mix with each other."),
              info("One migrant per generation", "One individual per genearation migrates into each population."),
              info("Scheme 1","A genetic rescue occurs when the local heterozygosity drops below a set threshold."),
              info("Scheme 2", "Migration is allowed at increasing rates once heterozygosity drops to a set threshold.")
              ),
            choiceValues = list("no_migration", "full_admixture", "ompg",
                                "scheme_1", "scheme_2"),
            selected = c("no_migration", "full_admixture", "ompg",
                         "scheme_1", "scheme_2")
          ),
          hr(),
          h3("Scenario parameters"),
          sliderInput('h_scheme_1',
            'Heterozygosity threshold for Scheme 1',
            min = 0, max = 1, value = 0.1
          ),
          sliderInput("h_scheme_2",
            "Heterozygosity threshold for Scheme 2",
            min = 0, max = 1, value = 0.2
          ),
          sliderInput('R',
            'Proportion of alleles replaced during rescue',
            min = 0, max = 1, value = 0.2
          )
        ), #tabpanel scenarios
        tabPanel("Options",
          # br(),
          # submitButton("Update Plot", icon("refresh")),
          br(),
          sliderInput('ylims', "Y axis range", min = 0, max = 1, value = c(0,1)),
          hr(),
          radioButtons("which_het", label = "Plot Heterozygosity",
             choices = list("Local" = 1, "Global" = 2, "Both" = 3),
             selected = 3
          ),
          hr(),
          h4("Alternative Scenarios"),
          checkboxInput("randomrescue",
          "Recurring rescues scenario",
          value = FALSE
          ),
          sliderInput('lambda',
            'Probability of random rescue per deme per generation',
            min = 0, max = 0.1, value = 0.01
          )
        ) #tabpanel
      ) #tabsetpanel
    ), #column3
    column(9,
      plotOutput("distPlot", height = "800px")
    )
  ),
  fluidRow(
    column(3,
      wellPanel(
        h3("Save Plot"),
        textInput('plot_filename', "Heterozygosity.pdf", label = "Filename"),
        downloadButton('downloadPlot', 'Download Plot')
        )
      )
    ),
    HTML("<script>
$(document).ready(function(){
  $('[data-toggle=\\\"popover\\\"]').popover(); 
});
</script>")#fluidRow
  )#fluidPage
)#shinyui
