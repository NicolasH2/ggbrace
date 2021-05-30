# devtools::document()

#' create a curly brace as a layer ready to be added to a ggplot object
#'
#' Imports:
#' ggplot2
#'
#' @inheritParams stat_brace
#' @inheritParams ggplot2::geom_path
#' @inheritParams ggplot2::annotate
#'
#' @param inherit.data boolean, should data (and aes) from the ggplot main function be inherited? Set to FALSE if you set your own x and y.
#' @return ggplot2 layer object (geom_path) that can directly be added to a ggplot2 object. If a label was provided, another layer is added.
#' @export
#' @examples
#' library(ggbrace)
#' library(ggplot2)
#' ggplot() + geom_brace()
#'
#' ggplot() + geom_brace(aes(x=c(1,2), y=c(1,2)), inherit.data=FALSE)
#'
geom_brace <- function(mapping = NULL, data = NULL, inherit.aes=TRUE, #mapping-related
                       inherit.data=TRUE,
                       rotate=0, mid=NULL, bending=NULL, npoints=100, #orientation and shape
                       labelsize = 0, labeldistance=NULL, labelrotate=0, #labels
                       textORlabel="text",
                       ...){
  #================#
  #==preparations==#
  #================#
  #if user provides custom x and y, data (from ggplot main function) must be set to NULL and inherit.aes to FALSE.
  #otherwise ggplot will try to match the custom x and y to the data provided before which will have a different size, ending in an error
  if(!inherit.data){
    data <- data.frame()
    inherit.aes <- FALSE
  }
  #force mid between 0.25 and 0.75
  mid <- ifelse(mid>0.75, 0.75, ifelse(mid<0.25, 0.25, mid))
  #up and right will be positive; down and left will be negative. The direction variable will be a shortcut to determine how the brace and text is placed
  direction <- -sign(rotate/90-1.5)

  #=======================#
  #==label for the brace==#
  #=======================#
  added_labels <- NULL #in case there is no label, the actual brace will be combined with NULL instead of something that doesn't exist
  if(labelsize>0){
    #hjust and vjust of the text depend on the brace rotation and the label rotation
    if(labelrotate==90){
      txtvjust <- switch(rotate/90+1, 0.5, 1, 0.5, 0)
      txthjust <- switch(rotate/90+1, 0, 0.5, 1, 0.5)
    }else if(labelrotate==270){
      txtvjust <- switch(rotate/90+1, 0.5, 0, 0.5, 1)
      txthjust <- switch(rotate/90+1, 1, 0.5, 0, 0.5)
    }else{
      txtvjust <- switch(rotate/90 +1, 0, 0.5, 1, 0.5)
      txthjust <- switch(rotate/90 +1, 0.5, 0, 0.5, 1)
    }
    #create ggplot layer. StatBraceLabel will do the calculations where to put the text (calling .coordCorrection)
    added_labels <- ggplot2::layer(
      stat = StatBraceLabel,
      data = data, mapping = mapping, geom = textORlabel,
      position = "identity", show.legend = FALSE, inherit.aes = inherit.aes,
      params = list(vjust=txtvjust, hjust=txthjust, size=labelsize, angle=labelrotate,
                    rotate=rotate, bending=bending, npoints=npoints, mid=mid,
                    labeldistance=labeldistance,
                    direction=direction, outside=FALSE, ...)
    )
  }

  #====================#
  #==the brace itself==#
  #====================#
  mapping$label <- NULL #set this to null to avoid a message from the next ggplot layer (which has no label option)
  #create ggplot layer. StatBrace will do the calculations where and how to draw the brace (calling .coordCorrection and then .seekBrace)
  outbrace <- ggplot2::layer(
    stat = StatBrace,
    data = data, mapping = mapping, geom = "path",
    position = "identity", show.legend = FALSE, inherit.aes = inherit.aes,
    params = list(rotate=rotate, bending=bending, npoints=npoints, mid=mid,
                  outside=FALSE, direction=direction, ...)
  )

  outbrace <- c(outbrace, added_labels)

  return(outbrace)
}
