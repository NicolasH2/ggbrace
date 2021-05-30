StatBrace <- ggproto(`_class` = "StatBrace",
                     `_inherit` = Stat,
                     required_aes = c("x", "y"),
                     compute_group = function(
                       data, scales,
                       rotate, mid, bending, npoints,
                       distance=NULL, outerstart=NULL, width=NULL,
                       direction, outside
                     ) {
                       x=data$x
                       y=data$y

                       #before we feed the .seekBrace function we need to change the x/y values
                       coords <- .coordCorrection(
                         x=x, y=y,
                         rotate=rotate, mid=mid,
                         distance=distance, outerstart=outerstart, width=width,
                         direction=direction, outside=outside
                       )[["dataCoords"]]

                       #provides data.frame with x and y values to draw the brace
                       brace <- .seekBrace(x=coords$x, y=coords$y,
                                           rotate=rotate, bending=bending, npoints=npoints)

                       return(brace)
                     }
)

StatBraceLabel <- ggproto("StatBraceLabel", Stat,
                          required_aes = c("x", "y"),
                          compute_group = function(
                            data, scales,
                            rotate, mid, bending, npoints,
                            labeldistance,
                            distance=NULL, outerstart=NULL, width=NULL,
                            direction, outside
                          ) {
                            x=data$x
                            y=data$y

                            #provides data.frame with an x and y value for the label
                            coords <- .coordCorrection(
                              x=x, y=y,
                              rotate=rotate, mid=mid,
                              labeldistance=labeldistance,
                              distance=distance, outerstart=outerstart, width=width,
                              direction=direction, outside=outside
                            )[["labelCoords"]]

                            return(coords)
                          }
)
