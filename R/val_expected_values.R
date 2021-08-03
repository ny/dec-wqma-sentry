
#' Validate Expected Values in Columns
#'
#' @param x
#' @param actions
#'
#' @return A pointblank interrogation.
#' @export

val_expected_values <- function(x, actions) {
  UseMethod("val_expected_values", x)
}

#' @export
val_expected_values.ALS_result <- function(x, actions) {
  pointblank::create_agent(
    data.frame(x),
    actions = actions
  ) %>%
    pointblank::col_vals_not_null(x = .,
                                  columns = c("sys_sample_code",
                                              "analysis_date",
                                              "lab_anl_method_name",
                                              "fraction",
                                              "test_type",
                                              "lab_matrix_code",
                                              "analysis_location",
                                              "lab_name_code",
                                              "qc_level",
                                              "lab_sample_id",
                                              # "subsample_amount",
                                              # "subsample_amount_unit",
                                              "cas_rn",
                                              "chemical_name",
                                              "result_type_code",
                                              "reportable_result",
                                              "detect_flag",
                                              "result_unit",
                                              "detection_limit_unit",
                                              "lab_sdg",
                                              "dilution_factor"
                                  )) %>%
    pointblank::col_vals_in_set(x = .,
                                columns = "fraction",
                                set = c("D", "T")) %>%
    pointblank::col_vals_between(x = .,
                                 columns = c("analysis_date",
                                             "prep_date",
                                             "leachate_date"),
                                 left = as.POSIXct("2020-01-01 00:00:00",
                                                   tz = "America/New_York"),
                                 right = as.POSIXct(Sys.time(),
                                                    tz = "America/New_York"),
                                 na_pass = TRUE) %>%
    pointblank::col_vals_in_set(x = .,
                                columns = "reportable_result",
                                set = c("Yes", "No")) %>%
    pointblank::col_vals_in_set(x = .,
                                columns = "detect_flag",
                                set = c("Y", "N")) %>%
    pointblank::interrogate(agent = .)
}

#' @export
val_expected_values.ALS_batch <- function(x, actions) {
  pointblank::create_agent(
    data.frame(x),
    actions = actions
  ) %>%
    pointblank::col_vals_not_null(x = .,
                                  columns = c("sys_sample_code",
                                              "lab_anl_method_name",
                                              "analysis_date",
                                              "fraction",
                                              "test_type",
                                              "test_batch_type",
                                              "test_batch_id")) %>%
    pointblank::col_vals_in_set(x = .,
                                columns = "fraction",
                                set = c("D", "T")) %>%
    pointblank::col_vals_between(x = .,
                                 columns = "analysis_date",
                                 left = as.POSIXct("2020-01-01 00:00:00",
                                                   tz = "America/New_York"),
                                 right = as.POSIXct(Sys.time(),
                                                    tz = "America/New_York")
    ) %>%
    pointblank::interrogate(agent = .)
  }

#' @export
val_expected_values.ALS_sample <- function(x, actions) {
  pointblank::create_agent(
    data.frame(x),
    actions = actions
  ) %>%
    pointblank::col_vals_not_null(x = .,
                                  columns = c("data_provider",
                                              "sys_sample_code",
                                              "sample_name",
                                              "sample_matrix_code",
                                              "sample_source",
                                              "sample_delivery_group",
                                              "sample_date",
                                              "sys_loc_code",
                                              "sampling_company_code",
                                              "task_code",
                                              "composite_yn")) %>%
    pointblank::col_vals_in_set(x = .,
                                columns = "composite_yn",
                                set = c("y", "n")) %>%
    pointblank::col_vals_between(x = .,
                                 columns = c("sample_date",
                                             "sent_to_lab_date",
                                             "sample_receipt_date"),
                                 left = as.POSIXct("2020-01-01 00:00:00",
                                                   tz = "America/New_York"),
                                 right = as.POSIXct(Sys.time(),
                                                    tz = "America/New_York"),
                                 na_pass = TRUE
    ) %>%
    pointblank::interrogate(agent = .)
}
