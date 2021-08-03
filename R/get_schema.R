#' Get the Appropriate Schema Object based on Supplied Object Class
#'
#' @param x a pointblank schema object.
#'
#' @return a pointblank schema object.
#' @export

get_schema <- function(x) {
  UseMethod("get_schema", x)
}

#' @export
get_schema.ALS_result <- function(x) {
  als_schema$result
}

#' @export
get_schema.ALS_batch <- function(x) {
  als_schema$batch
}

#' @export
get_schema.ALS_sample <- function(x) {
  als_schema$sample
}
