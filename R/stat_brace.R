
#' create curly braces as a layer in ggplot
#'
#' Imports:
#' ggplot2
#'
#' @inheritParams geom_brace
#' @inheritParams ggplot2::geom_path
#' @inheritParams ggplot2::geom_text
#' @import ggplot2
#'
#' @param rotate integer, either 0, 90, 180 or 270 to indicate if the braces should point up, right, down or left respectively
#' @param textsize number, regulates text size
#' @param distance number, regulates how far away the brace is from the last data point (individually for each group)
#' @param outerstart number, overwrites distance and provides one coordinate for all braces
#' @param width number, regulates how wide the braces are
#' @return ggplot2 layer object (geom_path) that can directly be added to a ggplot2 object. If a label was provided, a another layer (geom_text) is added.
#' @export
#' @examples
#' library(ggbrace)
#' library(ggplot2)
#' ggplot(mtcars, aes(mpg, wt, color=factor(am))) +
#'   geom_point() +
#'   facet_wrap(~vs) +
#'   stat_brace(rotate=90, aes(label=factor(am)))
#'
stat_brace <- function(mapping = NULL, data = NULL, rotate=0, textsize = 5,
                       distance=NULL, outerstart=NULL, width=NULL, mid=NULL, npoints=100,
                       ...) {
  #set variables for brace direction
  pointing <- ifelse(rotate==90 | rotate==270, "side", "updown") #should the brace point to the side?
  flip <- ifelse(rotate==180 | rotate==270, TRUE, FALSE) #should the pointing direction be flipped?

  #calculate coordinates for braces and labels
  StatBraceAndLabel <- .funStatBrace(pointing=pointing, flip=flip,
                                    distance=distance, outerstart=outerstart, #outerstart will overwrite distance, if specified
                                    width=width, mid=mid, npoints=npoints)
  StatBrace <- StatBraceAndLabel[[1]] #first list item contains coordinates for braces
  StatBraceLabel <- StatBraceAndLabel[[2]] #second list item contains coordinates for labels

  added_labels <- NULL #is set to NULL first, so if no labels are defined, NULL will be added to the braces

  #optional labels
  if(!is.null(mapping)){
    if(names(mapping) %in% "label"){
    # decide the vjust and hjust for the text
    approx_rotate <- as.character(round(rotate))
    txtvjust <- switch(approx_rotate,
                       "0" = 0,
                       "180" = 1,
                       "90" = 0.5,
                       "270" = 0.5)
    txthjust <- switch(approx_rotate,
                       "0" = 0.5,
                       "180" = 0.5,
                       "90" = 0,
                       "270" = 1)

    # plot labels
    added_labels <- ggplot2::layer(
      stat = StatBraceLabel,
      data = data,  mapping = mapping, geom = "text",
      position = "identity", show.legend = FALSE, inherit.aes = TRUE,
      params = list(vjust=txtvjust,
                    hjust=txthjust,
                    size=textsize,
                    ...)
    )
    mapping$label <- NULL #delete the label part from the mapping parameter so as to not raise a warning when plotting the brace
    }
  }

  #plot braces
  output <- ggplot2::layer(
    stat = StatBrace,
    data = data, mapping = mapping, geom = "path",
    position = "identity", show.legend = FALSE, inherit.aes = TRUE,
    params = list(...)
  )

  # add labels to the braces
  output <- c(output, added_labels)

  return(output)
}

#returns x and y coordinates for brace and label
.subcalc <- function(x, y, distance, width, pointing, flip, outerstart, mid, npoints){
  xrange <- range(x, na.rm = TRUE)
  yrange <- range(y, na.rm = TRUE)

  #set parameters for the labels
  if(pointing %in% "updown"){
    if(flip) yrange <- rev(yrange) #reverse the order if the brace is flipped (i.e. 180 or 270 degrees)
    if(is.null(mid)) mid <- (median(x) - min(xrange)) / abs(diff(xrange)) #if brace middle is not defined it is set to the median of the values
    if(is.null(distance)) distance <- diff(yrange) / 5 #if distance is not defined, it is set automatically
    if(is.null(outerstart)) outerstart <- yrange[2] + distance #if autostart is not defined, it is set automatically
    if(is.null(width)) width <- diff(yrange) / 2 #if brace width is not defined, it is set automatically
    yrange <- c(outerstart,
                outerstart + width )
  }else{
    if(flip) xrange <- rev(xrange)
    if(is.null(mid)) mid <- (median(y) - min(yrange)) / abs(diff(yrange))
    if(is.null(distance)) distance <- diff(xrange) / 5
    if(is.null(outerstart)) outerstart <- xrange[2] + distance
    if(is.null(width)) width <- diff(xrange) / 2
    xrange <- c(outerstart,
                outerstart + width )
  }

  #get data.frame for brace
  brace <- seekBrace(xstart = xrange[1], xend = xrange[2],
                     ystart = yrange[1], yend = yrange[2],
                     pointing = pointing, mid = mid, npoints = npoints)

  #get data.frame for labels
  bracelabel <- seekBraceLabel(xstart = xrange[1], xend = xrange[2],
                               ystart = yrange[1], yend = yrange[2],
                               pointing = pointing, mid = mid)

  return(list(brace, bracelabel))
}

#returns ggproto objects for the braces and labels. Their data.frames are taken from the .subcalc function.
.funStatBrace <- function(distance, width, pointing, flip, outerstart, mid, npoints){

  #calculate brace coordinates via .subcalc
  StatBrace <- ggproto("StatBrace", Stat,
                       required_aes = c("x", "y"),

                       compute_group = function(data, scales) {
                         x <- data$x
                         y <- data$y
                         brace <- .subcalc(x = x, y = y,
                                          distance = distance, outerstart = outerstart, width = width,
                                          pointing = pointing, flip = flip, mid = mid, npoints = npoints)[[1]]

                         return(brace)
                       }
  )

  #calculate label coordinates via .subcalc
  StatBraceLabel <- ggproto("StatBraceLabel", Stat,
                            required_aes = c("x", "y"),

                            compute_group = function(data, scales) {
                              x <- data$x
                              y <- data$y
                              bracelabel <- .subcalc(x = x, y = y,
                                                    distance = distance, outerstart = outerstart, width = width,
                                                    pointing = pointing, flip = flip, mid = mid, npoints = npoints)[[2]]

                              return(bracelabel)
                            }
  )

  return(list(StatBrace, StatBraceLabel))
}
