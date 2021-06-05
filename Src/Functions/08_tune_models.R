

tune_models <- function(wflow, seed, rs, grid_num) {
  
  ###########################
  ####  Tune the Models  ####
  ###########################
  
  ### Linear Model
  tictoc::tic()
  set.seed(seed)
  lm_tune <-
    wflow %>% 
    tune_grid(
      resamples = rs,
      grid = grid_num
    )
  tictoc::toc()
  
  return(lm_tune)
  
}

