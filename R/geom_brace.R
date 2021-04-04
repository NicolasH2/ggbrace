# devtools::document()

#' create a curly brace as a layer ready to be added to a ggplot object
#'
#' Imports:
#' ggplot2
#'
#' @inheritParams ggplot2::geom_path
#' @inheritParams ggplot2::annotate
#'
#' @param xstart number, most left part of the brace
#' @param xend number, most right part of the brace. If pointing="side" the brace points towards this.
#' @param ystart number, top end of the brace
#' @param yend number, bottom end of the brace. If pointing="updown" (default) the brace points towards this.
#' @param mid number, where the pointer is within the bracket space (between 0.25 and 0.75)
#' @param pointing string, either "side" or "updown" (default)
#' @param label string, a custom text to be displayed at the brace.
#' @param labeldistance number, distance of the label to the brace pointer
#' @param labelsize number, changing the font size of the label. Only takes effect if the parameter "label" was defined.
#' @param labelcolor string, defining the color of the label. Only takes effect if the parameter "label" was defined.
#' @param npoints integer, number of points generated for the brace curves (resolution). This number will be rounded to be a multiple of 4 for calculation purposes.
#' @return ggplot2 layer object (geom_path) that can directly be added to a ggplot2 object. If a label was provided, a another layer (annotate) is added.
#' @export
#' @examples
#' library(ggbrace)
#' library(ggplot2)
#' ggplot() + geom_brace()
#'
#' ggplot() + geom_brace(ystart=-5, pointing="side")
#'
#' ggplot() + geom_brace(color="red", size=3, linetype="dashed")
geom_brace <- function(
  xstart=0, xend=1, ystart=0, yend=1, mid=0.5, pointing="updown",
  label=NULL, labeldistance=NULL, labelsize=5, labelcolor="black",
  npoints=100,
  ...
){
  
  #calculate a data.frame with x and y values for plotting the brace
  data <- ggbrace::seekBrace(xstart, xend, ystart, yend, mid, pointing, npoints)
  
  #plot the brace
  output <- ggplot2::layer(
    data = data,
    mapping = ggplot2::aes(x=x, y=y),
    geom = "path",
    stat = "identity",
    position = "identity",
    show.legend = FALSE,
    inherit.aes = FALSE,
    params=list(...)
  )
  
  #label annotation at the same position as the brace pointer
  if(!is.null(label)){
    #for text placement, the mid value has to have the same limits as the brace pointer
    if(mid < 0.25){
      mid <- 0.25
    }else if(mid > 0.75){
      mid <- 0.75
    }
    #calculate values for x, y, rotation and vertical adjustment
    if(pointing %in% "updown"){
      if(is.null(labeldistance)) labeldistance <- yend * 0.01
      txtX <- max(c(xstart,xend)) - abs(xend - xstart)*(1-mid)
      txtY <- ifelse( abs(yend) > abs(ystart), yend+labeldistance, yend-labeldistance )
      txtRot <- 0
      txtVjust <- ifelse(yend > ystart, 0, 1)
    }else{
      if(is.null(labeldistance)) labeldistance <- xend * 0.01
      txtX <- ifelse( abs(xend) > abs(xstart), xend+labeldistance, xend-labeldistance )
      txtY <- max(c(ystart,yend)) - abs(yend - ystart)*(1-mid)
      txtRot <- 90
      txtVjust <- ifelse(xend > xstart, 1, 0)
    }
    #plot the label
    txt <- ggplot2::annotate(
      geom = "text",
      label = label,
      size = labelsize,
      color = labelcolor,
      x = txtX, y = txtY,
      angle = txtRot,
      hjust = 0.5, vjust = txtVjust,
      ...
    )
    #combine brace and label
    output <- list(output, txt)
  }
  
  return(output)
}
