
#' Workflow
#'
#' @param x a list with a secondary class, such as ALS.
#' @param filename a string.
#'
#' @return a list.
#' @export

workflow <- function(x, filename) {
  UseMethod("workflow", x)
}

#' @export
workflow.ALS <- function(x, filename) {
  # Create a temporary directory to store the HTML report.
  temp_path <- tempdir()
  on.exit(unlink(temp_path))
  # Generate the validation report.
  gen_val_report(
    x = x,
    output_dir = temp_path,
    filename = filename
  )
  # List to data frame.
  flattened <- list_to_df(x = x)
  # Nest the list by SDG.
  nested <- nest_sdg(x = flattened)
  # Add the HTML report as an object in the nested list.
  nested[[1]]$reports$validation <- read_html(
    filepath = file.path(temp_path,
                         paste0(filename,
                                "_validation-report.html"))
  )
  # End of function. Return a list.
  return(nested)
}
