#before calculating the brace, this function is used to change the data (mid value, position, etc.)
.coordCorrection <- function(
  x, y,
  rotate, mid,
  labeldistance=NULL,
  distance, outerstart, width,
  direction, outside
){
  #to save if-statements, define 2 axes: a and b
  # a is the axis that is enclosed by the brace
  # b is the axis along which the brace points
  # so for } or {, a would stand for y and b for x
  if(any(rotate==c(90,270))){
    a <- y
    b <- range(x)
  }else{
    a <- x
    b <- range(y)
  }

  #==========================================================#
  #==if mid is specified, replace -a- with its min, mid, max==#
  #==========================================================#
  base <- range(a)
  if(!is.null(mid)) a <- c( base[1] , base[1]+diff(base)*mid, base[2] )

  #============================================#
  #==change coordinates (poisition and width)==#
  #============================================#
  #outside is TRUE for stat_brace and FALSE for geom_brace
  if(outside){
    # change position
    if(is.null(distance)) distance <- diff(base)/50 #set distance to data points
    if(is.null(outerstart)) outerstart <- distance * direction + ifelse(direction>0, max(b), min(b)) #set position
    b <- b + outerstart - ifelse(direction>0, min(b), max(b)) #change coordinates
    # change width based on the original width
    if(is.null(width)) width <- diff(range(b)) / 2 #original width is diff(range(b))
    b[b == ifelse(direction>0, max(b), min(b))] <- width + ifelse(direction>0, min(b), max(b))
  }

  #=============================#
  #==coordinates for the label==#
  #=============================#
  if(is.null(labeldistance)) labeldistance <- diff(range(b)) / 5
  alabel <- median(a)
  blabel <- ifelse(direction>0, max(b)+labeldistance, min(b)-labeldistance)

  #convert a and b back to x and y
  if(any(rotate==c(90,270))){
    y <- a
    x <- b
    ylabel <- alabel
    xlabel <- blabel
  }else{
    x <- a
    y <- b
    xlabel <- alabel
    ylabel <- blabel
  }

  output <- list(
    dataCoords=list(x=x, y=y),
    labelCoords=data.frame(x=xlabel, y=ylabel)
  )
  return(output)
}
