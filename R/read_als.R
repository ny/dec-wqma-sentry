#' Import ALS Data
#'
#' @param zip_path a file path to an ALS EDD provided in a zip file.
#'
#' @return a list.
#' @export

read_als <- function(zip_path) {
  # Store zip contents in a list --------------------------------------------
  zip_list <- zipper::read_zip(.zip_path = zip_path)
  # Create a structured list and fill it with the appropriate files imported
  # from the zip This will not throw an error if an element is missing.
  raw_list <- list(
    result = get_element(zip_list, "[Rr]esult"),
    batch = get_element(zip_list, "(?=.*Batch)(?=.*txt)"),
    sample = get_element(zip_list, "[Ss]ample"),
    htm = get_element(zip_list, "\\.htm|\\.html")
  )
  # End of function. Return a list.
  return(raw_list)
}
