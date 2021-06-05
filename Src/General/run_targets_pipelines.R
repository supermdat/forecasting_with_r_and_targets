

targets::tar_manifest()
targets::tar_glimpse()


targets::tar_visnetwork()
tictoc::tic()
targets::tar_make(
  # names = raw_data_file:select_best_retrain
)
tictoc::toc()
targets::tar_visnetwork()


View(targets::tar_meta(fields = warnings))

targets::tar_watch(seconds = 10, outdated = FALSE, targets_only = TRUE)


(targets::tar_read(select_best_retrain))$.metrics
View(targets::tar_read(f_predict))
targets::tar_read(plot_pred_actual)


### tar_destroy() is by far the most commonly used cleaning function. It removes the _targets/ data store completely, deleting all the results from
### tar_make() except for external files. Use it if you intend to start the pipeline from scratch without any trace of a previous run.
# targets::tar_destroy()


