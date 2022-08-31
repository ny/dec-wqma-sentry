test_that("export_json R2004299", {

  r2004299 <- read_als(zip_path = here::here("inst",
                                             "example_zips",
                                             "R2004299.zip"))
  flattened <- list_to_df(x = r2004299)

  nested <- nest_sdg_ssc(x = flattened)


  temp_path <- tempdir()
  on.exit(unlink(temp_path))

  expect_silent(
    export_json(
      x = nested,
      path = temp_path,
      filename = "temp_r2005223"
    )
  )

  raw_json <- jsonlite::fromJSON(file.path(temp_path, "temp_r2005223.json"),
                     simplifyVector = TRUE)

  expect_equal(
    names(raw_json),
    names(nested)
  )

  expect_equal(
    names(raw_json$data[[1]]),
    names(nested$data[[1]])
  )

})

test_that("export_json R2005223", {

  r2005223 <- read_als(zip_path = here::here("inst",
                                             "example_zips",
                                             "R2005223.zip"))
  flattened <- list_to_df(x = r2005223)

  nested <- nest_sdg_ssc(x = flattened)


  temp_path <- tempdir()
  on.exit(unlink(temp_path))

  expect_silent(
    export_json(
      x = nested,
      path = temp_path,
      filename = "temp_r2005223"
    )
  )

  raw_json <- jsonlite::fromJSON(file.path(temp_path, "temp_r2005223.json"),
                                 simplifyVector = TRUE)
  expect_equal(
    names(raw_json),
    names(nested)
  )

  expect_equal(
    names(raw_json$data[[1]]),
    names(nested$data[[1]])
  )

})
