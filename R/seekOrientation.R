# calculate important points for the brace
.seekOrientation <- function(xlim, ylim, rotate, mid, bending=NULL, npoints=100){
  xstart <- min(xlim)
  xend <- max(xlim)
  ystart <- min(ylim)
  yend <- max(ylim)

  if(rotate==180){
    yend <- min(ylim)
    ystart <- max(ylim)
  }else if(rotate==270){
    xend <- min(xlim)
    xstart <- max(xlim)
  }

  if(mid < 0.25){
    mid <- 0.25
  }else if(mid > 0.75){
    mid <- 0.75
  }

  xradius <- (xend-xstart)/2
  yradius <- (yend-ystart)/2

  if(any(rotate==c(90, 270))){
    yradius <- yradius/4
    if(!is.null(bending)) yradius <- bending
    ymiddle <- (yend-ystart)*mid + ystart
    xmiddle <- sum(xlim)/2
    xtxt <- ifelse( abs(xend) > abs(xstart), xend*1.01, xend*0.99 )
    ytxt <- ymiddle
    txtRot <- 90
    txtVjust <- ifelse(xend > xstart, 1, 0)
  }else{
    xradius <- xradius/4
    if(!is.null(bending)) xradius <- bending
    xmiddle <- (xend-xstart)*mid + xstart
    ymiddle <- sum(ylim)/2
    ytxt <- ifelse( abs(yend) > abs(ystart), yend*1.01, yend*0.99 )
    xtxt <- xmiddle
    txtRot <- 0
    txtVjust <- ifelse(yend > ystart, 0, 1)
  }

  brace <- .seekBrace(xstart=xstart, ystart=ystart, xmiddle=xmiddle, ymiddle=ymiddle, xend=xend, yend=yend,
                      xradius=xradius, yradius=yradius, rotate=rotate,
                      bending = bending, npoints = npoints)

  output <- list(
    brace = brace,
    label = data.frame(x = xtxt, y = ytxt, rot = txtRot, vjust = txtVjust)
  )

  return(output)
}
