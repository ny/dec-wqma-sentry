## code to prepare `pcodes_df` dataset goes here
dir <- file.path(
  "L:",
  "DOW",
  "BWAM Share",
  "data",
  "streams",
  "cleaned_files",
  "Final_Chemistry_ITS"
  )

pcode_join_df <- readr::read_csv(file.path(dir,
                                           "pcode_join_table",
                                           "dec_pcode_join_2022-03-08.csv")) |>
  dplyr::select(
    pcode = DEC_pcode_FINAL,
    source = RESULT_TYPE,
    als_parameter = chemical_name,
    als_fraction = fraction,
    als_units = result_unit
  )

pcode_raw_df <- readr::read_csv(file.path(dir,
                                          "MASTER_S_CHEM_PARAMETER_2023_06_29.csv")) |>
  dplyr::select(
    pcode = CHEM_PARAMETER_PCODE,
    source = CHEM_PARAMETER_SOURCE,
    parameter = CHEM_PARAMETER_NAME,
    fraction = CHEM_PARAMETER_FRACTION,
    units_nosp = CHEM_PARAMETER_UNIT_NOSP,
    units = CHEM_PARAMETER_UNIT,
    group = CHEM_PARAMETER_GROUP,
    notes = CHEM_PARAMETER_NOTES
  )

valid_params <- dplyr::left_join(
  x = pcode_join_df,
  y = pcode_raw_df,
  by = dplyr::join_by(pcode, source)
) |>
  dplyr::select(-pcode)

usethis::use_data(valid_params, overwrite = TRUE)
