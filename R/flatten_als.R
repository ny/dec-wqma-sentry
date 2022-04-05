#' Flatten ALS Objects into a Single Data Frame.
#'
#' @param x an ALS object.
#'
#' @return a data frame.
#' @export

flatten_als <- function(x) {
  stopifnot(
    "x must be class 'ALS'." = "ALS" %in% class(x)
  )

  init_join <- merge(
    x = x$sample,
    y = x$result,
    by = "sys_sample_code",
    all = TRUE
  )

  final_df <- merge(
    x = init_join,
    y = x$batch,
    by = c(
      "sys_sample_code",
      "lab_anl_method_name",
      "analysis_date",
      "fraction",
      "column_number",
      "test_type"
    ),
    all = TRUE
  )

  return(final_df)
}

