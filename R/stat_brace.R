
#' create curly braces as a layer in ggplot
#'
#' Imports:
#' ggplot2
#'
#' @inheritParams ggplot2::geom_path
#' @inheritParams ggplot2::geom_text
#' @import ggplot2
#'
#' @param rotate number, defines where the brace is pointing to: 0=up, 90=right, 180=down, 270=left. When specified by user, will overwrite other directions the brace might have from x/y coordinates.
#' @param mid number, where the pointer is within the bracket space (between 0.25 and 0.75)
#' @param width number, regulates how wide the braces are
#' @param distance number between the brace and the nearest data point
#' @param outerstart number, overwrites distance and provides one coordinate for all braces
#' @param bending number, how strongly the curves of the braces should be bent (the higher the more round). Note: too high values will result in the brace showing zick-zack lines
#' @param label string, a custom text to be displayed at the brace.
#' @param labeldistance number, distance of the label to the brace pointer
#' @param labelsize number, changing the font size of the label. Only takes effect if the parameter "label" was defined.
#' @param labelcolor string, defining the color of the label. Only takes effect if the parameter "label" was defined.
#' @param textORlabel string, either "text" or "label" to define whether geom_text or geom_label should be used
#' @param npoints integer, number of points generated for the brace curves (resolution). This number will be rounded to be a multiple of 4 for calculation purposes.
#' @return ggplot2 layer object (geom_path) that can directly be added to a ggplot2 object. If a label was provided, a another layer (geom_text) is added.
#' @export
#' @examples
#' library(ggbrace)
#' library(ggplot2)
#' ggplot(mtcars, aes(mpg, wt, color=factor(am))) +
#'   geom_point() +
#'   facet_wrap(~vs) +
#'   stat_brace(rotate=90, aes(label=factor(am)))
#'
stat_brace <- function(mapping = NULL, data = NULL, inherit.aes=TRUE, #mapping-related
                       rotate=0, mid=NULL, bending=NULL, npoints=100, #orientation and shape
                       labelsize = 0, labeldistance=NULL, labelrotate=0, #labels
                       distance=NULL, outerstart=NULL, width=NULL, #position
                       textORlabel="text",
                       ...){
  #================#
  #==preparations==#
  #================#
  # Extract arguments for ggplot functions
  dots <- list(...)
  gglabel_args <- intersect(names(dots), unique(c(formalArgs(geom_label),formalArgs(layer))))
  if(length(gglabel_args)>0){
    dots_label <- dots[gglabel_args]
  }else{
    dots_label <- list(color="black")
  }
  
  ggpath_args <- intersect(names(dots), unique(c(formalArgs(geom_path),formalArgs(layer))))
  if(length(ggpath_args)>0){
    dots_path <- dots[ggpath_args]
  }else{
    dots_path <- list(color="black")
  }
  
  #force mid between 0.25 and 0.75
  mid <- ifelse(mid>0.75, 0.75, ifelse(mid<0.25, 0.25, mid))
  #up and right will be positive; down and left will be negative
  direction <- -sign(rotate/90-1.5)

  #=======================#
  #==label for the brace==#
  #=======================#
  added_labels <- NULL #in case there is no label, the actual brace will be combined with NULL instead of something that doesn't exist
  if(labelsize>0){
    #hjust and vjust of the text depend on the brace rotation and the label rotation
    if(any(labelrotate==c(90,270))){
      txtvjust <- switch(rotate/90+1, 0.5, 1, 0.5, 0)
      txthjust <- switch(rotate/90+1, 0, 0.5, 1, 0.5)
    }else{
      txtvjust <- switch(rotate/90+1, 0, 0.5, 1, 0.5)
      txthjust <- switch(rotate/90+1, 0.5, 0, 0.5, 1)
    }
    #create ggplot layer. StatBraceLabel will do the calculations where to put the text (calling .coordCorrection)
    added_labels <- ggplot2::layer(
      stat = StatBraceLabel,
      data = data, mapping = mapping, geom = textORlabel,
      position = "identity", show.legend = FALSE, inherit.aes = inherit.aes,
      params = append(dots_label, list(vjust=txtvjust, hjust=txthjust, size=labelsize, angle=labelrotate,
                    rotate=rotate, bending=bending, npoints=npoints, mid=mid,
                    labeldistance=labeldistance, width=width,
                    distance=distance, outerstart=outerstart,
                    direction=direction, outside=TRUE))
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
    params = append(dots_path, list(rotate=rotate, bending=bending, npoints=npoints, mid=mid,
                  distance=distance, outerstart=outerstart, width=width,
                  direction=direction, outside=TRUE))
  )

  outbrace <- c(outbrace, added_labels)

  return(outbrace)
}






