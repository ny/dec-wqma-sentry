#' Validated Column Names
#'
#' @param x a data frame of provided data.
#' @param expected a pointblank schema of expected data.
#' @param ... Arguments to be passed on to pointblank::col_exists.
#'
#' @return pointblank interrogated data.
#' @export

val_names <- function(x, expected, ...) {
  agent <- pointblank::create_agent(
    x,
    actions = pointblank::stop_on_fail(stop_at = 1)
  )

  validated <- pointblank::col_exists(x = agent,
                                      columns = names(expected),
                                      ...)

  pointblank::interrogate(validated)
}
