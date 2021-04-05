# dataframe for a curly brace
.seekBrace <- function(
  xstart, ystart, xmiddle, ymiddle, xend, yend,
  xradius, yradius, rotate=0, bending=NULL, npoints=100
){

  #function to create a circle (of which only quarters will be used later)
  circle <- function(x, y){
    positions <- seq(0, 2*pi, length.out=npoints)
    return( data.frame(x = x + xradius * cos(positions), y = y + yradius * sin(positions)) )
  }
  #==========================================================
  #create brace data points by calculating 4 quarter circles
  #note: list items names reflect a brace pointing either to the right or up
  if(any(rotate==c(90, 270))){
    rounds <- list(
      data.frame(x=xstart,y=yend),
      upperQuartercircle = circle(xstart, yend-yradius)[seq(1,npoints/4),],
      upmidQuartercircle = circle(xend, ymiddle+yradius)[seq(npoints/2+1, npoints/4*3),],
      data.frame(x=xend, y=ymiddle),
      lowmidQuartercircle = circle(xend, ymiddle-yradius)[seq(npoints/4+1, npoints/2),],
      lowerQuartercircle = circle(xstart, ystart+yradius)[seq(npoints/4*3+1, npoints),],
      data.frame(x=xstart,y=ystart)
    )
  }else{
    rounds <- list(
      data.frame(x=xstart,y=ystart),
      leftQuartercircle = circle(xstart+xradius, ystart)[seq(npoints/4+1, npoints/2),],
      leftmidQuartercircle = circle(xmiddle-xradius, yend)[seq(npoints/4*3+1, npoints),],
      data.frame(x=xmiddle,y=yend),
      rightmidQuartercircle = circle(xmiddle+xradius, yend)[seq(npoints/2+1, npoints/4*3),],
      rightQuartercircle = circle(xend-xradius, ystart)[seq(1,npoints/4),],
      data.frame(x=xend,y=ystart)
    )
  }
  #==========================================================
  output <- do.call(rbind, rounds)

  #order to avoid zickzack
  if(any(rotate==c(90, 270))){
    output <- output[order(output$y),]
  }else{
    output <- output[order(output$x),]
  }

  rownames(output) <- NULL

  return(output)
}
