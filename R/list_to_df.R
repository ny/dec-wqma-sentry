
#' Convert a list to a data frame based on special class
#'
#' @param x a list.
#'
#' @return a data frame.
#' @export

list_to_df <- function(x) {
  UseMethod("list_to_df", x)
}


#' Flatten ALS Objects into a Single Data Frame.
#'
#' @param x an ALS object.
#'
#' @return a data frame.
#' @export

list_to_df.ALS <- function(x) {
  # Standardize the column name to match name of the same value in "sample".
  names(x$result)[names(x$result) %in% "lab_sdg"] <- "sample_delivery_group"

  init_join <- merge(
    x = x$sample,
    y = x$result,
    by = c("sys_sample_code",
           "sample_delivery_group"),
    all = TRUE
  )

  second_join <- merge(
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
  # This is necessary for creating a common value to query on when this data is
  # stored as individual JSON objects representing a row of this DF.
  second_join$table <- "chemistry"

  primary_cols_vec <- c(
    "table",
    "sys_sample_code",
    "sample_date",
    "fraction",
    "chemical_name",
    "cas_rn",
    "result_value",
    "result_unit",
    "lab_qualifiers",
    "validator_qualifiers",
    "interpreted_qualifiers",
    "method_detection_limit",
    "reporting_detection_limit",
    "detection_limit_unit",
    "quantitation_limit",
    "sample_source",
    "sample_type_code",
    "sample_delivery_group"
  )

  additional_cols_vec <- names(second_join)[!names(second_join) %in% primary_cols_vec]

  final_df <- second_join[c(primary_cols_vec, additional_cols_vec)]

  return(final_df)
}

