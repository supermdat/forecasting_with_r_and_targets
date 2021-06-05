

clean_data <- function(data, num_top_pu_ids, ...) {
  
  ####################################
  ####  Aggregate to Daily Amounts  ##
  ####  by PULocationID             ##
  ####################################
  
  # aggregate to daily data
  daily_amount_by_pulocation <-
    data %>%
    # taxi_df_r %>%
    mutate(
      PULocationID = as.character(PULocationID),
      date = lubridate::as_date(tpep_pickup_datetime)
    ) %>% 
    dplyr::filter(
      date >= lubridate::as_date("2019-07-01") &
        date <= lubridate::as_date("2019-12-31")
    ) %>% 
    dplyr::group_by(
      PULocationID,
      date
    ) %>% 
    dplyr::summarise(
      total_amount = sum(total_amount)
    )
  
  # limit data to the top PULocation Ids for testing purposes
  top_pu_ids <-
    daily_amount_by_pulocation %>% 
    dplyr::count(
      PULocationID,
      wt = total_amount,
      sort = TRUE
    ) %>% 
    head(num_top_pu_ids) %>% 
    dplyr::pull(PULocationID)
  
  
  limit_top_pu_ids <-
    daily_amount_by_pulocation %>% 
    dplyr::filter(
      PULocationID %in% top_pu_ids
    ) %>% 
    dplyr::ungroup() %>% 
    dplyr::arrange(
      PULocationID,
      date
    )
  
  
  glimpse(limit_top_pu_ids)
  
  
  # rm(taxi_df_r, daily_amount_by_pulocation, top_pu_ids)
  rm(daily_amount_by_pulocation, top_pu_ids)
  # rm(data)
  
  
  return(limit_top_pu_ids)
  
  
  # %>% 
  #   mutate(
  #     across(
  #       Retailer_Name:UPC,
  #       ~factor(.x)
  #     )
  #   ) %>% 
  #   dplyr::arrange(
  #     Retailer_Name,
  #     Store_Id,
  #     week_start
  #   ) %>% 
  #   timetk::tk_augment_timeseries_signature(
  #     .date_var = week_start
  #   ) %>%  
  #   timetk::tk_augment_lags(
  #     .value = Units,
  #     .lags = c(4, 8, 12)
  #   ) %>% 
  #   dplyr::select(
  #     -diff,
  #     -contains(".iso"),
  #     -contains(".xts"),
  #     -month,
  #     -hour,
  #     -minute,
  #     -second,
  #     -hour12,
  #     -am.pm,
  #     -wday,
  #     -wday.lbl,
  #     -day,
  #     -mday7,
  #     -qday,
  #     -yday
  #   ) %>%  
  #   tidyr::drop_na() %>% 
  #   # ensure the variables based on the calendar are encoded as factor variables
  #   dplyr::mutate(
  #     dplyr::across(
  #       year:week4,
  #       ~factor(as.character(.x))
  #     )
  #   ) %>% 
  #   ungroup() %>% 
  #   dplyr::arrange(
  #     Retailer_Name,
  #     Store_Id,
  #     week_start
  #   )
  
  

  
}

