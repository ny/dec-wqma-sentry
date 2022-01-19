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
    result = get_element(zip_list, "[Rr]esult", clean_names = TRUE),
    batch = get_element(zip_list, "(?=.*Batch)(?=.*txt)", clean_names = TRUE),
    sample = get_element(zip_list, "[Ss]ample", clean_names = TRUE),
    htm = get_element(zip_list, "\\.htm|\\.html")
  )
  # Convert to class ALS.
  als <- as_als(x = raw_list)
  # End of function. Return a ALS object.
  return(als)
}


#' Convert to Class ALS
#'
#' @param x a list object containing 3 or 4 list elements.
#'
#' @return ALS object
#' @export

as_als <- function(x) {
  stopifnot(is.list(x),
            length(x) %in% c(3, 4))
  x <- structure(x, class = c("ALS", "list"))
  als_substructure(x = x)
}

#' Assign New Classes to Each ALS Element
#'
#' @param x an ALS object.
#'
#' @return

als_substructure <- function(x) {
  if ("result" %in% names(x)) {
    x$result <- structure(x$result, class = c("data.frame",
                                              "ALS_result",
                                              "ALS"))
  }

  if ("batch" %in% names(x)) {
    x$batch <- structure(x$batch, class = c("data.frame",
                                            "ALS_batch",
                                            "ALS"))
  }

  if ("sample" %in% names(x)) {
    x$sample <- structure(x$sample, class = c("data.frame",
                                              "ALS_sample",
                                              "ALS"))
  }

  if ("htm" %in% names(x)) {
    x$htm <- structure(x$htm, class = c("character",
                                        "ALS_htm",
                                        "ALS"))
  }

  return(x)
}
