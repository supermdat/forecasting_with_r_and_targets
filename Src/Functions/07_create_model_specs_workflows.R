

create_model_specs_workflows <- function(recipe) {
  
  ##############################
  ####  Create Model Specs  ####
  ##############################
  
  ### Linear Model
  model_spec_lm <- 
    linear_reg(
      penalty = tune(),
      mixture = tune()
    ) %>% 
    set_engine("glmnet")
  
  
  workflow_fit_lm <-
    workflow() %>% 
    add_model(model_spec_lm) %>% 
    add_recipe(recipe)
  
  
  return(workflow_fit_lm)
  
}

