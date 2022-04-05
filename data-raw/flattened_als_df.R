## code to prepare `DATASET` dataset goes here
extracted_list <- Sentry::read_als(zip_path = here::here("inst",
                                                         "example_zips",
                                                         "R2004299.zip"))

flattened_als_df <- Sentry::flatten_als(x = extracted_list)
usethis::use_data(flattened_als_df, overwrite = TRUE)
