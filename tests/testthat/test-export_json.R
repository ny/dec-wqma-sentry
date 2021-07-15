test_that("export_json R2004299", {

  r2004299 <- read_als(zip_path = here::here("inst",
                                             "example_zips",
                                             "R2004299.zip"))

  temp_path <- tempdir()
  on.exit(unlink(temp_path))

  expect_silent(
    export_json(
      x = r2004299,
      path = temp_path,
      filename = "temp_r2005223"
    )
  )

  expect_equal(
    object = jsonlite::fromJSON(file.path(temp_path, "temp_r2005223.json"),
                                simplifyVector = TRUE),
    expected = r2004299
  )

})

test_that("export_json R2005223", {

  r2005223 <- read_als(zip_path = here::here("inst",
                                             "example_zips",
                                             "R2005223.zip"))

  temp_path <- tempdir()
  on.exit(unlink(temp_path))

  expect_silent(
    export_json(
      x = r2005223,
      path = temp_path,
      filename = "temp_r2005223"
    )
  )

  expect_equal(
    object = jsonlite::fromJSON(file.path(temp_path, "temp_r2005223.json"),
                                simplifyVector = TRUE),
    expected = r2005223
  )

})
