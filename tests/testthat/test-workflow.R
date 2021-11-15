test_that("workflow", {
  r2004299 <- read_als(zip_path = here::here("inst",
                                             "example_zips",
                                             "R2004299.zip"))
  temp_path <- tempdir()
  on.exit(unlink(temp_path))

  workflow(
    x = r2004299,
    filepath = temp_path,
    filename = "R2004299"
  )

})

