test_that("ALS workflow", {
  r2004299 <- read_als(zip_path = here::here("inst",
                                             "example_zips",
                                             "R2004299.zip"))
  temp_path <- tempdir()
  on.exit(unlink(temp_path))

  als_wf <- workflow(
    x = r2004299,
    filename = "R2004299"
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
    wf$report$message,
    "The ALS SDG, R2004299, did not pass the automated validation for the following reason(s): * 66 name(s) missing from Result Table."
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
    wf$report$message,
    "The ALS SDG, R2004299, did not pass the automated validation for the following reason(s): * 8 name(s) missing from Batch Table."
  )

  testthat::expect_null(wf$data)

})

test_that("ALS workflow: Missing Sample Table", {

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
    wf$report$message,
    "The ALS SDG, R2004299, did not pass the automated validation for the following reason(s): * 29 name(s) missing from Sample Table."
  )

  testthat::expect_null(wf$data)

})
