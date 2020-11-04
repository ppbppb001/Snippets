# Docker file for R

FROM r-base:3.6.3

RUN R -e "install.packages('DT')"
RUN R -e "install.packages('shiny')"
RUN R -e "install.packages('shinydashboard')"
RUN R -e "install.packages('ggplot2')"
RUN R -e "install.packages('visNetwork')"

RUN mkdir /usr/local/shiny-app

#COPY *.R /usr/local/shiny-app
COPY r-scripts/*.R /usr/local/shiny-app

WORKDIR /usr/local/shiny-app

#CMD R -e "source('/usr/local/shiny-app/shiny-test-2.R')"
CMD ["Rscript", "shiny-test-2.R"]
