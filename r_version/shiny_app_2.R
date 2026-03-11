#importing dataset

dataset= read.csv('adult.csv')


#missing data

dataset$age= ifelse(is.na(dataset$age),
                    ave(dataset$age, FUN = function(x)mean(x,na.rm=TRUE)),
                    dataset$age)
dataset$hours.per.week= ifelse(is.na(dataset$hours.per.week),
                               ave(dataset$hours.per.week, FUN = function(x)mean(x,na.rm=TRUE)),
                               dataset$hours.per.week)

#categorical data

#dataset$income =factor(dataset$income,levels=c('<=50K','>50K'),labels=c(0,1))
dataset$gender=factor(dataset$gender,levels=c('Male','Female'),labels=c(1,2))

#PREPARATION OF THE DATA FOR WEB APPLICATION
library(plyr)

summary(dataset$workclass)
levels(dataset$workclass)[1] <- 'Unknown'
# combine into Government job
dataset$workclass <- gsub('^Federal-gov', 'Government', dataset$workclass)
dataset$workclass <- gsub('^Local-gov', 'Government', dataset$workclass)
dataset$workclass <- gsub('^State-gov', 'Government',dataset$workclass) 

# combine into Sele-Employed job
dataset$workclass <- gsub('^Self-emp-inc', 'Self-Employed', dataset$workclass)
dataset$workclass <- gsub('^Self-emp-not-inc', 'Self-Employed', dataset$workclass)

# combine into Other/Unknown
dataset$workclass <- gsub('^Never-worked', 'Other', dataset$workclass)
dataset$workclass <- gsub('^Without-pay', 'Other', dataset$workclass)
dataset$workclass <- gsub('^Other', 'Other/Unknown', dataset$workclass)
dataset$workclass <- gsub('^Unknown', 'Other/Unknown', dataset$workclass)



dataset$workclass <- as.factor(dataset$workclass)

summary(dataset$workclass)

# get the counts by industry and income group
count <-table(dataset[dataset$workclass == 'Government',]$income)["<=50K"]
count <- c(count, table(dataset[dataset$workclass == 'Government',]$income)[">50K"])
count <- c(count, table(dataset[dataset$workclass == 'Other/Unknown',]$income)["<=50K"])
count <- c(count, table(dataset[dataset$workclass == 'Other/Unknown',]$income)[">50K"])
count <- c(count, table(dataset[dataset$workclass == 'Private',]$income)["<=50K"])
count <- c(count, table(dataset[dataset$workclass == 'Private',]$income)[">50K"])
count <- c(count, table(dataset[dataset$workclass == 'Self-Employed',]$income)["<=50K"])
count <- c(count, table(dataset[dataset$workclass == 'Self-Employed',]$income)[">50K"])
count <- as.numeric(count)
count
# create a dataframe

industry <- rep(levels(dataset$workclass), each = 2)
income <- rep(c('<=50K', '>50K'), 4)
df <- data.frame(industry, income, count)
df
#install.packages("plyr")
library(plyr)
df <- ddply(df, .(industry), transform, percent = count/sum(count) * 100)
df <- ddply(df, .(industry), transform, pos = (cumsum(count) - 0.5 * count))
df$label <- paste0(sprintf("%.0f", df$percent), "%")

#education_num

df1 <- data.frame(table(dataset$income, dataset$educational.num))
names(df1) <- c('income', 'education_num', 'count')
df1


df1 <- ddply(df1, .(education_num), transform, percent = count/sum(count) * 100)

df1 <- ddply(df1, .(education_num), transform, pos = (cumsum(count) - 0.5 * count))
df1$label <- paste0(sprintf("%.0f", df1$percent), "%")


df1$label[which(df1$percent < 5)] <- NA

#marital status preparation
summary(dataset$marital.status)
dataset$marital.status <- gsub('Married-AF-spouse', 'Married', dataset$marital.status)
dataset$marital.status <- gsub('Married-civ-spouse', 'Married', dataset$marital.status)
dataset$marital.status <- gsub('Married-spouse-absent', 'Married', dataset$marital.status)
dataset$marital.status <- gsub('Never-married', 'Single', dataset$marital.status)
dataset$marital.status <- as.factor(dataset$marital.status)
summary(dataset$marital.status)

df3 <- data.frame(table(dataset$income, dataset$marital.status))
names(df3) <- c('income', 'marital_status', 'count')
df3

df3 <- ddply(df3, .(marital_status), transform, percent = count/sum(count) * 100)

df3 <- ddply(df3, .(marital_status), transform, pos = (cumsum(count) - 0.5 * count))
df3$label <- paste0(sprintf("%.0f", df3$percent), "%")


#occupation
summary(dataset$occupation)

levels(dataset$occupation)[1] <- 'Unknown'
dataset$occupation <- gsub('Adm-clerical', 'Professional', dataset$occupation)
dataset$occupation <- gsub('Craft-repair', 'Manual-Labour', dataset$occupation)
dataset$occupation <- gsub('Exec-managerial', 'Professional', dataset$occupation)
dataset$occupation <- gsub('Farming-fishing', 'Manual-Labour', dataset$occupation)
dataset$occupation <- gsub('Handlers-cleaners', 'Manual-Labour',dataset$occupation)
dataset$occupation <- gsub('Machine-op-inspct', 'Manual-Labour',dataset$occupation)
dataset$occupation <- gsub('Other-service', 'Service', dataset$occupation)
dataset$occupation <- gsub('Priv-house-serv', 'Service',dataset$occupation)
dataset$occupation <- gsub('Prof-specialty', 'Professional', dataset$occupation)
dataset$occupation <- gsub('Protective-serv', 'Service', dataset$occupation)
dataset$occupation <- gsub('Tech-support', 'Service', dataset$occupation)
dataset$occupation <- gsub('Transport-moving', 'Manual-Labour', dataset$occupation)
dataset$occupation <- gsub('Unknown', 'Other/Unknown', dataset$occupation)
dataset$occupation <- gsub('Armed-Forces', 'Other/Unknown', dataset$occupation)
dataset$occupation <- as.factor(dataset$occupation)

