
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
#' @param rotate number in degrees, defines where the brace points to: 0=up, 90=right, 180=down, 270=left
#' @param width number, how wide is the braces? If NULL (default), will be determined by data.
#' @param mid number, where is the pointer within the brace space (between 0.25 and 0.75). If NULL (default), will be determined by data.
#' @param outside boolean, if TRUE, brace is next to the data area; if FALSE, brace is inside the data area
#' @param distance number, space between the brace and the nearest data point
#' @param outerstart number, overwrites distance; sets all braces to the same origin
#' @param bending number between 0 and 0.5, how strong is the bend of the brace curves (0=rectangular). If NULL (default), will be determined by data. If too high, values will result in zick-zack lines
#' @param discreteAxis boolean, does the embraced axis feature discrete values (often true for bar graphs)
#' @param bracketType text: either "curly" or "square"
#' @param npoints integer, number of points generated for the brace curves (resolution). This number will be rounded to be a multiple of 4 for calculation purposes.
#' @return ggplot2 layer object (geom_path) that can directly be added to a ggplot2 object. If a label was provided, a another layer (geom_text) is added.
#' @export
#' @examples
#' library(ggbrace)
#' library(ggplot2)
#' data(iris)
#'
#' # regular braces
#' ggplot(iris, aes(x=Sepal.Length, y=Sepal.Width, color=Species, label=Species)) +
#'  geom_point() +
#'  stat_brace()
#'
#'  # rotated braces
#' ggplot(iris, aes(x=Sepal.Length, y=Sepal.Width, color=Species, label=Species)) +
#'  geom_point() +
#'  stat_brace(rotate = 90)
#'
#'  # braces inside the given coordinates
#' ggplot(iris, aes(x=Sepal.Length, y=Sepal.Width, color=Species, label=Species)) +
#'  geom_point() +
#'  stat_brace(outside = FALSE)
#'
#'  # braces with a defined distance from their data points
#' ggplot(iris, aes(x=Sepal.Length, y=Sepal.Width, color=Species, label=Species)) +
#'  geom_point() +
#'  stat_brace(distance = 2)
#'
#'  # braces starting at a defined point
#' ggplot(iris, aes(x=Sepal.Length, y=Sepal.Width, color=Species, label=Species)) +
#'  geom_point() +
#'  stat_brace(outerstart = 5)
#'
#'  # braces starting at a defined point and with defined width
#' ggplot(iris, aes(x=Sepal.Length, y=Sepal.Width, color=Species, label=Species)) +
#'  geom_point() +
#'  stat_brace(outerstart = 5, width = 1)
#'
#'  # braces starting at a defined point and with defined width and defined curve bending
#' ggplot(iris, aes(x=Sepal.Length, y=Sepal.Width, color=Species, label=Species)) +
#'  geom_point() +
#'  stat_brace(outerstart = 5, width = 1, bending = 0.1)
#'
#'  # braces outside of the plotting area
#' ggplot(iris, aes(x=Sepal.Length, y=Sepal.Width, color=Species, label=Species)) +
#'  geom_point() +
#'  stat_brace(outerstart = 4.5) +
#'  coord_cartesian(y=range(iris$Sepal.Width), clip = "off") +
#'  theme(plot.margin = unit(c(0.25, 0.11, 0.11, 0.11), units="npc"))
#'
#'  # braces with discrete axes
#'  df <- iris
#'  df$Group <- substring(iris$Species,1,1)
#'  ggplot(df, aes(x=Species, y=Sepal.Length, group=Group)) +
#'    geom_jitter() +
#'    stat_brace(discreteAxis=TRUE)
#'
#'
stat_brace <- function(
    mapping = NULL,
    data = NULL,
    ...,
    rotate = 0,
    width = NULL,
    mid = NULL,
    outside = TRUE,
    distance = NULL,
    outerstart = NULL,
    bending = NULL,
    show.legend = FALSE,
    inherit.aes = TRUE,
    discreteAxis = FALSE,
    bracketType = "curly",
    npoints = 100
){
  ggplot2::layer(
    data = data,
    mapping = mapping,
    stat = StatBrace,
    geom = "path",
    position = "identity",
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
      discreteAxis = discreteAxis,
      braceType = braceType,
      ...
    )
  )
}
