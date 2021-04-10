
#' create curly braces as a layer in ggplot
#'
#' Imports:
#' ggplot2
#'
#' @inheritParams geom_brace
#' @inheritParams ggplot2::geom_path
#' @inheritParams ggplot2::geom_text
#' @import ggplot2
#'
#' @param outerstart number, overwrites distance and provides one coordinate for all braces
#' @param width number, regulates how wide the braces are
#' @param distance number between the brace and the nearest data point
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
stat_brace <- function(mapping = NULL, data = NULL, rotate=0,
                       labelsize = 0, labeldistance=NULL, labelrotate=0,
                       distance=NULL, outerstart=NULL, width=NULL, mid=NULL, bending=NULL,
                       npoints=100, inherit.aes=TRUE,
                       ...) {
  position="out"
  if(!is.null(outerstart)){
    if(is.na(outerstart)){
      position="in" #a way for geom_brace to call stat_brace
      outerstart=NULL
    }
  }
  #calculate coordinates for braces and labels
  StatBraceAndLabel <- .funStatBrace(rotate=rotate, position=position, distance=distance,
                                     labeldistance=labeldistance, outerstart=outerstart, #outerstart will overwrite distance, if specified
                                     width=width, mid=mid, bending=bending, npoints=npoints)
  StatBrace <- StatBraceAndLabel[[1]] #first list item contains ggproto for braces
  StatBraceLabel <- StatBraceAndLabel[[2]] #second list item contains ggproto for labels

  # decide the vjust and hjust for the text
  if(labelrotate==90 | labelrotate==270){
    txtvjust <- switch(rotate/90+1,
                       0.5, 1, 0.5, 0)
    txthjust <- switch(rotate/90+1,
                       0, 0.5, 1, 0.5)
  }else{
    txtvjust <- switch(rotate/90+1,
                       0, 0.5, 1, 0.5)
    txthjust <- switch(rotate/90+1,
                       0.5, 0, 0.5, 1)
  }

  added_labels <- NULL #is set to NULL first, so if no labels are defined, NULL will be added to the braces
  # plot labels
  if(labelsize>0){
    added_labels <- ggplot2::layer(
      stat = StatBraceLabel,
      data = data,
      mapping = mapping,
      geom = "text",
      position = "identity",
      show.legend = FALSE,
      inherit.aes = inherit.aes,
      params = list(vjust=txtvjust, hjust=txthjust, size=labelsize, angle=labelrotate, ...))

    # if(!is.null(labelcolor)) added_labels$aes_params[["colour"]] <- labelcolor # causes an error for some reason
  }
  mapping$label <- NULL #delete the label part from the mapping parameter so as to not raise a warning when plotting the brace

  #plot braces
  output <- ggplot2::layer(
    stat = StatBrace,
    data = data, mapping = mapping, geom = "path",
    position = "identity", show.legend = FALSE, inherit.aes = inherit.aes,
    params = list(...)
  )

  # add labels to the braces
  output <- c(output, added_labels)

  return(output)
}






