
library("targets")

source("SRC/Functions/01_setup_r.R")
source("SRC/Functions/02_read_data.R")
source("SRC/Functions/03_clean_data.R")
source("SRC/Functions/04_feat_engineer.R")
source("SRC/Functions/05_create_data_splits_and_cv.R")
source("SRC/Functions/06_create_recipe.R")
source("SRC/Functions/07_create_model_specs_workflows.R")
source("SRC/Functions/08_tune_models.R")
source("SRC/Functions/09_select_best_model_and_retrain.R")
source("SRC/Functions/10_predict.R")
source("SRC/Functions/11_predict_actual_plot.R")

# options(tidyverse.quiet = TRUE)


tar_option_set(
  packages = c("tidyverse", 
               "tidymodels",
               "embed",
               "finetune",
               "modeltime",
               "furrr",
               "data.table",
               "plotly",
               "tictoc",
               "skimr"
               )
)



list(
  # tar_target(
  #   raw_data_file,
  #   "C:/Users/usTurseDa/OneDrive - NESTLE/Desktop/Analytics/test_forecast/Data/Processed/test-of-100-stores-weekly-pos.csv", 
  #   format = "file"
  # ),
  tar_target(
    name = setup,
    command = setup_r(cores_to_reserve = 1)#,
    # format = "file"
  ),
  tar_target(
    name = get_data,
    command = read_data(setup_r_details = setup)#,
    # format = "file"
  ),
  tar_target(
    name = clean,
    command = clean_data(data = get_data, num_top_pu_ids = 100)
  ),
  tar_target(
    name = f_engnr,
    command = feat_engineer(data = clean)
  ),
  tar_target(
    name = split_cv,
    command = create_data_splits_and_cv(data = f_engnr, assess_period = "7 days", 
                                        cumulative_cv = TRUE, seed = 123456789, 
                                        skip_period_tscv = 4, cumulative_tscv = FALSE
                                        )
  ),
  tar_target(
    name = recipe,
    command = create_recipe(data = split_cv$train, embed_terms = 20)
  ),
  tar_target(
    name = specs_workflow,
    command = create_model_specs_workflows(recipe = recipe)
  ),
  tar_target(
    name = tune,
    command = tune_models(wflow = specs_workflow, seed = 123456789, 
                          rs = split_cv$folds, grid_num = 4
                          )
  ),
  tar_target(
    name = select_best_retrain,
    command = select_best_model_and_retrain(tuned_mod = tune, metric = "rmse",
                                            wflow = specs_workflow,
                                            splits = split_cv$split
                                            )
  ),
  tar_target(
    name = f_predict,
    command = func_predict(final_mod = select_best_retrain)
  ),
  tar_target(
    name = plot_pred_actual,
    command = predict_actual_plot(data = f_predict)
  )
)


