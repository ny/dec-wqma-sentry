
#' Validate the Provided Data
#'
#' @param x
#' @param actions
#'
#' @return
#' @export
validate <- function(x, actions) {
  UseMethod("validate", x)
}

#' @export
validate.ALS_result <- function(x, actions) {
  result <- list()
  result$raw <- x
  result$post <- result$raw

  result$names <- pointblank::create_agent(
    data.frame(result$raw),
    actions = actions
  ) %>%
    pointblank::col_exists(x = ., columns = c(names(als_schema$result))) %>%
    pointblank::interrogate(agent = .)

  for (i in names(result$post)) {
    result$post[[i]] <- switch_class(
      result$post[[i]],
      expected_class = als_schema$result[[i]]
    )
  }

result$classes <- pointblank::create_agent(
  data.frame(result$post),
  actions = actions
) %>%
  pointblank::col_is_character(x = .,
                   columns = get_schema_class(x = als_schema$result,
                                              "character")) %>%
  pointblank::col_is_posix(x = .,
               columns = get_schema_class(x = als_schema$result,
                                          "datetime")) %>%
  pointblank::col_is_numeric(x = .,
                 columns = get_schema_class(x = als_schema$result,
                                            "numeric")) %>%
  pointblank::interrogate(agent = .)

result$expected_values <- pointblank::create_agent(
  data.frame(result$post),
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
                                "subsample_amount_unit",
                                "cas_rn",
                                "chemical_name",
                                "result_type_code",
                                "reportable_result",
                                "detect_flag",
                                "result_unit",
                                "detection_limit_unit",
                                "lab_sdg",
                                "dilution_factor",
                                "subsample_amount"
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
  pointblank::interrogate()

return(result)

}

#' @export
validate.ALS_batch <- function(x, actions) {
  batch <- list()
  batch$raw <- x
  batch$post <- batch$raw

  batch$names <- pointblank::create_agent(
    data.frame(batch$raw),
    actions = actions
  ) %>%
    pointblank::col_exists(x = ., columns = c(names(als_schema$batch))) %>%
    pointblank::interrogate(agent = .)

  for (i in names(batch$post)) {
    batch$post[[i]] <- switch_class(
      batch$post[[i]],
      expected_class = als_schema$batch[[i]]
    )
  }

  batch$classes <- pointblank::create_agent(
    data.frame(batch$post),
    actions = actions
  ) %>%
    pointblank::col_is_character(x = .,
                     columns = get_schema_class(x = als_schema$batch,
                                                "character")) %>%
    pointblank::col_is_posix(x = .,
                 columns = get_schema_class(x = als_schema$batch,
                                            "datetime")) %>%
    pointblank::col_is_numeric(x = .,
                   columns = get_schema_class(x = als_schema$batch,
                                              "numeric")) %>%
    pointblank::interrogate(agent = .)

  batch$expected_values <- pointblank::create_agent(
    data.frame(batch$post),
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
    pointblank::interrogate()

  return(batch)
}

#' @export
validate.ALS_sample <- function(x, actions) {
  sample <- list()
  sample$raw <- x
  sample$post <- sample$raw

  sample$names <- pointblank::create_agent(
    data.frame(sample$raw),
    actions = actions
  ) %>%
    pointblank::col_exists(x = ., columns = c(names(als_schema$sample))) %>%
    pointblank::interrogate(agent = .)

  for (i in names(sample$post)) {
    cat(i)
    sample$post[[i]] <- switch_class(
      x = sample$post[[i]],
      expected_class = als_schema$sample[[i]]
    )
  }

  sample$classes <- pointblank::create_agent(
    data.frame(sample$post),
    actions = actions
  ) %>%
    pointblank::col_is_character(x = .,
                     columns = get_schema_class(x = als_schema$sample,
                                                "character")) %>%
    pointblank::col_is_posix(x = .,
                 columns = get_schema_class(x = als_schema$sample,
                                            "datetime")) %>%
    pointblank::col_is_numeric(x = .,
                   columns = get_schema_class(x = als_schema$sample,
                                              "numeric")) %>%
    pointblank::interrogate(agent = .)

  sample$expected_values <- pointblank::create_agent(
    data.frame(sample$post),
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
    pointblank::interrogate()

  return(sample)

}

#' @export
validate.ALS_htm <- function(x, actions) {
  return(x)
}
