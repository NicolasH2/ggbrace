# devtools::document()

#' create a curly brace as a layer ready to be added to a ggplot object
#'
#' Imports:
#' ggplot2
#'
#' @inheritParams ggplot2::geom_path
#' @import ggplot2
#'
#' @param xstart number, most left part of the brace
#' @param xend number, most right part of the brace. If pointing="side" the brace points towards this.
#' @param ystart number, top end of the brace
#' @param yend number, bottom end of the brace. If pointing="updown" (default) the brace points towards this.
#' @param mid number, where the pointer is within the bracket space (between 0.25 and 0.75)
#' @param pointing string, either "side" or "updown" (default)
#' @param npoints integer, number of points generated for the brace curves (resolution). This number will be rounded to be a multiple of 4 for calculation purposes.
#' @return ggplot2 layer object (geom_path) that can directly be added to a ggplot2 object
#' @export
#' @examples
#' library(ggbrace)
#' library(ggplot2)
#' ggplot() + geom_brace()
#'
#' ggplot() + geom_brace(ystart=-5, pointing="side")
#'
#' ggplot() + geom_brace(color="red", size=3, linetype="dashed")
geom_brace <- function(xstart=0, xend=1, ystart=0, yend=1, mid=0.5, pointing="updown", npoints=100, ...){

  data <- ggbrace::seekBrace(xstart, xend, ystart, yend, mid, pointing, npoints)

  output <- ggplot2::layer(
    data=data,
    mapping=ggplot2::aes(x=x, y=y),
    geom="path",
    stat="identity",
    position="identity",
    show.legend=FALSE,
    params=list(...)
  )

  return(output)
}
