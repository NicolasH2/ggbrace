#' creates a dataframe for a curly brace
#'
#' @param xstart number, most left part of the brace
#' @param xend number, most right part of the brace. If pointing="side" the brace points towards this.
#' @param ystart number, top end of the brace
#' @param yend number, bottom end of the brace. If pointing="updown" (default) the brace points towards this.
#' @param mid number, where the pointer is within the bracket space (between 0.25 and 0.75)
#' @param pointing string, either "side" or "updown" (default)
#' @param npoints integer, number of points generated for the brace curves (resolution). This number will be rounded to be a multiple of 4 for calculation purposes.
#' @return data.frame with x and y columns that can be used as an input for ggplot or plotly
#' @export
#' @examples
#' library(curlyBrace, ggplot2)
#' mybrace <- seekBrace()
#' ggplot() + geom_path(aes(x,y), data=mybrace)
#'
#' mybrace <- seekBrace(pointing="side")
#' ggplot() + geom_path(aes(x,y), data=mybrace)
seekBrace <- function(xstart=0, xend=1, ystart=0, yend=5, mid=0.5, pointing="updown", npoints=100){

  if(!pointing %in% c("updown","side")) stop("error: select either ’side’ or ’updown’ for the pointing arguement")
  if(mid<0.25){
    mid <- 0.25
  }else if(mid>0.75){
    mid <- 0.75
  }
  #making sure that it is a multiple of 4
  npoints <- round(npoints/4)*4
  #==========================================================
  #==========================================================
  #==Circle calculations==#
  radiusX <- (xend-xstart)/2
  radiusY <- (yend-ystart)/2

  if(pointing %in% "side"){
    radiusY <- radiusY/4
    ymiddle <- (yend+ystart)*mid
    xmiddle <- (xend+xstart)*.5
  }else if(pointing %in% "updown"){
    radiusX <- radiusX/4
    ymiddle <- (yend+ystart)*.5
    xmiddle <- (xend+xstart)*mid
  }
  #function to create a circle (of which only quarters will be used later)
  circle <- function(x=0,y=0){
    positions <- seq(0,2*pi, length.out=npoints)
    return( data.frame(x=x+radiusX*cos(positions), y=y+radiusY*sin(positions)) )
  }
  #==========================================================
  #==========================================================
  #the list items were named with a brace pointing to the right or up
  if(pointing %in% "side"){
    rounds <- list(
      data.frame(x=xstart,y=yend),
      upperQuartercircle = circle(xstart, yend-radiusY)[seq(1,npoints/4),],
      upmidQuartercircle = circle(xend, ymiddle+radiusY)[seq(npoints/2+1, npoints/4*3),],
      data.frame(x=xend, y=ymiddle),
      lowmidQuartercircle = circle(xend, ymiddle-radiusY)[seq(npoints/4+1, npoints/2),],
      lowerQuartercircle = circle(xstart, ystart+radiusY)[seq(npoints/4*3+1, npoints),],
      data.frame(x=xstart,y=ystart)
    )
  }else if(pointing %in% "updown"){
    rounds <- list(
      data.frame(x=xstart,y=ystart),
      leftQuartercircle = circle(xstart+radiusX, ystart)[seq(npoints/4+1, npoints/2),],
      leftmidQuartercircle = circle(xmiddle-radiusX, yend)[seq(npoints/4*3+1, npoints),],
      data.frame(x=xmiddle,y=yend),
      rightmidQuartercircle = circle(xmiddle+radiusX, yend)[seq(npoints/2+1, npoints/4*3),],
      rightQuartercircle = circle(xend-radiusX, ystart)[seq(1,npoints/4),],
      data.frame(x=xend,y=ystart)
    )
  }
  #==========================================================
  #==========================================================
  output <- do.call(rbind, rounds)

  #fix the ggplot-zickzack for the "updown" option
  output <- switch(pointing,
                   "updown"=output[order(output$x),],
                   "side"=output[order(output$y),]
                   )
  rownames(output) <- NULL

  return(output)
}
seekBrace()
