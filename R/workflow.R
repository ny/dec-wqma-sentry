
#' Workflow
#'
#' @param x a list with a secondary class, such as ALS.
#' @param filename a string.
#' @param gen_report a logical indicating if a report should be generated.
#'
#' @return a list.
#' @export

workflow <- function(x, filename, gen_report = TRUE) {
  UseMethod("workflow", x)
}

#' @export
workflow.ALS <- function(x, filename, gen_report = TRUE) {
  # Create a temporary directory to store the HTML report.
  temp_path <- tempdir()
  on.exit(unlink(temp_path))
  # Run validation with PointBlank
  validated <- lapply(
    X = x,
    validate,
    actions = pointblank::action_levels(
      warn_at = 0.1,
      stop_at = 1,
      fns = list(
        warn = ~ pointblank::log4r_step(x),
        stop = ~ pointblank::log4r_step(x)
      )
    )
  )

  validated <- structure(validated, class = c("ALS_val", "list"))

  report_list <- list()

  if (gen_report == TRUE) {
    # Generate the validation report.
    gen_val_report(
      x = validated,
      output_dir = temp_path,
      filename = filename
    )

    # Add the HTML report as an object in the nested list.
    report_list$report <- read_html(
      filepath = file.path(temp_path,
                           paste0(filename,
                                  "_validation-report.html"))
    )
  } else {
    report_list$report <- "User requested the report not be generated."
  }

  # Include as a key value pair that will allow us to query this report once
  # in the WQMA data base.
  report_list$lab_sdg <- filename

  error_summary <- c(
    validated$result$error_summary,
    validated$batch$error_summary,
    validated$sample$error_summary
  )

  report_list$status <- ifelse(
    test = is.null(error_summary),
    yes = "pass",
    no = "fail"
  )


  report_list$message <- ifelse(
    test = report_list$status == "pass",
    yes = "No validation issues identified.",
    no = paste(
      "The ALS SDG,",
      paste0(filename, ","),
      "did not pass the automated validation for the following reason(s):",
      paste("*", error_summary, collapse = " \n ")
    )
  )

  if (report_list$status == "pass") {
    final_data <- list_to_df(x = x)
  } else {
    final_data <- NULL
  }
  final_list <- list(
    data = final_data,
    report = report_list
  )
  # End of function. Return a list.
  return(final_list)
}
