#' Get Zip File Content Information
#'
#' @param .zip_path a file path to a zip file.
#' @return a data frame containing information about the zip file.
#' @export

get_zip_content <- function(.zip_path) {
  # unzip will extract zip content info
  zip_content <- utils::unzip(zipfile = .zip_path,
                              # Provides data frame of info
                              list = TRUE,
                              # prevents the unzip files from saving to disk
                              junkpaths = TRUE)

  # Add a column that contains the name of the zip file
  # Makes it clear where the data came from
  zip_content$zip_file <- sub(".*\\/", "", .zip_path)

  return(zip_content)
}

#' Read a Single File From a Zip File
#' Provides some flexibility regarding the file type to be imported.
#' @param .file the name of a single file contained within a zip file.
#' @param ... pass arguements on to read.csv or read.table.
#' @inheritParams get_zip_content
#' @return A single object extracted from a zip file.

read_zip_element <- function(.file, .zip_path, ...) {

  # Identify the file extension
  file_extension <- substring(.file,
                              regexpr("\\.([[:alnum:]]+)$",
                                      .file) + 1L)

  # Apply the proper import based on the file extension
  if (file_extension %in% "csv") {
    final <- read.csv(unz(description = .zip_path,
                          filename = .file),
                      header = TRUE,
                      check.names = FALSE,
                      na.strings = c("", "NA", "N/A",
                                     "na", "n/a"),
                      strip.white = TRUE,
                      stringsAsFactors = FALSE,
                      ...)

  } else if (file_extension %in% "txt") {

    # Read in the first row to try and guess the delimiter
    first_row <- read.csv(unz(description = .zip_path,
                              filename = .file),
                          nrow = 1,
                          ...)

    delimiter <- ifelse(
      test = grepl("\\t", first_row[1, 1]),
      yes = "\t",
      no = ",")

    final <- read.table(unz(description = .zip_path,
                            filename = .file),
                        header = TRUE,
                        check.names = FALSE,
                        sep = delimiter,
                        na.strings = c("", "NA", "N/A",
                                       "na", "n/a"),
                        strip.white = TRUE,
                        stringsAsFactors = FALSE,
                        ...)

  } else if (file_extension %in% c("htm", "html")) {
    # NOT READING CORRECTLY
    final <- read_htm(.zip_path = .zip_path,
                      .file = .file)
  } else {
    # Provide error message if not one of the file types referenced above
    stop(paste("read_zip_element does not know how to read files of type",
               file_extension))
  }
  # If there is more than one column name that is blank,
  # then assume that no header was provide.
  # Add the header as a row to the DF and convert the column type.
  if (sum(nchar(names(final)) == 0, na.rm = TRUE) >= 2) {
    # Append the column names as a row to the DF.
    final_append <- rbind(names(final), final)
    # Provide the best guess at the column type.
    # Also, overwrite the existing "final" DF.
    final <- type.convert(final_append , as.is = TRUE)
    # Assign dummy column names to the DF.
    names(final) <- paste0("x", seq_along(final))
  }
  # End of function. Return a DF.
  return(final)
}


#' Read and Clean HTM Strings
#'
#' @inheritParams get_zip_content
#' @inheritParams read_zip_element
#'
#' @return a clean htm string.

read_htm <- function(.zip_path, .file) {
  init_string <- paste(
    readLines(
      con = unzip(zipfile = .zip_path,
                  files = .file,
                  junkpaths = TRUE,
                  exdir = tempdir()),
      encoding = "UTF-8",
      skipNul = FALSE,
      warn = FALSE
    ),
    collapse = "\n"
  )

  gsub("\\", "/", init_string, fixed = TRUE)
}


#' Read in Files Contained in a Zip File
#'
#' @inheritParams get_zip_content
#' @inheritParams read_zip_element
#' @return A list of objects imported from a zip file.
#' @export

read_zip <- function(.zip_path, ...) {
  # validator function call to extract file names contained in zip
  name_vec <- get_zip_content(.zip_path = .zip_path)$Name
  # Extract the contents of the zip file into a list
  zip_list <- lapply(X = name_vec,
                     FUN = function(file_i) {
                       # Internal validator function
                       read_zip_element(.file = file_i,
                                        .zip_path = .zip_path,
                                        ...)
                     })
  # Name the elements of the list with the file names
  names(zip_list) <- name_vec

  # Return the list of files
  return(zip_list)
}
