
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
    validate#,
    # actions = pointblank::action_levels(
    #   warn_at = 0.1,
    #   stop_at = 1,
    #   fns = list(
    #     warn = ~ pointblank::log4r_step(x),
    #     stop = ~ pointblank::log4r_step(x)
    #   )
    # )
  )

  validated <- structure(validated, class = c("ALS_val", "list"))
  # Prevents duplicate column names when sample is joined with result.
  names(validated$sample$post$comment) <- "sample_comment"

  # Default value for report. Will be updated if gen_report == TRUE,
  report <- NULL
  if (gen_report == TRUE) {
    # Generate the validation report.
    gen_val_report(
      x = validated,
      output_dir = temp_path,
      filename = filename
    )

    # Import the html doc as a character string.
    report <- get_html_report(
      output_dir = temp_path,
      filename = paste0(filename,
                        "_validation-report.html")
    )
  }

  error_summary <- c(
    validated$result$error_summary,
    validated$batch$error_summary,
    validated$sample$error_summary
  )

  summary_list <- val_summary(
    kvp_element = "lab_sdg",
    kvp_value = filename,
    email_address = "bwamData@dec.ny.gov",
    filename = filename,
    error_summary = error_summary,
    report = report,
    status = ifelse(
      test = is.null(error_summary),
      yes = "pass",
      no = "fail"
    )
  )

  if (summary_list$status == "pass") {
    flattened <- list_to_df(x = x)

    final_data <- split(
      x = flattened,
      f = rownames(flattened)
    )
  } else {
    final_data <- NULL
  }
  final_list <- list(
    data = final_data,
    validation_summary = summary_list
  )
  # End of function. Return a list.
  return(final_list)
}
