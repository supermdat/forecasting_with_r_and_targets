

func_predict <- function(final_mod) {
  
  ###################
  ####  Predict  ####
  ###################
  
  predictions <- collect_predictions(final_mod)
  
  return(predictions)
  
}

