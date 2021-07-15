#' Standard Rmd Setup
#'
#' @return Side effects.
#' @export

rmd_setup <- function() {
  # Rmd Options -------------------------------------------------------------
  # Hide all code chunks by default
  knitr::opts_chunk$set(echo = FALSE)

  # pointblank rmd settings
  pointblank::validate_rmd(summary = FALSE,
                           log_to_file = NULL)

}
