# ALS Schema
# Define the ALS schema and add schema as data that is
# accessible through the validator package.

als_schema <- list()
# Define the Result Schema -----------------------------------------------------
als_schema$result <- pointblank::col_schema(
 sys_sample_code = "character",
 lab_anl_method_name = "character",
 analysis_date = "datetime",
 fraction = "character",
 column_number = "numeric", # ?
 test_type = "character",
 lab_matrix_code = "character",
 analysis_location = "character",
 basis = "character", #?
 container_id = "character",
 dilution_factor = "numeric",
 prep_method = "character",
 prep_date = "datetime",
 leachate_method = "character",
 leachate_date = "datetime",
 lab_name_code = "character",
 qc_level = "character",
 lab_sample_id = "character",
 percent_moisture = "numeric",
 subsample_amount = "numeric",
 subsample_amount_unit = "character",
 analyst_name = "character",
 instrument_id = "character",
 comment = "character",
 preservative = "character",
 final_volume = "numeric",
 final_volume_unit = "character",
 cas_rn = "character",
 chemical_name = "character",
 result_value = "numeric",
 result_error_delta = "numeric", # ?
 result_type_code = "character",
 reportable_result = "character",
 detect_flag = "character",
 lab_qualifiers = "character",
 validator_qualifiers = "character",
 interpreted_qualifiers = "character",
 validated_yn = "character",
 method_detection_limit = "numeric",
 reporting_detection_limit = "numeric",
 quantitation_limit = "numeric",
 result_unit = "character",
 detection_limit_unit = "character",
 tic_retention_time = "character",
 minimum_detectable_conc = "numeric",
 counting_error = "numeric", # ?
 uncertainty = "numeric", # ?
 critical_value = "numeric", # ?
 validation_level = "numeric", # ?
 result_comment = "character",
 qc_original_conc = "numeric",
 qc_spike_added = "numeric",
 qc_spike_measured = "numeric",
 qc_spike_recovery = "numeric",
 qc_dup_original_conc = "numeric",
 qc_dup_spike_added = "numeric",
 qc_dup_spike_measured = "numeric",
 qc_dup_spike_recovery = "numeric",
 qc_rpd = "character",
 qc_spike_lcl = "numeric",
 qc_spike_ucl = "numeric", #
 qc_rpd_cl = "numeric",
 qc_spike_status = "character",
 qc_dup_spike_status = "character",
 qc_rpd_status = "character", #?
 lab_sdg = "character"
)

# Define the batch schema -------------------------------------------------

als_schema$batch <- pointblank::col_schema(
 sys_sample_code = "character",
 lab_anl_method_name = "character",
 analysis_date = "datetime",
 fraction = "character",
 column_number = "numeric",
 test_type = "character",
 test_batch_type = "character",
 test_batch_id = "character"
)


# Define sample schema ----------------------------------------------------

als_schema$sample <- pointblank::col_schema(
 data_provider = "character",
 sys_sample_code = "character",
 sample_name = "character",
 sample_matrix_code = "character",
 sample_type_code = "character",
 sample_source = "character",
 parent_sample_code = "character",
 sample_delivery_group = "character",
 sample_date = "datetime",
 sys_loc_code = "character",
 start_depth = "numeric",
 end_depth = "numeric",
 depth_unit = "character",
 chain_of_custody = "character",
 sent_to_lab_date = "datetime",
 sample_receipt_date = "datetime",
 sampler = "character",
 sampling_company_code = "character",
 sampling_reason = "character",
 sampling_technique = "character",
 task_code = "character",
 collection_quarter = "character",
 composite_yn = "character",
 composite_desc = "character",
 sample_class = "character",
 custom_field_1 = "character",
 custom_field_2 = "character",
 custom_field_3 = "character",
 comment = "character"
)

# Add Data to Package -----------------------------------------------------
usethis::use_data(als_schema, overwrite = TRUE)
