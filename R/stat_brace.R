
#' create curly braces as a layer in ggplot
#'
#' Imports:
#' ggplot2
#'
#' @inheritParams ggplot2::geom_path
#' @inheritParams ggplot2::stat_align
#' @inheritParams ggplot2::geom_text
#' @import ggplot2
#'
#' @param rotate number, defines where the brace is pointing to: 0=up, 90=right, 180=down, 270=left. When specified by user, will overwrite other directions the brace might have from x/y coordinates.
#' @param width number, how wide should the braces be? If NULL (default), will be determined automatically based on the data.
#' @param mid number, where the pointer is within the bracket space (between 0.25 and 0.75). If NULL (default), will be determined automatically based on the data.
#' @param outside boolean, should the brace be outside of the data area or cover the data area?
#' @param distance number, space between the brace and the nearest data point
#' @param outerstart number, overwrites distance and provides one coordinate for all braces
#' @param bending number, how strongly the curves of the braces should be bent (the higher the more round). Note: too high values will result in the brace showing zick-zack lines
#' @param npoints integer, number of points generated for the brace curves (resolution). This number will be rounded to be a multiple of 4 for calculation purposes.
#' @return ggplot2 layer object (geom_path) that can directly be added to a ggplot2 object. If a label was provided, a another layer (geom_text) is added.
#' @export
#' @examples
#' library(ggbrace)
#' library(ggplot2)
#' data(iris)
#' ggplot(iris, aes(x=Sepal.Length, y=Sepal.Width, color=Species, label=Species)) +
#'  geom_point() +
#'  stat_brace()
#'
stat_brace <- function(
    mapping = NULL,
    data = NULL,
    geom = "path",
    position = "identity",
    ...,
    rotate = 0,
    width = NULL,
    mid = NULL,
    outside = TRUE,
    distance = NULL,
    outerstart = NULL,
    bending = NULL,
    npoints = 100,
    show.legend = FALSE,
    inherit.aes = TRUE
){
  ggplot2::layer(
    data = data,
    mapping = mapping,
    stat = StatBrace,
    geom = geom,
    position = position,
    show.legend = show.legend,
    inherit.aes = inherit.aes,
    params = list(
      rotate = rotate,
      bending = bending,
      npoints = npoints,
      width = width,
      mid = mid,
      outside = outside,
      distance = distance,
      outerstart = outerstart,
      ...
    )
  )
}
