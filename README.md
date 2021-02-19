# curlybRaces
Wanna draw curly braces into your ggplot or plotly graph? This package provides the function seekBrace(), which outputs a data.frame, ready to be plotted.

## Installation

Install the culybRaces package from the git repository:
``` r
devtools::install_github("solatar/curlybRaces")
```

## Default braces

Load the package, create your first brace and plot it with ggplot2:
``` r
library(curlybRaces, ggplot2)

mybrace <- seekBrace()
ggplot() + geom_line(aes(x,y), data=mybrace)
```
We can also produce a brace that points sideways instead of up or down. However, we must then spefify the orientation parameter in ggplot, otherwise our brace will end up as a zickzack line (if for some reason the above already results in a zickzack line for you, specify orientation="x"):
``` r
mybrace <- seekBrace(pointing="side")
ggplot() + geom_line(aes(x,y), data=mybrace, orientation="y")
```

## Custom braces
To put braces wherever you want in your graph, we can change the x and y coordinates of the bracket. This can also change where the bracket is pointing to. If xend is smaller then xstart, the brace will point to the left. The same is true for the y coordinates if we specify the pointing parameter to be "updown".
``` r
mybrace <- seekBrace(xstart=3, xend=1, ystart=2, yend= -2)
ggplot() + geom_line(aes(x,y), data=mybrace, orientation="y")
```
To change where the brace is pointing, we change the mid parameter. This is always between 0.25 and 0.75 (even if you type in something smaller or higher), with 0.5 being the default. 
``` r
mybrace <- seekBrace(xstart=3, xend=1, ystart=2, yend= -2, mid=0.3)
ggplot() + geom_line(aes(x,y), data=mybrace, orientation="y")
```
