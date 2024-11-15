#source('https://s-ecfin-web.net1.cec.eu.int/directorates/db/u1/R/routines/installMDecfin.txt')


library(MDecfin)
setwd('U:/Topics/Spillovers_and_EA/flowoffunds/finflows2024/gitcodedata')


aall=readRDS('data/aall.rds')

#####fill blanks#####
aall[.AT.S12K..LE._T.2023q4 ]
aall[....LE._T.  ][aall[...S0.LE._T.]==0, onlyna=TRUE] = 0
aall[.DE.S12K..LE._T.2023q4 ]


#####AUSTRIA#####

#whom to whom with F
aall[F.AT...LE._T.y2022q4]
aall[F.AT...LE.FND.y2022q4]


### Assets S121+s122 vis-a-vis counterpart_sectors per FI
aall[.AT.S12K..LE._T.y2022q4]


### Liabilities S121+s122 vis-a-vis counterpart_sectors per FI
aall[.AT..S12K.LE._T.y2022q4]








### dependency wheel 
#install.packages("highcharter")
library(highcharter)

highchart() %>%
  hc_chart(
    type = "dependencywheel",
    accessibility = list(
      point = list(
        valueDescriptionFormat = "{index}. From {point.from} to {point.to}: {point.weight}."
      )
    )
  ) %>%
  hc_title(text = "Asset Dependencies") %>%
  hc_series(
    list(
      keys = c("from", "to", "weight"),
      data = S12K_a,
      type = "dependencywheel",
      name = "Dependency Wheel Series",
      dataLabels = list(
        color = "#333",
        style = list(
          textOutline = "none",
          fontSize = "12px",
          fontWeight = "bold"
        ),
        textPath = list(enabled = TRUE),
        distance = 10
      ),
      size = "95%"
    )
  )