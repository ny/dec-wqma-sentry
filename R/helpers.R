#' Get a List Element
#'
#' @param .list a named list object.
#' @param .pattern a regular expression to be matched to a character string.
#'
#' @return a single element of a list.
#'
#' @examples
#' get_element(.list = list(first_element = 1:3,
#'  second_element = 4:6),
#'  .pattern = "second")
get_element <- function(.list, .pattern) {
  stopifnot(
    is.list(.list),
    !is.data.frame(.list)
  )
  # A named list is required
  if (is.null(names(.list))) stop(".list must contain named elements.")
  # Identify the list names that match the provided pattern
  pattern_vec <- grepl(
    pattern = .pattern,
    x = names(.list),
    perl = TRUE
  )
  # Identify the matched names
  name_vec <- names(.list)[pattern_vec]
  # End early if no match found.
  if (length(name_vec) == 0) {
    # Provide a warning message that no match was found.
    warning(
      "No element matched the supplied pattern:",
      paste0('"', .pattern, '"')
    )
    # Return NULL early.
    return(NULL)
  }
  # Ensure that only one name was matched
  if (length(name_vec) > 1) {
    stop(
      "Matched list names must be length 1. \n",
      "\t Pattern:", .pattern, "\n",
      "\t Matches:", paste(name_vec, collapse = ", \n\t\t")
    )
  }
  # Extract the element from the list
  .list[[name_vec]]
}
