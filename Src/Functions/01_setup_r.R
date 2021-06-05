

setup_r <- function(cores_to_reserve, ...) {

  
  # rm(list = ls())

  ###################################
  ####  Take a Library Snapshot  ####
  ###################################

  if(!require(renv)) {install.packages("renv")}

  # consent (below) is only needed once
  # options(renv.consent = TRUE)
  #
  # renv::init()
  renv::snapshot(prompt = FALSE)


  #####################################
  ####  Set the Working Directory  ####
  #####################################
  wd <- here::here()
  wd


  #################################
  ####  Load Needed Libraries  ####
  #################################
  library("tidyverse")
  library("tidymodels")
  library("embed")
  library("finetune")
  library("modeltime")
  library("furrr")
  library("data.table")
  library("plotly")
  library("tictoc")
  library("skimr")


  ###########################
  ####  Session Details  ####
  ###########################
  sessionInfo()



  installed_packages <- as.data.frame(installed.packages()[ , c("Package", "Version", "LibPath")])
  installed_packages[with(installed_packages, order(LibPath, Package)), ]

  rm(installed_packages)


  #######################
  ####  Set Options  ####
  #######################
  
  # tensorflow options
  reticulate::use_condaenv(condaenv = "r-reticulate", required = TRUE)
  
  # set the plotting theme to `theme_minimal`
  ggplot2::theme_set(ggplot2::theme_minimal())

  # set print options
  options(max.print = 10000)  # set the number of lines to print
  options(scipen = 999)       # digits longer than this will be converted to scientific notation

  # Setup for Parallel Processing
  num_cores <- future::availableCores() - cores_to_reserve
  future::plan(multisession, workers = num_cores)

  num_cores
  

  return(num_cores)
  
}

