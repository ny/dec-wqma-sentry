#' Nest a Data Frame by SDG and sys_sample_code
#'
#' @param x  a data frame.
#'
#' @return a list.
#' @export

nest_sdg_ssc <- function(x) {
  sdg_check <- any(names(x) %in% "sample_delivery_group")
  ssc_check <- any(names(x) %in% "sys_sample_code")

  stopifnot(
    "x must be a data frame" = is.data.frame(x),
    'x is must contain the column name: "sample_delivery_group"' = sdg_check,
    'x is must contain the column name: "sys_sample_code"' = ssc_check
  )
  # List of each SDG.
  sdg_list <- split(x = x,
                    f = x$sample_delivery_group)
  # List of each sys_sample_code.
  lapply(
    sdg_list,
    FUN = function(sdg_i) {
      split(x = sdg_i,
            f = sdg_i$sys_sample_code)
    }
  )
}
