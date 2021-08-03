als <- read_als(zip_path = here::here('inst',
                                       'example_zips',
                                       'R2004299.zip'))
usethis::use_data(als,
                  overwrite = TRUE)
