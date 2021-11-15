test_that("multiplication works", {
  r2004299 <- read_als(zip_path = here::here("inst",
                                             "example_zips",
                                             "R2004299.zip"))

  temp_path <- tempdir()
  on.exit(unlink(temp_path))

  gen_val_report(
    x = r2004299,
    output_dir = temp_path,
    filename = "R20004299"
  )
})
