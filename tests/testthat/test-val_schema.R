test_that("val_schema.ALS", {
  r2004299 <- read_als(zip_path = here::here("inst",
                                             "example_zips",
                                             "R2004299.zip"))

  r2005223 <- read_als(zip_path = here::here("inst",
                                             "example_zips",
                                             "R2005223.zip"))
  expect_error(
    val_schema(list())
  )
  test2 <- val_schema(r2004299)


})
