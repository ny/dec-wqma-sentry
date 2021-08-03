#' Get a List Element
#'
#' @param list a named list object.
#' @param pattern a regular expression to be matched to a character string.
#' @param clean_names a logical indicating if column names should be cleaned.
#'
#' @return a single element of a list.
#'
#' @examples
#' get_element(list = list(first_element = 1:3,
#'  second_element = 4:6),
#'  pattern = "second")
get_element <- function(list, pattern, clean_names = FALSE) {
  stopifnot(
    is.list(list),
    !is.data.frame(list)
  )
  # A named list is required
  if (is.null(names(list))) stop("list must contain named elements.")
  # Identify the list names that match the provided pattern
  pattern_vec <- grepl(
    pattern = pattern,
    x = names(list),
    perl = TRUE
  )
  # Identify the matched names
  name_vec <- names(list)[pattern_vec]
  # End early if no match found.
  if (length(name_vec) == 0) {
    # Provide a warning message that no match was found.
    warning(
      "No element matched the supplied pattern:",
      paste0('"', pattern, '"')
    )
    # Return NULL early.
    return(NULL)
  }
  # Ensure that only one name was matched
  if (length(name_vec) > 1) {
    stop(
      "Matched list names must be length 1. \n",
      "\t Pattern:", pattern, "\n",
      "\t Matches:", paste(name_vec, collapse = ", \n\t\t")
    )
  }

  # Extract the element from the list
  extracted <- list[[name_vec]]
  if (isTRUE(clean_names)) names(extracted) <- clean_strings(names(extracted))
  return(extracted)
}

#' Replace non-numeric or non-character values with "_".
#'
#' @param x a character vector.
#' @return A character vector.
underscore <- function(x) {
  gsub("[^A-Za-z0-9]", "_", x)
}

#' Trim Leading and Trailing Underscores
#'
#' @param variables
#'
#' @return

trim_underscore <- function(x) {
  x <- ifelse(startsWith(x, "_"),
              substr(x, start = 2, stop = nchar(x)),
              x)
  ifelse(endsWith(x, "_"),
         substr(x, start = 1, stop = nchar(x) - 1),
         x)
}

#' Standardized string formatting.
#'
#' @param x a character vector.
#' @return A character vector.
#' @export
clean_strings <- function(x) {
  trim_underscore(underscore(trimws(tolower(x))))
}

#' Get Schema Class
#'
#' @param x a pointblank schema object.
#' @param class_type a character string representing the class of interest.
#'
#' @return a characer vector
#' @export

get_schema_class <- function(x, class_type) {
  stopifnot(
    class(x) %in% c("r_type", "col_schema"),
    length(class_type) == 1
  )
  names(x[x %in% class_type])
}

#' Import an HTML file
#'
#' @param filepath
#'
#' @return
#' @export

read_html <- function(filepath) {
  init_string <- paste(
    readLines(
      con = filepath,
      encoding = "UTF-8",
      skipNul = FALSE,
      warn = FALSE
    ),
    collapse = "\n"
  )

  gsub("\\", "/", init_string, fixed = TRUE)
}
