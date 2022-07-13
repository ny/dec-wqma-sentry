
#' Workflow
#'
#' @param x a list with a secondary class, such as ALS.
#' @param filepath a file path.
#' @param filename a string.
#'
#' @return a list.
#' @export

workflow <- function(x, filepath, filename) {
  UseMethod("workflow", x)
}

#' @export
workflow.ALS <- function(x, filepath = NULL, filename) {
  # Create a temporary directory to store the HTML report.
  #
  temp_path <- tempdir()
  on.exit(unlink(temp_path))

  gen_val_report(
    x = x,
    output_dir = temp_path,
    filename = filename
  )

  # class(x) <- "list"
  # final_obj <- list(
  #   "data" = as_als(x),
  #   "validation_report" = read_html(
  #     filepath = file.path(temp_path,
  #                          paste0(filename,
  #                                 "_validation-report.html"))
  #   )
  # )

  flattened <- list_to_df(x = x)
  nested <- nest_sdg(x = flattened)

  nested[[1]]$reports$validation <- read_html(
    filepath = file.path(temp_path,
                         paste0(filename,
                                "_validation-report.html"))
  )

  # export_json(
  #   x = nested,
  #   path = filepath,
  #   filename = filename
  # )
  return(nested)
}
