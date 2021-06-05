

create_recipe <- function(data, embed_terms) {
  
  #################################
  ####  Create Train and Test  ####
  #################################
  
  recipe_spec <-
    recipes::recipe(
      total_amount ~ .,
      data = data
    ) %>% 
    recipes::update_role(
      rowid,
      new_role = "id_vars"
    ) %>% 
    recipes::step_normalize(
      recipes::all_numeric_predictors(),
      -contains("date")
    ) %>% 
    recipes::step_zv(
      all_predictors()
    ) %>% 
    recipes::step_dummy(
      recipes::all_nominal_predictors(),
      -PULocationID,
      -mday,
      -week,
      one_hot = TRUE
    ) %>% 
    
    embed::step_feature_hash(
      PULocationID,
      num_hash = embed_terms,
      preserve = FALSE
    ) %>%
    embed::step_feature_hash(
      mday,
      num_hash = embed_terms,
      preserve = FALSE
    ) %>%
    embed::step_feature_hash(
      week,
      num_hash = embed_terms,
      preserve = FALSE
    ) %>%
    recipes::step_zv(
      all_predictors()
    ) %>%
    
    # embed::step_embed(
    #   PULocationID,
    #   outcome = vars(total_amount),
    #   num_terms = embed_terms
    # ) %>%
    # embed::step_embed(
    #   mday,
    #   outcome = vars(total_amount),
    #   num_terms = embed_terms
    # ) %>%
    # embed::step_embed(
    #   week,
    #   outcome = vars(total_amount),
    #   num_terms = embed_terms
    # ) %>%
    # recipes::step_zv(
    #   all_predictors()
    # ) %>%
    
  recipes::step_rm(
      date
    )
  
  
  baked <-
    recipe_spec %>% 
    recipes::prep() %>% 
    # recipes::juice() %>% 
    recipes::bake(new_data = data)
  
  glimpse(baked)
  # View(baked)
  # skimr::skim(baked)
  
  
  return(recipe_spec)
  
}

