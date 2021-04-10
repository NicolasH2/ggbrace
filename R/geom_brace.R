# devtools::document()

#' create a curly brace as a layer ready to be added to a ggplot object
#'
#' Imports:
#' ggplot2
#'
#' @inheritParams ggplot2::geom_path
#' @inheritParams ggplot2::annotate
#'
#' @param x number, most left part of the brace
#' @param xend number, most right part of the brace
#' @param y number, top end of the brace
#' @param yend number, bottom end of the brace
#' @param mid number, where the pointer is within the bracket space (between 0.25 and 0.75)
#' @param bending number, how strongly the curves of the braces should be bent (the higher the more round). Note: too high values will result in the brace showing zick-zack lines
#' @param rotate number, defines where the brace is pointing to: 0=up, 90=right, 180=down, 270=left. When specified by user, will overwrite other directions the brace might have from x/y coordinates.
#' @param label string, a custom text to be displayed at the brace.
#' @param labeldistance number, distance of the label to the brace pointer
#' @param labelsize number, changing the font size of the label. Only takes effect if the parameter "label" was defined.
#' @param labelcolor string, defining the color of the label. Only takes effect if the parameter "label" was defined.
#' @param npoints integer, number of points generated for the brace curves (resolution). This number will be rounded to be a multiple of 4 for calculation purposes.
#' @param pointing (DEPRECATED) string, either "side" or "updown"
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
#'
geom_brace <- function(
  xstart=0, xend=1, ystart=0, yend=1, mid=0.5,
  mapping=NULL, data=NULL, inherit.aes=FALSE,
  rotate=0, bending=NULL, labelrotate=0,
  label=NULL, labeldistance=NULL, labelsize=0, labelcolor="black",
  npoints=100, pointing=NULL,
  ...
){
  if(!is.null(pointing)) message("Warning: pointing is deprecated and will be discontinued in future releases. Use rotate instead.")
  if(!is.null(mapping) | inherit.aes){

    output <- stat_brace(mapping=mapping, data=data, rotate=rotate,
                         labelsize=labelsize, labeldistance=labeldistance, labelrotate=labelrotate,
                         mid=mid, bending=bending, npoints=npoints, outerstart=NA)

  }else{
    #making sure previous usage of this function works as it should, but at the same time, integrate rotate
    if( !any(names(as.list(match.call())) %in% "rotate")){
      rotate <- ifelse(yend>ystart, 0, 180)
      if(!is.null(pointing)){
        if(pointing %in% "side") rotate <- ifelse(xend>xstart, 90, 270)
      }
    }

    #calculate a data.frame with x and y values for plotting the brace
    orientation <- .seekOrientation(xlim = c(xstart, xend), ylim = c(ystart, yend), mid=mid, rotate=rotate, bending=bending, npoints=npoints)
    data <- orientation[[1]]

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
      if(is.null(labeldistance)) labeldistance <- 0
      xdistance <- ifelse(any(rotate==c(90,270)), sign(sin(rotate+.1))*labeldistance, 0)
      ydistance <- ifelse(any(rotate==c(90,270)), 0, sign(sin(rotate+.1))*labeldistance)

      ori2 <- orientation[[2]]

      txt <- ggplot2::annotate(
        geom = "text",
        label = label,
        size = labelsize,
        color = labelcolor,
        x = ori2$x + xdistance,
        y = ori2$y + ydistance,
        angle = ori2$rot,
        hjust = 0.5,
        vjust = ori2$vjust,
        ...
      )
      #combine brace and label
      output <- list(output, txt)
    }

  }



  return(output)
}
