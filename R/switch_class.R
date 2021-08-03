

#' Switch Class Based on Expected Class
#'
#' @param x a vector
#' @param expected_class a character string.
#'
#' @return
#' @export

switch_class <- function(x, expected_class) {
  # Extra work to check for Posix classes
  expected <- expected_class
  if (expected_class == "datetime") expected <- c("POSIXct", "POSIXt")
  # End early. No work to be done.
  if (all(class(x) %in% expected)) return(x)

  switch(
    expected_class,
    "date" = as.Date(x = x,
                     format = "%m/%d/%Y",
                     tz = "America/New_York"),
    "datetime" = as.POSIXct(x = x,
                            format = "%m/%d/%Y %H:%M:%S",
                            tz = "America/New_York"),
    "character" = as.character(x),
    "numeric" = as.numeric(x),
    "logical" = as.logical(x),
    stop("The supplied `expected_type` does not match an expected value.")
  )
}

#' Correct the Column Classes
#'
#' @inheritParams switch_class
#' @param schema a pointblank schema that supplies the correct class.
#'
#' @return a data frame.
#' @export

correct_class <- function(x, schema) {
  for (i in names(x)) {
    x[[i]] <- switch_class(
      x[[i]],
      expected_class = schema[[i]]
    )
  }

  return(x)
}

