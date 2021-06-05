

select_best_model_and_retrain <- function(tuned_mod, metric, wflow, splits) {
  
  ########################
  ####  Select Model  ####
  ########################
  
  ### Show based on rmse
  show_best(
    tuned_mod,
    metric = metric
  )
  
  ### Selection based on rmse
  final_lm <-
    wflow %>% 
    finalize_workflow(
      select_best(
        tuned_mod,
        metric = metric
      )
    )
  
  final_lm
  
  ### Refit on all data
  lm_final_fit <-
    last_fit(
      object = final_lm,
      splits
    )
  
  lm_final_fit
  
  ### Show accuracy metrics
  collect_metrics(lm_final_fit)
  
  
  return(lm_final_fit)
  
}

