#' Generate a Validation Report
#'
#' @param x a data object.
#' @param output_dir a file path were the rendered report will be stored.
#' @param filename a character string to include in file name.
#' @param ... additional arguments.
#'
#' @return
#' @export
gen_val_report <- function(x, output_dir, filename, ...) {
  UseMethod("gen_val_report", x)
}

#' @export
gen_val_report.ALS <- function(x, output_dir, filename) {

  validated <- lapply(
    X = x,
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
  # Render a single report.
  rmarkdown::render(input = system.file("rmarkdown",
                                        "templates",
                                        "ALS",
                                        "als_template.Rmd",
                                        package = "Sentry"),
                    output_dir = output_dir,
                    output_file = paste0(filename,
                                         "_validation-report"),
                    params = list(
                      validated = validated
                    ))
}
