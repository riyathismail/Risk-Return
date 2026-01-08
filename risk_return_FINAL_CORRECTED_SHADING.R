library(shiny)
library(shinydashboard)
library(ggplot2)
library(plotly)
library(DT)

# UI
ui <- dashboardPage(
  skin = "blue",
  dashboardHeader(
    title = "Risk and Return: Complete Guide",
    tags$li(class = "dropdown",
            tags$style(HTML("
              .dark-mode { background-color: #2c3e50 !important; color: #ecf0f1 !important; }
              .dark-mode .content-wrapper { background-color: #34495e !important; }
              .dark-mode .box { background-color: #2c3e50 !important; color: #ecf0f1 !important; }
            ")),
            actionButton("dark_mode_toggle", "🌙 Dark Mode", 
                        style = "margin-top: 8px; margin-right: 10px;")
    )
  ),
  
  dashboardSidebar(
    sidebarMenu(
      id = "sidebar",
      menuItem("1. Return Basics", tabName = "returns", icon = icon("percent")),
      menuItem("2. Historical vs Expected", tabName = "historical", icon = icon("chart-line")),
      menuItem("3. Return Measures", tabName = "measures", icon = icon("calculator")),
      menuItem("4. Probability & Risk", tabName = "probability", icon = icon("dice")),
      menuItem("5. Portfolio Returns", tabName = "portfolio", icon = icon("briefcase")),
      menuItem("6. Why Diversification Works", tabName = "diversification", icon = icon("shield-alt")),
      menuItem("7. Systematic vs Unsystematic Risk", tabName = "systematic_risk", icon = icon("layer-group")),
      menuItem("8. Efficient Frontier & CML", tabName = "efficient_frontier", icon = icon("chart-area")),
      menuItem("9. CAPM & Beta", tabName = "capm", icon = icon("bullseye")),
      menuItem("10. Risk-Adjusted Performance", tabName = "risk", icon = icon("star")),
      menuItem("11. Comprehensive Quiz", tabName = "quiz", icon = icon("graduation-cap")),
      
      # NEW FEATURES
      menuItem("13. Download Reports", tabName = "downloads", icon = icon("download")),
      menuItem("14. Import Data", tabName = "import_data", icon = icon("upload")),
      menuItem("15. Portfolio Comparison", tabName = "comparison", icon = icon("balance-scale")),
      
      menuItem("About", tabName = "about", icon = icon("info-circle")),
      
      # PROGRESS TRACKER
      tags$hr(),
      tags$div(
        style = "padding: 15px;",
        h4("Your Progress", style = "color: white;"),
        uiOutput("progress_display")
      )
    )
  ),
  
  dashboardBody(
    # DARK MODE SCRIPT
    tags$script(HTML("
      $(document).on('click', '#dark_mode_toggle', function() {
        $('body').toggleClass('dark-mode');
        if($('body').hasClass('dark-mode')) {
          $('#dark_mode_toggle').html('☀️ Light Mode');
        } else {
          $('#dark_mode_toggle').html('🌙 Dark Mode');
        }
      });
    ")),
    
    tags$head(
      # MOBILE RESPONSIVENESS
      tags$meta(name = "viewport", content = "width=device-width, initial-scale=1"),
      
      tags$style(HTML("
        .content-wrapper { background-color: #ecf0f5; }
        .box { border-radius: 5px; }
        .formula-box {
          background-color: #fff3cd;
          border: 2px solid #ffc107;
          border-radius: 5px;
          padding: 15px;
          margin: 10px 0;
        }
        .example-box {
          background-color: #d1ecf1;
          border: 2px solid #17a2b8;
          border-radius: 5px;
          padding: 15px;
          margin: 10px 0;
        }
        .quiz-option { 
          margin: 10px 0; 
          padding: 15px; 
          background: white; 
          border: 2px solid #ddd; 
          border-radius: 5px; 
          cursor: pointer;
          transition: all 0.3s;
        }
        .quiz-option:hover { 
          background: #e3f2fd; 
          border-color: #2196F3;
        }
        .correct { 
          background: #c8e6c9 !important; 
          border-color: #4caf50 !important;
        }
        .incorrect { 
          background: #ffcdd2 !important; 
          border-color: #f44336 !important;
        }
        
        /* Mobile Responsiveness */
        @media (max-width: 768px) {
          .box { margin: 5px 0; }
          .value-box { margin: 5px 0; }
          .sidebar-menu { font-size: 14px; }
        }
      "))
    ),
    
    tabItems(
      # Tab 1: Return Basics
      tabItem(
        tabName = "returns",
        fluidRow(
          box(
            title = "Understanding Investment Returns", 
            status = "primary", 
            solidHeader = TRUE,
            width = 12,
            h3("What is Return?"),
            p("Return is the gain or loss on an investment over a period of time. It consists of two components:"),
            tags$ul(
              tags$li(strong("Capital Gain (or Loss):"), " Change in the price of the asset"),
              tags$li(strong("Income (Dividends/Interest):"), " Cash payments received from the investment")
            )
          )
        ),
        
        fluidRow(
          box(
            title = "Calculate Investment Returns", 
            status = "info", 
            solidHeader = TRUE,
            width = 6,
            h4("Stock Investment Example"),
            numericInput("buy_price", "Purchase Price (Rs.):", value = 100, min = 0),
            numericInput("sell_price", "Selling Price (Rs.):", value = 120, min = 0),
            numericInput("dividend", "Dividend Received (Rs.):", value = 5, min = 0),
            hr(),
            actionButton("calc_return", "Calculate Return", class = "btn-success btn-block")
          ),
          
          box(
            title = "Return Components", 
            status = "success", 
            solidHeader = TRUE,
            width = 6,
            fluidRow(
              valueBoxOutput("capital_gain_box", width = 12),
              valueBoxOutput("dividend_yield_box", width = 12),
              valueBoxOutput("total_return_box", width = 12)
            )
          )
        ),
        
        fluidRow(
          box(
            title = "Formula Reference", 
            status = "warning", 
            solidHeader = TRUE,
            width = 12,
            div(class = "formula-box",
                h4("Total Return Formula:"),
                HTML("<p style='font-size: 16px;'><strong>Total Return = Capital Gain + Dividend Yield</strong></p>"),
                HTML("<p style='font-size: 16px;'><strong>Total Return = [(P₁ - P₀) / P₀] + (D / P₀)</strong></p>"),
                HTML("<p style='font-size: 16px;'><strong>Total Return = [(P₁ - P₀ + D) / P₀]</strong></p>"),
                p("Where:"),
                tags$ul(
                  tags$li("P₀ = Initial price (purchase price)"),
                  tags$li("P₁ = Ending price (selling price)"),
                  tags$li("D = Dividends received")
                )
            ),
            div(class = "example-box",
                h4("Real-World Example: John Keells Holdings"),
                p("You bought JKH shares at Rs. 100 in January 2024"),
                p("Sold at Rs. 120 in December 2024"),
                p("Received Rs. 5 dividend during the year"),
                p(strong("Capital Gain:"), " (120 - 100) / 100 = 20%"),
                p(strong("Dividend Yield:"), " 5 / 100 = 5%"),
                p(strong("Total Return:"), " 20% + 5% = 25%")
            )
          )
        )
      ),
      
      # Tab 2: Historical vs Expected Returns
      tabItem(
        tabName = "historical",
        fluidRow(
          box(
            title = "Historical Returns vs Expected Returns", 
            status = "primary", 
            solidHeader = TRUE,
            width = 12,
            h4("Two Perspectives on Returns:"),
            tags$ul(
              tags$li(strong("Historical (Realized) Returns:"), " Actual returns earned in the past - what DID happen"),
              tags$li(strong("Expected (Future) Returns:"), " Anticipated returns in the future - what MIGHT happen")
            )
          )
        ),
        
        fluidRow(
          box(
            title = "Historical Returns Analysis", 
            status = "info", 
            solidHeader = TRUE,
            width = 6,
            h4("Enter Past Year Returns (%)"),
            p("Example: Dialog Axiata historical returns"),
            numericInput("year1", "Year 1 Return (%):", value = 12),
            numericInput("year2", "Year 2 Return (%):", value = 15),
            numericInput("year3", "Year 3 Return (%):", value = -5),
            numericInput("year4", "Year 4 Return (%):", value = 20),
            numericInput("year5", "Year 5 Return (%):", value = 8),
            hr(),
            actionButton("calc_historical", "Analyze Historical Returns", class = "btn-primary btn-block")
          ),
          
          box(
            title = "Historical Return Statistics", 
            status = "success", 
            solidHeader = TRUE,
            width = 6,
            fluidRow(
              valueBoxOutput("avg_historical_box", width = 12),
              valueBoxOutput("best_year_box", width = 6),
              valueBoxOutput("worst_year_box", width = 6)
            ),
            hr(),
            plotlyOutput("historical_plot", height = "250px")
          )
        ),
        
        fluidRow(
          box(
            title = "Expected Returns (Probability-Based)", 
            status = "warning", 
            solidHeader = TRUE,
            width = 6,
            h4("Scenario Analysis"),
            p("Enter possible future scenarios with probabilities"),
            fluidRow(
              column(6, numericInput("prob_boom", "Boom Probability (%):", value = 30, min = 0, max = 100)),
              column(6, numericInput("ret_boom", "Boom Return (%):", value = 25))
            ),
            fluidRow(
              column(6, numericInput("prob_normal", "Normal Probability (%):", value = 50, min = 0, max = 100)),
              column(6, numericInput("ret_normal", "Normal Return (%):", value = 12))
            ),
            fluidRow(
              column(6, numericInput("prob_recession", "Recession Probability (%):", value = 20, min = 0, max = 100)),
              column(6, numericInput("ret_recession", "Recession Return (%):", value = -10))
            ),
            hr(),
            valueBoxOutput("total_prob_box", width = 12),
            actionButton("calc_expected", "Calculate Expected Return", class = "btn-success btn-block")
          ),
          
          box(
            title = "Expected Return Results", 
            status = "success", 
            solidHeader = TRUE,
            width = 6,
            valueBoxOutput("expected_return_box", width = 12),
            hr(),
            plotlyOutput("scenario_plot", height = "300px"),
            hr(),
            div(class = "formula-box",
                h4("Expected Return Formula:"),
                HTML("<p style='font-size: 16px;'><strong>E(R) = Σ [Probability × Return]</strong></p>"),
                HTML("<p style='font-size: 16px;'><strong>E(R) = p₁R₁ + p₂R₂ + p₃R₃</strong></p>")
            )
          )
        )
      ),
      
      # Tab 3: Return Measures
      tabItem(
        tabName = "measures",
        fluidRow(
          box(
            title = "Types of Return Measures", 
            status = "primary", 
            solidHeader = TRUE,
            width = 12,
            h4("Three Ways to Calculate Average Returns:"),
            tags$ul(
              tags$li(strong("Arithmetic Mean:"), " Simple average - best for single-period expectations"),
              tags$li(strong("Geometric Mean:"), " Compound average - best for multi-period actual performance"),
              tags$li(strong("Harmonic Mean:"), " Used for averaging ratios (like P/E ratios) - not common for returns")
            )
          )
        ),
        
        fluidRow(
          box(
            title = "Multi-Year Return Data", 
            status = "info", 
            solidHeader = TRUE,
            width = 4,
            h4("Enter Annual Returns (%)"),
            numericInput("ret_yr1", "Year 1:", value = 10),
            numericInput("ret_yr2", "Year 2:", value = 20),
            numericInput("ret_yr3", "Year 3:", value = -15),
            numericInput("ret_yr4", "Year 4:", value = 25),
            numericInput("ret_yr5", "Year 5:", value = 5),
            hr(),
            actionButton("calc_means", "Calculate All Averages", class = "btn-primary btn-block")
          ),
          
          box(
            title = "Average Return Results", 
            status = "success", 
            solidHeader = TRUE,
            width = 8,
            fluidRow(
              valueBoxOutput("arithmetic_mean_box", width = 6),
              valueBoxOutput("geometric_mean_box", width = 6)
            ),
            hr(),
            plotlyOutput("means_comparison_plot", height = "300px"),
            hr(),
            uiOutput("means_interpretation")
          )
        ),
        
        fluidRow(
          box(
            title = "Formula Reference Guide", 
            status = "warning", 
            solidHeader = TRUE,
            width = 12,
            fluidRow(
              column(6,
                     div(class = "formula-box",
                         h4("Arithmetic Mean"),
                         HTML("<p><strong>AM = (R₁ + R₂ + ... + Rₙ) / n</strong></p>"),
                         p("Simple average of returns"),
                         p(strong("Use when:"), " Estimating single-period expected return"),
                         div(class = "example-box",
                             h5("Example:"),
                             p("Returns: 10%, 20%, -5%"),
                             p("AM = (10 + 20 - 5) / 3 = 8.33%")
                         )
                     )
              ),
              column(6,
                     div(class = "formula-box",
                         h4("Geometric Mean"),
                         HTML("<p><strong>GM = [(1+R₁)(1+R₂)...(1+Rₙ)]^(1/n) - 1</strong></p>"),
                         p("Compound average return"),
                         p(strong("Use when:"), " Measuring actual multi-period performance"),
                         div(class = "example-box",
                             h5("Example:"),
                             p("Returns: 10%, 20%, -5%"),
                             p("GM = [(1.10)(1.20)(0.95)]^(1/3) - 1"),
                             p("GM = [1.254]^0.333 - 1 = 7.85%")
                         )
                     )
              )
            ),
            hr(),
            div(class = "example-box",
                h4("Key Insight: Why Geometric Mean < Arithmetic Mean"),
                p("The geometric mean is always ≤ arithmetic mean (equality only if all returns are identical)."),
                p(strong("Reason:"), " The geometric mean accounts for volatility drag - the compounding effect of ups and downs."),
                p(strong("Example:"), " If you gain 50% then lose 50%, you don't break even!"),
                tags$ul(
                  tags$li("Start: Rs. 100"),
                  tags$li("After +50%: Rs. 150"),
                  tags$li("After -50%: Rs. 75 (you're down 25%!)"),
                  tags$li("Arithmetic Mean: (50% - 50%) / 2 = 0%"),
                  tags$li("Geometric Mean: [(1.50)(0.50)]^0.5 - 1 = -13.4%")
                )
            )
          )
        )
      ),
      
      # Tab 4: Probability and Risk
      tabItem(
        tabName = "probability",
        fluidRow(
          box(
            title = "Probability Distributions and Risk", 
            status = "primary", 
            solidHeader = TRUE,
            width = 12,
            h4("Understanding Risk Through Probability"),
            p("Risk in finance is measured by the dispersion or variability of possible returns around the expected return."),
            p("Key risk measures: Variance, Standard Deviation, and Coefficient of Variation")
          )
        ),
        
        fluidRow(
          box(
            title = "Build a Return Distribution", 
            status = "info", 
            solidHeader = TRUE,
            width = 6,
            h4("Scenario Inputs"),
            p("Define up to 5 possible scenarios"),
            fluidRow(
              column(6, h5("Probability (%)")),
              column(6, h5("Return (%)"))
            ),
            fluidRow(
              column(6, numericInput("p1", "Scenario 1:", value = 10)),
              column(6, numericInput("r1", "", value = -20))
            ),
            fluidRow(
              column(6, numericInput("p2", "Scenario 2:", value = 20)),
              column(6, numericInput("r2", "", value = -5))
            ),
            fluidRow(
              column(6, numericInput("p3", "Scenario 3:", value = 40)),
              column(6, numericInput("r3", "", value = 10))
            ),
            fluidRow(
              column(6, numericInput("p4", "Scenario 4:", value = 20)),
              column(6, numericInput("r4", "", value = 20))
            ),
            fluidRow(
              column(6, numericInput("p5", "Scenario 5:", value = 10)),
              column(6, numericInput("r5", "", value = 35))
            ),
            hr(),
            valueBoxOutput("prob_total_box", width = 12),
            actionButton("calc_risk", "Calculate Risk Measures", class = "btn-success btn-block")
          ),
          
          box(
            title = "Risk Metrics", 
            status = "success", 
            solidHeader = TRUE,
            width = 6,
            fluidRow(
              valueBoxOutput("exp_ret_box", width = 12),
              valueBoxOutput("variance_box", width = 6),
              valueBoxOutput("std_dev_box", width = 6),
              valueBoxOutput("coef_var_box", width = 12)
            ),
            hr(),
            plotlyOutput("distribution_plot", height = "300px")
          )
        ),
        
        fluidRow(
          box(
            title = "Risk Measure Formulas", 
            status = "warning", 
            solidHeader = TRUE,
            width = 12,
            fluidRow(
              column(6,
                     div(class = "formula-box",
                         h4("Expected Return"),
                         HTML("<p><strong>E(R) = Σ [pᵢ × Rᵢ]</strong></p>"),
                         p("Probability-weighted average return")
                     ),
                     div(class = "formula-box",
                         h4("Variance"),
                         HTML("<p><strong>σ² = Σ [pᵢ × (Rᵢ - E(R))²]</strong></p>"),
                         p("Average squared deviation from expected return"),
                         p("Measures absolute variability"),
                         p(strong(style="color: blue;", "Units: Squared percentage points (%²)")),
                         p(em("Note: Variance is not directly interpretable due to squared units. Use standard deviation for easier interpretation."))
                     )
              ),
              column(6,
                     div(class = "formula-box",
                         h4("Standard Deviation"),
                         HTML("<p><strong>σ = √Variance</strong></p>"),
                         p("Square root of variance"),
                         p("Same units as returns (easier to interpret)")
                     ),
                     div(class = "formula-box",
                         h4("Coefficient of Variation"),
                         HTML("<p><strong>CV = σ / E(R)</strong></p>"),
                         p("Risk per unit of return"),
                         p("Useful for comparing investments with different expected returns")
                     )
              )
            ),
            hr(),
            div(class = "example-box",
                h4("Worked Example: Commercial Bank of Ceylon"),
                HTML("
                <table style='width:100%; border-collapse: collapse;'>
                <tr style='background-color: #e9ecef;'>
                  <th style='border: 1px solid #ddd; padding: 8px;'>Scenario</th>
                  <th style='border: 1px solid #ddd; padding: 8px;'>Probability</th>
                  <th style='border: 1px solid #ddd; padding: 8px;'>Return</th>
                  <th style='border: 1px solid #ddd; padding: 8px;'>p × R</th>
                </tr>
                <tr>
                  <td style='border: 1px solid #ddd; padding: 8px;'>Recession</td>
                  <td style='border: 1px solid #ddd; padding: 8px;'>20%</td>
                  <td style='border: 1px solid #ddd; padding: 8px;'>-10%</td>
                  <td style='border: 1px solid #ddd; padding: 8px;'>-2%</td>
                </tr>
                <tr>
                  <td style='border: 1px solid #ddd; padding: 8px;'>Normal</td>
                  <td style='border: 1px solid #ddd; padding: 8px;'>60%</td>
                  <td style='border: 1px solid #ddd; padding: 8px;'>12%</td>
                  <td style='border: 1px solid #ddd; padding: 8px;'>7.2%</td>
                </tr>
                <tr>
                  <td style='border: 1px solid #ddd; padding: 8px;'>Boom</td>
                  <td style='border: 1px solid #ddd; padding: 8px;'>20%</td>
                  <td style='border: 1px solid #ddd; padding: 8px;'>25%</td>
                  <td style='border: 1px solid #ddd; padding: 8px;'>5%</td>
                </tr>
                <tr style='background-color: #d4edda; font-weight: bold;'>
                  <td style='border: 1px solid #ddd; padding: 8px;'>Total</td>
                  <td style='border: 1px solid #ddd; padding: 8px;'>100%</td>
                  <td style='border: 1px solid #ddd; padding: 8px;'></td>
                  <td style='border: 1px solid #ddd; padding: 8px;'>E(R) = 10.2%</td>
                </tr>
                </table>
                "),
                br(),
                p(strong("Variance Calculation:")),
                p("σ² = 0.20(-10% - 10.2%)² + 0.60(12% - 10.2%)² + 0.20(25% - 10.2%)²"),
                p("σ² = 0.20(408.04) + 0.60(3.24) + 0.20(219.04) = 127.36"),
                p(strong("Standard Deviation:"), " σ = √127.36 = 11.29%"),
                p(strong("Coefficient of Variation:"), " CV = 11.29% / 10.2% = 1.11")
            )
          )
        )
      ),
      
      # Tab 5: Portfolio Returns
      tabItem(
        tabName = "portfolio",
        fluidRow(
          box(
            title = "Portfolio Return Calculations", 
            status = "primary", 
            solidHeader = TRUE,
            width = 12,
            h4("Building Portfolios"),
            p("A portfolio combines multiple assets. Portfolio return is the weighted average of individual asset returns."),
            p("Portfolio risk, however, depends on how assets move together (correlation).")
          )
        ),
        
        fluidRow(
          box(
            title = "Two-Asset Portfolio", 
            status = "info", 
            solidHeader = TRUE,
            width = 6,
            h4("Asset A: John Keells Holdings"),
            sliderInput("weight_a_port", "Weight in Portfolio (%):", 
                       min = 0, max = 100, value = 60, step = 5),
            numericInput("ret_a_port", "Expected Return (%):", value = 15),
            numericInput("sd_a_port", "Standard Deviation (%):", value = 25),
            hr(),
            h4("Asset B: Dialog Axiata"),
            numericInput("ret_b_port", "Expected Return (%):", value = 12),
            numericInput("sd_b_port", "Standard Deviation (%):", value = 20),
            hr(),
            sliderInput("correlation", "Correlation between A and B:", 
                       min = -1, max = 1, value = 0.3, step = 0.1),
            hr(),
            actionButton("calc_portfolio", "Calculate Portfolio Metrics", class = "btn-success btn-block")
          ),
          
          box(
            title = "Portfolio Results", 
            status = "success", 
            solidHeader = TRUE,
            width = 6,
            valueBoxOutput("weight_b_box", width = 12),
            hr(),
            fluidRow(
              valueBoxOutput("port_return_box", width = 6),
              valueBoxOutput("port_risk_box", width = 6)
            ),
            hr(),
            plotlyOutput("portfolio_plot", height = "300px"),
            hr(),
            uiOutput("diversification_benefit")
          )
        ),
        
        fluidRow(
          box(
            title = "Portfolio Formulas", 
            status = "warning", 
            solidHeader = TRUE,
            width = 12,
            fluidRow(
              column(6,
                     div(class = "formula-box",
                         h4("Portfolio Expected Return"),
                         HTML("<p><strong>E(Rp) = wₐE(Rₐ) + wᵦE(Rᵦ)</strong></p>"),
                         p("Where:"),
                         tags$ul(
                           tags$li("wₐ, wᵦ = weights (proportions invested)"),
                           tags$li("E(Rₐ), E(Rᵦ) = expected returns"),
                           tags$li("wₐ + wᵦ = 1 (100%)")
                         ),
                         div(class = "example-box",
                             h5("Example:"),
                             p("60% in Stock A (E(R) = 15%)"),
                             p("40% in Stock B (E(R) = 12%)"),
                             p("E(Rp) = 0.6(15%) + 0.4(12%) = 13.8%")
                         )
                     )
              ),
              column(6,
                     div(class = "formula-box",
                         h4("Portfolio Variance"),
                         HTML("<p><strong>σp² = wₐ²σₐ² + wᵦ²σᵦ² + 2wₐwᵦCov(Rₐ,Rᵦ)</strong></p>"),
                         HTML("<p><strong>σp² = wₐ²σₐ² + wᵦ²σᵦ² + 2wₐwᵦρσₐσᵦ</strong></p>"),
                         p("Where:"),
                         tags$ul(
                           tags$li("σₐ, σᵦ = standard deviations"),
                           tags$li("ρ = correlation coefficient"),
                           tags$li("Cov = covariance = ρσₐσᵦ")
                         ),
                         p(strong("Portfolio Std Dev:"), " σp = √σp²")
                     )
              )
            ),
            hr(),
            div(class = "example-box",
                h4("The Power of Diversification"),
                p(strong("Key Insight:"), " Portfolio risk is NOT simply the weighted average of individual risks!"),
                p("The correlation term allows risk reduction through diversification."),
                HTML("
                <table style='width:100%; border-collapse: collapse; margin-top: 10px;'>
                <tr style='background-color: #e9ecef;'>
                  <th style='border: 1px solid #ddd; padding: 8px;'>Correlation (ρ)</th>
                  <th style='border: 1px solid #ddd; padding: 8px;'>Meaning</th>
                  <th style='border: 1px solid #ddd; padding: 8px;'>Diversification Benefit</th>
                </tr>
                <tr>
                  <td style='border: 1px solid #ddd; padding: 8px;'>+1.0</td>
                  <td style='border: 1px solid #ddd; padding: 8px;'>Perfect positive correlation</td>
                  <td style='border: 1px solid #ddd; padding: 8px;'>None - assets move identically</td>
                </tr>
                <tr>
                  <td style='border: 1px solid #ddd; padding: 8px;'>0.0</td>
                  <td style='border: 1px solid #ddd; padding: 8px;'>No correlation</td>
                  <td style='border: 1px solid #ddd; padding: 8px;'>Moderate - some risk reduction</td>
                </tr>
                <tr>
                  <td style='border: 1px solid #ddd; padding: 8px;'>-1.0</td>
                  <td style='border: 1px solid #ddd; padding: 8px;'>Perfect negative correlation</td>
                  <td style='border: 1px solid #ddd; padding: 8px;'>Maximum - can eliminate risk entirely</td>
                </tr>
                </table>
                ")
            )
          )
        )
      ),
      
      # Tab 6: Why Diversification Works
      tabItem(
        tabName = "diversification",
        fluidRow(
          box(
            title = "Understanding Diversification: The Foundation of Modern Portfolio Theory", 
            status = "primary", 
            solidHeader = TRUE,
            width = 12,
            h4("The Central Insight of Portfolio Theory"),
            p(strong("Key Question:"), " Why does combining assets reduce risk?"),
            div(class = "formula-box",
                h4("The Diversification Principle"),
                p("When assets don't move perfectly together, their ups and downs partially cancel out, reducing overall portfolio volatility."),
                p(strong("Mathematical reason:"), " Portfolio variance includes correlation terms that can reduce total risk below the weighted average of individual risks.")
            )
          )
        ),
        
        fluidRow(
          box(
            title = "Correlation Explorer", 
            status = "info", 
            solidHeader = TRUE,
            width = 6,
            h4("Two-Asset Portfolio: The Impact of Correlation"),
            p("See how correlation affects diversification benefit"),
            hr(),
            numericInput("asset1_return_div", "Asset 1 Expected Return (%):", value = 12, step = 1),
            numericInput("asset1_sd_div", "Asset 1 Std Deviation (%):", value = 20, min = 1, step = 1),
            hr(),
            numericInput("asset2_return_div", "Asset 2 Expected Return (%):", value = 12, step = 1),
            numericInput("asset2_sd_div", "Asset 2 Std Deviation (%):", value = 20, min = 1, step = 1),
            hr(),
            sliderInput("correlation_div", "Correlation (ρ):", 
                       min = -1, max = 1, value = 0.3, step = 0.1),
            p(em("Try different correlations to see the effect!")),
            hr(),
            h5("Equal-Weighted Portfolio (50% each)"),
            actionButton("calc_div_effect", "Calculate Diversification Effect", class = "btn-primary btn-block")
          ),
          
          box(
            title = "Diversification Results", 
            status = "success", 
            solidHeader = TRUE,
            width = 6,
            fluidRow(
              valueBoxOutput("weighted_avg_risk_box", width = 12),
              valueBoxOutput("actual_port_risk_box", width = 12),
              valueBoxOutput("risk_reduction_box", width = 12)
            ),
            hr(),
            plotlyOutput("correlation_effect_plot", height = "300px"),
            hr(),
            uiOutput("correlation_interpretation_div")
          )
        ),
        
        fluidRow(
          box(
            title = "The Diversification Experiment: Adding More Stocks", 
            status = "warning", 
            solidHeader = TRUE,
            width = 12,
            h4("What happens as we add more stocks to the portfolio?"),
            p("This simulation shows how portfolio risk changes as you diversify across multiple stocks."),
            fluidRow(
              column(6,
                     sliderInput("num_stocks_div", "Number of Stocks in Portfolio:", 
                                min = 1, max = 30, value = 1, step = 1),
                     p(strong("Assumptions:")),
                     tags$ul(
                       tags$li("Each stock: E(R) = 12%, σ = 30%"),
                       tags$li("Correlation between any two stocks = 0.3"),
                       tags$li("Equal weights in all stocks"),
                       tags$li("Systematic risk component = 15%")
                     ),
                     actionButton("run_diversification_exp", "Run Experiment", class = "btn-success btn-block")
              ),
              column(6,
                     valueBoxOutput("portfolio_stocks_box", width = 12),
                     valueBoxOutput("portfolio_risk_div_box", width = 12),
                     valueBoxOutput("risk_reduction_pct_box", width = 12)
              )
            ),
            hr(),
            plotlyOutput("diversification_curve", height = "400px")
          )
        ),
        
        fluidRow(
          box(
            title = "Understanding Correlation", 
            status = "info", 
            solidHeader = TRUE,
            width = 12,
            h4("What Does Correlation Mean?"),
            HTML("
            <table style='width:100%; border-collapse: collapse; margin-top: 10px;'>
            <tr style='background-color: #e9ecef;'>
              <th style='border: 1px solid #ddd; padding: 8px;'>Correlation (ρ)</th>
              <th style='border: 1px solid #ddd; padding: 8px;'>Meaning</th>
              <th style='border: 1px solid #ddd; padding: 8px;'>Portfolio Risk</th>
              <th style='border: 1px solid #ddd; padding: 8px;'>Diversification Benefit</th>
            </tr>
            <tr>
              <td style='border: 1px solid #ddd; padding: 8px;'>ρ = +1.0</td>
              <td style='border: 1px solid #ddd; padding: 8px;'>Perfect positive - assets move identically</td>
              <td style='border: 1px solid #ddd; padding: 8px;'>= Weighted average risk</td>
              <td style='border: 1px solid #ddd; padding: 8px; color: red;'><strong>NONE</strong></td>
            </tr>
            <tr>
              <td style='border: 1px solid #ddd; padding: 8px;'>ρ = +0.5</td>
              <td style='border: 1px solid #ddd; padding: 8px;'>Moderate positive - tend to move together</td>
              <td style='border: 1px solid #ddd; padding: 8px;'>< Weighted average risk</td>
              <td style='border: 1px solid #ddd; padding: 8px; color: orange;'><strong>MODERATE</strong></td>
            </tr>
            <tr>
              <td style='border: 1px solid #ddd; padding: 8px;'>ρ = 0.0</td>
              <td style='border: 1px solid #ddd; padding: 8px;'>No correlation - independent movements</td>
              <td style='border: 1px solid #ddd; padding: 8px;'>Much < Weighted average</td>
              <td style='border: 1px solid #ddd; padding: 8px; color: blue;'><strong>GOOD</strong></td>
            </tr>
            <tr>
              <td style='border: 1px solid #ddd; padding: 8px;'>ρ = -0.5</td>
              <td style='border: 1px solid #ddd; padding: 8px;'>Moderate negative - tend to move oppositely</td>
              <td style='border: 1px solid #ddd; padding: 8px;'>Very much < Weighted average</td>
              <td style='border: 1px solid #ddd; padding: 8px; color: green;'><strong>EXCELLENT</strong></td>
            </tr>
            <tr>
              <td style='border: 1px solid #ddd; padding: 8px;'>ρ = -1.0</td>
              <td style='border: 1px solid #ddd; padding: 8px;'>Perfect negative - move in exact opposite</td>
              <td style='border: 1px solid #ddd; padding: 8px;'>Can be reduced to ZERO</td>
              <td style='border: 1px solid #ddd; padding: 8px; color: green;'><strong>MAXIMUM (Rare in reality)</strong></td>
            </tr>
            </table>
            "),
            hr(),
            div(class = "example-box",
                h4("Real-World Correlation Examples (Sri Lankan Market)"),
                tags$ul(
                  tags$li(strong("High Positive Correlation (+0.7 to +0.9):"), " Two banks (e.g., Commercial Bank & Sampath Bank) - affected by same economic factors"),
                  tags$li(strong("Moderate Positive (+0.3 to +0.6):"), " JKH and Dialog - different industries but same economy"),
                  tags$li(strong("Low/Zero Correlation (0 to +0.3):"), " Sri Lankan stocks and international gold - different drivers"),
                  tags$li(strong("Negative Correlation (-0.3 to -0.5):"), " Airline stocks and oil company stocks - fuel costs affect them oppositely")
                )
            )
          )
        ),
        
        fluidRow(
          box(
            title = "Key Takeaways: Why Diversification Works", 
            status = "success", 
            solidHeader = TRUE,
            width = 12,
            h4("Summary of Diversification Principles:"),
            tags$ol(
              tags$li(strong("Not all risk disappears:"), " As you add more stocks, portfolio risk decreases but reaches a limit (the systematic risk floor)"),
              tags$li(strong("Correlation is key:"), " Lower correlation = better diversification. Perfect positive correlation provides no benefit"),
              tags$li(strong("Diminishing returns:"), " The first 10-15 stocks provide most of the diversification benefit. Beyond 20-30 stocks, marginal benefit is minimal"),
              tags$li(strong("The limit exists:"), " You cannot diversify away all risk. The remaining risk (systematic risk) is what we'll explore next")
            ),
            hr(),
            div(class = "formula-box",
                h4("This leads to a critical question:"),
                p(strong(style="font-size: 18px;", "If some risk remains no matter how much we diversify, what IS that risk and why can't it be eliminated?")),
                p("This question leads us to the distinction between Systematic and Unsystematic Risk...")
            )
          )
        )
      ),
      
      # Tab 7: Systematic vs Unsystematic Risk
      tabItem(
        tabName = "systematic_risk",
        fluidRow(
          box(
            title = "The Two Types of Risk: A Critical Distinction", 
            status = "primary", 
            solidHeader = TRUE,
            width = 12,
            h4("Understanding Why Some Risk Cannot Be Diversified Away"),
            p("In the previous module, we saw that diversification reduces risk but reaches a limit. Now we understand WHY that limit exists."),
            div(class = "formula-box",
                h4("The Fundamental Insight"),
                p(strong("Total Risk = Systematic Risk + Unsystematic Risk")),
                p("Diversification can eliminate unsystematic risk but NOT systematic risk.")
            )
          )
        ),
        
        fluidRow(
          box(
            title = "Critical Distinction: Two Types of Risk", 
            status = "warning", 
            solidHeader = TRUE,
            width = 12,
            HTML("
            <table style='width:100%; border-collapse: collapse; margin-top: 10px;'>
            <tr style='background-color: #e9ecef;'>
              <th style='border: 1px solid #ddd; padding: 8px;'>Characteristic</th>
              <th style='border: 1px solid #ddd; padding: 8px;'>Systematic Risk</th>
              <th style='border: 1px solid #ddd; padding: 8px;'>Unsystematic Risk</th>
            </tr>
            <tr>
              <td style='border: 1px solid #ddd; padding: 8px;'><strong>Also Called</strong></td>
              <td style='border: 1px solid #ddd; padding: 8px;'>Market risk, Non-diversifiable risk</td>
              <td style='border: 1px solid #ddd; padding: 8px;'>Specific risk, Diversifiable risk, Idiosyncratic risk</td>
            </tr>
            <tr>
              <td style='border: 1px solid #ddd; padding: 8px;'><strong>Source</strong></td>
              <td style='border: 1px solid #ddd; padding: 8px;'>Economy-wide factors affecting all companies</td>
              <td style='border: 1px solid #ddd; padding: 8px;'>Company-specific or industry-specific events</td>
            </tr>
            <tr>
              <td style='border: 1px solid #ddd; padding: 8px;'><strong>Examples</strong></td>
              <td style='border: 1px solid #ddd; padding: 8px;'>Interest rate changes, inflation, recession, war, political instability, exchange rates</td>
              <td style='border: 1px solid #ddd; padding: 8px;'>Management changes, strikes, product failures, lawsuits, competitor actions, supply disruptions</td>
            </tr>
            <tr>
              <td style='border: 1px solid #ddd; padding: 8px;'><strong>Can Be Eliminated?</strong></td>
              <td style='border: 1px solid #ddd; padding: 8px; background-color: #ffcdd2;'><strong>❌ NO</strong> - Affects entire market</td>
              <td style='border: 1px solid #ddd; padding: 8px; background-color: #c8e6c9;'><strong>✅ YES</strong> - Through diversification</td>
            </tr>
            <tr>
              <td style='border: 1px solid #ddd; padding: 8px;'><strong>Measured By</strong></td>
              <td style='border: 1px solid #ddd; padding: 8px;'>Beta (β)</td>
              <td style='border: 1px solid #ddd; padding: 8px;'>Stock variance minus systematic component</td>
            </tr>
            <tr>
              <td style='border: 1px solid #ddd; padding: 8px;'><strong>Compensated in Returns?</strong></td>
              <td style='border: 1px solid #ddd; padding: 8px; background-color: #c8e6c9;'><strong>✅ YES</strong> - Via CAPM risk premium</td>
              <td style='border: 1px solid #ddd; padding: 8px; background-color: #ffcdd2;'><strong>❌ NO</strong> - Investors can diversify it away</td>
            </tr>
            <tr>
              <td style='border: 1px solid #ddd; padding: 8px;'><strong>Portfolio Impact</strong></td>
              <td style='border: 1px solid #ddd; padding: 8px;'>Remains constant regardless of diversification</td>
              <td style='border: 1px solid #ddd; padding: 8px;'>Decreases as more stocks are added</td>
            </tr>
            </table>
            ")
          )
        ),
        
        fluidRow(
          box(
            title = "Risk Decomposition Calculator", 
            status = "info", 
            solidHeader = TRUE,
            width = 6,
            h4("Decompose a Stock's Total Risk"),
            p("Calculate how much of a stock's risk is systematic vs unsystematic"),
            hr(),
            selectInput("stock_example_sys", "Select Company or Custom:",
                       choices = c("Custom", "Dialog Axiata", "John Keells", "Commercial Bank", "Hemas Holdings")),
            numericInput("stock_sd_sys", "Stock Standard Deviation (%):", value = 25, min = 0, step = 1),
            numericInput("stock_beta_sys", "Stock Beta (β):", value = 1.15, min = -2, max = 3, step = 0.05),
            numericInput("market_sd_sys", "Market Standard Deviation (%):", value = 18, min = 0, step = 1),
            hr(),
            actionButton("calc_decomp", "Decompose Risk", class = "btn-primary btn-block")
          ),
          
          box(
            title = "Risk Decomposition Results", 
            status = "success", 
            solidHeader = TRUE,
            width = 6,
            fluidRow(
              valueBoxOutput("total_variance_box", width = 12),
              valueBoxOutput("systematic_variance_box", width = 6),
              valueBoxOutput("unsystematic_variance_box", width = 6),
              valueBoxOutput("pct_systematic_box", width = 6),
              valueBoxOutput("pct_unsystematic_box", width = 6)
            ),
            hr(),
            plotlyOutput("risk_decomp_plot", height = "250px")
          )
        ),
        
        fluidRow(
          box(
            title = "Visualizing Risk Reduction Through Diversification", 
            status = "warning", 
            solidHeader = TRUE,
            width = 12,
            h4("The Systematic Risk Floor"),
            p("This simulation shows how total risk, systematic risk, and unsystematic risk change as you add stocks."),
            fluidRow(
              column(4,
                     sliderInput("n_stocks_sys", "Number of Stocks:", 
                                min = 1, max = 50, value = 1, step = 1),
                     actionButton("show_decomp", "Show Risk Components", class = "btn-success btn-block"),
                     hr(),
                     valueBoxOutput("total_risk_sys_box", width = 12),
                     valueBoxOutput("systematic_component_box", width = 12),
                     valueBoxOutput("unsystematic_component_box", width = 12)
              ),
              column(8,
                     plotlyOutput("systematic_unsystematic_plot", height = "400px")
              )
            )
          )
        ),
        
        fluidRow(
          box(
            title = "Sri Lankan Market Examples", 
            status = "info", 
            solidHeader = TRUE,
            width = 6,
            h4("Systematic Risk Examples (Market-Wide Events)"),
            tags$ul(
              tags$li(strong("2022 Economic Crisis:"), " Affected ALL Sri Lankan stocks - currency collapse, sovereign default, fuel shortage"),
              tags$li(strong("COVID-19 Pandemic (2020):"), " Tourism, retail, manufacturing all hit simultaneously"),
              tags$li(strong("Interest Rate Changes by CBSL:"), " Impacts all companies' cost of capital"),
              tags$li(strong("Political Instability (2022):"), " Market-wide uncertainty affects all sectors"),
              tags$li(strong("GST/Tax Policy Changes:"), " Broad impact across industries")
            ),
            p(strong(style="color: red;", "⚠️ Cannot be eliminated through diversification within Sri Lanka"))
          ),
          
          box(
            title = "Sri Lankan Market Examples", 
            status = "success", 
            solidHeader = TRUE,
            width = 6,
            h4("Unsystematic Risk Examples (Company-Specific Events)"),
            tags$ul(
              tags$li(strong("Dialog Axiata:"), " Regulatory approval for spectrum license - affects only Dialog"),
              tags$li(strong("John Keells Hotels:"), " Opening of new Cinnamon property - company-specific"),
              tags$li(strong("Commercial Bank:"), " Non-performing loan provisions - bank-specific"),
              tags$li(strong("Hemas:"), " Supply chain disruption for pharmaceuticals - company-specific"),
              tags$li(strong("Any Company:"), " Management scandal, product recall, factory fire")
            ),
            p(strong(style="color: green;", "✅ Can be eliminated by holding a diversified portfolio"))
          )
        ),
        
        fluidRow(
          box(
            title = "Mathematical Foundation: Risk Decomposition Formula", 
            status = "warning", 
            solidHeader = TRUE,
            width = 12,
            div(class = "formula-box",
                h4("Total Risk Decomposition"),
                HTML("<p style='font-size: 16px;'><strong>Total Variance = Systematic Variance + Unsystematic Variance</strong></p>"),
                HTML("<p style='font-size: 16px;'><strong>σ²ᵢ = β²ᵢ × σ²ₘ + σ²ₑᵢ</strong></p>"),
                p("Where:"),
                tags$ul(
                  tags$li("σ²ᵢ = Total variance of stock i"),
                  tags$li("β²ᵢ × σ²ₘ = Systematic variance (market-related)"),
                  tags$li("σ²ₑᵢ = Unsystematic variance (firm-specific)")
                ),
                hr(),
                HTML("<p style='font-size: 16px;'><strong>Percentage Calculations:</strong></p>"),
                HTML("<p><strong>% Systematic = (β²ᵢ × σ²ₘ) / σ²ᵢ × 100%</strong></p>"),
                HTML("<p><strong>% Unsystematic = 100% - % Systematic</strong></p>")
            ),
            hr(),
            div(class = "example-box",
                h4("Worked Example: Dialog Axiata"),
                p(strong("Given:")),
                tags$ul(
                  tags$li("Stock σ = 25%"),
                  tags$li("Beta (β) = 1.15"),
                  tags$li("Market σₘ = 18%")
                ),
                p(strong("Solution:")),
                p("Total variance = (25)² = 625 %²"),
                p("Systematic variance = (1.15)² × (18)² = 1.3225 × 324 = 428.5 %²"),
                p("Unsystematic variance = 625 - 428.5 = 196.5 %²"),
                p("% Systematic = (428.5 / 625) × 100% = 68.6%"),
                p("% Unsystematic = 31.4%"),
                hr(),
                p(strong("Interpretation:")),
                p("Dialog's risk is 68.6% driven by market movements (systematic) and 31.4% driven by company-specific factors (unsystematic)."),
                p("An investor holding only Dialog faces both risks. An investor with a diversified portfolio eliminates the 31.4% unsystematic component.")
            )
          )
        ),
        
        fluidRow(
          box(
            title = "Why This Matters: Three Perspectives", 
            status = "primary", 
            solidHeader = TRUE,
            width = 12,
            HTML("
            <table style='width:100%; border-collapse: collapse; margin-top: 10px;'>
            <tr style='background-color: #e9ecef;'>
              <th style='border: 1px solid #ddd; padding: 8px;'>Perspective</th>
              <th style='border: 1px solid #ddd; padding: 8px;'>Key Implication</th>
            </tr>
            <tr>
              <td style='border: 1px solid #ddd; padding: 8px;'><strong>Investor (Portfolio Manager)</strong></td>
              <td style='border: 1px solid #ddd; padding: 8px;'>Only systematic risk matters for expected returns. Don't expect extra return for bearing unsystematic risk - just diversify it away! This is why CAPM only prices beta (systematic risk).</td>
            </tr>
            <tr>
              <td style='border: 1px solid #ddd; padding: 8px;'><strong>Corporate Manager (CIMA View)</strong></td>
              <td style='border: 1px solid #ddd; padding: 8px;'>Even though investors can diversify unsystematic risk, managers must STILL manage it through operational controls, hedging, and risk mitigation. A product failure still hurts the company even if investors are diversified.</td>
            </tr>
            <tr>
              <td style='border: 1px solid #ddd; padding: 8px;'><strong>Financial Analyst (Valuation)</strong></td>
              <td style='border: 1px solid #ddd; padding: 8px;'>When calculating required return (discount rate), only use systematic risk (beta). Unsystematic risk should not increase the required return because rational investors hold diversified portfolios.</td>
            </tr>
            </table>
            "),
            hr(),
            div(class = "formula-box",
                h4("This Leads Directly to CAPM"),
                p(strong("Now we understand WHY the Capital Asset Pricing Model uses only beta (systematic risk):")),
                tags$ol(
                  tags$li("Rational investors hold diversified portfolios"),
                  tags$li("Diversification eliminates unsystematic risk"),
                  tags$li("Therefore, investors only require compensation for systematic risk"),
                  tags$li("Beta measures systematic risk"),
                  tags$li("CAPM equation: E(R) = Rf + β[E(Rm) - Rf]")
                ),
                p("In the next modules, we'll see how to build optimal portfolios and apply CAPM for valuation.")
            )
          )
        )
      ),
      
      # Tab 8: Efficient Frontier & Capital Market Line
      tabItem(
        tabName = "efficient_frontier",
        fluidRow(
          box(
            title = "Modern Portfolio Theory: From Efficient Frontier to Capital Market Line", 
            status = "primary", 
            solidHeader = TRUE,
            width = 12,
            h4("Complete Portfolio Optimization Framework"),
            p("This module demonstrates the complete Markowitz portfolio theory and its extension to the Capital Market Line."),
            div(class = "formula-box",
                h4("Learning Progression"),
                tags$ol(
                  tags$li(strong("Feasible Set:"), " All possible portfolio combinations"),
                  tags$li(strong("Efficient Frontier:"), " Best risk-return combinations"),
                  tags$li(strong("Capital Market Line:"), " Optimal allocation with risk-free asset"),
                  tags$li(strong("Investor Choice:"), " Selecting based on risk tolerance")
                )
            )
          )
        ),
        
        # SECTION 1: Asset Inputs (Foundation)
        fluidRow(
          box(
            title = "Section 1: Asset Parameters (Foundation)", 
            status = "info", 
            solidHeader = TRUE,
            width = 12,
            h4("Define Your Investment Universe"),
            p("All portfolios are combinations of these risky assets. Diversification benefit comes from correlation, not returns."),
            hr(),
            
            fluidRow(
              column(3,
                h5("Asset A (e.g., John Keells)"),
                numericInput("asset_a_ret_ef", "Expected Return (%):", value = 12, step = 1),
                numericInput("asset_a_sd_ef", "Standard Deviation (%):", value = 20, min = 1, step = 1)
              ),
              column(3,
                h5("Asset B (e.g., Dialog)"),
                numericInput("asset_b_ret_ef", "Expected Return (%):", value = 15, step = 1),
                numericInput("asset_b_sd_ef", "Standard Deviation (%):", value = 25, min = 1, step = 1)
              ),
              column(3,
                h5("Asset C (e.g., Commercial Bank)"),
                numericInput("asset_c_ret_ef", "Expected Return (%):", value = 10, step = 1),
                numericInput("asset_c_sd_ef", "Standard Deviation (%):", value = 15, min = 1, step = 1)
              ),
              column(3,
                h5("Correlations & Risk-Free Rate"),
                sliderInput("avg_correlation_ef", "Avg Correlation:", 
                           min = 0, max = 0.9, value = 0.3, step = 0.05),
                numericInput("rf_ef", "Risk-Free Rate (%):", value = 5, min = 0, max = 10, step = 0.5),
                hr(),
                actionButton("generate_frontier", "Generate Analysis", 
                            class = "btn-success btn-block", icon = icon("chart-area"))
              )
            )
          )
        ),
        
        # SECTION 2 & 3: Feasible Set + Efficient Frontier + CML (Combined Visual)
        fluidRow(
          box(
            title = "Section 2-4: Portfolio Visualization - Feasible Set → Efficient Frontier → Capital Market Line", 
            status = "success", 
            solidHeader = TRUE,
            width = 12,
            
            tabsetPanel(
              id = "ef_visualization_tabs",
              
              # Sub-tab: Feasible Set
              tabPanel("2. Feasible Set",
                       br(),
                       div(class = "formula-box",
                           h4("Concept: The Feasible Set"),
                           p(strong("All possible portfolios from these assets are shown as gray dots.")),
                           p("Question to consider: ", em("Why would anyone choose a portfolio deep inside this cloud?"))
                       ),
                       plotlyOutput("feasible_set_plot", height = "500px"),
                       hr(),
                       div(class = "example-box",
                           h4("Key Insights:"),
                           tags$ul(
                             tags$li("Each dot = a different portfolio combination"),
                             tags$li("Lower correlation → Wider feasible set"),
                             tags$li("Some portfolios offer poor risk-return tradeoffs")
                           )
                       )
              ),
              
              # Sub-tab: Efficient Frontier
              tabPanel("3. Efficient Frontier",
                       br(),
                       div(class = "formula-box",
                           h4("Definition: Efficient Frontier"),
                           p(strong("The efficient frontier consists of portfolios offering the highest expected return for each level of risk.")),
                           p(em("Efficient ≠ Highest return")),
                           p(em("Efficient = Best return FOR A GIVEN RISK"))
                       ),
                       plotlyOutput("efficient_frontier_plot", height = "500px"),
                       hr(),
                       fluidRow(
                         column(6,
                           div(class = "example-box",
                               h4("Dominated Portfolios:"),
                               p("Portfolios below the frontier are ", strong("dominated"), " - you can achieve:"),
                               tags$ul(
                                 tags$li("Higher return for same risk, OR"),
                                 tags$li("Same return with lower risk")
                               ),
                               p(strong(style="color: red;", "Rational investors avoid dominated portfolios."))
                           )
                         ),
                         column(6,
                           div(class = "example-box",
                               h4("Minimum Variance Portfolio:"),
                               p("The leftmost point on the frontier."),
                               p("Offers the ", strong("lowest possible risk"), " from these assets."),
                               p("Not necessarily optimal - depends on risk tolerance.")
                           )
                         )
                       ),
                       hr(),
                       uiOutput("frontier_explanation")
              ),
              
              # Sub-tab: Capital Market Line
              tabPanel("4. Capital Market Line (CML)",
                       br(),
                       div(class = "formula-box",
                           h4("The Capital Market Line"),
                           p(strong("When a risk-free asset is available, investors can achieve better risk-return combinations.")),
                           HTML("<p style='font-size: 16px;'><strong>CML Equation: E(Rp) = Rf + [(E(Rm)-Rf)/σm] × σp</strong></p>"),
                           p("The CML is the line from Rf tangent to the efficient frontier."),
                           p(strong("Key Result:"), " Any point on the CML dominates the efficient frontier (except at tangency).")
                       ),
                       plotlyOutput("cml_plot", height = "500px"),
                       hr(),
                       div(class = "example-box",
                           h4("Tobin's Separation Theorem:"),
                           p(strong("All investors, regardless of risk preferences, should:")),
                           tags$ol(
                             tags$li("Hold the SAME risky portfolio (the tangency/market portfolio)"),
                             tags$li("Adjust risk by varying the mix between risk-free asset and market portfolio")
                           ),
                           p(strong("Implication:"), " Investment decision is separated from financing decision.")
                       ),
                       hr(),
                       fluidRow(
                         valueBoxOutput("tangency_return_box", width = 4),
                         valueBoxOutput("tangency_risk_box", width = 4),
                         valueBoxOutput("cml_slope_box", width = 4)
                       )
              )
            )
          )
        ),
        
        # SECTION 5: Portfolio Choice & Investor Preferences
        fluidRow(
          box(
            title = "Section 5: Investor Preferences & Portfolio Choice", 
            status = "warning", 
            solidHeader = TRUE,
            width = 12,
            h4("Select Optimal Portfolio Based on Risk Tolerance"),
            
            fluidRow(
              column(6,
                sliderInput("risk_tolerance_ef", "Your Risk Tolerance (Target Portfolio Risk %):", 
                           min = 0, max = 40, value = 15, step = 1),
                p(em("Conservative investors: < 10%")),
                p(em("Moderate investors: 10-20%")),
                p(em("Aggressive investors: > 20%")),
                hr(),
                actionButton("find_optimal", "Find My Optimal Portfolio", class = "btn-primary btn-block")
              ),
              
              column(6,
                h4("Your Optimal Portfolio:"),
                valueBoxOutput("optimal_return_box", width = 12),
                valueBoxOutput("optimal_risk_box", width = 12),
                uiOutput("optimal_allocation_type")
              )
            ),
            
            hr(),
            
            h4("Investor Types on the CML:"),
            HTML("
            <table style='width:100%; border-collapse: collapse; margin-top: 10px;'>
            <tr style='background-color: #e9ecef;'>
              <th style='border: 1px solid #ddd; padding: 8px;'>Investor Type</th>
              <th style='border: 1px solid #ddd; padding: 8px;'>Risk Level</th>
              <th style='border: 1px solid #ddd; padding: 8px;'>Strategy</th>
              <th style='border: 1px solid #ddd; padding: 8px;'>Portfolio Composition</th>
            </tr>
            <tr>
              <td style='border: 1px solid #ddd; padding: 8px;'><strong>Conservative (Lender)</strong></td>
              <td style='border: 1px solid #ddd; padding: 8px;'>σp < σm</td>
              <td style='border: 1px solid #ddd; padding: 8px;'>Invest in both risk-free asset and market portfolio</td>
              <td style='border: 1px solid #ddd; padding: 8px;'>e.g., 60% T-bills + 40% Market</td>
            </tr>
            <tr>
              <td style='border: 1px solid #ddd; padding: 8px;'><strong>Moderate</strong></td>
              <td style='border: 1px solid #ddd; padding: 8px;'>σp = σm</td>
              <td style='border: 1px solid #ddd; padding: 8px;'>Hold 100% market portfolio</td>
              <td style='border: 1px solid #ddd; padding: 8px;'>100% Market Portfolio</td>
            </tr>
            <tr>
              <td style='border: 1px solid #ddd; padding: 8px;'><strong>Aggressive (Borrower)</strong></td>
              <td style='border: 1px solid #ddd; padding: 8px;'>σp > σm</td>
              <td style='border: 1px solid #ddd; padding: 8px;'>Borrow at risk-free rate and invest in market</td>
              <td style='border: 1px solid #ddd; padding: 8px;'>e.g., 150% Market (50% borrowed)</td>
            </tr>
            </table>
            ")
          )
        ),
        
        # CRITICAL DISTINCTION: CML vs SML
        fluidRow(
          box(
            title = "Critical Distinction: Capital Market Line (CML) vs Security Market Line (SML)", 
            status = "danger", 
            solidHeader = TRUE,
            width = 12,
            
            div(class = "formula-box",
                h4("⚠️ DO NOT CONFUSE CML WITH SML"),
                p(strong("They answer different questions and use different risk measures."))
            ),
            
            HTML("
            <table style='width:100%; border-collapse: collapse; margin-top: 10px;'>
            <tr style='background-color: #e9ecef;'>
              <th style='border: 1px solid #ddd; padding: 10px;'>Feature</th>
              <th style='border: 1px solid #ddd; padding: 10px;'>Capital Market Line (CML)</th>
              <th style='border: 1px solid #ddd; padding: 10px;'>Security Market Line (SML)</th>
            </tr>
            <tr>
              <td style='border: 1px solid #ddd; padding: 10px;'><strong>Risk Measure</strong></td>
              <td style='border: 1px solid #ddd; padding: 10px;'>Total risk (σ - Standard Deviation)</td>
              <td style='border: 1px solid #ddd; padding: 10px;'>Systematic risk (β - Beta)</td>
            </tr>
            <tr>
              <td style='border: 1px solid #ddd; padding: 10px;'><strong>Applies To</strong></td>
              <td style='border: 1px solid #ddd; padding: 10px;'><strong>Efficient portfolios ONLY</strong></td>
              <td style='border: 1px solid #ddd; padding: 10px;'><strong>ALL assets and portfolios</strong></td>
            </tr>
            <tr>
              <td style='border: 1px solid #ddd; padding: 10px;'><strong>Risk-Free Asset</strong></td>
              <td style='border: 1px solid #ddd; padding: 10px;'>✅ Explicit (shown on chart)</td>
              <td style='border: 1px solid #ddd; padding: 10px;'>Implicit (at β=0)</td>
            </tr>
            <tr>
              <td style='border: 1px solid #ddd; padding: 10px;'><strong>Equation</strong></td>
              <td style='border: 1px solid #ddd; padding: 10px;'>E(Rp) = Rf + [(E(Rm)-Rf)/σm] × σp</td>
              <td style='border: 1px solid #ddd; padding: 10px;'>E(Ri) = Rf + βi[E(Rm)-Rf]</td>
            </tr>
            <tr>
              <td style='border: 1px solid #ddd; padding: 10px;'><strong>Slope</strong></td>
              <td style='border: 1px solid #ddd; padding: 10px;'>Sharpe ratio of market portfolio</td>
              <td style='border: 1px solid #ddd; padding: 10px;'>Market risk premium</td>
            </tr>
            <tr>
              <td style='border: 1px solid #ddd; padding: 10px;'><strong>Used For</strong></td>
              <td style='border: 1px solid #ddd; padding: 10px;'><strong>Portfolio allocation decision</strong><br>(How much risk to take?)</td>
              <td style='border: 1px solid #ddd; padding: 10px;'><strong>Asset pricing/valuation</strong><br>(What return to expect?)</td>
            </tr>
            <tr>
              <td style='border: 1px solid #ddd; padding: 10px;'><strong>Who Uses It?</strong></td>
              <td style='border: 1px solid #ddd; padding: 10px;'>Investors choosing risk level</td>
              <td style='border: 1px solid #ddd; padding: 10px;'>Analysts pricing securities</td>
            </tr>
            <tr>
              <td style='border: 1px solid #ddd; padding: 10px;'><strong>Key Question</strong></td>
              <td style='border: 1px solid #ddd; padding: 10px;'>How should I allocate my wealth?</td>
              <td style='border: 1px solid #ddd; padding: 10px;'>What return should this asset provide?</td>
            </tr>
            </table>
            "),
            
            hr(),
            
            div(class = "example-box",
                h4("Common Student Misconception:"),
                p(strong(style="color: red;", "❌ WRONG:"), " \"Individual stocks plot on the CML.\""),
                p(strong(style="color: green;", "✅ CORRECT:"), " \"Individual stocks plot BELOW the CML because they contain unsystematic risk. Only EFFICIENT portfolios (diversified) plot on the CML.\"")
            )
          )
        ),
        
        # CIMA Perspective
        fluidRow(
          box(
            title = "Managerial Perspective (CIMA Insight)", 
            status = "info", 
            solidHeader = TRUE,
            width = 12,
            h4("Capital Markets vs Corporate Management"),
            div(class = "example-box",
                p(strong("Investor Perspective:"), " Diversification eliminates unsystematic risk, so investors only require compensation for systematic risk (beta)."),
                p(strong("Corporate Manager Perspective:"), " Even though investors can diversify, managers must STILL manage unsystematic risk through:"),
                tags$ul(
                  tags$li("Operational controls and risk management"),
                  tags$li("Hedging strategies"),
                  tags$li("Quality control and supply chain management"),
                  tags$li("Strategic planning")
                ),
                p(strong("Key Insight:"), " A product failure or lawsuit still hurts the company even if investors are diversified.")
            )
          )
        ),
        
        # Test Your Understanding
        fluidRow(
          box(
            title = "Test Your Portfolio", 
            status = "warning", 
            solidHeader = TRUE,
            width = 6,
            h4("Build a Custom Portfolio"),
            p("Allocate weights across the three assets (must sum to 100%)"),
            sliderInput("weight_a_ef", "Weight in Asset A (%):", 
                       min = 0, max = 100, value = 33, step = 1),
            sliderInput("weight_b_ef", "Weight in Asset B (%):", 
                       min = 0, max = 100, value = 33, step = 1),
            sliderInput("weight_c_ef", "Weight in Asset C (%):", 
                       min = 0, max = 100, value = 34, step = 1),
            hr(),
            valueBoxOutput("total_weight_ef_box", width = 12),
            actionButton("evaluate_portfolio", "Evaluate My Portfolio", 
                        class = "btn-primary btn-block")
          ),
          
          box(
            title = "Portfolio Evaluation", 
            status = "success", 
            solidHeader = TRUE,
            width = 6,
            fluidRow(
              valueBoxOutput("my_port_return_box", width = 6),
              valueBoxOutput("my_port_risk_box", width = 6)
            ),
            hr(),
            uiOutput("efficiency_verdict"),
            hr(),
            uiOutput("improvement_suggestion")
          )
        )
      ),
      
      # Tab 10: CAPM and Beta
      tabItem(
        tabName = "capm",
        fluidRow(
          box(
            title = "Capital Asset Pricing Model (CAPM): From Market Portfolio to Asset Pricing", 
            status = "primary", 
            solidHeader = TRUE,
            width = 12,
            h4("Pricing Individual Assets Based on Systematic Risk"),
            p("Building on the CML, CAPM determines the required return on an asset based on its systematic risk (beta)."),
            div(class = "formula-box",
                h4("From CML to CAPM"),
                p(strong("CML showed:"), " Everyone holds the market portfolio (Tobin's Separation)"),
                p(strong("CAPM asks:"), " What return should individual assets provide?"),
                p(strong("Answer:"), " Returns depend on contribution to MARKET PORTFOLIO risk = BETA (β)")
            ),
            p(strong("Key Insight:"), " Only systematic risk (market risk) is rewarded. Unsystematic risk can be diversified away.")
          )
        ),
        
        fluidRow(
          box(
            title = "CAPM Calculator", 
            status = "info", 
            solidHeader = TRUE,
            width = 6,
            h4("Market Parameters"),
            numericInput("rf_capm", "Risk-Free Rate (%):", value = 5, step = 0.1),
            numericInput("rm_capm", "Market Return (%):", value = 12, step = 0.1),
            hr(),
            h4("Stock Parameters"),
            numericInput("beta_capm", "Beta (β):", value = 1.2, step = 0.1),
            hr(),
            h4("Quick Load: Sri Lankan Companies"),
            fluidRow(
              column(6, actionButton("load_jkh_beta", "John Keells (β=0.85)", class = "btn-info btn-sm btn-block")),
              column(6, actionButton("load_dialog_beta", "Dialog (β=1.15)", class = "btn-info btn-sm btn-block"))
            ),
            fluidRow(
              column(6, actionButton("load_cse_beta", "Com. Bank (β=0.95)", class = "btn-info btn-sm btn-block")),
              column(6, actionButton("load_hemas_beta", "Hemas (β=1.30)", class = "btn-info btn-sm btn-block"))
            ),
            hr(),
            actionButton("calc_capm_btn", "Calculate Required Return", class = "btn-success btn-block")
          ),
          
          box(
            title = "CAPM Results", 
            status = "success", 
            solidHeader = TRUE,
            width = 6,
            fluidRow(
              valueBoxOutput("req_return_box", width = 12),
              valueBoxOutput("market_premium_box", width = 6),
              valueBoxOutput("stock_premium_box", width = 6)
            ),
            hr(),
            plotlyOutput("sml_plot", height = "300px"),
            hr(),
            uiOutput("beta_interpretation")
          )
        ),
        
        fluidRow(
          box(
            title = "CAPM Formula and Interpretation", 
            status = "warning", 
            solidHeader = TRUE,
            width = 12,
            div(class = "formula-box",
                h4("CAPM Formula:"),
                HTML("<p style='font-size: 18px;'><strong>E(Rᵢ) = Rf + βᵢ[E(Rm) - Rf]</strong></p>"),
                p("Where:"),
                tags$ul(
                  tags$li("E(Rᵢ) = Required return on asset i"),
                  tags$li("Rf = Risk-free rate"),
                  tags$li("βᵢ = Beta of asset i (systematic risk)"),
                  tags$li("E(Rm) = Expected market return"),
                  tags$li("[E(Rm) - Rf] = Market risk premium")
                )
            ),
            hr(),
            fluidRow(
              column(6,
                     div(class = "example-box",
                         h4("Understanding Beta (β)"),
                         HTML("
                         <table style='width:100%; border-collapse: collapse;'>
                         <tr style='background-color: #e9ecef;'>
                           <th style='border: 1px solid #ddd; padding: 8px;'>Beta Value</th>
                           <th style='border: 1px solid #ddd; padding: 8px;'>Interpretation</th>
                           <th style='border: 1px solid #ddd; padding: 8px;'>Risk Level</th>
                         </tr>
                         <tr>
                           <td style='border: 1px solid #ddd; padding: 8px;'>β < 0</td>
                           <td style='border: 1px solid #ddd; padding: 8px;'>Moves opposite to market</td>
                           <td style='border: 1px solid #ddd; padding: 8px;'>Hedge asset (rare)</td>
                         </tr>
                         <tr>
                           <td style='border: 1px solid #ddd; padding: 8px;'>β = 0</td>
                           <td style='border: 1px solid #ddd; padding: 8px;'>No correlation with market</td>
                           <td style='border: 1px solid #ddd; padding: 8px;'>Risk-free asset</td>
                         </tr>
                         <tr>
                           <td style='border: 1px solid #ddd; padding: 8px;'>0 < β < 1</td>
                           <td style='border: 1px solid #ddd; padding: 8px;'>Less volatile than market</td>
                           <td style='border: 1px solid #ddd; padding: 8px;'>Defensive stock</td>
                         </tr>
                         <tr>
                           <td style='border: 1px solid #ddd; padding: 8px;'>β = 1</td>
                           <td style='border: 1px solid #ddd; padding: 8px;'>Moves with market</td>
                           <td style='border: 1px solid #ddd; padding: 8px;'>Market-level risk</td>
                         </tr>
                         <tr>
                           <td style='border: 1px solid #ddd; padding: 8px;'>β > 1</td>
                           <td style='border: 1px solid #ddd; padding: 8px;'>More volatile than market</td>
                           <td style='border: 1px solid #ddd; padding: 8px;'>Aggressive stock</td>
                         </tr>
                         </table>
                         ")
                     )
              ),
              column(6,
                     div(class = "example-box",
                         h4("Worked Example: Dialog Axiata"),
                         p(strong("Given:")),
                         tags$ul(
                           tags$li("Risk-free rate (Rf) = 5%"),
                           tags$li("Market return (Rm) = 12%"),
                           tags$li("Dialog's Beta (β) = 1.15")
                         ),
                         p(strong("Solution:")),
                         p("Market Risk Premium = 12% - 5% = 7%"),
                         p("Required Return = 5% + 1.15(7%)"),
                         p("Required Return = 5% + 8.05% = 13.05%"),
                         hr(),
                         p(strong("Interpretation:")),
                         p("Dialog is 15% more volatile than the market (β = 1.15), so investors require 13.05% return to compensate for this systematic risk.")
                     )
              )
            )
          )
        )
      ),
      
      # Tab 11: Risk-Adjusted Performance (moved from old Tab 6/7)
      tabItem(
        tabName = "risk",
        fluidRow(
          box(
            title = "Comprehensive Risk Analysis", 
            status = "primary", 
            solidHeader = TRUE,
            width = 12,
            h4("Beyond Standard Deviation: Additional Risk Measures"),
            p("While standard deviation is the most common risk measure, investors also consider:"),
            tags$ul(
              tags$li(strong("Range:"), " Difference between best and worst outcomes"),
              tags$li(strong("Semi-Variance:"), " Variance of returns below the mean (downside risk only)"),
              tags$li(strong("Value at Risk (VaR):"), " Maximum expected loss at a confidence level"),
              tags$li(strong("Beta:"), " Systematic risk relative to the market")
            )
          )
        ),
        
        fluidRow(
          box(
            title = "Investment Comparison", 
            status = "info", 
            solidHeader = TRUE,
            width = 6,
            h4("Investment A"),
            numericInput("inv_a_return", "Expected Return (%):", value = 12),
            numericInput("inv_a_sd", "Standard Deviation (%):", value = 20),
            numericInput("inv_a_min", "Minimum Possible Return (%):", value = -15),
            numericInput("inv_a_max", "Maximum Possible Return (%):", value = 35),
            hr(),
            h4("Investment B"),
            numericInput("inv_b_return", "Expected Return (%):", value = 10),
            numericInput("inv_b_sd", "Standard Deviation (%):", value = 12),
            numericInput("inv_b_min", "Minimum Possible Return (%):", value = -5),
            numericInput("inv_b_max", "Maximum Possible Return (%):", value = 22),
            hr(),
            numericInput("risk_free_rate", "Risk-Free Rate (%):", value = 5),
            actionButton("compare_risk", "Compare Investments", class = "btn-primary btn-block")
          ),
          
          box(
            title = "Risk Comparison Results", 
            status = "success", 
            solidHeader = TRUE,
            width = 6,
            h4("Investment A Metrics"),
            fluidRow(
              valueBoxOutput("cv_a_box", width = 6),
              valueBoxOutput("sharpe_a_box", width = 6),
              valueBoxOutput("range_a_box", width = 12)
            ),
            hr(),
            h4("Investment B Metrics"),
            fluidRow(
              valueBoxOutput("cv_b_box", width = 6),
              valueBoxOutput("sharpe_b_box", width = 6),
              valueBoxOutput("range_b_box", width = 12)
            ),
            hr(),
            uiOutput("investment_recommendation")
          )
        ),
        
        fluidRow(
          box(
            title = "Risk-Adjusted Performance Measures", 
            status = "warning", 
            solidHeader = TRUE,
            width = 12,
            fluidRow(
              column(4,
                     div(class = "formula-box",
                         h4("Coefficient of Variation"),
                         HTML("<p><strong>CV = σ / E(R)</strong></p>"),
                         p("Risk per unit of return"),
                         p(strong("Lower is better")),
                         p("Useful when comparing investments with different expected returns"),
                         div(class = "example-box",
                             h5("Example:"),
                             p("Investment A: E(R) = 12%, σ = 20%"),
                             p("CV = 20/12 = 1.67"),
                             p("Investment B: E(R) = 10%, σ = 12%"),
                             p("CV = 12/10 = 1.20"),
                             p(strong("B has lower CV → Better risk-adjusted return"))
                         )
                     )
              ),
              column(4,
                     div(class = "formula-box",
                         h4("Sharpe Ratio"),
                         HTML("<p><strong>Sharpe = [E(R) - Rf] / σ</strong></p>"),
                         p("Excess return per unit of risk"),
                         p(strong("Higher is better")),
                         p("Most widely used risk-adjusted measure"),
                         div(class = "example-box",
                             h5("Example:"),
                             p("E(R) = 12%, Rf = 5%, σ = 20%"),
                             p("Sharpe = (12 - 5) / 20 = 0.35"),
                             p("For every 1% of risk, you earn 0.35% excess return")
                         )
                     )
              ),
              column(4,
                     div(class = "formula-box",
                         h4("Range"),
                         HTML("<p><strong>Range = Maximum - Minimum</strong></p>"),
                         p("Spread of possible outcomes"),
                         p("Simple but useful measure"),
                         p("Shows best and worst case scenarios"),
                         div(class = "example-box",
                             h5("Example:"),
                             p("Max Return: 35%"),
                             p("Min Return: -15%"),
                             p("Range = 35 - (-15) = 50%"),
                             p("Wide range indicates high uncertainty")
                         )
                     )
              )
            ),
            hr(),
            plotlyOutput("risk_comparison_plot", height = "300px")
          )
        )
      ),
      
      # Tab 12: Comprehensive Quiz
      tabItem(
        tabName = "quiz",
        fluidRow(
          box(
            title = "Risk and Return Mastery Quiz", 
            status = "primary", 
            solidHeader = TRUE,
            width = 12,
            selectInput("quiz_difficulty", "Select Difficulty Level:",
                       choices = c("Beginner - Return Basics", 
                                 "Intermediate - Risk Measures", 
                                 "Advanced - Portfolio Theory & CAPM")),
            actionButton("start_quiz_btn", "Start Quiz", class = "btn-success"),
            actionButton("next_quiz_btn", "Next Question", class = "btn-primary"),
            hr(),
            uiOutput("quiz_ui"),
            hr(),
            fluidRow(
              valueBoxOutput("quiz_score_box", width = 4),
              valueBoxOutput("quiz_progress_box", width = 4),
              valueBoxOutput("quiz_accuracy_box", width = 4)
            )
          )
        )
      ),
      
      # About Tab
      tabItem(
        tabName = "about",
        fluidRow(
          box(
            title = "About This Educational Tool", 
            status = "info", 
            solidHeader = TRUE,
            width = 12,
            h3("Risk and Return: Complete Learning Guide"),
            p("A comprehensive, interactive educational platform for mastering risk and return concepts in corporate finance."),
            hr(),
            h4("Learning Path:"),
            tags$ol(
              tags$li(strong("Return Basics:"), " Capital gains, dividend yield, total return"),
              tags$li(strong("Historical vs Expected:"), " Understanding past performance and future expectations"),
              tags$li(strong("Return Measures:"), " Arithmetic and geometric means"),
              tags$li(strong("Probability & Risk:"), " Expected return, variance, standard deviation"),
              tags$li(strong("Portfolio Returns:"), " Diversification and correlation effects"),
              tags$li(strong("Why Diversification Works:"), " Correlation effects and risk reduction"),
              tags$li(strong("Systematic vs Unsystematic Risk:"), " Risk decomposition"),
              tags$li(strong("Efficient Frontier:"), " Portfolio optimization with risky assets"),
              tags$li(strong("Capital Market Line:"), " Introducing risk-free asset and tangency portfolio"),
              tags$li(strong("CAPM & Beta:"), " From CML equilibrium to systematic risk pricing"),
              tags$li(strong("Risk-Adjusted Performance:"), " Sharpe, CV, and other metrics"),
              tags$li(strong("Comprehensive Quiz:"), " Test your knowledge across all topics")
            ),
            hr(),
            h4("Features:"),
            tags$ul(
              tags$li("Interactive calculators for all major concepts"),
              tags$li("Real-world examples using Sri Lankan companies"),
              tags$li("Visual demonstrations with interactive charts"),
              tags$li("Comprehensive formula references"),
              tags$li("Worked examples with step-by-step solutions"),
              tags$li("Multi-level quiz system (Beginner to Advanced)"),
              tags$li("Download reports and import data"),
              tags$li("Portfolio comparison tool"),
              tags$li("Progress tracking"),
              tags$li("Dark mode support")
            ),
            hr(),
            h4("Target Audience:"),
            p("Undergraduate and graduate students in finance, accounting, business administration, and economics."),
            hr(),
            p(strong("Developer:"), " Dr. M.I.M. Riyath"),
            p(strong("Affiliation:"), " Department of Accountancy and Finance, Faculty of Management and Commerce, South Eastern University of Sri Lanka"),
            p(strong("Email:"), " riyath@seu.ac.lk"),
            p(strong("Version:"), " 1.0 (December 2025)"),
            hr(),
            p(em("This tool is designed to complement traditional teaching methods and provide students with hands-on experience in financial analysis."))
          )
        )
      ),
      
      # Tab 13: Download Reports
      tabItem(
        tabName = "downloads",
        fluidRow(
          box(
            title = "Download Your Analysis Reports", 
            status = "primary", 
            solidHeader = TRUE,
            width = 12,
            h4("Export Your Work"),
            p("Download comprehensive reports of your calculations and analysis."),
            hr(),
            
            fluidRow(
              column(4,
                wellPanel(
                  h4("Portfolio Analysis Report"),
                  p("Includes all portfolio calculations, charts, and interpretations."),
                  downloadButton("download_portfolio_report", "Download Portfolio Report", 
                                class = "btn-success btn-block")
                )
              ),
              column(4,
                wellPanel(
                  h4("Risk Metrics Report"),
                  p("Comprehensive risk analysis with all calculations."),
                  downloadButton("download_risk_report", "Download Risk Report", 
                                class = "btn-info btn-block")
                )
              ),
              column(4,
                wellPanel(
                  h4("CAPM Analysis Report"),
                  p("Complete CAPM and beta analysis results."),
                  downloadButton("download_capm_report", "Download CAPM Report", 
                                class = "btn-warning btn-block")
                )
              )
            ),
            hr(),
            
            fluidRow(
              column(6,
                wellPanel(
                  h4("Quiz Results"),
                  p("Export your quiz performance and answers."),
                  downloadButton("download_quiz_results", "Download Quiz Results", 
                                class = "btn-primary btn-block")
                )
              ),
              column(6,
                wellPanel(
                  h4("All Data (CSV)"),
                  p("Export all your inputs and results as CSV."),
                  downloadButton("download_all_csv", "Download All Data (CSV)", 
                                class = "btn-danger btn-block")
                )
              )
            )
          )
        )
      ),
      
      # Tab 14: Import Data
      tabItem(
        tabName = "import_data",
        fluidRow(
          box(
            title = "Import Your Own Stock Data", 
            status = "primary", 
            solidHeader = TRUE,
            width = 12,
            
            fluidRow(
              column(6,
                h4("Upload CSV File"),
                fileInput("upload_csv", "Choose CSV File",
                         accept = c("text/csv", "text/comma-separated-values,text/plain", ".csv")),
                
                helpText("CSV should have columns: Date, Return (%)"),
                
                div(class = "example-box",
                    h5("Example CSV Format:"),
                    HTML("<pre>Date,Return
2024-01-01,5.2
2024-02-01,-3.1
2024-03-01,8.5</pre>")
                ),
                
                hr(),
                checkboxInput("header_csv", "File has header row", TRUE),
                actionButton("analyze_uploaded", "Analyze Uploaded Data", class = "btn-success btn-block")
              ),
              
              column(6,
                h4("Uploaded Data Preview"),
                DTOutput("uploaded_data_preview"),
                hr(),
                uiOutput("upload_summary")
              )
            )
          )
        ),
        
        fluidRow(
          box(
            title = "Analysis of Uploaded Data",
            status = "success",
            solidHeader = TRUE,
            width = 12,
            
            fluidRow(
              valueBoxOutput("uploaded_mean_box", width = 3),
              valueBoxOutput("uploaded_sd_box", width = 3),
              valueBoxOutput("uploaded_min_box", width = 3),
              valueBoxOutput("uploaded_max_box", width = 3)
            ),
            
            hr(),
            plotlyOutput("uploaded_data_plot", height = "400px")
          )
        )
      ),
      
      # Tab 15: Portfolio Comparison
      tabItem(
        tabName = "comparison",
        fluidRow(
          box(
            title = "Compare Multiple Portfolios Side-by-Side", 
            status = "primary", 
            solidHeader = TRUE,
            width = 12,
            h4("Build and Compare Up to 3 Portfolios"),
            p("Create different portfolio allocations and compare their risk-return profiles.")
          )
        ),
        
        fluidRow(
          box(
            title = "Portfolio 1",
            status = "info",
            solidHeader = TRUE,
            width = 4,
            textInput("port1_name", "Portfolio Name:", value = "Conservative"),
            sliderInput("port1_stock_a", "Stock A (%):", 0, 100, 30, 5),
            sliderInput("port1_stock_b", "Stock B (%):", 0, 100, 30, 5),
            sliderInput("port1_stock_c", "Stock C (%):", 0, 100, 40, 5),
            hr(),
            valueBoxOutput("port1_total", width = 12)
          ),
          
          box(
            title = "Portfolio 2",
            status = "warning",
            solidHeader = TRUE,
            width = 4,
            textInput("port2_name", "Portfolio Name:", value = "Moderate"),
            sliderInput("port2_stock_a", "Stock A (%):", 0, 100, 40, 5),
            sliderInput("port2_stock_b", "Stock B (%):", 0, 100, 40, 5),
            sliderInput("port2_stock_c", "Stock C (%):", 0, 100, 20, 5),
            hr(),
            valueBoxOutput("port2_total", width = 12)
          ),
          
          box(
            title = "Portfolio 3",
            status = "danger",
            solidHeader = TRUE,
            width = 4,
            textInput("port3_name", "Portfolio Name:", value = "Aggressive"),
            sliderInput("port3_stock_a", "Stock A (%):", 0, 100, 60, 5),
            sliderInput("port3_stock_b", "Stock B (%):", 0, 100, 30, 5),
            sliderInput("port3_stock_c", "Stock C (%):", 0, 100, 10, 5),
            hr(),
            valueBoxOutput("port3_total", width = 12)
          )
        ),
        
        fluidRow(
          box(
            title = "Stock Parameters (Common for All Portfolios)",
            status = "primary",
            solidHeader = TRUE,
            width = 12,
            fluidRow(
              column(4,
                h5("Stock A"),
                numericInput("comp_stock_a_ret", "Expected Return (%):", 12, step = 1),
                numericInput("comp_stock_a_sd", "Std Dev (%):", 20, step = 1)
              ),
              column(4,
                h5("Stock B"),
                numericInput("comp_stock_b_ret", "Expected Return (%):", 15, step = 1),
                numericInput("comp_stock_b_sd", "Std Dev (%):", 25, step = 1)
              ),
              column(4,
                h5("Stock C"),
                numericInput("comp_stock_c_ret", "Expected Return (%):", 10, step = 1),
                numericInput("comp_stock_c_sd", "Std Dev (%):", 15, step = 1)
              )
            ),
            hr(),
            sliderInput("comp_correlation", "Average Correlation:", -1, 1, 0.3, 0.1),
            actionButton("compare_portfolios", "Compare Portfolios", class = "btn-success btn-block")
          )
        ),
        
        fluidRow(
          box(
            title = "Comparison Results",
            status = "success",
            solidHeader = TRUE,
            width = 12,
            
            h4("Performance Metrics Comparison"),
            DTOutput("comparison_table"),
            
            hr(),
            
            fluidRow(
              column(6,
                plotlyOutput("comparison_risk_return", height = "400px")
              ),
              column(6,
                plotlyOutput("comparison_bar_chart", height = "400px")
              )
            )
          )
        )
      )
    ),
    
    # FOOTER
    tags$footer(
      style = "text-align: center; padding: 20px; background-color: #ecf0f5; border-top: 1px solid #d2d6de; margin-top: 20px;",
      HTML("<p style='margin: 0; color: #7f8c8d; font-size: 11px;'>
             Developed by <strong>Dr. M.I.M. Riyath</strong>, Department of Accountancy and Finance, Faculty of Management and Commerce, South Eastern University of Sri Lanka, E-mail: riyath@seu.ac.lk <br>
              Version 1.0 | December 2025
           </p>")
    )
  )
)

# Server
server <- function(input, output, session) {
  
  # ==========================================================================
  # PROGRESS TRACKING
  # ==========================================================================
  
  progress_rv <- reactiveValues(
    returns_complete = FALSE,
    historical_complete = FALSE,
    measures_complete = FALSE,
    probability_complete = FALSE,
    portfolio_complete = FALSE,
    diversification_complete = FALSE,
    systematic_complete = FALSE,
    frontier_complete = FALSE,
    capm_complete = FALSE,
    cml_complete = FALSE,
    risk_complete = FALSE,
    quiz_complete = FALSE
  )
  
  # Track completion when users perform calculations
  observeEvent(input$calc_return, { progress_rv$returns_complete <- TRUE })
  observeEvent(input$calc_historical, { progress_rv$historical_complete <- TRUE })
  observeEvent(input$calc_means, { progress_rv$measures_complete <- TRUE })
  observeEvent(input$calc_risk, { progress_rv$probability_complete <- TRUE })
  observeEvent(input$calc_portfolio, { progress_rv$portfolio_complete <- TRUE })
  observeEvent(input$calc_div_effect, { progress_rv$diversification_complete <- TRUE })
  observeEvent(input$calc_decomp, { progress_rv$systematic_complete <- TRUE })
  observeEvent(input$generate_frontier, { progress_rv$frontier_complete <- TRUE })
  observeEvent(input$calc_capm_btn, { progress_rv$capm_complete <- TRUE })
  observeEvent(input$calc_cml_allocation, { progress_rv$cml_complete <- TRUE })
  observeEvent(input$compare_risk, { progress_rv$risk_complete <- TRUE })
  
  # Mark quiz complete when finished
  observe({
    if(!is.null(quiz_rv$started) && quiz_rv$started && quiz_rv$current > quiz_rv$total) {
      progress_rv$quiz_complete <- TRUE
    }
  })
  
  output$progress_display <- renderUI({
    completed <- sum(c(
      progress_rv$returns_complete,
      progress_rv$historical_complete,
      progress_rv$measures_complete,
      progress_rv$probability_complete,
      progress_rv$portfolio_complete,
      progress_rv$diversification_complete,
      progress_rv$systematic_complete,
      progress_rv$frontier_complete,
      progress_rv$capm_complete,
      progress_rv$cml_complete,
      progress_rv$risk_complete,
      progress_rv$quiz_complete
    ))
    
    total <- 12
    pct <- round((completed / total) * 100)
    
    HTML(paste0(
      "<div style='background: white; padding: 10px; border-radius: 5px;'>",
      "<p style='margin: 0; color: #2c3e50;'><strong>", completed, " / ", total, " modules</strong></p>",
      "<div style='background: #ecf0f1; height: 20px; border-radius: 10px; margin-top: 5px;'>",
      "<div style='background: #3498db; width: ", pct, "%; height: 100%; border-radius: 10px;'></div>",
      "</div>",
      "<p style='margin: 5px 0 0 0; color: #7f8c8d; font-size: 12px;'>", pct, "% Complete</p>",
      "</div>"
    ))
  })
  
  # Reactive values for quiz
  quiz_rv <- reactiveValues(
    started = FALSE,
    current = 1,
    score = 0,
    total = 10,
    answered = FALSE,
    selected = NULL,
    questions = NULL
  )
  
  # Tab 1: Return Basics Calculations
  return_results <- eventReactive(input$calc_return, {
    capital_gain <- ((input$sell_price - input$buy_price) / input$buy_price) * 100
    dividend_yield <- (input$dividend / input$buy_price) * 100
    total_return <- capital_gain + dividend_yield
    
    list(
      capital_gain = capital_gain,
      dividend_yield = dividend_yield,
      total_return = total_return
    )
  })
  
  output$capital_gain_box <- renderValueBox({
    results <- return_results()
    color <- if(results$capital_gain >= 0) "green" else "red"
    valueBox(
      paste0(round(results$capital_gain, 2), "%"),
      "Capital Gain",
      icon = icon("chart-line"),
      color = color
    )
  })
  
  output$dividend_yield_box <- renderValueBox({
    results <- return_results()
    valueBox(
      paste0(round(results$dividend_yield, 2), "%"),
      "Dividend Yield",
      icon = icon("money-bill-wave"),
      color = "blue"
    )
  })
  
  output$total_return_box <- renderValueBox({
    results <- return_results()
    color <- if(results$total_return >= 0) "green" else "red"
    valueBox(
      paste0(round(results$total_return, 2), "%"),
      "Total Return",
      icon = icon("trophy"),
      color = color
    )
  })
  
  # Tab 2: Historical Returns
  historical_results <- eventReactive(input$calc_historical, {
    returns <- c(input$year1, input$year2, input$year3, input$year4, input$year5)
    avg <- mean(returns)
    best <- max(returns)
    worst <- min(returns)
    
    list(
      returns = returns,
      average = avg,
      best = best,
      worst = worst
    )
  })
  
  output$avg_historical_box <- renderValueBox({
    results <- historical_results()
    valueBox(
      paste0(round(results$average, 2), "%"),
      "Average Historical Return",
      icon = icon("chart-bar"),
      color = "blue"
    )
  })
  
  output$best_year_box <- renderValueBox({
    results <- historical_results()
    valueBox(
      paste0(round(results$best, 2), "%"),
      "Best Year",
      icon = icon("arrow-up"),
      color = "green"
    )
  })
  
  output$worst_year_box <- renderValueBox({
    results <- historical_results()
    valueBox(
      paste0(round(results$worst, 2), "%"),
      "Worst Year",
      icon = icon("arrow-down"),
      color = "red"
    )
  })
  
  output$historical_plot <- renderPlotly({
    results <- historical_results()
    
    plot_ly(x = paste("Year", 1:5), y = results$returns, type = 'bar',
            marker = list(color = ifelse(results$returns >= 0, 'green', 'red'))) %>%
      layout(title = "Historical Returns by Year",
             xaxis = list(title = ""),
             yaxis = list(title = "Return (%)"),
             showlegend = FALSE)
  })
  
  # Expected Returns
  output$total_prob_box <- renderValueBox({
    total <- input$prob_boom + input$prob_normal + input$prob_recession
    color <- if(total == 100) "green" else "red"
    
    valueBox(
      paste0(total, "%"),
      "Total Probability",
      icon = (if(total == 100) icon("check-circle") else icon("exclamation-triangle")),
      color = color
    )
  })
  
  expected_results <- eventReactive(input$calc_expected, {
    req(input$prob_boom + input$prob_normal + input$prob_recession == 100)
    
    exp_return <- (input$prob_boom/100 * input$ret_boom +
                  input$prob_normal/100 * input$ret_normal +
                  input$prob_recession/100 * input$ret_recession)
    
    list(expected_return = exp_return)
  })
  
  output$expected_return_box <- renderValueBox({
    results <- expected_results()
    valueBox(
      paste0(round(results$expected_return, 2), "%"),
      "Expected Return E(R)",
      icon = icon("bullseye"),
      color = "green"
    )
  })
  
  output$scenario_plot <- renderPlotly({
    scenarios <- c("Boom", "Normal", "Recession")
    probs <- c(input$prob_boom, input$prob_normal, input$prob_recession)
    returns <- c(input$ret_boom, input$ret_normal, input$ret_recession)
    
    plot_ly() %>%
      add_trace(x = scenarios, y = probs, type = 'bar', name = 'Probability (%)',
                marker = list(color = 'lightblue')) %>%
      add_trace(x = scenarios, y = returns, type = 'scatter', mode = 'lines+markers',
                name = 'Return (%)', yaxis = 'y2',
                line = list(color = 'red', width = 3),
                marker = list(size = 10, color = 'red')) %>%
      layout(title = "Scenario Analysis",
             xaxis = list(title = ""),
             yaxis = list(title = "Probability (%)"),
             yaxis2 = list(title = "Return (%)", overlaying = 'y', side = 'right'),
             showlegend = TRUE)
  })
  
  # Tab 3: Return Measures
  means_results <- eventReactive(input$calc_means, {
    returns <- c(input$ret_yr1, input$ret_yr2, input$ret_yr3, input$ret_yr4, input$ret_yr5)
    
    # Arithmetic mean
    arithmetic <- mean(returns)
    
    # Geometric mean
    returns_decimal <- returns / 100
    product <- prod(1 + returns_decimal)
    geometric <- (product ^ (1/length(returns)) - 1) * 100
    
    list(
      arithmetic = arithmetic,
      geometric = geometric,
      returns = returns
    )
  })
  
  output$arithmetic_mean_box <- renderValueBox({
    results <- means_results()
    valueBox(
      paste0(round(results$arithmetic, 2), "%"),
      "Arithmetic Mean",
      icon = icon("calculator"),
      color = "blue"
    )
  })
  
  output$geometric_mean_box <- renderValueBox({
    results <- means_results()
    valueBox(
      paste0(round(results$geometric, 2), "%"),
      "Geometric Mean",
      icon = icon("chart-line"),
      color = "green"
    )
  })
  
  output$means_comparison_plot <- renderPlotly({
    results <- means_results()
    
    measures <- c("Arithmetic", "Geometric")
    values <- c(results$arithmetic, results$geometric)
    
    plot_ly(x = measures, y = values, type = 'bar',
            marker = list(color = c('blue', 'green'))) %>%
      layout(title = "Comparison of Average Return Measures",
             xaxis = list(title = ""),
             yaxis = list(title = "Return (%)"))
  })
  
  output$means_interpretation <- renderUI({
    results <- means_results()
    
    diff <- results$arithmetic - results$geometric
    
    HTML(paste0(
      "<div class='example-box'>",
      "<h4>Interpretation:</h4>",
      "<p><strong>Arithmetic Mean (", round(results$arithmetic, 2), "%):</strong> ",
      "Simple average - best estimate for a single period's expected return.</p>",
      "<p><strong>Geometric Mean (", round(results$geometric, 2), "%):</strong> ",
      "Compound average - shows the actual annualized return achieved over the period.</p>",
      "<p><strong>Difference (", round(diff, 2), "%):</strong> ",
      "The geometric mean is lower due to volatility drag. Higher volatility creates a larger gap between arithmetic and geometric means.</p>",
      "</div>"
    ))
  })
  
  # Tab 4: Probability and Risk
  output$prob_total_box <- renderValueBox({
    total <- input$p1 + input$p2 + input$p3 + input$p4 + input$p5
    color <- if(abs(total - 100) < 0.01) "green" else "red"
    
    valueBox(
      paste0(round(total, 1), "%"),
      "Total Probability",
      icon = (if(abs(total - 100) < 0.01) icon("check-circle") else icon("exclamation-triangle")),
      color = color
    )
  })
  
  risk_results <- eventReactive(input$calc_risk, {
    req(abs((input$p1 + input$p2 + input$p3 + input$p4 + input$p5) - 100) < 0.01)
    
    probs <- c(input$p1, input$p2, input$p3, input$p4, input$p5) / 100
    returns <- c(input$r1, input$r2, input$r3, input$r4, input$r5)
    
    # Expected return
    exp_ret <- sum(probs * returns)
    
    # Variance
    variance <- sum(probs * (returns - exp_ret)^2)
    
    # Standard deviation
    std_dev <- sqrt(variance)
    
    # Coefficient of variation
    cv <- if(exp_ret != 0) std_dev / abs(exp_ret) else NA
    
    list(
      expected_return = exp_ret,
      variance = variance,
      std_dev = std_dev,
      cv = cv,
      probs = probs * 100,
      returns = returns
    )
  })
  
  output$exp_ret_box <- renderValueBox({
    results <- risk_results()
    valueBox(
      paste0(round(results$expected_return, 2), "%"),
      "Expected Return E(R)",
      icon = icon("bullseye"),
      color = "blue"
    )
  })
  
  output$variance_box <- renderValueBox({
    results <- risk_results()
    valueBox(
      paste0(round(results$variance, 2), " %²"),
      "Variance (σ²)",
      icon = icon("chart-area"),
      color = "orange"
    )
  })
  
  output$std_dev_box <- renderValueBox({
    results <- risk_results()
    valueBox(
      paste0(round(results$std_dev, 2), "%"),
      "Std Deviation (σ)",
      icon = icon("wave-square"),
      color = "red"
    )
  })
  
  output$coef_var_box <- renderValueBox({
    results <- risk_results()
    value <- if(is.na(results$cv)) "N/A" else round(results$cv, 3)
    valueBox(
      value,
      "Coefficient of Variation",
      icon = icon("balance-scale"),
      color = "purple"
    )
  })
  
  output$distribution_plot <- renderPlotly({
    results <- risk_results()
    
    plot_ly(x = results$returns, y = results$probs, type = 'bar',
            marker = list(color = 'steelblue')) %>%
      add_trace(x = rep(results$expected_return, 2), y = c(0, max(results$probs)),
                type = 'scatter', mode = 'lines',
                line = list(color = 'red', width = 3, dash = 'dash'),
                name = 'Expected Return') %>%
      layout(title = "Return Probability Distribution",
             xaxis = list(title = "Return (%)"),
             yaxis = list(title = "Probability (%)"),
             showlegend = TRUE)
  })
  
  # Tab 5: Portfolio Returns
  output$weight_b_box <- renderValueBox({
    weight_b <- 100 - input$weight_a_port
    valueBox(
      paste0(weight_b, "%"),
      "Weight in Asset B",
      icon = icon("balance-scale"),
      color = "blue"
    )
  })
  
  portfolio_results <- eventReactive(input$calc_portfolio, {
    wa <- input$weight_a_port / 100
    wb <- 1 - wa
    
    # Portfolio return
    port_return <- wa * input$ret_a_port + wb * input$ret_b_port
    
    # Portfolio risk
    sa <- input$sd_a_port
    sb <- input$sd_b_port
    corr <- input$correlation
    
    variance <- (wa^2 * sa^2) + (wb^2 * sb^2) + (2 * wa * wb * corr * sa * sb)
    port_risk <- sqrt(variance)
    
    # Weighted average risk (for comparison)
    weighted_avg_risk <- wa * sa + wb * sb
    
    # Diversification benefit
    div_benefit <- weighted_avg_risk - port_risk
    
    list(
      return = port_return,
      risk = port_risk,
      weighted_avg_risk = weighted_avg_risk,
      div_benefit = div_benefit
    )
  })
  
  output$port_return_box <- renderValueBox({
    results <- portfolio_results()
    valueBox(
      paste0(round(results$return, 2), "%"),
      "Portfolio Return",
      icon = icon("chart-line"),
      color = "green"
    )
  })
  
  output$port_risk_box <- renderValueBox({
    results <- portfolio_results()
    valueBox(
      paste0(round(results$risk, 2), "%"),
      "Portfolio Risk (σp)",
      icon = icon("exclamation-triangle"),
      color = "orange"
    )
  })
  
  output$portfolio_plot <- renderPlotly({
    results <- portfolio_results()
    
    assets <- c("Asset A", "Asset B", "Portfolio")
    returns <- c(input$ret_a_port, input$ret_b_port, results$return)
    risks <- c(input$sd_a_port, input$sd_b_port, results$risk)
    
    plot_ly(x = risks, y = returns, text = assets, type = 'scatter', mode = 'markers+text',
            marker = list(size = c(12, 12, 20), color = c('blue', 'green', 'red')),
            textposition = 'top center') %>%
      layout(title = "Risk-Return Space",
             xaxis = list(title = "Risk (Standard Deviation %)"),
             yaxis = list(title = "Expected Return (%)"))
  })
  
  output$diversification_benefit <- renderUI({
    results <- portfolio_results()
    
    # Extract the correlation interpretation first
    corr_text <- if(input$correlation < 0.3) {
      "Strong diversification benefit!"
    } else if(input$correlation < 0.7) {
      "Moderate diversification benefit."
    } else {
      "Limited diversification benefit."
    }
    
    HTML(paste0(
      "<div class='example-box'>",
      "<h4>Diversification Analysis:</h4>",
      "<p><strong>Weighted Average Risk:</strong> ", round(results$weighted_avg_risk, 2), "%</p>",
      "<p><strong>Actual Portfolio Risk:</strong> ", round(results$risk, 2), "%</p>",
      "<p><strong>Risk Reduction:</strong> ", round(results$div_benefit, 2), "% (", 
      round((results$div_benefit/results$weighted_avg_risk)*100, 1), "% reduction)</p>",
      "<p>Correlation = ", input$correlation, ": ", corr_text, "</p>",
      "</div>"
    ))
  })
  
  # Tab 6: Why Diversification Works
  div_effect_results <- eventReactive(input$calc_div_effect, {
    # Equal weights
    w1 <- 0.5
    w2 <- 0.5
    
    # Weighted average risk (naive calculation)
    weighted_avg <- w1 * input$asset1_sd_div + w2 * input$asset2_sd_div
    
    # Actual portfolio risk with correlation
    variance <- (w1^2 * input$asset1_sd_div^2) + 
                (w2^2 * input$asset2_sd_div^2) + 
                (2 * w1 * w2 * input$correlation_div * input$asset1_sd_div * input$asset2_sd_div)
    actual_risk <- sqrt(variance)
    
    # Risk reduction
    reduction <- weighted_avg - actual_risk
    reduction_pct <- (reduction / weighted_avg) * 100
    
    list(
      weighted_avg = weighted_avg,
      actual_risk = actual_risk,
      reduction = reduction,
      reduction_pct = reduction_pct
    )
  })
  
  output$weighted_avg_risk_box <- renderValueBox({
    results <- div_effect_results()
    valueBox(
      paste0(round(results$weighted_avg, 2), "%"),
      "Weighted Average Risk (Naive)",
      icon = icon("calculator"),
      color = "blue"
    )
  })
  
  output$actual_port_risk_box <- renderValueBox({
    results <- div_effect_results()
    valueBox(
      paste0(round(results$actual_risk, 2), "%"),
      "Actual Portfolio Risk (with correlation)",
      icon = icon("shield-alt"),
      color = "green"
    )
  })
  
  output$risk_reduction_box <- renderValueBox({
    results <- div_effect_results()
    color <- if(results$reduction > 0) "green" else "red"
    valueBox(
      paste0(round(results$reduction, 2), "% (", round(results$reduction_pct, 1), "%)"),
      "Risk Reduction Benefit",
      icon = icon("arrow-down"),
      color = color
    )
  })
  
  output$correlation_effect_plot <- renderPlotly({
    # Generate portfolio risk for different correlations
    correlations <- seq(-1, 1, 0.1)
    w1 <- 0.5
    w2 <- 0.5
    
    portfolio_risks <- sapply(correlations, function(rho) {
      variance <- (w1^2 * input$asset1_sd_div^2) + 
                  (w2^2 * input$asset2_sd_div^2) + 
                  (2 * w1 * w2 * rho * input$asset1_sd_div * input$asset2_sd_div)
      sqrt(variance)
    })
    
    weighted_avg <- w1 * input$asset1_sd_div + w2 * input$asset2_sd_div
    
    plot_ly() %>%
      add_trace(x = correlations, y = portfolio_risks, type = 'scatter', mode = 'lines',
                line = list(color = 'blue', width = 3), name = 'Portfolio Risk') %>%
      add_trace(x = correlations, y = rep(weighted_avg, length(correlations)), 
                type = 'scatter', mode = 'lines',
                line = list(color = 'red', width = 2, dash = 'dash'), 
                name = 'Weighted Avg (No diversification)') %>%
      add_trace(x = input$correlation_div, y = div_effect_results()$actual_risk,
                type = 'scatter', mode = 'markers',
                marker = list(size = 15, color = 'green', symbol = 'star'),
                name = 'Your Portfolio') %>%
      layout(title = "How Correlation Affects Portfolio Risk",
             xaxis = list(title = "Correlation (ρ)"),
             yaxis = list(title = "Portfolio Risk (%)"),
             showlegend = TRUE)
  })
  
  output$correlation_interpretation_div <- renderUI({
    results <- div_effect_results()
    rho <- input$correlation_div
    
    interp <- if(rho >= 0.8) {
      "Very high positive correlation - assets move almost identically. Minimal diversification benefit."
    } else if(rho >= 0.5) {
      "Moderate positive correlation - assets tend to move together. Some diversification benefit."
    } else if(rho >= 0) {
      "Low positive correlation - assets move somewhat independently. Good diversification benefit."
    } else if(rho >= -0.5) {
      "Negative correlation - assets tend to move in opposite directions. Excellent diversification!"
    } else {
      "Strong negative correlation - assets move in opposite directions. Maximum diversification benefit!"
    }
    
    benefit_msg <- if(results$reduction_pct < 10) {
      "<p style='color: orange;'>⚠️ Low diversification benefit. Consider assets with lower correlation.</p>"
    } else if(results$reduction_pct > 30) {
      "<p style='color: green;'>✓ Excellent diversification! Significant risk reduction achieved.</p>"
    } else {
      "<p style='color: blue;'>Moderate diversification benefit achieved.</p>"
    }
    
    HTML(paste0(
      "<div class='example-box'>",
      "<h5>Interpretation (ρ = ", rho, "):</h5>",
      "<p>", interp, "</p>",
      "<p><strong>Risk Reduction:</strong> By diversifying, you reduced risk by ", 
      round(results$reduction, 2), "% (", round(results$reduction_pct, 1), "% reduction).</p>",
      benefit_msg,
      "</div>"
    ))
  })
  
  # Diversification experiment
  div_exp_results <- eventReactive(input$run_diversification_exp, {
    n <- input$num_stocks_div
    individual_sd <- 30
    correlation <- 0.3
    systematic_risk <- 15
    
    # Portfolio variance for equally-weighted portfolio with constant pairwise correlation
    # σp² = (1/n)σ² + [(n-1)/n]ρσ²
    # σp² = σ²[(1/n) + (n-1)/n × ρ]
    # σp² = σ²[(1 + (n-1)ρ)/n]
    
    variance <- (individual_sd^2) * ((1 + (n - 1) * correlation) / n)
    portfolio_risk <- sqrt(variance)
    
    # Risk reduction from single stock
    initial_risk <- individual_sd
    reduction <- initial_risk - portfolio_risk
    reduction_pct <- (reduction / initial_risk) * 100
    
    list(
      n = n,
      portfolio_risk = portfolio_risk,
      reduction = reduction,
      reduction_pct = reduction_pct,
      systematic_risk = systematic_risk
    )
  })
  
  output$portfolio_stocks_box <- renderValueBox({
    results <- div_exp_results()
    valueBox(
      results$n,
      "Number of Stocks",
      icon = icon("layer-group"),
      color = "blue"
    )
  })
  
  output$portfolio_risk_div_box <- renderValueBox({
    results <- div_exp_results()
    valueBox(
      paste0(round(results$portfolio_risk, 2), "%"),
      "Portfolio Risk (σp)",
      icon = icon("chart-line"),
      color = "orange"
    )
  })
  
  output$risk_reduction_pct_box <- renderValueBox({
    results <- div_exp_results()
    valueBox(
      paste0(round(results$reduction_pct, 1), "%"),
      "Risk Reduction from N=1",
      icon = icon("arrow-down"),
      color = "green"
    )
  })
  
  output$diversification_curve <- renderPlotly({
    # Generate curve for 1 to 30 stocks
    n_stocks <- 1:30
    individual_sd <- 30
    correlation <- 0.3
    systematic_risk <- 15
    
    portfolio_risks <- sapply(n_stocks, function(n) {
      variance <- (individual_sd^2) * ((1 + (n - 1) * correlation) / n)
      sqrt(variance)
    })
    
    plot_ly() %>%
      add_trace(x = n_stocks, y = portfolio_risks, type = 'scatter', mode = 'lines',
                line = list(color = 'blue', width = 3), name = 'Total Portfolio Risk') %>%
      add_trace(x = n_stocks, y = rep(systematic_risk, length(n_stocks)),
                type = 'scatter', mode = 'lines',
                line = list(color = 'red', width = 2, dash = 'dash'),
                name = 'Systematic Risk Floor') %>%
      add_trace(x = input$num_stocks_div, y = div_exp_results()$portfolio_risk,
                type = 'scatter', mode = 'markers',
                marker = list(size = 12, color = 'green', symbol = 'circle'),
                name = 'Your Portfolio') %>%
      add_trace(x = n_stocks, 
                y = portfolio_risks - systematic_risk,
                type = 'scatter', mode = 'none', fill = 'tonexty',
                fillcolor = 'rgba(255, 165, 0, 0.3)',
                name = 'Unsystematic Risk (Diversifiable)',
                showlegend = TRUE) %>%
      layout(title = "Diversification Effect: Risk Reduction as Stocks Increase",
             xaxis = list(title = "Number of Stocks in Portfolio"),
             yaxis = list(title = "Risk (Standard Deviation %)"),
             showlegend = TRUE,
             annotations = list(
               list(x = 25, y = 18, text = "← Diminishing returns after ~20 stocks",
                    showarrow = FALSE, font = list(size = 11, color = 'blue'))
             ))
  })
  
  # Tab 7: Systematic vs Unsystematic Risk
  # Quick load stock examples
  observeEvent(input$stock_example_sys, {
    if(input$stock_example_sys == "Dialog Axiata") {
      updateNumericInput(session, "stock_sd_sys", value = 25)
      updateNumericInput(session, "stock_beta_sys", value = 1.15)
    } else if(input$stock_example_sys == "John Keells") {
      updateNumericInput(session, "stock_sd_sys", value = 22)
      updateNumericInput(session, "stock_beta_sys", value = 0.85)
    } else if(input$stock_example_sys == "Commercial Bank") {
      updateNumericInput(session, "stock_sd_sys", value = 20)
      updateNumericInput(session, "stock_beta_sys", value = 0.95)
    } else if(input$stock_example_sys == "Hemas Holdings") {
      updateNumericInput(session, "stock_sd_sys", value = 28)
      updateNumericInput(session, "stock_beta_sys", value = 1.30)
    }
  })
  
  # Risk decomposition calculation
  decomp_results <- eventReactive(input$calc_decomp, {
    total_variance <- input$stock_sd_sys^2
    systematic_variance <- (input$stock_beta_sys^2) * (input$market_sd_sys^2)
    unsystematic_variance <- total_variance - systematic_variance
    
    pct_systematic <- (systematic_variance / total_variance) * 100
    pct_unsystematic <- 100 - pct_systematic
    
    list(
      total_variance = total_variance,
      systematic_variance = systematic_variance,
      unsystematic_variance = unsystematic_variance,
      pct_systematic = pct_systematic,
      pct_unsystematic = pct_unsystematic
    )
  })
  
  output$total_variance_box <- renderValueBox({
    results <- decomp_results()
    valueBox(
      paste0(round(results$total_variance, 2), " %²"),
      "Total Variance",
      icon = icon("chart-area"),
      color = "blue"
    )
  })
  
  output$systematic_variance_box <- renderValueBox({
    results <- decomp_results()
    valueBox(
      paste0(round(results$systematic_variance, 2), " %²"),
      "Systematic Variance",
      icon = icon("globe"),
      color = "red"
    )
  })
  
  output$unsystematic_variance_box <- renderValueBox({
    results <- decomp_results()
    valueBox(
      paste0(round(results$unsystematic_variance, 2), " %²"),
      "Unsystematic Variance",
      icon = icon("building"),
      color = "green"
    )
  })
  
  output$pct_systematic_box <- renderValueBox({
    results <- decomp_results()
    valueBox(
      paste0(round(results$pct_systematic, 1), "%"),
      "% Systematic",
      icon = icon("percent"),
      color = "red"
    )
  })
  
  output$pct_unsystematic_box <- renderValueBox({
    results <- decomp_results()
    valueBox(
      paste0(round(results$pct_unsystematic, 1), "%"),
      "% Unsystematic",
      icon = icon("percent"),
      color = "green"
    )
  })
  
  output$risk_decomp_plot <- renderPlotly({
    results <- decomp_results()
    
    components <- c("Systematic", "Unsystematic")
    values <- c(results$pct_systematic, results$pct_unsystematic)
    
    plot_ly(labels = components, values = values, type = 'pie',
            marker = list(colors = c('#ff6b6b', '#51cf66')),
            textinfo = 'label+percent') %>%
      layout(title = "Risk Composition")
  })
  
  # Systematic/Unsystematic visualization over N stocks
  sys_unsys_results <- eventReactive(input$show_decomp, {
    n <- input$n_stocks_sys
    individual_sd <- 30
    correlation <- 0.3
    systematic_risk <- 15  # The floor
    
    # Portfolio risk with n stocks
    variance <- (individual_sd^2) * ((1 + (n - 1) * correlation) / n)
    total_risk <- sqrt(variance)
    
    # Systematic component stays constant
    systematic_component <- systematic_risk
    
    # Unsystematic component
    unsystematic_component <- sqrt(max(0, total_risk^2 - systematic_component^2))
    
    list(
      n = n,
      total_risk = total_risk,
      systematic = systematic_component,
      unsystematic = unsystematic_component
    )
  })
  
  output$total_risk_sys_box <- renderValueBox({
    results <- sys_unsys_results()
    valueBox(
      paste0(round(results$total_risk, 2), "%"),
      "Total Portfolio Risk",
      icon = icon("chart-line"),
      color = "blue"
    )
  })
  
  output$systematic_component_box <- renderValueBox({
    results <- sys_unsys_results()
    valueBox(
      paste0(round(results$systematic, 2), "%"),
      "Systematic Component",
      icon = icon("globe"),
      color = "red"
    )
  })
  
  output$unsystematic_component_box <- renderValueBox({
    results <- sys_unsys_results()
    valueBox(
      paste0(round(results$unsystematic, 2), "%"),
      "Unsystematic Component",
      icon = icon("building"),
      color = "green"
    )
  })
  
  output$systematic_unsystematic_plot <- renderPlotly({
    # Generate data for 1 to 50 stocks
    n_stocks <- 1:50
    individual_sd <- 30
    correlation <- 0.3
    systematic_risk <- 15
    
    # Calculate total risk for each n
    total_risks <- sapply(n_stocks, function(n) {
      variance <- (individual_sd^2) * ((1 + (n - 1) * correlation) / n)
      sqrt(variance)
    })
    
    # Systematic component is constant
    systematic_component <- rep(systematic_risk, length(n_stocks))
    
    # Unsystematic component
    unsystematic_component <- sqrt(pmax(0, total_risks^2 - systematic_component^2))
    
    plot_ly() %>%
      add_trace(x = n_stocks, y = total_risks, type = 'scatter', mode = 'lines',
                line = list(color = 'blue', width = 3), name = 'Total Risk',
                fill = 'tozeroy', fillcolor = 'rgba(66, 135, 245, 0.2)') %>%
      add_trace(x = n_stocks, y = systematic_component, type = 'scatter', mode = 'lines',
                line = list(color = 'red', width = 3, dash = 'dash'), 
                name = 'Systematic Risk (Floor)') %>%
      add_trace(x = n_stocks, y = unsystematic_component, type = 'scatter', mode = 'lines',
                line = list(color = 'green', width = 2), name = 'Unsystematic Risk',
                fill = 'tonexty', fillcolor = 'rgba(81, 207, 102, 0.3)') %>%
      add_trace(x = input$n_stocks_sys, y = sys_unsys_results()$total_risk,
                type = 'scatter', mode = 'markers',
                marker = list(size = 12, color = 'purple', symbol = 'star'),
                name = 'Your Portfolio') %>%
      layout(title = "Risk Decomposition: How Diversification Affects Each Component",
             xaxis = list(title = "Number of Stocks in Portfolio"),
             yaxis = list(title = "Risk (Standard Deviation %)"),
             showlegend = TRUE,
             annotations = list(
               list(x = 40, y = 16, text = "Systematic Risk Cannot Be Diversified →",
                    showarrow = TRUE, arrowhead = 2, ax = -50, ay = -30,
                    font = list(size = 11, color = 'red')),
               list(x = 10, y = 25, text = "← Unsystematic Risk Eliminated",
                    showarrow = TRUE, arrowhead = 2, ax = 40, ay = 30,
                    font = list(size = 11, color = 'green'))
             ))
  })
  
  # Tab 11: Risk-Adjusted Performance (moved from old Tab 7)
  comparison_results <- eventReactive(input$compare_risk, {
    # Investment A
    cv_a <- input$inv_a_sd / input$inv_a_return
    sharpe_a <- (input$inv_a_return - input$risk_free_rate) / input$inv_a_sd
    range_a <- input$inv_a_max - input$inv_a_min
    
    # Investment B
    cv_b <- input$inv_b_sd / input$inv_b_return
    sharpe_b <- (input$inv_b_return - input$risk_free_rate) / input$inv_b_sd
    range_b <- input$inv_b_max - input$inv_b_min
    
    list(
      cv_a = cv_a, sharpe_a = sharpe_a, range_a = range_a,
      cv_b = cv_b, sharpe_b = sharpe_b, range_b = range_b
    )
  })
  
  output$cv_a_box <- renderValueBox({
    results <- comparison_results()
    valueBox(
      round(results$cv_a, 3),
      "CV (A)",
      icon = icon("balance-scale"),
      color = "blue"
    )
  })
  
  output$sharpe_a_box <- renderValueBox({
    results <- comparison_results()
    valueBox(
      round(results$sharpe_a, 3),
      "Sharpe (A)",
      icon = icon("star"),
      color = "green"
    )
  })
  
  output$range_a_box <- renderValueBox({
    results <- comparison_results()
    valueBox(
      paste0(round(results$range_a, 1), "%"),
      "Range (A)",
      icon = icon("arrows-alt-h"),
      color = "orange"
    )
  })
  
  output$cv_b_box <- renderValueBox({
    results <- comparison_results()
    valueBox(
      round(results$cv_b, 3),
      "CV (B)",
      icon = icon("balance-scale"),
      color = "blue"
    )
  })
  
  output$sharpe_b_box <- renderValueBox({
    results <- comparison_results()
    valueBox(
      round(results$sharpe_b, 3),
      "Sharpe (B)",
      icon = icon("star"),
      color = "green"
    )
  })
  
  output$range_b_box <- renderValueBox({
    results <- comparison_results()
    valueBox(
      paste0(round(results$range_b, 1), "%"),
      "Range (B)",
      icon = icon("arrows-alt-h"),
      color = "orange"
    )
  })
  
  output$investment_recommendation <- renderUI({
    results <- comparison_results()
    
    # Determine winner for each metric
    cv_winner <- if(results$cv_a < results$cv_b) "A" else "B"
    sharpe_winner <- if(results$sharpe_a > results$sharpe_b) "A" else "B"
    
    HTML(paste0(
      "<div class='example-box'>",
      "<h4>Investment Comparison Summary:</h4>",
      "<p><strong>Coefficient of Variation:</strong> Investment ", cv_winner, 
      " has better risk-adjusted returns (lower CV is better)</p>",
      "<p><strong>Sharpe Ratio:</strong> Investment ", sharpe_winner,
      " provides better excess return per unit of risk (higher is better)</p>",
      "<p><strong>Overall Recommendation:</strong> ",
      if(cv_winner == sharpe_winner) {
        paste0("Investment ", cv_winner, " is superior on both risk-adjusted measures.")
      } else {
        "Mixed results - consider your risk tolerance and return objectives."
      },
      "</p>",
      "</div>"
    ))
  })
  
  output$risk_comparison_plot <- renderPlotly({
    results <- comparison_results()
    
    metrics <- c("Return", "Risk", "Sharpe", "CV")
    inv_a <- c(input$inv_a_return, input$inv_a_sd, results$sharpe_a*10, results$cv_a*10)
    inv_b <- c(input$inv_b_return, input$inv_b_sd, results$sharpe_b*10, results$cv_b*10)
    
    plot_ly() %>%
      add_trace(x = metrics, y = inv_a, type = 'bar', name = 'Investment A',
                marker = list(color = 'steelblue')) %>%
      add_trace(x = metrics, y = inv_b, type = 'bar', name = 'Investment B',
                marker = list(color = 'orange')) %>%
      layout(title = "Side-by-Side Comparison (Sharpe & CV scaled ×10)",
             xaxis = list(title = ""),
             yaxis = list(title = "Value"),
             barmode = 'group')
  })
  
  # Tab 9: CAPM (previously Tab 7, now Tab 9)
  observeEvent(input$load_jkh_beta, { updateNumericInput(session, "beta_capm", value = 0.85) })
  observeEvent(input$load_dialog_beta, { updateNumericInput(session, "beta_capm", value = 1.15) })
  observeEvent(input$load_cse_beta, { updateNumericInput(session, "beta_capm", value = 0.95) })
  observeEvent(input$load_hemas_beta, { updateNumericInput(session, "beta_capm", value = 1.30) })
  
  capm_results <- eventReactive(input$calc_capm_btn, {
    market_premium <- input$rm_capm - input$rf_capm
    stock_premium <- input$beta_capm * market_premium
    required_return <- input$rf_capm + stock_premium
    
    list(
      required_return = required_return,
      market_premium = market_premium,
      stock_premium = stock_premium
    )
  })
  
  output$req_return_box <- renderValueBox({
    results <- capm_results()
    valueBox(
      paste0(round(results$required_return, 2), "%"),
      "Required Return",
      icon = icon("bullseye"),
      color = "green"
    )
  })
  
  output$market_premium_box <- renderValueBox({
    results <- capm_results()
    valueBox(
      paste0(round(results$market_premium, 2), "%"),
      "Market Risk Premium",
      icon = icon("chart-line"),
      color = "blue"
    )
  })
  
  output$stock_premium_box <- renderValueBox({
    results <- capm_results()
    valueBox(
      paste0(round(results$stock_premium, 2), "%"),
      "Stock Risk Premium",
      icon = icon("arrow-up"),
      color = "orange"
    )
  })
  
  output$sml_plot <- renderPlotly({
    results <- capm_results()
    
    # Generate SML line
    beta_range <- seq(-0.5, 2.5, 0.1)
    sml_returns <- input$rf_capm + beta_range * (input$rm_capm - input$rf_capm)
    
    plot_ly() %>%
      add_trace(x = beta_range, y = sml_returns, type = 'scatter', mode = 'lines',
                line = list(color = 'blue', width = 2), name = 'SML') %>%
      add_trace(x = 0, y = input$rf_capm, type = 'scatter', mode = 'markers',
                marker = list(size = 12, color = 'green'), name = 'Risk-Free Rate') %>%
      add_trace(x = 1, y = input$rm_capm, type = 'scatter', mode = 'markers',
                marker = list(size = 12, color = 'orange'), name = 'Market') %>%
      add_trace(x = input$beta_capm, y = results$required_return, type = 'scatter', mode = 'markers',
                marker = list(size = 15, color = 'red', symbol = 'star'), name = 'Your Stock') %>%
      layout(title = "Security Market Line (SML)",
             xaxis = list(title = "Beta (β)"),
             yaxis = list(title = "Expected Return (%)"))
  })
  
  output$beta_interpretation <- renderUI({
    risk_level <- if(input$beta_capm < 0) {
      "hedge asset (moves opposite to market)"
    } else if(input$beta_capm < 0.8) {
      "defensive (low risk)"
    } else if(input$beta_capm <= 1.2) {
      "neutral (market-level risk)"
    } else {
      "aggressive (high risk)"
    }
    
    beta_explanation <- if(input$beta_capm > 1) {
      paste0("When the market moves 1%, this stock is expected to move ", round(input$beta_capm, 2), "%.")
    } else if(input$beta_capm < 1 && input$beta_capm > 0) {
      paste0("When the market moves 1%, this stock is expected to move only ", round(input$beta_capm, 2), "%.")
    } else {
      "This stock has unusual characteristics relative to the market."
    }
    
    HTML(paste0(
      "<div class='example-box'>",
      "<h4>Beta Interpretation:</h4>",
      "<p><strong>Beta = ", input$beta_capm, "</strong> indicates this stock is <strong>", risk_level, "</strong>.</p>",
      "<p>", beta_explanation, "</p>",
      "</div>"
    ))
  })
  
  # Tab 8: Efficient Frontier & CML
  frontier_data <- eventReactive(input$generate_frontier, {
    # Asset parameters
    returns <- c(input$asset_a_ret_ef, input$asset_b_ret_ef, input$asset_c_ret_ef)
    sds <- c(input$asset_a_sd_ef, input$asset_b_sd_ef, input$asset_c_sd_ef)
    rho <- input$avg_correlation_ef
    rf <- input$rf_ef
    
    # Correlation matrix (simplified - using average correlation)
    cor_matrix <- matrix(c(
      1, rho, rho,
      rho, 1, rho,
      rho, rho, 1
    ), nrow = 3)
    
    # Generate 500 random portfolios
    n_portfolios <- 500
    port_returns <- numeric(n_portfolios)
    port_risks <- numeric(n_portfolios)
    port_weights <- matrix(0, nrow = n_portfolios, ncol = 3)
    
    set.seed(123)  # For reproducibility
    for(i in 1:n_portfolios) {
      # Random weights
      w <- runif(3)
      w <- w / sum(w)  # Normalize to sum to 1
      port_weights[i, ] <- w
      
      # Portfolio return
      port_returns[i] <- sum(w * returns)
      
      # Portfolio variance
      variance <- sum(w^2 * sds^2)
      for(j in 1:2) {
        for(k in (j+1):3) {
          variance <- variance + 2 * w[j] * w[k] * cor_matrix[j,k] * sds[j] * sds[k]
        }
      }
      port_risks[i] <- sqrt(variance)
    }
    
    # Find minimum variance portfolio
    min_var_idx <- which.min(port_risks)
    
    # Identify efficient frontier (upper part of the feasible set)
    # For each risk level, find max return
    risk_levels <- seq(min(port_risks), max(port_risks), length.out = 100)
    efficient_returns <- sapply(risk_levels, function(r) {
      candidates <- which(abs(port_risks - r) < 0.5)
      if(length(candidates) > 0) max(port_returns[candidates]) else NA
    })
    
    # Find tangency portfolio (max Sharpe ratio)
    sharpe_ratios <- (port_returns - rf) / port_risks
    tangency_idx <- which.max(sharpe_ratios)
    tangency_return <- port_returns[tangency_idx]
    tangency_risk <- port_risks[tangency_idx]
    tangency_sharpe <- sharpe_ratios[tangency_idx]
    tangency_weights <- port_weights[tangency_idx, ]
    
    # CML line coordinates (from Rf to beyond tangency)
    cml_risks <- seq(0, max(port_risks), length.out = 100)
    cml_returns <- rf + tangency_sharpe * cml_risks
    
    list(
      port_returns = port_returns,
      port_risks = port_risks,
      port_weights = port_weights,
      min_var_idx = min_var_idx,
      efficient_risks = risk_levels,
      efficient_returns = efficient_returns,
      individual_returns = returns,
      individual_risks = sds,
      rf = rf,
      tangency_idx = tangency_idx,
      tangency_return = tangency_return,
      tangency_risk = tangency_risk,
      tangency_sharpe = tangency_sharpe,
      tangency_weights = tangency_weights,
      cml_risks = cml_risks,
      cml_returns = cml_returns
    )
  })
  
  # Plot 1: Feasible Set only
  output$feasible_set_plot <- renderPlotly({
    data <- frontier_data()
    
    plot_ly() %>%
      # All portfolios (feasible set)
      add_trace(x = data$port_risks, y = data$port_returns, 
                type = 'scatter', mode = 'markers',
                marker = list(size = 5, color = 'gray', opacity = 0.6),
                name = 'Feasible Portfolios',
                hovertemplate = 'Risk: %{x:.2f}%<br>Return: %{y:.2f}%<extra></extra>') %>%
      # Individual assets
      add_trace(x = data$individual_risks, y = data$individual_returns,
                type = 'scatter', mode = 'markers+text',
                marker = list(size = 15, color = c('red', 'green', 'purple')),
                text = c('A', 'B', 'C'),
                textposition = 'top center',
                name = 'Individual Assets') %>%
      # Minimum variance portfolio
      add_trace(x = data$port_risks[data$min_var_idx], 
                y = data$port_returns[data$min_var_idx],
                type = 'scatter', mode = 'markers',
                marker = list(size = 20, color = 'gold', symbol = 'star'),
                name = 'Min Variance',
                hovertemplate = 'MVP<br>Risk: %{x:.2f}%<br>Return: %{y:.2f}%<extra></extra>') %>%
      layout(title = "Feasible Set of Portfolios",
             xaxis = list(title = "Risk (Standard Deviation %)"),
             yaxis = list(title = "Expected Return (%)"),
             hovermode = 'closest',
             showlegend = TRUE)
  })
  
  # Plot 2: Efficient Frontier highlighted
  output$efficient_frontier_plot <- renderPlotly({
    data <- frontier_data()
    
    plot_ly() %>%
      # Inefficient portfolios (faded)
      add_trace(x = data$port_risks, y = data$port_returns, 
                type = 'scatter', mode = 'markers',
                marker = list(size = 4, color = 'lightgray', opacity = 0.3),
                name = 'Inefficient Portfolios',
                hovertemplate = 'Risk: %{x:.2f}%<br>Return: %{y:.2f}%<extra></extra>') %>%
      # Efficient frontier line (BOLD)
      add_trace(x = data$efficient_risks, y = data$efficient_returns,
                type = 'scatter', mode = 'lines',
                line = list(color = 'blue', width = 4),
                name = 'Efficient Frontier') %>%
      # Individual assets
      add_trace(x = data$individual_risks, y = data$individual_returns,
                type = 'scatter', mode = 'markers+text',
                marker = list(size = 15, color = c('red', 'green', 'purple')),
                text = c('A', 'B', 'C'),
                textposition = 'top center',
                name = 'Individual Assets') %>%
      # Minimum variance portfolio
      add_trace(x = data$port_risks[data$min_var_idx], 
                y = data$port_returns[data$min_var_idx],
                type = 'scatter', mode = 'markers',
                marker = list(size = 20, color = 'gold', symbol = 'star'),
                name = 'Min Variance Portfolio',
                hovertemplate = 'MVP<br>Risk: %{x:.2f}%<br>Return: %{y:.2f}%<extra></extra>') %>%
      layout(title = "Efficient Frontier: Maximum Return for Each Risk Level",
             xaxis = list(title = "Risk (Standard Deviation %)"),
             yaxis = list(title = "Expected Return (%)"),
             hovermode = 'closest',
             showlegend = TRUE)
  })
  
  # Plot 3: Capital Market Line
  output$cml_plot <- renderPlotly({
    data <- frontier_data()
    
    # Sample down portfolios for better performance (500 → 150)
    sample_indices <- seq(1, length(data$port_risks), length.out = min(150, length(data$port_risks)))
    
    plot_ly() %>%
      # LENDING ZONE - Vertical background rectangle (left of market)
      add_trace(
        x = c(0, data$tangency_risk, data$tangency_risk, 0),
        y = c(max(data$cml_returns) * 1.05, max(data$cml_returns) * 1.05, 
              min(data$port_returns) * 0.95, min(data$port_returns) * 0.95),
        type = 'scatter', mode = 'none', fill = 'toself',
        fillcolor = 'rgba(135, 206, 250, 0.12)',  # Light sky blue - subtle
        name = 'Lending Zone',
        showlegend = TRUE,
        hoverinfo = 'text',
        text = '<b>Lending Zone</b><br>Mix Rf + Market<br>(Conservative Investors)',
        line = list(width = 0)
      ) %>%
      # BORROWING ZONE - Vertical background rectangle (right of market)
      add_trace(
        x = c(data$tangency_risk, max(data$cml_risks), max(data$cml_risks), data$tangency_risk),
        y = c(max(data$cml_returns) * 1.05, max(data$cml_returns) * 1.05, 
              min(data$port_returns) * 0.95, min(data$port_returns) * 0.95),
        type = 'scatter', mode = 'none', fill = 'toself',
        fillcolor = 'rgba(255, 200, 124, 0.15)',  # Light peach/orange - subtle
        name = 'Borrowing Zone',
        showlegend = TRUE,
        hoverinfo = 'text',
        text = '<b>Borrowing Zone</b><br>Leveraged Market<br>(Aggressive Investors)',
        line = list(width = 0)
      ) %>%
      # Inefficient portfolios (reduced & faded for performance)
      add_trace(x = data$port_risks[sample_indices], 
                y = data$port_returns[sample_indices], 
                type = 'scatter', mode = 'markers',
                marker = list(size = 4, color = 'lightgray', opacity = 0.25),
                name = 'Feasible Set',
                showlegend = FALSE,
                hovertemplate = 'Risk: %{x:.2f}%<br>Return: %{y:.2f}%<extra></extra>') %>%
      # Efficient frontier line (background)
      add_trace(x = data$efficient_risks, y = data$efficient_returns,
                type = 'scatter', mode = 'lines',
                line = list(color = 'steelblue', width = 2, dash = 'dot'),
                name = 'Efficient Frontier',
                showlegend = TRUE) %>%
      # VERTICAL LINE at market risk (separating lending/borrowing)
      add_trace(
        x = c(data$tangency_risk, data$tangency_risk),
        y = c(min(data$port_returns), max(data$cml_returns)),
        type = 'scatter', mode = 'lines',
        line = list(color = 'gray', width = 1, dash = 'dash'),
        name = 'Market Risk (σm)',
        showlegend = FALSE,
        hoverinfo = 'skip'
      ) %>%
      # CML Line (DOMINANT - thicker for clarity)
      add_trace(x = data$cml_risks, y = data$cml_returns,
                type = 'scatter', mode = 'lines',
                line = list(color = 'red', width = 6),
                name = 'Capital Market Line',
                hovertemplate = 'CML<br>Risk: %{x:.2f}%<br>Expected Return: %{y:.2f}%<extra></extra>') %>%
      # Risk-free asset (larger marker)
      add_trace(x = 0, y = data$rf,
                type = 'scatter', mode = 'markers+text',
                marker = list(size = 20, color = 'green', symbol = 'diamond', line = list(width = 2, color = 'darkgreen')),
                text = ' Rf',
                textfont = list(size = 14, color = 'darkgreen'),
                textposition = 'right',
                name = 'Risk-Free Asset',
                hovertemplate = 'Risk-Free Asset<br>Risk: 0%<br>Return: %{y:.2f}%<extra></extra>') %>%
      # Market/Tangency portfolio (larger star)
      add_trace(x = data$tangency_risk, y = data$tangency_return,
                type = 'scatter', mode = 'markers+text',
                marker = list(size = 25, color = 'orange', symbol = 'star', line = list(width = 2, color = 'darkorange')),
                text = 'Market ',
                textfont = list(size = 14, color = 'darkorange'),
                textposition = 'top center',
                name = 'Market Portfolio',
                hovertemplate = 'Market Portfolio<br>Risk: %{x:.2f}%<br>Return: %{y:.2f}%<extra></extra>') %>%
      # EXAMPLE: Conservative investor (40% market)
      add_trace(x = data$tangency_risk * 0.4, 
                y = data$rf + data$tangency_sharpe * (data$tangency_risk * 0.4),
                type = 'scatter', mode = 'markers',
                marker = list(size = 12, color = 'blue', symbol = 'circle'),
                name = 'Example: Conservative',
                hovertemplate = 'Conservative Investor<br>40% Market + 60% Rf<br>Risk: %{x:.2f}%<br>Return: %{y:.2f}%<extra></extra>') %>%
      # EXAMPLE: Aggressive investor (130% market - leveraged)
      add_trace(x = data$tangency_risk * 1.3, 
                y = data$rf + data$tangency_sharpe * (data$tangency_risk * 1.3),
                type = 'scatter', mode = 'markers',
                marker = list(size = 12, color = 'darkred', symbol = 'diamond'),
                name = 'Example: Aggressive',
                hovertemplate = 'Aggressive Investor<br>130% Market (30% borrowed)<br>Risk: %{x:.2f}%<br>Return: %{y:.2f}%<extra></extra>') %>%
      # Annotations for zones
      add_annotations(
        x = data$tangency_risk * 0.5,
        y = max(data$cml_returns) * 0.85,
        text = "<b>LENDING</b><br>at Rf",
        showarrow = FALSE,
        font = list(size = 13, color = 'steelblue'),
        xanchor = 'center'
      ) %>%
      add_annotations(
        x = data$tangency_risk * 1.5,
        y = max(data$cml_returns) * 0.85,
        text = "<b>BORROWING</b><br>at Rf",
        showarrow = FALSE,
        font = list(size = 13, color = 'darkorange'),
        xanchor = 'center'
      ) %>%
      layout(
        title = list(
          text = "<b>Capital Market Line: Optimal Portfolios with Risk-Free Asset</b>",
          font = list(size = 18)
        ),
        xaxis = list(
          title = list(text = "<b>Risk (Standard Deviation %)</b>", font = list(size = 14)),
          range = c(0, max(data$cml_risks)),
          tickfont = list(size = 12)
        ),
        yaxis = list(
          title = list(text = "<b>Expected Return (%)</b>", font = list(size = 14)),
          tickfont = list(size = 12)
        ),
        hovermode = 'closest',
        showlegend = TRUE,
        legend = list(
          x = 0.02, y = 0.98,
          bgcolor = 'rgba(255, 255, 255, 0.8)',
          bordercolor = 'gray',
          borderwidth = 1,
          font = list(size = 11)
        ),
        # ENABLE FULLSCREEN AND TOOLS
        modebar = list(
          orientation = 'v',
          bgcolor = 'rgba(255, 255, 255, 0.7)'
        ),
        height = 650  # Increased height for better visibility
      ) %>%
      config(
        displayModeBar = TRUE,
        modeBarButtonsToAdd = list('toggleSpikelines'),
        displaylogo = FALSE,
        toImageButtonOptions = list(
          format = 'png',
          filename = 'CML_plot',
          height = 800,
          width = 1200,
          scale = 2
        )
      )
  })
  
  # CML Value Boxes
  output$tangency_return_box <- renderValueBox({
    data <- frontier_data()
    valueBox(
      paste0(round(data$tangency_return, 2), "%"),
      "Market Portfolio Return",
      icon = icon("bullseye"),
      color = "orange"
    )
  })
  
  output$tangency_risk_box <- renderValueBox({
    data <- frontier_data()
    valueBox(
      paste0(round(data$tangency_risk, 2), "%"),
      "Market Portfolio Risk",
      icon = icon("chart-line"),
      color = "orange"
    )
  })
  
  output$cml_slope_box <- renderValueBox({
    data <- frontier_data()
    valueBox(
      round(data$tangency_sharpe, 3),
      "Market Sharpe Ratio (CML Slope)",
      icon = icon("angle-up"),
      color = "red"
    )
  })
  
  # Optimal Portfolio Selection
  optimal_portfolio <- eventReactive(input$find_optimal, {
    data <- frontier_data()
    target_risk <- input$risk_tolerance_ef
    
    # Calculate optimal allocation on CML
    # If target_risk < tangency_risk: Lend (mix Rf + Market)
    # If target_risk = tangency_risk: 100% Market
    # If target_risk > tangency_risk: Borrow (leverage Market)
    
    weight_market <- target_risk / data$tangency_risk
    weight_rf <- 1 - weight_market
    
    expected_return <- data$rf + data$tangency_sharpe * target_risk
    
    allocation_type <- if(weight_market < 1) {
      "CONSERVATIVE (Lending Position)"
    } else if(abs(weight_market - 1) < 0.01) {
      "MODERATE (100% Market Portfolio)"
    } else {
      "AGGRESSIVE (Borrowing Position)"
    }
    
    list(
      target_risk = target_risk,
      expected_return = expected_return,
      weight_market = weight_market,
      weight_rf = weight_rf,
      allocation_type = allocation_type,
      tangency_weights = data$tangency_weights
    )
  })
  
  output$optimal_return_box <- renderValueBox({
    opt <- optimal_portfolio()
    valueBox(
      paste0(round(opt$expected_return, 2), "%"),
      "Your Expected Return",
      icon = icon("chart-line"),
      color = "blue"
    )
  })
  
  output$optimal_risk_box <- renderValueBox({
    opt <- optimal_portfolio()
    valueBox(
      paste0(round(opt$target_risk, 2), "%"),
      "Your Portfolio Risk",
      icon = icon("exclamation-triangle"),
      color = "yellow"
    )
  })
  
  output$optimal_allocation_type <- renderUI({
    opt <- optimal_portfolio()
    
    color <- if(grepl("CONSERVATIVE", opt$allocation_type)) {
      "info"
    } else if(grepl("MODERATE", opt$allocation_type)) {
      "success"
    } else {
      "danger"
    }
    
    allocation_details <- if(opt$weight_market < 1) {
      paste0(
        "<p><strong>Allocation:</strong></p>",
        "<ul>",
        "<li>", round(opt$weight_rf * 100, 1), "% in Risk-Free Asset (T-bills)</li>",
        "<li>", round(opt$weight_market * 100, 1), "% in Market Portfolio</li>",
        "</ul>",
        "<p><strong>Market Portfolio consists of:</strong></p>",
        "<ul>",
        "<li>", round(opt$tangency_weights[1] * 100, 1), "% Asset A</li>",
        "<li>", round(opt$tangency_weights[2] * 100, 1), "% Asset B</li>",
        "<li>", round(opt$tangency_weights[3] * 100, 1), "% Asset C</li>",
        "</ul>"
      )
    } else if(abs(opt$weight_market - 1) < 0.01) {
      paste0(
        "<p><strong>Allocation:</strong></p>",
        "<ul>",
        "<li>100% in Market Portfolio</li>",
        "</ul>",
        "<p><strong>Market Portfolio consists of:</strong></p>",
        "<ul>",
        "<li>", round(opt$tangency_weights[1] * 100, 1), "% Asset A</li>",
        "<li>", round(opt$tangency_weights[2] * 100, 1), "% Asset B</li>",
        "<li>", round(opt$tangency_weights[3] * 100, 1), "% Asset C</li>",
        "</ul>"
      )
    } else {
      paste0(
        "<p><strong>Allocation:</strong></p>",
        "<ul>",
        "<li>Borrow ", round(abs(opt$weight_rf) * 100, 1), "% at risk-free rate</li>",
        "<li>Invest ", round(opt$weight_market * 100, 1), "% in Market Portfolio (leveraged)</li>",
        "</ul>",
        "<p><strong>Market Portfolio consists of:</strong></p>",
        "<ul>",
        "<li>", round(opt$tangency_weights[1] * 100, 1), "% Asset A</li>",
        "<li>", round(opt$tangency_weights[2] * 100, 1), "% Asset B</li>",
        "<li>", round(opt$tangency_weights[3] * 100, 1), "% Asset C</li>",
        "</ul>",
        "<p style='color: red;'><strong>Warning:</strong> Leveraged positions amplify both gains and losses.</p>"
      )
    }
    
    HTML(paste0(
      "<div class='alert alert-", color, "'>",
      "<h4>", opt$allocation_type, "</h4>",
      allocation_details,
      "</div>"
    ))
  })
  
  output$frontier_explanation <- renderUI({
    data <- frontier_data()
    
    HTML(paste0(
      "<div class='example-box'>",
      "<h5>Key Statistics:</h5>",
      "<p><strong>Minimum Variance Portfolio:</strong> ", 
      round(data$port_risks[data$min_var_idx], 2), "% risk, ",
      round(data$port_returns[data$min_var_idx], 2), "% return</p>",
      "<p><strong>Market Portfolio (Tangency):</strong> ",
      round(data$tangency_risk, 2), "% risk, ",
      round(data$tangency_return, 2), "% return</p>",
      "<p><strong>Market Sharpe Ratio:</strong> ", round(data$tangency_sharpe, 3), "</p>",
      "</div>"
    ))
  })
  
  # Evaluate custom portfolio
  output$total_weight_ef_box <- renderValueBox({
    total <- input$weight_a_ef + input$weight_b_ef + input$weight_c_ef
    color <- if(total == 100) "green" else "red"
    
    valueBox(
      paste0(total, "%"),
      "Total Weight",
      icon = (if(total == 100) icon("check-circle") else icon("exclamation-triangle")),
      color = color
    )
  })
  
  my_portfolio_results <- eventReactive(input$evaluate_portfolio, {
    req(input$weight_a_ef + input$weight_b_ef + input$weight_c_ef == 100)
    
    w <- c(input$weight_a_ef, input$weight_b_ef, input$weight_c_ef) / 100
    returns <- c(input$asset_a_ret_ef, input$asset_b_ret_ef, input$asset_c_ret_ef)
    sds <- c(input$asset_a_sd_ef, input$asset_b_sd_ef, input$asset_c_sd_ef)
    rho <- input$avg_correlation_ef
    
    # Portfolio return
    port_return <- sum(w * returns)
    
    # Portfolio variance
    variance <- sum(w^2 * sds^2)
    variance <- variance + 2 * w[1] * w[2] * rho * sds[1] * sds[2]
    variance <- variance + 2 * w[1] * w[3] * rho * sds[1] * sds[3]
    variance <- variance + 2 * w[2] * w[3] * rho * sds[2] * sds[3]
    
    port_risk <- sqrt(variance)
    
    # Check if efficient (simplified check)
    data <- frontier_data()
    # Find portfolios with similar risk
    similar_risk <- which(abs(data$port_risks - port_risk) < 1)
    if(length(similar_risk) > 0) {
      max_return_at_risk <- max(data$port_returns[similar_risk])
      is_efficient <- port_return >= (max_return_at_risk - 0.5)
    } else {
      is_efficient <- FALSE
    }
    
    list(
      return = port_return,
      risk = port_risk,
      is_efficient = is_efficient,
      weights = w
    )
  })
  
  output$my_port_return_box <- renderValueBox({
    results <- my_portfolio_results()
    valueBox(
      paste0(round(results$return, 2), "%"),
      "Expected Return",
      icon = icon("arrow-trend-up"),
      color = "green"
    )
  })
  
  output$my_port_risk_box <- renderValueBox({
    results <- my_portfolio_results()
    valueBox(
      paste0(round(results$risk, 2), "%"),
      "Portfolio Risk",
      icon = icon("chart-line"),
      color = "orange"
    )
  })
  
  output$efficiency_verdict <- renderUI({
    results <- my_portfolio_results()
    
    if(results$is_efficient) {
      HTML("<div class='example-box' style='background-color: #c8e6c9;'>
            <h5 style='color: green;'>✅ EFFICIENT PORTFOLIO</h5>
            <p>Your portfolio lies on or near the efficient frontier. Well done!</p>
            </div>")
    } else {
      HTML("<div class='example-box' style='background-color: #ffcdd2;'>
            <h5 style='color: red;'>⚠️ INEFFICIENT PORTFOLIO</h5>
            <p>Your portfolio is below the efficient frontier. You can achieve higher return for the same risk!</p>
            </div>")
    }
  })
  
  output$improvement_suggestion <- renderUI({
    results <- my_portfolio_results()
    
    if(!results$is_efficient) {
      HTML(paste0(
        "<div class='formula-box'>",
        "<h5>Improvement Suggestions:</h5>",
        "<p>To improve your portfolio, consider:</p>",
        "<ul>",
        "<li>Reducing allocation to the highest-risk asset</li>",
        "<li>Increasing diversification across all three assets</li>",
        "<li>Using the efficient frontier visualization to find better combinations</li>",
        "</ul>",
        "</div>"
      ))
    } else {
      HTML("<p><em>Your portfolio is already efficient. The choice now depends on your risk tolerance.</em></p>")
    }
  })
  
  # Tab 12: Quiz System (previously Tab 8, now Tab 12)
  get_quiz_questions <- function(difficulty) {
    if(difficulty == "Beginner - Return Basics") {
      list(
        list(
          q = "If you buy a stock for Rs. 100, sell it for Rs. 120, and receive Rs. 5 in dividends, what is your total return?",
          opts = c("20%", "25%", "15%", "30%"),
          correct = 2,
          explanation = "Total Return = [(120-100+5)/100] × 100% = 25%"
        ),
        list(
          q = "Which component represents the change in stock price?",
          opts = c("Dividend yield", "Capital gain", "Interest rate", "Beta"),
          correct = 2,
          explanation = "Capital gain (or loss) represents the change in the price of the asset."
        ),
        list(
          q = "What is the dividend yield if you receive Rs. 8 dividend on a Rs. 200 stock?",
          opts = c("2%", "4%", "8%", "16%"),
          correct = 2,
          explanation = "Dividend Yield = (8/200) × 100% = 4%"
        ),
        list(
          q = "Historical returns represent:",
          opts = c("Future expectations", "Past actual performance", "Risk-free returns", "Market predictions"),
          correct = 2,
          explanation = "Historical (realized) returns are actual returns earned in the past."
        ),
        list(
          q = "Expected return is calculated using:",
          opts = c("Only historical data", "Probability-weighted scenarios", "Current stock price only", "Risk-free rate only"),
          correct = 2,
          explanation = "Expected return = Σ(Probability × Return) for all scenarios."
        ),
        list(
          q = "If returns over 3 years are 10%, 20%, and -5%, what is the arithmetic mean?",
          opts = c("8.33%", "10%", "25%", "7.5%"),
          correct = 1,
          explanation = "Arithmetic Mean = (10+20-5)/3 = 25/3 = 8.33%"
        ),
        list(
          q = "The geometric mean is most appropriate for:",
          opts = c("Single period returns", "Multi-period actual performance", "Averaging ratios", "Risk measurement"),
          correct = 2,
          explanation = "Geometric mean shows the actual compound average return over multiple periods."
        ),
        list(
          q = "Which is always true about arithmetic and geometric means?",
          opts = c("They are always equal", "Geometric ≤ Arithmetic", "Arithmetic < Geometric", "No relationship"),
          correct = 2,
          explanation = "Geometric mean is always ≤ arithmetic mean, with equality only when all returns are identical."
        ),
        list(
          q = "Standard deviation measures:",
          opts = c("Average return", "Return volatility/risk", "Maximum return", "Minimum return"),
          correct = 2,
          explanation = "Standard deviation measures the dispersion or volatility of returns around the mean."
        ),
        list(
          q = "A portfolio return is calculated as:",
          opts = c("Simple average of all assets", "Weighted average based on investment proportions", "Sum of all returns", "Highest individual return"),
          correct = 2,
          explanation = "Portfolio return = Σ(Weight × Return) for each asset in the portfolio."
        )
      )
    } else if(difficulty == "Intermediate - Risk Measures") {
      list(
        list(
          q = "If E(R) = 12%, σ = 20%, what is the coefficient of variation?",
          opts = c("1.67", "0.60", "32%", "2.40"),
          correct = 1,
          explanation = "CV = σ/E(R) = 20/12 = 1.67"
        ),
        list(
          q = "The Sharpe ratio measures:",
          opts = c("Total return", "Risk-adjusted excess return", "Only risk", "Dividend yield"),
          correct = 2,
          explanation = "Sharpe Ratio = (Return - Risk-free Rate) / Standard Deviation"
        ),
        list(
          q = "If Rf=5%, E(R)=15%, σ=25%, what is the Sharpe ratio?",
          opts = c("0.40", "0.60", "0.20", "1.00"),
          correct = 1,
          explanation = "Sharpe = (15-5)/25 = 10/25 = 0.40"
        ),
        list(
          q = "Variance is measured in:",
          opts = c("Percentage points", "Squared percentage points", "Dollars", "Ratio form"),
          correct = 2,
          explanation = "Variance = average squared deviation, so it's in squared units."
        ),
        list(
          q = "For two assets with ρ=+1, diversification benefit is:",
          opts = c("Maximum", "Moderate", "None", "Negative"),
          correct = 3,
          explanation = "Perfect positive correlation (ρ=+1) means no diversification benefit."
        ),
        list(
          q = "Portfolio variance depends on:",
          opts = c("Weights and individual variances only", "Weights, variances, and correlations", "Only correlations", "Only individual variances"),
          correct = 2,
          explanation = "Portfolio variance = f(weights, individual variances, correlations/covariances)."
        ),
        list(
          q = "If two assets have ρ=-1, portfolio risk can be:",
          opts = c("Completely eliminated with proper weights", "Only reduced slightly", "Never reduced", "Doubled"),
          correct = 1,
          explanation = "Perfect negative correlation allows complete risk elimination with appropriate weights."
        ),
        list(
          q = "The range of returns measures:",
          opts = c("Average return", "Best minus worst outcome", "Standard deviation", "Correlation"),
          correct = 2,
          explanation = "Range = Maximum Return - Minimum Return"
        ),
        list(
          q = "Expected return with 30% prob of 20% return and 70% prob of 10% return is:",
          opts = c("15%", "13%", "12%", "10%"),
          correct = 2,
          explanation = "E(R) = 0.30(20%) + 0.70(10%) = 6% + 7% = 13%"
        ),
        list(
          q = "Lower coefficient of variation indicates:",
          opts = c("Higher risk per unit of return", "Better risk-adjusted performance", "Higher total risk", "Lower returns"),
          correct = 2,
          explanation = "Lower CV = less risk per unit of return = better risk-adjusted performance."
        )
      )
    } else { # Advanced
      list(
        list(
          q = "What defines an efficient portfolio?",
          opts = c("Highest return only", "Lowest risk only", "Maximum return for given risk OR minimum risk for given return", "Equal weights in all assets"),
          correct = 3,
          explanation = "Efficient portfolios lie on the efficient frontier - they offer the best risk-return tradeoff."
        ),
        list(
          q = "A portfolio below the efficient frontier is:",
          opts = c("Optimal", "Dominated", "Efficient", "On the CML"),
          correct = 2,
          explanation = "Portfolios below the frontier are dominated - you can achieve better risk-return combinations."
        ),
        list(
          q = "The minimum variance portfolio is:",
          opts = c("Always optimal", "Leftmost point on efficient frontier", "Has zero risk", "Same as market portfolio"),
          correct = 2,
          explanation = "MVP is the leftmost point on the frontier - lowest possible risk from available assets."
        ),
        list(
          q = "The Capital Market Line (CML) shows portfolios combining:",
          opts = c("Two risky assets", "Risk-free asset and market portfolio", "Only risky assets", "Three or more assets"),
          correct = 2,
          explanation = "CML consists of combinations of the risk-free asset and the market (tangency) portfolio."
        ),
        list(
          q = "The slope of the CML equals:",
          opts = c("Beta of market", "Risk-free rate", "Market Sharpe ratio", "Market return"),
          correct = 3,
          explanation = "CML slope = (E(Rm)-Rf)/σm = Market Sharpe ratio"
        ),
        list(
          q = "Which portfolio represents the tangency point on the CML?",
          opts = c("Minimum variance portfolio", "Risk-free asset", "Market portfolio", "Any efficient portfolio"),
          correct = 3,
          explanation = "The market (tangency) portfolio is where CML touches the efficient frontier."
        ),
        list(
          q = "An investor on the CML with σp < σm is:",
          opts = c("Borrowing", "Lending (investing in risk-free asset)", "100% in market", "Leveraged"),
          correct = 2,
          explanation = "Risk below market means mixing risk-free asset with market portfolio (lending position)."
        ),
        list(
          q = "Tobin's Separation Theorem states that:",
          opts = c("All investors hold different portfolios", "Investment decision is separate from financing decision", "Risk cannot be separated", "Returns equal risk"),
          correct = 2,
          explanation = "All investors hold the same risky portfolio; they differ only in their mix with the risk-free asset."
        ),
        list(
          q = "CML applies to:",
          opts = c("All assets", "Only efficient portfolios", "Individual stocks", "Bonds only"),
          correct = 2,
          explanation = "CML only applies to efficient portfolios. Individual assets plot below CML due to unsystematic risk."
        ),
        list(
          q = "The main difference between CML and SML is:",
          opts = c("CML uses total risk, SML uses beta", "They are the same", "CML is for stocks, SML is for bonds", "SML uses correlation"),
          correct = 1,
          explanation = "CML uses total risk (σ) and applies to efficient portfolios; SML uses systematic risk (β) and applies to all assets."
        ),
        list(
          q = "According to CAPM, what determines required return?",
          opts = c("Total risk (σ)", "Systematic risk (β)", "Unsystematic risk", "Historical returns"),
          correct = 2,
          explanation = "CAPM: E(R) = Rf + β[E(Rm)-Rf]. Only systematic risk (beta) is priced."
        ),
        list(
          q = "If Rf=5%, Rm=12%, β=1.5, what is required return?",
          opts = c("15.5%", "18%", "13.5%", "12%"),
          correct = 1,
          explanation = "E(R) = 5% + 1.5(12%-5%) = 5% + 1.5(7%) = 5% + 10.5% = 15.5%"
        ),
        list(
          q = "A stock with β=0.7 is considered:",
          opts = c("Aggressive", "Defensive", "Neutral", "Risk-free"),
          correct = 2,
          explanation = "β < 1 indicates defensive stock - less volatile than market."
        ),
        list(
          q = "The Security Market Line (SML) plots:",
          opts = c("Total risk vs return", "Beta vs required return", "Variance vs return", "Time vs price"),
          correct = 2,
          explanation = "SML shows the linear relationship between beta (systematic risk) and required return."
        ),
        list(
          q = "Market portfolio has a beta of:",
          opts = c("0", "0.5", "1.0", "2.0"),
          correct = 3,
          explanation = "By definition, the market portfolio has β = 1.0."
        ),
        list(
          q = "If a stock plots above the SML, it is:",
          opts = c("Overpriced", "Underpriced", "Fairly priced", "Risk-free"),
          correct = 2,
          explanation = "Above SML means expected return > required return → underpriced (buy)."
        ),
        list(
          q = "Unsystematic risk can be reduced by:",
          opts = c("Increasing beta", "Diversification", "Leverage", "Cannot be reduced"),
          correct = 2,
          explanation = "Unsystematic (company-specific) risk is reduced through diversification."
        ),
        list(
          q = "The market risk premium is:",
          opts = c("Rf", "E(Rm)", "E(Rm) - Rf", "β × E(Rm)"),
          correct = 3,
          explanation = "Market Risk Premium = E(Rm) - Rf"
        ),
        list(
          q = "Covariance between two assets equals:",
          opts = c("ρ only", "σ₁σ₂ only", "ρσ₁σ₂", "ρ + σ₁σ₂"),
          correct = 3,
          explanation = "Covariance = Correlation × σ₁ × σ₂ = ρσ₁σ₂"
        ),
        list(
          q = "Which assumption is NOT part of CAPM?",
          opts = c("Investors are rational", "Markets are perfect", "All investors have same holding period", "Returns follow exponential distribution"),
          correct = 4,
          explanation = "CAPM assumes normally distributed returns, not exponential."
        )
      )
    }
  }
  
  observeEvent(input$start_quiz_btn, {
    quiz_rv$started <- TRUE
    quiz_rv$current <- 1
    quiz_rv$score <- 0
    quiz_rv$answered <- FALSE
    quiz_rv$selected <- NULL
    quiz_rv$questions <- get_quiz_questions(input$quiz_difficulty)
  })
  
  observeEvent(input$next_quiz_btn, {
    if(quiz_rv$current < quiz_rv$total) {
      quiz_rv$current <- quiz_rv$current + 1
      quiz_rv$answered <- FALSE
      quiz_rv$selected <- NULL
    }
  })
  
  output$quiz_ui <- renderUI({
    if(!quiz_rv$started) {
      return(div(
        h4("Ready to test your knowledge?"),
        p("Select a difficulty level and click 'Start Quiz' to begin!")
      ))
    }
    
    if(quiz_rv$current > quiz_rv$total) {
      pct <- round(quiz_rv$score/quiz_rv$total * 100, 1)
      
      feedback_msg <- if(pct >= 80) {
        p(strong("Excellent! You've mastered this topic."), style="color: green;")
      } else if(pct >= 60) {
        p(strong("Good work! Review the areas you missed."), style="color: blue;")
      } else {
        p(strong("Keep studying! Go through the learning modules again."), style="color: orange;")
      }
      
      return(div(
        h3("Quiz Complete! 🎉"),
        h4(paste0("Final Score: ", quiz_rv$score, "/", quiz_rv$total, " (", pct, "%)")),
        feedback_msg,
        actionButton("restart_quiz", "Take Quiz Again", class = "btn-success")
      ))
    }
    
    q <- quiz_rv$questions[[quiz_rv$current]]
    
    option_divs <- lapply(1:length(q$opts), function(i) {
      btn_class <- ""
      if(quiz_rv$answered) {
        if(i == q$correct) btn_class <- "correct"
        else if(i == quiz_rv$selected) btn_class <- "incorrect"
      }
      
      div(
        class = paste("quiz-option", btn_class),
        onclick = (if(!quiz_rv$answered) sprintf("Shiny.setInputValue('quiz_answer', %d, {priority: 'event'})", i) else ""),
        strong(LETTERS[i], ") "), q$opts[i]
      )
    })
    
    div(
      h4(paste0("Question ", quiz_rv$current, " of ", quiz_rv$total)),
      h5(q$q),
      option_divs,
      if(quiz_rv$answered) {
        div(style = "margin-top: 20px; padding: 15px; background-color: #e8f5e9; border-radius: 5px;",
            h5((if(quiz_rv$selected == q$correct) "✓ Correct!" else "✗ Incorrect")),
            p(strong("Explanation: "), q$explanation))
      }
    )
  })
  
  observeEvent(input$quiz_answer, {
    if(!quiz_rv$answered) {
      quiz_rv$selected <- input$quiz_answer
      quiz_rv$answered <- TRUE
      
      if(quiz_rv$selected == quiz_rv$questions[[quiz_rv$current]]$correct) {
        quiz_rv$score <- quiz_rv$score + 1
      }
    }
  })
  
  observeEvent(input$restart_quiz, {
    quiz_rv$started <- FALSE
    quiz_rv$current <- 1
    quiz_rv$score <- 0
    quiz_rv$answered <- FALSE
    quiz_rv$selected <- NULL
  })
  
  output$quiz_score_box <- renderValueBox({
    valueBox(
      paste0(quiz_rv$score, " / ", quiz_rv$total),
      "Score",
      icon = icon("trophy"),
      color = "green"
    )
  })
  
  output$quiz_progress_box <- renderValueBox({
    current <- min(quiz_rv$current, quiz_rv$total)
    valueBox(
      paste0(current, " / ", quiz_rv$total),
      "Progress",
      icon = icon("tasks"),
      color = "blue"
    )
  })
  
  output$quiz_accuracy_box <- renderValueBox({
    acc <- if(quiz_rv$current > 1) round(quiz_rv$score/(quiz_rv$current-1)*100, 1) else 0
    valueBox(
      paste0(acc, "%"),
      "Accuracy",
      icon = icon("percent"),
      color = "orange"
    )
  })
  
  # ==========================================================================
  # DOWNLOAD REPORTS
  # ==========================================================================
  
  output$download_portfolio_report <- downloadHandler(
    filename = function() {
      paste("Portfolio_Analysis_", Sys.Date(), ".html", sep = "")
    },
    content = function(file) {
      html_content <- paste0(
        "<!DOCTYPE html><html><head>",
        "<meta charset='UTF-8'>",
        "<style>",
        "body { font-family: Arial, sans-serif; margin: 40px; line-height: 1.6; }",
        "h1 { color: #2c3e50; border-bottom: 3px solid #3498db; padding-bottom: 10px; }",
        "h2 { color: #34495e; margin-top: 30px; }",
        ".result-box { background: #ecf0f1; padding: 15px; margin: 10px 0; border-radius: 5px; }",
        ".highlight { background: #3498db; color: white; padding: 5px 10px; border-radius: 3px; }",
        "table { border-collapse: collapse; width: 100%; margin: 20px 0; }",
        "th, td { border: 1px solid #bdc3c7; padding: 12px; text-align: left; }",
        "th { background: #3498db; color: white; }",
        "</style></head><body>",
        
        "<h1>Portfolio Analysis Report</h1>",
        "<p><strong>Generated:</strong> ", format(Sys.time(), "%Y-%m-%d %H:%M:%S"), "</p>",
        "<p><strong>Institution:</strong> South Eastern University of Sri Lanka</p>",
        "<hr>",
        
        "<h2>Portfolio Configuration</h2>",
        "<div class='result-box'>",
        "<p><strong>Asset A Weight:</strong> ", input$weight_a_port, "%</p>",
        "<p><strong>Asset B Weight:</strong> ", 100 - input$weight_a_port, "%</p>",
        "<p><strong>Correlation:</strong> ", input$correlation, "</p>",
        "</div>",
        "</body></html>"
      )
      
      writeLines(html_content, file)
    }
  )
  
  output$download_risk_report <- downloadHandler(
    filename = function() {
      paste("Risk_Analysis_", Sys.Date(), ".html", sep = "")
    },
    content = function(file) {
      html_content <- paste0(
        "<!DOCTYPE html><html><head>",
        "<style>",
        "body { font-family: Arial, sans-serif; margin: 40px; }",
        "h1 { color: #e74c3c; }",
        ".metric { background: #fadbd8; padding: 15px; margin: 10px 0; border-left: 5px solid #e74c3c; }",
        "</style></head><body>",
        
        "<h1>Risk Metrics Analysis Report</h1>",
        "<p><strong>Date:</strong> ", format(Sys.Date(), "%B %d, %Y"), "</p>",
        "<hr>",
        "<p>Risk analysis report generated from Risk and Return application.</p>",
        "</body></html>"
      )
      
      writeLines(html_content, file)
    }
  )
  
  output$download_capm_report <- downloadHandler(
    filename = function() {
      paste("CAPM_Analysis_", Sys.Date(), ".html", sep = "")
    },
    content = function(file) {
      html_content <- paste0(
        "<!DOCTYPE html><html><head>",
        "<style>",
        "body { font-family: Arial, sans-serif; margin: 40px; }",
        "h1 { color: #27ae60; }",
        ".formula { background: #d5f4e6; padding: 20px; border-radius: 5px; font-size: 18px; }",
        "</style></head><body>",
        
        "<h1>CAPM Analysis Report</h1>",
        "<p><strong>Date:</strong> ", format(Sys.Date(), "%B %d, %Y"), "</p>",
        
        "<h2>Input Parameters</h2>",
        "<p><strong>Risk-Free Rate:</strong> ", input$rf_capm, "%</p>",
        "<p><strong>Market Return:</strong> ", input$rm_capm, "%</p>",
        "<p><strong>Beta (β):</strong> ", input$beta_capm, "</p>",
        "</body></html>"
      )
      
      writeLines(html_content, file)
    }
  )
  
  output$download_quiz_results <- downloadHandler(
    filename = function() {
      paste("Quiz_Results_", Sys.Date(), ".txt", sep = "")
    },
    content = function(file) {
      if(!quiz_rv$started || quiz_rv$current <= quiz_rv$total) {
        content <- "No quiz results available yet. Please complete a quiz first."
      } else {
        pct <- round(quiz_rv$score/quiz_rv$total * 100, 1)
        content <- paste0(
          "RISK AND RETURN QUIZ RESULTS\n",
          "=============================\n\n",
          "Date: ", format(Sys.Date(), "%B %d, %Y"), "\n",
          "Difficulty Level: ", input$quiz_difficulty, "\n\n",
          "Score: ", quiz_rv$score, " / ", quiz_rv$total, " (", pct, "%)\n\n",
          "Performance Rating: ",
          ifelse(pct >= 80, "Excellent! ⭐⭐⭐",
                 ifelse(pct >= 60, "Good! ⭐⭐", "Keep Practicing! ⭐")), "\n\n",
          "---\n",
          "Generated by Risk and Return Learning App\n",
          "South Eastern University of Sri Lanka"
        )
      }
      writeLines(content, file)
    }
  )
  
  output$download_all_csv <- downloadHandler(
    filename = function() {
      paste("All_Data_", Sys.Date(), ".csv", sep = "")
    },
    content = function(file) {
      data <- data.frame(
        Parameter = c(
          "Purchase Price", "Selling Price", "Dividend",
          "Weight Asset A", "Correlation", "Risk-Free Rate",
          "Market Return", "Beta"
        ),
        Value = c(
          input$buy_price, input$sell_price, input$dividend,
          input$weight_a_port, input$correlation, input$rf_capm,
          input$rm_capm, input$beta_capm
        ),
        stringsAsFactors = FALSE
      )
      write.csv(data, file, row.names = FALSE)
    }
  )
  
  # ==========================================================================
  # DATA IMPORT
  # ==========================================================================
  
  uploaded_data <- reactive({
    req(input$upload_csv)
    
    tryCatch({
      df <- read.csv(input$upload_csv$datapath, header = input$header_csv)
      
      if(ncol(df) < 2) {
        showNotification("CSV must have at least 2 columns (Date, Return)", type = "error")
        return(NULL)
      }
      
      names(df)[1:2] <- c("Date", "Return")
      df$Return <- as.numeric(df$Return)
      df
    }, error = function(e) {
      showNotification(paste("Error reading file:", e$message), type = "error")
      return(NULL)
    })
  })
  
  output$uploaded_data_preview <- renderDT({
    req(uploaded_data())
    datatable(head(uploaded_data(), 20), options = list(pageLength = 10))
  })
  
  output$upload_summary <- renderUI({
    req(uploaded_data())
    df <- uploaded_data()
    
    HTML(paste0(
      "<div class='formula-box'>",
      "<h4>Data Summary</h4>",
      "<p><strong>Total Observations:</strong> ", nrow(df), "</p>",
      "<p><strong>Date Range:</strong> ", df$Date[1], " to ", df$Date[nrow(df)], "</p>",
      "<p><strong>Data appears valid ✓</strong></p>",
      "</div>"
    ))
  })
  
  uploaded_stats <- eventReactive(input$analyze_uploaded, {
    req(uploaded_data())
    returns <- uploaded_data()$Return
    
    list(
      mean = mean(returns, na.rm = TRUE),
      sd = sd(returns, na.rm = TRUE),
      min = min(returns, na.rm = TRUE),
      max = max(returns, na.rm = TRUE),
      returns = returns
    )
  })
  
  output$uploaded_mean_box <- renderValueBox({
    stats <- uploaded_stats()
    valueBox(paste0(round(stats$mean, 2), "%"), "Average Return", icon = icon("chart-line"), color = "blue")
  })
  
  output$uploaded_sd_box <- renderValueBox({
    stats <- uploaded_stats()
    valueBox(paste0(round(stats$sd, 2), "%"), "Standard Deviation", icon = icon("wave-square"), color = "red")
  })
  
  output$uploaded_min_box <- renderValueBox({
    stats <- uploaded_stats()
    valueBox(paste0(round(stats$min, 2), "%"), "Minimum Return", icon = icon("arrow-down"), color = "orange")
  })
  
  output$uploaded_max_box <- renderValueBox({
    stats <- uploaded_stats()
    valueBox(paste0(round(stats$max, 2), "%"), "Maximum Return", icon = icon("arrow-up"), color = "green")
  })
  
  output$uploaded_data_plot <- renderPlotly({
    stats <- uploaded_stats()
    df <- uploaded_data()
    
    plot_ly() %>%
      add_trace(x = 1:length(stats$returns), y = stats$returns, 
                type = 'scatter', mode = 'lines+markers',
                line = list(color = 'steelblue', width = 2),
                marker = list(size = 6),
                name = 'Returns') %>%
      add_trace(x = c(1, length(stats$returns)), y = rep(stats$mean, 2),
                type = 'scatter', mode = 'lines',
                line = list(color = 'red', dash = 'dash', width = 2),
                name = 'Mean') %>%
      layout(title = "Historical Returns Over Time",
             xaxis = list(title = "Period"),
             yaxis = list(title = "Return (%)"))
  })
  
  # ==========================================================================
  # PORTFOLIO COMPARISON
  # ==========================================================================
  
  output$port1_total <- renderValueBox({
    total <- input$port1_stock_a + input$port1_stock_b + input$port1_stock_c
    color <- if(total == 100) "green" else "red"
    valueBox(paste0(total, "%"), "Total Weight", icon = icon("percent"), color = color)
  })
  
  output$port2_total <- renderValueBox({
    total <- input$port2_stock_a + input$port2_stock_b + input$port2_stock_c
    color <- if(total == 100) "green" else "red"
    valueBox(paste0(total, "%"), "Total Weight", icon = icon("percent"), color = color)
  })
  
  output$port3_total <- renderValueBox({
    total <- input$port3_stock_a + input$port3_stock_b + input$port3_stock_c
    color <- if(total == 100) "green" else "red"
    valueBox(paste0(total, "%"), "Total Weight", icon = icon("percent"), color = color)
  })
  
  comparison_results_comp <- eventReactive(input$compare_portfolios, {
    req(input$port1_stock_a + input$port1_stock_b + input$port1_stock_c == 100)
    req(input$port2_stock_a + input$port2_stock_b + input$port2_stock_c == 100)
    req(input$port3_stock_a + input$port3_stock_b + input$port3_stock_c == 100)
    
    returns <- c(input$comp_stock_a_ret, input$comp_stock_b_ret, input$comp_stock_c_ret)
    sds <- c(input$comp_stock_a_sd, input$comp_stock_b_sd, input$comp_stock_c_sd)
    rho <- input$comp_correlation
    
    calc_portfolio <- function(w1, w2, w3) {
      w <- c(w1, w2, w3) / 100
      port_ret <- sum(w * returns)
      
      variance <- sum(w^2 * sds^2)
      variance <- variance + 2 * w[1] * w[2] * rho * sds[1] * sds[2]
      variance <- variance + 2 * w[1] * w[3] * rho * sds[1] * sds[3]
      variance <- variance + 2 * w[2] * w[3] * rho * sds[2] * sds[3]
      
      port_risk <- sqrt(variance)
      
      list(return = port_ret, risk = port_risk, sharpe = port_ret / port_risk)
    }
    
    port1 <- calc_portfolio(input$port1_stock_a, input$port1_stock_b, input$port1_stock_c)
    port2 <- calc_portfolio(input$port2_stock_a, input$port2_stock_b, input$port2_stock_c)
    port3 <- calc_portfolio(input$port3_stock_a, input$port3_stock_b, input$port3_stock_c)
    
    list(
      names = c(input$port1_name, input$port2_name, input$port3_name),
      port1 = port1, port2 = port2, port3 = port3
    )
  })
  
  output$comparison_table <- renderDT({
    results <- comparison_results_comp()
    
    df <- data.frame(
      Portfolio = results$names,
      `Expected Return (%)` = c(
        round(results$port1$return, 2),
        round(results$port2$return, 2),
        round(results$port3$return, 2)
      ),
      `Risk (%)` = c(
        round(results$port1$risk, 2),
        round(results$port2$risk, 2),
        round(results$port3$risk, 2)
      ),
      `Sharpe Ratio` = c(
        round(results$port1$sharpe, 3),
        round(results$port2$sharpe, 3),
        round(results$port3$sharpe, 3)
      ),
      check.names = FALSE
    )
    
    datatable(df, options = list(dom = 't', ordering = FALSE), rownames = FALSE) %>%
      formatStyle(
        'Expected Return (%)',
        background = styleColorBar(df$`Expected Return (%)`, 'lightblue'),
        backgroundSize = '100% 90%',
        backgroundRepeat = 'no-repeat',
        backgroundPosition = 'center'
      )
  })
  
  output$comparison_risk_return <- renderPlotly({
    results <- comparison_results_comp()
    
    plot_ly() %>%
      add_trace(
        x = c(results$port1$risk, results$port2$risk, results$port3$risk),
        y = c(results$port1$return, results$port2$return, results$port3$return),
        text = results$names,
        type = 'scatter', mode = 'markers+text',
        marker = list(size = 20, color = c('blue', 'orange', 'red')),
        textposition = 'top center', textfont = list(size = 14)
      ) %>%
      layout(title = "Risk-Return Profile",
             xaxis = list(title = "Risk (Standard Deviation %)"),
             yaxis = list(title = "Expected Return (%)"))
  })
  
  output$comparison_bar_chart <- renderPlotly({
    results <- comparison_results_comp()
    
    plot_ly() %>%
      add_trace(x = results$names,
                y = c(results$port1$return, results$port2$return, results$port3$return),
                type = 'bar', name = 'Expected Return', marker = list(color = 'lightblue')) %>%
      add_trace(x = results$names,
                y = c(results$port1$risk, results$port2$risk, results$port3$risk),
                type = 'bar', name = 'Risk', marker = list(color = 'lightcoral')) %>%
      layout(title = "Portfolio Metrics Comparison",
             xaxis = list(title = ""), yaxis = list(title = "Percentage (%)"),
             barmode = 'group')
  })
}

# Run the application
shinyApp(ui = ui, server = server)
