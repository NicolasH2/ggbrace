# devtools::document()

#' create text for curly braces as a layer in ggplot
#'
#' Imports:
#' ggplot2
#'
#' @inheritParams stat_brace
#' @inheritParams ggplot2::geom_path
#' @inheritParams ggplot2::stat_align
#' @inheritParams ggplot2::annotate
#' @import ggplot2
#'
#' @param textdistance number. Distance of the label to the brace pointer
#' @return ggplot2 layer object (geom_text or geom_label) that can directly be added to a ggplot2 object.
#' @export
#' @examples
#' library(ggbrace)
#' library(ggplot2)
#' data(iris)
#' ggplot(iris, aes(x=Sepal.Length, y=Sepal.Width, color=Species, label=Species)) +
#'  geom_point() +
#'  stat_brace() +
#'  stat_bracetext()
#'
stat_bracetext <- function(
    mapping = NULL,
    data = NULL,
    geom = "text",
    position = "identity",
    ...,
    rotate = 0,
    width = NULL,
    mid = NULL,
    outside = TRUE,
    distance = NULL,
    outerstart = NULL,
    textdistance = NULL,
    show.legend = FALSE,
    inherit.aes = TRUE
){
  angle <- 0
  if("angle" %in% names(list(...))) angle <- list(...)["angle"]

  #hjust and vjust of the text depend on the brace rotation and the label rotation
  rfactor = round(rotate/90+1, 0)
  txtvjust <- switch(rfactor, 0, .5, 1, .5)
  txthjust <- switch(rfactor, .5, 0, .5, 1)
  if(angle == 90){
    txtvjust <- switch(rfactor, .5, 1, .5, 0)#   0.5, 1, 0.5, 0)
    txthjust <- switch(rfactor, 0, .5, 1, .5)# 0, 0.5, 1, 0.5)
  }else if(angle == 270){
    txtvjust <- switch(rfactor, .5, 0, .5, 1)
    txthjust <- switch(rfactor, 0, .5, 1, .5)
  }

  ggplot2::layer(
    data = data,
    mapping = mapping,
    stat = StatBraceLabel,
    position = position,
    geom = geom,
    show.legend = FALSE,
    inherit.aes = inherit.aes,
    params = list(
      vjust = txtvjust,
      hjust = txthjust,
      rotate = rotate,
      mid = mid,
      textdistance = textdistance,
      outside = outside,
      distance = distance,
      outerstart = outerstart,
      width = width,
      ...
    )
  )
}
