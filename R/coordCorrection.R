#before calculating the brace, this function is used to change the data (mid value, position, etc.)

#' Imports:
#' stats
#'
#' @inheritParams stat_brace
#' @inheritParams stat_bracetext
#' @import stats
#'
#' @param x vector, x values of all data points
#' @param y vector, y value of all data points
.coordCorrection <- function(
  x,
  y,
  rotate,
  mid,
  textdistance=NULL,
  distance,
  outerstart,
  width,
  outside,
  discreteAxis=FALSE
){
  #to save if-statements, define 2 axes: a and b
  # a is the axis that is enclosed by the brace
  # b is the axis along which the brace points
  # so for } or {, a would stand for y and b for x
  direction <- -sign(rotate/90-1.5)
  a <- x
  b <- range(y)
  if(any(rotate==c(90,270))){
    a <- y
    b <- range(x)
  }

  #==========================================================#
  #==if mid is specified, replace -a- with its min, mid, max==#
  #==========================================================#
  base <- range(a)
  if(!is.null(mid)) a <- c( base[1] , base[1]+diff(base)*mid, base[2] )

  #============================================#
  #==change coordinates (position and width)==#
  #============================================#
  #outside is TRUE for stat_brace and FALSE for geom_brace
  if(outside){
    # change position
    if(is.null(distance)) distance <- diff(base)/50 #set distance to data points
    if(is.null(outerstart)) outerstart <- distance * direction + ifelse(direction>0, max(b), min(b)) #set position
    if(is.null(width)) width <- diff(range(b)) / 2
    outerend <- outerstart + width * direction
    b <- c(outerstart, outerend)
    # b <- b + outerstart - ifelse(direction>0, min(b), max(b)) #change coordinates
    # # change width based on the original width
    # b[b == ifelse(direction>0, max(b), min(b))] <- width + ifelse(direction>0, min(b), max(b))
  }

  #============================#
  #==discrete Axis adjustment==#
  #============================#
  if(discreteAxis){
    radius=.45
    a <- c(min(a,na.rm=T)-radius, a, max(a,na.rm=T)+radius)
  }

  #=============================#
  #==coordinates for the label==#
  #=============================#
  if(is.null(textdistance)) textdistance <- ( diff(range(b)) )/5
  alabel <- stats::median(a)
  blabel <- ifelse(direction>0, max(b)+textdistance, min(b)-textdistance)

  #convert a and b back to x and y
  x <- a
  y <- b
  xlabel <- alabel
  ylabel <- blabel
  if(any(rotate==c(90,270))){
    y <- a
    x <- b
    ylabel <- alabel
    xlabel <- blabel
  }

  output <- list(
    dataCoords=list(x=x, y=y),
    labelCoords=data.frame(x=xlabel, y=ylabel)
  )
  return(output)
}
