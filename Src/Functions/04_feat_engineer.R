

feat_engineer <- function(data, ...) {
  
  ########################################
  ####  Time-Based Feature Engineering  ##
  ########################################
  
 
  basic_feature_engineering <-
    data %>%
    # limit_top_pu_ids %>%
    dplyr::mutate(
      PULocationID = factor(PULocationID),
    ) %>% 
    dplyr::group_by(
      PULocationID
    ) %>% 
    dplyr::arrange(
      PULocationID,
      date
    ) %>%
    timetk::tk_augment_timeseries_signature(
      .date_var = date
    ) %>%
    timetk::tk_augment_lags(
      .value = total_amount,
      .lags = 7:14
    ) %>% 
    timetk::tk_augment_fourier(
      .date_var = date,
      .periods = c(7, 14, 28)
    ) %>%
    timetk::tk_augment_slidify(
      .value   = total_amount,
      .f       = ~mean(.x, na.rm = TRUE),
      .period  = c(7*2^0, 7*2^1, 7*2^2, 7*2^3),
      .partial = TRUE,
      .align   = "right"
    ) %>% 
    dplyr::select(
      -diff,
      -contains(".iso"),
      -contains(".xts"),
      -month,
      -hour,
      -minute,
      -second,
      -hour12,
      -am.pm,
      -wday,
      -day,
      -mday7,
      -qday,
      -yday
    ) %>%
    tidyr::drop_na() %>% 
    # ensure the variables based on the calendar are encoded as factor variables
    dplyr::mutate(
      dplyr::across(
        year:week4,
        ~factor(as.character(.x))
      )
    ) %>% 
    dplyr::ungroup() %>% 
    dplyr::arrange(
      PULocationID,
      date
    ) %>% 
    tibble::rowid_to_column(var = "rowid")
  
  
  add_cyclic_encoding <-
    basic_feature_engineering %>% 
    mutate(
      ce = lubridate::cyclic_encoding(x = date,
                                      periods = c("week", "month", "year")
      ) %>% 
        as_tibble
    )
  
  # class(add_cyclic_encoding)
  # glimpse(add_cyclic_encoding)
  # 
  # class(add_cyclic_encoding$ce)
  # glimpse(add_cyclic_encoding$ce)
  
  
  add_cyclic_encoding <- 
    do.call(data.frame, add_cyclic_encoding) %>% 
    as_tibble() %>% 
    rename_with(
      .fn = ~str_replace(string = .x, pattern = "ce.", replacement = "date."),
      .cols = starts_with("ce.")
    ) %>% 
    dplyr::arrange(
      PULocationID,
      date
    )
  
  class(add_cyclic_encoding)
  glimpse(add_cyclic_encoding)
  
  
  # rm(limit_top_pu_ids, basic_feature_engineering)
  rm(basic_feature_engineering)
  
  
  return(add_cyclic_encoding)
  
}

