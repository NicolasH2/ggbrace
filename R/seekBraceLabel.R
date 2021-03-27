#' dataframe for a curly brace label
#'
#' @param xstart number, most left part of the brace
#' @param xend number, most right part of the brace. If pointing="side" the brace points towards this.
#' @param ystart number, top end of the brace
#' @param yend number, bottom end of the brace. If pointing="updown" (default) the brace points towards this.
#' @param mid number between 0.25 and 0.75, defining the relative position of the pointer.
#' @param pointing string, either "side" or "updown" (default)
#' @return data.frame with columns x and y, to be used as an input for ggplot's geom_text
#' @export
#' @examples
#' library(ggbrace)
#' library(ggplot2)
#' mybrace <- seekBrace()
#' mylabel <- seekBraceLabel()
#' ggplot(mapping=aes(x,y)) +
#'   geom_path(data=mybrace) +
#'   geom_text(data=mylabel, label="my custom brace", vjust=0)
#'
seekBraceLabel <- function(xstart=0, xend=1, ystart=0, yend=5, mid=0.5, pointing="updown"){

  #for text placement, the mid value has to have the same limits as the brace pointer
  if(mid < 0.25){
    mid <- 0.25
  }else if(mid > 0.75){
    mid <- 0.75
  }
  #calculate values for x, y, rotation and vertical adjustment
  if(pointing %in% "updown"){
    txtX <- max(c(xstart,xend)) - abs(xend - xstart)*(1-mid)
    txtY <- ifelse( abs(yend) > abs(ystart), yend*1.01, yend*0.99 )
    txtRot <- 0
    txtVjust <- ifelse(yend > ystart, 0, 1)
  }else{
    txtX <- ifelse( abs(xend) > abs(xstart), xend*1.01, xend*0.99 )
    txtY <- max(c(ystart,yend)) - abs(yend - ystart)*(1-mid)
    txtRot <- 90
    txtVjust <- ifelse(xend > xstart, 1, 0)
  }

  brace_label <- data.frame(
    x = txtX,
    y = txtY
  )

  return(brace_label)
}








