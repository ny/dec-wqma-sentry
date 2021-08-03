
#' Workflow
#'
#' @param x
#' @param filepath
#' @param filename
#'
#' @return
#' @export

workflow <- function(x, filepath, filename) {
  UseMethod("workflow", x)
}

#' @export
workflow.ALS <- function(x, filepath, filename) {

  temp_path <- tempdir()
  on.exit(unlink(temp_path))

  gen_val_report(
    x = x,
    output_dir = temp_path,
    filename = filename
  )

  class(x) <- "list"
  final_obj <- list(
    "data" = x,
    "validation_report" = read_html(
      filepath = file.path(temp_path,
                           paste0(Sys.Date(), "_",
                                  filename, ".html"))
    )
  )

  # export_json(
  #   x = final_obj,
  #   path = filepath,
  #   filename = filename
  # )
}
