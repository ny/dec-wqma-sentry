
#' Generate a New R Markdown Tabset Section
#'
#' @param x a list object.
#' @param header a character string to be used to name the section.
#'
#' @return output to be rendered in R Markdown document.
#' @export

gen_section <- function(x, header) {
  cat("\n\n##", header, "{.tabset .tabset-pills}", "\n\n\n")


  for (i in c("names", "classes", "expected_values")) {
    gen_subsection(
      x = x,
      section = i,
      header = switch(i,
                      "names" = "Column Names",
                      "classes" = "Column Types",
                      "expected_values" = "Expected Values")
    )
  }


}

#' Generate a Subsection
#'
#' @param x a list.
#' @param section a name of the list item of interest.
#' @param header a string to be used as a label for the section.
#'
#' @return an output to be rendered in markdown.
#' @export

gen_subsection <- function(x, section, header) {
  if (!is.null(x[[section]])) {
    cat(
      "\n\n###",
      header,
      "\n\n"
      )

    x[[section]]

  }
}
