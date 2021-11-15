als_validated <- lapply(
  X = Sentry::als,
  validate,
  actions = action_levels(
    warn_at = 0.1,
    stop_at = 1,
    fns = list(
      warn = ~ log4r_step(x),
      stop = ~ log4r_step(x)
    )
  )
)

usethis::use_data(als_validated, overwrite = TRUE)
