

create_data_splits_and_cv <- function(data, assess_period, cumulative_cv, 
                                      seed, skip_period_tscv, cumulative_tscv
                                      ) {
  
  ##########################
  ####  rsample method  ####
  ##########################
  
  # ### split
  # 
  # split <-
  #   data %>% 
  #   rsample::initial_split(prop = prop)
  # 
  # train <- rsample::training(split)
  # test  <- rsample::testing(split)
  # 
  # dim(train)
  # dim(test)
  # 
  # ### create cross validation 
  # 
  # set.seed(seed)
  # folds <-
  #   train %>% 
  #   vfold_cv(v = cv_folds)
  # 
  # folds
  
  
  ##########################
  ####  timetk method   ####
  ##########################
  
  ### split
  
  split <-
    data %>%
    # add_cyclic_encoding %>%
    timetk::time_series_split(
      date_var = date,
      assess = assess_period,
      cumulative = cumulative_cv
    )
  
  train <- rsample::training(split)
  test  <- rsample::testing(split)
  
  dim(train)
  dim(test)
  
  ### create cross validation 
  
  set.seed(seed)
  folds <-
    train %>% 
    timetk::time_series_cv(
      date_var = date,
      initial = (28 * 4),
      assess = assess_period,
      skip = skip_period_tscv,
      cumulative = cumulative_tscv
    )
  
  folds
  
  
  ###################
  ####  outupts  ####
  ###################  
  
  ret <- list(split = split,
              train = train,
              test = test,
              folds = folds
              )
  
  return(ret)  
  
}

