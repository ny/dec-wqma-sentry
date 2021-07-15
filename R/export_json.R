#' Export as JSON
#'
#' @param x an object to be written as a JSON file.
#' @param path Where to write the file.
#' @param filename The name of the file to be written.
#'
#' @return Write a JSON Object.
#' @export

export_json <- function(x, path, filename) {
  # Add json extension if missing.
  if (tools::file_ext(filename) != "json") {
    filename <- paste0(filename, ".json")
  }
  # Write JSON object.
  jsonlite::write_json(
    x = x,
    path = file.path(
      path,
      filename
    ),
    na = "string",
    pretty = TRUE
  )
}
