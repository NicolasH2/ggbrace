#returns ggproto objects for the braces and labels. Their data.frames are taken from the .modorientation function.
.funStatBrace <- function(width=NULL, position="out", rotate, outerstart=NULL, mid, bending=NULL, npoints=100, distance=NULL, labeldistance=NULL){

  if(!is.null(distance) & !is.null(labeldistance)) labeldistance <- labeldistance + distance
  if(!is.null(distance) & is.null(labeldistance)) labeldistance <- distance

  #calculate brace coordinates via .subcalc
  StatBrace <- ggproto("StatBrace", Stat,
                       required_aes = c("x", "y"),

                       compute_group = function(data, scales) {
                         x <- data$x
                         y <- data$y
                         brace <- .modorientation(x = x,
                                                  y = y,
                                                  position = position,
                                                  outerstart = outerstart,
                                                  width = width,
                                                  rotate = rotate,
                                                  mid = mid,
                                                  distance = distance,
                                                  bending = bending,
                                                  npoints = npoints)[[1]]
                         return(brace)
                       }
  )

  #calculate label coordinates via .subcalc
  StatBraceLabel <- ggproto("StatBraceLabel", Stat,
                            required_aes = c("x", "y"),

                            compute_group = function(data, scales) {
                              x <- data$x
                              y <- data$y
                              bracelabel <- .modorientation(x = x,
                                                            y = y,
                                                            position = position,
                                                            outerstart = outerstart,
                                                            width = width,
                                                            rotate = rotate,
                                                            mid = mid,
                                                            distance = labeldistance)[[2]]
                              return(bracelabel)
                            }
  )

  return(list(StatBrace, StatBraceLabel))
}

#returns x and y coordinates for brace and label
# the position parameter is the important distinction between geom_brace ("in") and stat_brace ("out")
.modorientation <- function(x, y, position="out", distance=NULL, width=NULL, rotate, outerstart=NULL, mid, bending=NULL, npoints=100){

  xrange <- range(x, na.rm = TRUE)
  yrange <- range(y, na.rm = TRUE)
  flip <- ifelse(rotate==180 | rotate==270, TRUE, FALSE) #should the pointing direction be flipped?

  if(any(rotate==c(90, 270))){
    if(flip) xrange <- rev(xrange)
    if(is.null(mid)) mid <- (median(y) - min(yrange)) / abs(diff(yrange))
    distance <- ifelse(is.null(distance), diff(xrange)/5, sign(sin(rotate+.1))*distance)
    if(is.null(outerstart)){
      outerstart <- ifelse(position %in% "in", xrange[1], xrange[2] + distance)#if outerstart is not defined, it is set automatically
    }
    if(is.null(width)){
      width <- ifelse(position %in% "in", diff(xrange), diff(xrange)/2)
    }
    xrange <- c(outerstart, outerstart + width )
  }else{
    if(flip) yrange <- rev(yrange) #reverse the order if the brace is flipped (i.e. 180 or 270 degrees)
    if(is.null(mid)) mid <- (median(x) - min(xrange)) / abs(diff(xrange)) #if brace middle is not defined it is set to the median of the values
    distance <- ifelse(is.null(distance), diff(yrange)/5, sign(sin(rotate+.1))*distance) #if distance is not defined, it is set automatically
    if(is.null(outerstart)){
      outerstart <- ifelse(position %in% "in", yrange[1], yrange[2] + distance)#if outerstart is not defined, it is set automatically
    }
    if(is.null(width)){
      width <- ifelse(position %in% "in", diff(yrange), diff(yrange)/2)  #if brace width is not defined, it is set automatically
    }
    yrange <- c(outerstart, outerstart + width )
  }

  orientation <- .seekOrientation(xlim = xrange, ylim = yrange, mid = mid,
                                  rotate = rotate, bending=bending, npoints=npoints)
  ori1 <- orientation[[1]]
  ori2 <- orientation[[2]]

  return(list(ori1, ori2))
}
