# Base image https://hub.docker.com/u/rocker/
FROM rocker/shiny-verse:4.0.3

# Set /srv/shiny-server as base WORKDIR
WORKDIR /srv/shiny-server

# Remove default shiny conf
RUN rm -rf *

# Copy necessary files
COPY /app ./comptes

# install package requirement
RUN Rscript -e 'install.packages("shinydashboard")'

# expose port
EXPOSE 3838

# run app on container start
CMD ["R", "-e", "shiny::runApp('./comptes', host = '0.0.0.0', port = 3838)"]
