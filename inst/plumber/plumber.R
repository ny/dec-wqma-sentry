# plumber.R

#* Echo the parameter that was sent in
#* @param input_path The file path for the data to be imported into this script.
# #* @param output_path The file path for the data to be exported from this script.
#* @get /boxed

# Test path: C:/Users/zmsmith.000/OneDrive - New York State Office of Information Technology Services/projects/dow/dow-als-processing/data/example_zips
function(input_path){
  Sentry::run_validation(input_path)
}


