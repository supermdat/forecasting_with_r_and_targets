

read_data <- function(setup_r_details, cores_to_reserve, ...) {
  
  ############################################
  ####  Get Six Months of Taxi Trip Data  ####
  ############################################
  
  # setup_r(cores_to_reserve = cores_to_reserve)
  
  
  url_prefix <- "https://nyc-tlc.s3.amazonaws.com/trip+data/yellow_tripdata_2019-"
  url_suffix <- ".csv"
  months     <- as.character(7:12) %>% stringr::str_pad(width = 2, side = "left", pad = "0")
  
  
  tictoc::tic("time to read in data")
  taxi_df_r <-
    months %>% 
    furrr::future_map_dfr(
      .f = ~data.table::fread(
        input = paste0(url_prefix, .x, url_suffix),
        sep = ",",
        select = c("tpep_pickup_datetime",
                   "PULocationID",
                   "total_amount"
                   ),
        showProgress = FALSE
      )
    )
  tictoc::toc()
  
  
  class(taxi_df_r)
  glimpse(taxi_df_r)
  
  
  rm(url_prefix, url_suffix, months)
  
  
  return(taxi_df_r)
  
}

