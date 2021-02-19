

#' creates a dataframe for a curled brace
#'
#' @param xstart number, most left part of the brace
#' @param xend number, most right part of the brace
#' @param ystart number, top end of the brace
#' @param yend number, bottom end of the brace
#' @param mid number, where the pointer is within the bracket space (between 0.25 and 0.75)
#' @param pointing string, either "side" or "updown"
#' @param npoints integer, number of points generated for the brace curves (resolution). This number will be rounded to be a multiple of 4 for calculation purposes.
#' @return data.frame with x and y columns that can be used as an input for ggplot or plotly
#' @examples
#' library(curlyBrace, ggplot2)
#' mybrace <- seekBrace()
#' ggplot() + geom_line(aes(x,y), data=mybrace, orientation="y")
#'
#' mybrace <- seekBrace(xend=5, yend=1, pointing="updown")
#' ggplot() + geom_line(aes(x,y), data=mybrace, orientation="x")
seekBrace <- function(xstart=0, xend=1, ystart=0, yend=5, mid=0.5, pointing="updown", npoints=100){
  if(mid<0.25){
    mid <- 0.25
  }else if(mid>0.75){
    mid <- 0.75
  }
  npoints <- round(npoints/4)*4 #making sure that it is a multiple of 10
  radiusX <- (xend-xstart)/2
  radiusY <- (yend-ystart)/2
  if(pointing %in% "side"){
    radiusY <- radiusY/4
    ymiddle <- yend-(yend-ystart)*mid
    xmiddle <- xend-(xend-xstart)*.5
  }
  if(pointing %in% "updown"){
    radiusX <- radiusX/4
    ymiddle <- yend-(yend-ystart)*.5
    xmiddle <- xend-(xend-xstart)*mid
  }

  circle <- function(x=0,y=0){
    positions <- seq(0,2*pi, length.out=npoints)
    data.frame(x=x+radiusX*cos(positions),
               y=y+radiusY*sin(positions))
  }

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
  }else{
    stop("error: select either ’side’ or ’updown’ for the pointing arguement")
  }

  mybrace <- do.call(rbind, rounds)
  mybrace <- mybrace[order(mybrace$x),] #fixes the ggplot-zickzack for the "updown" option
  mybrace
}

