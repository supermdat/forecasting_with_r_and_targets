

predict_actual_plot <- function(data) {
  
  ###################
  ####  Predict  ####
  ###################
  
  max_actual = max(data$total_amount, na.rm = TRUE)
  max_pred   = max(data$`.pred`, na.rm = TRUE)
  max_all    = max(max_actual, max_pred)
  limit_all  = (ceiling(max_all / 5000) * 5000)
  
  p =
    data %>%
    mutate(
      total_amount.actual = total_amount,
      total_amount.pred = base::round(x = .pred, digits = 0)
    ) %>% 
    ggplot(
      aes(
        x = total_amount.actual,
        y = total_amount.pred
      )
    ) +
    geom_abline(lty = 2, color = "gray50") +
    geom_point(alpha = 0.5, color = "midnightblue") +
    scale_x_continuous(label = scales::comma) +
    scale_y_continuous(label = scales::comma) +
    coord_fixed(
      xlim = c(0, limit_all),
      ylim = c(0, limit_all)
    ) +
    theme_minimal()
  
  plotly::ggplotly(p)
  # p
  
}

