#' Run Validation Process (API Use Only)
#'
#' @param input_path The file path for the data to be imported into this script.
#'
#' @return a JSON object.
#' @export
run_validation <- function(input_path) {
  # Guard Clause ----------------------------------------------------------------
  # WQMA Devs will pass the object 'input_path' and 'output-path' from Java to the
  # global environment of this R-script.
  # The following statement will provide an informative error message if basic
  #  assumptions for this object are not met.
  stopifnot(
    "'input_path' does not exist. This object is expected to be passed to this script by WQMA Devs." = exists("input_path"),
    "'input_path' must be a vector of length 1." = length(input_path) == 1,
    "'input_path must be a character vector." = is.character(input_path),
    "'input_path must exist." = file.exists(input_path)#,
    # "'output_path' does not exist. This object is expected to be passed to this script by WQMA Devs." = exists("output_path"),
    # "'output_path' must be a vector of length 1." = length(output_path) == 1,
    # "'output_path must be a character vector." = is.character(output_path),
    # "'output_path must exist." = file.exists(output_path)
  )

  # Extract & Transform -----------------------------------------------------
  sdg_string <- tools::file_path_sans_ext(
    x = basename(input_path)
  )

  extracted_list <- Sentry::read_als(zip_path = input_path)

  validated <- Sentry::workflow(x = extracted_list,
                                filename = sdg_string)
  # Load --------------------------------------------------------------------
#
#   Sentry::export_json(
#     x = validated,
#     path = output_path,
#     filename = "r2004299"
#   )
  jsonlite::toJSON(
    x = validated,
    na = "string",
    pretty = TRUE
  )
}
