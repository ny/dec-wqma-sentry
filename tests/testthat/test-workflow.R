test_that("ALS workflow", {
  r2004299 <- read_als(zip_path = here::here("inst",
                                             "example_zips",
                                             "R2004299.zip"))
  temp_path <- tempdir()
  on.exit(unlink(temp_path))

  als_wf <- workflow(
    x = r2004299,
    filename = "R2004299",
    gen_report = TRUE
  )

  export_json(
    x =  als_wf,
    path = temp_path,
    filename = "R2004299"
  )

})



test_that("ALS workflow: Missing Result Table", {

 no_result <- read_als(zip_path = here::here("inst",
                                             "example_zips",
                                             "R2004299",
                                             "no_result.zip"))
  temp_path <- tempdir()
  on.exit(unlink(temp_path))

  wf <- workflow(
    x = no_result,
    filename = "R2004299",
    gen_report = FALSE
  )

  testthat::expect_equal(
    wf$validation_summary$email_body,
    jsonlite::unbox(
      "R2004299, did not pass the automated validation for the following reason(s): <br/> 1) The Result Table was missing from the raw data."
    )
  )

  testthat::expect_null(wf$data)

})


test_that("ALS workflow: Missing Batch Table", {

  no_batch <- read_als(zip_path = here::here("inst",
                                              "example_zips",
                                              "R2004299",
                                              "no_batch.zip"))
  temp_path <- tempdir()
  on.exit(unlink(temp_path))

  wf <- workflow(
    x = no_batch,
    filename = "R2004299",
    gen_report = FALSE
  )

  testthat::expect_equal(
    wf$validation_summary$email_body,
    jsonlite::unbox(
      "R2004299, did not pass the automated validation for the following reason(s): <br/> 1) The Batch Table was missing from the raw data."
    )
  )

  testthat::expect_null(wf$data)

})

test_that("ALS workflow: Handles all expected information missing", {

  all_missing <- read_als(zip_path = here::here("inst",
                                             "example_zips",
                                             "R2004299",
                                             "unexpected.zip"))
  temp_path <- tempdir()
  on.exit(unlink(temp_path))

  wf <- workflow(
    x = all_missing,
    filename = "R2004299",
    gen_report = FALSE
  )

  testthat::expect_equal(
    wf$validation_summary$email_body,
    jsonlite::unbox(
      "R2004299, did not pass the automated validation for the following reason(s): <br/> 1) The Result Table was missing from the raw data. <br/> 2) The Batch Table was missing from the raw data. <br/> 3) The Sample Table was missing from the raw data."
    )
    )


  testthat::expect_null(wf$data)

})

test_that("ALS workflow: No Tables", {

  no_sample <- read_als(zip_path = here::here("inst",
                                              "example_zips",
                                              "R2004299",
                                              "no_sample.zip"))
  temp_path <- tempdir()
  on.exit(unlink(temp_path))

  wf <- workflow(
    x = no_sample,
    filename = "R2004299",
    gen_report = FALSE
  )

  testthat::expect_equal(
    wf$validation_summary$email_body,
    jsonlite::unbox(
      "R2004299, did not pass the automated validation for the following reason(s): <br/> 1) The Sample Table was missing from the raw data."
    )

  )

  testthat::expect_null(wf$data)

})

test_that("ALS workflow: Multiple Failures", {

  r2004299 <- read_als(zip_path = here::here("inst",
                                             "example_zips",
                                             "R2004299",
                                             "missing_cols_bad_values.zip"))
  # Missing Columns
  r2004299$result <- r2004299$result[1:10]
  # Incorrect Types
  r2004299$batch$fraction <- TRUE
  suppressWarnings(
    r2004299$batch$test_batch_id <- as.numeric(r2004299$batch$test_batch_id)
  )
  # Outside of expected range.
  r2004299$sample$sample_date <- as.POSIXct("2060-01-01")
  r2004299$sample$composite_yn <- "yes"

  lapply(r2004299[1:3], function(x) {

  })

  write.csv(
    x = r2004299$result,
    file = here::here("inst",
                      "example_zips",
                      "mod_result.csv"),
    row.names = FALSE
  )

  write.csv(
    x = r2004299$batch,
    file = here::here("inst",
                      "example_zips",
                      "mod_batch.csv"),
    row.names = FALSE
  )

  write.csv(
    x = r2004299$sample,
    file = here::here("inst",
                      "example_zips",
                      "mod_sample.csv"),
    row.names = FALSE
  )




  temp_path <- tempdir()
  on.exit(unlink(temp_path))

  wf <- workflow(
    x = r2004299,
    filename = "R2004299",
    gen_report = FALSE
  )

  testthat::expect_equal(
    wf$validation_summary$email_body,
    jsonlite::unbox(
      "R2004299, did not pass the automated validation for the following reason(s): <br/> 1) 56 name(s) missing from Result Table."
    )
  )

})
