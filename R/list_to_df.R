
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