df2 <- data.frame(table(dataset$income, dataset$occupation))
names(df2) <- c('income', 'occupation', 'count')
df2


df2 <- ddply(df2, .(occupation), transform, percent = count/sum(count) * 100)

df2 <- ddply(df2, .(occupation), transform, pos = (cumsum(count) - 0.5 * count))
df2$label <- paste0(sprintf("%.0f", df2$percent), "%")



#FRONTEND 
LR_model<- glm(income~age+educational.num+occupation+race+hours.per.week+native.country,dataset,family= "binomial")
library(e1071)
library(shiny)
library(ggplot2)
NB_model <- naiveBayes(income~age+educational.num+occupation+race+hours.per.week+native.country, data=dataset)
answer = c("Living modestly, under 50K/year", "Comfortable lifestyle, over 50K/year")
nativeCountry <- unique(dataset$native.country)
occupation <- unique(dataset$occupation)
race <- unique(dataset$race)
maritalStatus <- unique(dataset$marital.status)
model<-c("NAIVE BAYES","LOGISTIC REGRESSION")
ui<-fluidPage(pageWithSidebar(
  headerPanel("Standard of Living Predictor"),
  sidebarPanel(
    selectInput("selectModel","Classification Model",choices = model ),
    selectInput("selectCountry", "Country of Origin", choices = nativeCountry ),
    selectInput("selectOcc", "Occupation", choices = occupation ),
    selectInput("selectRace", "Race", choices = race ),
    
    sliderInput("slideAge", "Age (years)", 18, 80, 30),
    sliderInput("slideSchooling", "Years of formal schooling", 0, 22, 22),
    sliderInput("slideHours", "Hours Per Week of Work", 0, 80, 80)
  ),
  mainPanel(
    tabsetPanel(
      tabPanel("Output",
               h2('Predicted standard of living'),
               textOutput('text1'),
               hr(),
               h5('Classification Model'),
               textOutput('textModel'),
               h5('Country of Origin'),
               textOutput('textCountry'),
               h5('Occupation'),
               textOutput('textOccupation'),
               h5('Race'),
               textOutput('textRace'),
               h5('Age'),
               textOutput('textAge'),
               h5('Years of schooling'),
               textOutput('textSchooling'),
               h5('Hours per week'),
               textOutput('textHours')
      ),
      tabPanel("AGE BOXPLOT", plotOutput("plot1")),
      tabPanel("FREQUENCY VS AGE", plotOutput("plot2")),
      tabPanel("WORKCLASS", plotOutput("plot3")),
      tabPanel("EDUCATION LEVEL", plotOutput("plot4")),
      tabPanel("MARITAL STATUS", plotOutput("plot5")),
      tabPanel("OCCUPATION", plotOutput("plot6"))
    ) 
  )
) )

server<- function(input,output) {
  output$textModel <- renderText(input$selectModel)
  output$textAge <- renderText(input$slideAge)
  output$textSchooling <- renderText(input$slideSchooling)
  output$textOccupation <- renderText(input$selectOcc)
  output$textRace <- renderText(input$selectRace)
  output$textHours <- renderText(input$slideHours)
  output$textCountry <- renderText(input$selectCountry)
  output$text1 <- renderText({
    userData <- data.frame(input$slideAge, input$slideSchooling,
                           input$selectOcc, input$selectRace, 
                           input$slideHours, input$selectCountry)
    names(userData) <- c("age", "educational.num",  "occupation",
                         "race", "hours.per.week", "native.country")
    mdl=factor(input$selectModel,levels=c('NAIVE BAYES','LOGISTIC REGRESSION'),labels=c(1,2))
    if(as.numeric(mdl)==1){
      preAnswerCode <- predict(NB_model, userData)
      answerCode =factor(preAnswerCode,levels=c('<=50K','>50K'),labels=c(1,2))
      
      }
    else{
      answerCode <- predict(LR_model, userData)
      answerCode <- (answerCode>0.5)+1
      }
    answer[answerCode]
  })
  output$plot1 <- renderPlot({boxplot (age ~ income, data = dataset, 
                                       main = "Age distribution for different income levels",
                                       xlab = "Income Levels", ylab = "Age", col = "salmon")
  })
  output$plot2 <- renderPlot({ggplot(dataset) + aes(x=as.numeric(age), group=income, fill=income) + 
      geom_histogram(binwidth=1, color='black') 
  })
  output$plot3 <- renderPlot({ ggplot(df, aes(x = industry, y = count, fill = income)) +
      geom_bar(stat = "identity",position = "dodge") +
      ggtitle('Income by Industry')
    
  })
  output$plot4 <- renderPlot({ ggplot(df1, aes(x = education_num, y = count, fill = income)) +
      geom_bar(stat = "identity",position= "dodge") +
      ggtitle('Income Level with Years of Education')
    
  })
  output$plot5 <- renderPlot({ ggplot(df3, aes(x = marital_status, y = count, fill = income)) +
      geom_bar(stat = "identity", position="dodge") +
      ggtitle('Income Level with Marital Status')
    
    
  })
  output$plot6 <- renderPlot({ ggplot(df2, aes(x = occupation, y = count, fill = income)) +
      geom_bar(stat = "identity",position= "dodge") +
      ggtitle('Income Level with Different Occupations')
    
  })
  
}

shinyApp(ui = ui,server = server)


