#' Import ALS Data
#'
#' @param zip_path a file path to an ALS EDD provided in a zip file.
#'
#' @return a list.
#' @export

read_als <- function(zip_path) {
  # Get file extension.
  ext <- tools::file_ext(zip_path)
  # Error out if the supplied file is not a zip file.
  if (ext != "zip") {
    stop(paste0("\nExpected File Extension: zip \n",
           'Supplied File Extension: ',
           ext))
  }
  # Store zip contents in a list --------------------------------------------
  zip_list <- read_zip(.zip_path = zip_path)
  # Create a structured list and fill it with the appropriate files imported
  # from the zip This will not throw an error if an element is missing.
  raw_list <- list(
    result = get_element(zip_list, "[Rr]esult", clean_names = TRUE),
    batch = get_element(zip_list, "[Bb]atch.*\\.(txt|csv)$", clean_names = TRUE),
    sample = get_element(zip_list, "[Ss]ample", clean_names = TRUE),
    htm = get_element(list = zip_list, pattern = "\\.htm|\\.html")
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

#' Read & Combine Multiple ALS EDDs
#'
#' @param edd_filepaths multiple file paths to zip file provided by ALS.
#'
#' @return A single ALS object.
#' @export

read_comb_multi_als <- function(edd_filepaths) {
  # Name the edd_filepath vector based on the file name, which is the EDD number.
  names(edd_filepaths) <- tools::file_path_sans_ext(x = basename(path = edd_filepaths))
  # Import all of the EDDs and store in a list.
  # The names of the list items are based on the EDD number.
  raw_list <- names(edd_filepaths) |>
    purrr::set_names(x = _) |>
    purrr::map(
      .x = _,
      .progress = TRUE,
      .f = function(edd_i) {
        # Get the full filepath based on the EDD name.
        edd_path <- edd_filepaths[edd_i]
        # Read in a single EDD.
        raw_als <- Sentry::read_als(zip_path = edd_path)
        # Standardize qc_rpd as a character value.
        raw_als$result$qc_rpd <- as.character(raw_als$result$qc_rpd)
        # Standard the fraction as a character value.
        # When the fraction col is filled with "T",
        # R imports this column as a logical and interprets "T" to mean TRUE.
        # This switches the value back to the appropriate "T" value.
        raw_als$result$fraction <- ifelse(
          test = raw_als$result$fraction %in% "TRUE",
          yes = "T",
          no = raw_als$result$fraction
        )
        # Same operation as above.
        raw_als$batch$fraction <- ifelse(
          test = raw_als$batch$fraction %in% "TRUE",
          yes = "T",
          no = raw_als$batch$fraction
        )
        # Return a list object.
        return(raw_als)
      })

  # Transpose the list object to represent results, sample, and batch.
  raw_transposed <- purrr::transpose(raw_list)

  # Each element (result, sample, and batch) in raw_transpose contain a list
  # of outputs from each EDD. This opperation appends the list within each
  # element into a single data frame. Ultimately, a list with 3-elements is
  # produced: 1) Result, 2) Sample, and 3) batch. Where each element is a single
  # data frame.
  raw_combined <- list(
    result = purrr::map_dfr(raw_transposed$result, data.frame),
    sample = purrr::map_dfr(raw_transposed$sample, data.frame),
    batch = purrr::map_dfr(raw_transposed$batch, data.frame)
  )

  # Assign the ALS class to the object.
  raw_als <- Sentry::as_als(raw_combined)
  # End of function. Export an ALS object.
  return(raw_als)
}
