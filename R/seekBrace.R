#will build a brace from the min, max and median values of x and y, taking the rotation into account
.seekBrace <- function(
  x, y,
  rotate, bending, npoints
){

  xstart <- min(x)
  ystart <- min(y)
  xmid <- median(x)
  ymid <- median(y)
  xend <- max(x)
  yend <- max(y)

  if(rotate==180){
    ystart <- max(y)
    yend <- min(y)
  }else if(rotate==270){
    xstart <- max(x)
    xend <- min(x)
  }

  #===================#
  #==set brace radii==#
  #===================#
  #the brace is basically a combination of 4 quartercircles or more accurately 4 quarterellipses
  #the radius on the axis along which the brace points, is half that of the brace width (because it contains 2 quatercircles)
  xradius <- (xend-xstart)/2
  yradius <- (yend-ystart)/2

  #the radius on the axis that is enclosed by the brace, is a quarter of the brace width (because it contains 4 quatercircles)
  #the user can change that raius to a fixed value (bending)
  if(any(rotate==c(90, 270))){
    yradius <- yradius/4
    if(!is.null(bending)) yradius <- bending
  }else{
    xradius <- xradius/4
    if(!is.null(bending)) xradius <- bending
  }

  #==============================================================#
  #==calculate the quartercircles and put them into a dataframe==#
  #==============================================================#
  #function to create a circle (of which only quarters will be used later)
  circle <- function(x, y){
    positions <- seq(0, 2*pi, length.out=npoints)
    return( data.frame(x = x + xradius * cos(positions), y = y + yradius * sin(positions)) )
  }
  #==========================================================
  #create brace data points by calculating 4 quarter circles
  #note: list item names reflect a brace pointing either to the right or up
  if(any(rotate==c(90, 270))){
    rounds <- list(
      data.frame(x=xstart,y=yend),
      upperQuartercircle = circle(xstart, yend-yradius)[seq(1,npoints/4),],
      upmidQuartercircle = circle(xend, ymid+yradius)[seq(npoints/2+1, npoints/4*3),],
      data.frame(x=xend, y=ymid),
      lowmidQuartercircle = circle(xend, ymid-yradius)[seq(npoints/4+1, npoints/2),],
      lowerQuartercircle = circle(xstart, ystart+yradius)[seq(npoints/4*3+1, npoints),],
      data.frame(x=xstart,y=ystart)
    )
  }else{
    rounds <- list(
      data.frame(x=xstart,y=ystart),
      leftQuartercircle = circle(xstart+xradius, ystart)[seq(npoints/4+1, npoints/2),],
      leftmidQuartercircle = circle(xmid-xradius, yend)[seq(npoints/4*3+1, npoints),],
      data.frame(x=xmid,y=yend),
      rightmidQuartercircle = circle(xmid+xradius, yend)[seq(npoints/2+1, npoints/4*3),],
      rightQuartercircle = circle(xend-xradius, ystart)[seq(1,npoints/4),],
      data.frame(x=xend,y=ystart)
    )
  }

  output <- do.call(rbind, rounds)

  #===========================#
  #==order to avoid zickzack==#
  #===========================#
  # this will prepare the data to not show zickzack-lines as long as geom_path is used (not geom_line!)
  if(any(rotate==c(90, 270))){
    output <- output[order(output$y),]
  }else{
    output <- output[order(output$x),]
  }

  rownames(output) <- NULL
  return(output)
}
