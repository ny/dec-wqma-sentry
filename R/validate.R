
#' Validate the Provided Data
#'
#' @param x
#' @param actions
#'
#' @return
#' @export
validate <- function(x, actions) {
  UseMethod("validate", x)
}

#' @export
validate.ALS <- function(x, actions) {
  if ("ALS_htm" %in% class(x)) return(x)
  obj <- list(
    raw = NULL,
    post = NULL,
    names = NULL,
    classes = NULL,
    expected_values = NULL,
    error_summary = NULL
  )
  obj$raw <- x
  obj$post <- obj$raw
  schema <- get_schema(x = x)


  obj$names <- validate_names(
    x = obj$raw,
    schema = schema,
    actions = actions
  )

  n_names_failed <- sum(obj$names$validation_set$n_failed)

  if (n_names_failed > 0) {
    tar_class <- class(x)[!class(x) %in% c("data.frame", "ALS")]
    class_message <- switch(tar_class,
                            "ALS_result" = "Result Table.",
                            "ALS_batch" = "Batch Table.",
                            "ALS_sample" = "Sample Table.",
                            stop("Unexpected Class Supplied."))
    obj$error_summary <- paste(n_names_failed,
                               "name(s) missing from",
                               class_message
                               )
    return(obj)
  }

  obj$post <- correct_class(
    x = obj$post,
    schema = schema
  )
  # When the fraction col is filled with "T",
  # R imports this column as a logical and interprets "T" to mean TRUE.
  # This switches the value back to the appropriate "T" value.
  if ("fraction" %in% names(obj$post)) {
    obj$post$fraction <- ifelse(
      test = obj$post$fraction %in% "TRUE",
      yes = "T",
      no = obj$post$fraction
    )
  }

  obj$classes <- validate_class(
    x = obj$post,
    schema = schema,
    actions = actions
  )

  obj$expected_values <- val_expected_values(
    x = obj$post,
    actions = actions
  )

return(obj)

}

validate_names <- function(x, schema, actions) {
  pointblank::create_agent(
    data.frame(x),
    actions = actions
  ) %>%
    pointblank::col_exists(x = ., columns = c(names(schema))) %>%
    pointblank::interrogate(agent = .)
}


#' Title
#'
#' @param x
#' @param schema
#' @param actions
#'
#' @return

validate_class <- function(x, schema, actions) {
  agent <- pointblank::create_agent(
    data.frame(x),
    actions = actions
  )

  if (any(schema == "character")) {
    agent <- pointblank::col_is_character(
      x = agent,
      columns = get_schema_class(x = schema,
                                 "character")
    )
  }

  if (any(schema == "datetime")) {
    agent <- pointblank::col_is_posix(
      x = agent,
      columns = get_schema_class(x = schema,
                                 "datetime")
    )
  }

  if (any(schema == "numeric")) {
    agent <- pointblank::col_is_numeric(
      x = agent,
      columns = get_schema_class(x = schema,
                                 "numeric")
    )
  }

  pointblank::interrogate(agent = agent)
}


