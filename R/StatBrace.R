StatBrace <- ggplot2::ggproto(
  `_class` = "StatBrace",
  `_inherit` = Stat,
  required_aes = c("x", "y"),
  compute_group = function(
    data,
    scales,
    rotate = 0,
    mid = NULL,
    bending = NULL,
    npoints = 100,
    distance = NULL,
    outerstart = NULL,
    width = NULL,
    outside = TRUE,
    discreteAxis=FALSE,
    bracketType="curly"
  ){
    x = data$x
    y = data$y

    #before we feed the .seekBrace function we need to change the x/y values
    coords <- .coordCorrection(
      x = x,
      y = y,
      rotate = rotate,
      mid = mid,
      distance = distance,
      outerstart = outerstart,
      width = width,
      outside = outside,
      bending = bending,
      discreteAxis=discreteAxis
    )[["dataCoords"]]

    #provides data.frame with x and y values to draw the brace
    brace <- .seekBrace(
      x = coords$x,
      y = coords$y,
      rotate = rotate,
      bending = bending,
      npoints = npoints,
      bracketType = bracketType
    )

    return(brace)
  }
)
