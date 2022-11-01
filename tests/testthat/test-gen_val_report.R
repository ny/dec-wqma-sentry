test_that("Test report can be generated", {
  r2004299 <- read_als(zip_path = here::here("inst",
                                             "example_zips",
                                             "R2004299.zip"))

  temp_path <- tempdir()
  on.exit(unlink(temp_path))

  wf <- workflow(
    x = r2004299,
    filename = "R2004299",
    gen_report = TRUE
  )

})
