StatBraceLabel <- ggplot2::ggproto(
  `_class` = "StatBraceLabel",
  `_inherit` = Stat,
  compute_group = function(
    data,
    scales,
    rotate = 0,
    mid = NULL,
    textdistance = NULL,
    distance = NULL,
    outerstart = NULL,
    width = NULL,
    outside = TRUE,
    bending = NULL,
    discreteAxis=FALSE
  ){
      x = data$x
      y = data$y

      #provides data.frame with an x and y value for the label
      coords <- .coordCorrection(
        x = x,
        y = y,
        rotate = rotate,
        mid = mid,
        textdistance = textdistance,
        distance = distance,
        outerstart = outerstart,
        width = width,
        outside = outside,
        bending = bending,
        discreteAxis = discreteAxis
      )[["labelCoords"]]

      return(coords)
    }
)
