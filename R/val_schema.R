#' Title
#'
#' @param variables
#'
#' @return
#' @export

val_schema <- function(x) {
    UseMethod("val_schema", x)
}


#' @export

val_schema.ALS <- function(x) {
  val_list <- list()

  for (i in c("result", "batch", "sample")) {
    val_list[[i]] <- val_names(x = x[[i]],
                               expected = als_schema[[i]])
  }



  return(val_list)
}
