# ggbrace

An R package that draws highly modifiable curly braces in [ggplot2](https://ggplot2.tidyverse.org/). The brace can easily be modified and added to an existing ggplot object. ggbrace vizualizes the brace using a ggplot2's geom_path layer.

## Installation
Install the ggbrace package from the git repository:
``` r
devtools::install_github("solatar/ggbrace")
```

## Default braces
Load the package, create your first brace in ggplot2:
``` r
library(ggbrace)
library(ggplot2)

ggplot() + geom_brace()
```

<img src="readme_files/up.png"/>
We can also produce a brace that points sideways instead of up or down. However, we must then spefify the orientation parameter in ggplot, otherwise our brace will end up as a zickzack line (if for some reason the above already results in a zickzack line for you, specify orientation="x"):

``` r
ggplot() + geom_brace(pointing="side")
```
<img src="readme_files/right.png"/>
You can add the geom_line() to your plot of choice to include the brace. Specify its x and y coordinates to put it wherever you want (see below).

## Custom braces
To put the brace anywhere in your graph, change its x and y coordinates. This can also change where the bracket is pointing to. The brace will always point towards yend, or xend if parameter="side" is specified.

``` r
ggplot() + geom_brace(ystart=2, yend= -2)
```
<img src="readme_files/down.png"/>
To change where the brace is pointing, we change the mid parameter. This is always between 0.25 and 0.75 (even if you type in something smaller or higher), with 0.5 being the default. 

``` r
ggplot() + geom_brace(mid=0.7)
```
<img src="readme_files/shifted.png"/>

## Customization via ggplot2
To change how the brace looks like, simply provide the arguements needed by ggplot. This includes all arguements that could be given to geom_path: size, color, linetype, alpha (opacity), lineend and linejoin. The first 3 are examplified here.

``` r
ggplot() + geom_brace(linetype="dashed", color="blue", size=3, alpha=0.6)
```
<img src="readme_files/parameters.png"/>

If the size is bigger than usual, it might make sense to specify how the ends of the brace look like. This can be specified via the lineend and linejoin options (inherent to the ggplot2's geom_path object). They lead to subtle differences.

``` r
ggplot() + geom_brace(size=5, lineend="butt")
ggplot() + geom_brace(size=5, linejoin="mitre")
```
<img src="readme_files/parameters2.png"/>

All possible options for:
- linetype: solid (default), dotted, dotdash, twodash, dashed, longdash, blank
- lineend: butt (default), square, round
- linejoin: round (default), mitre, bevel

## Creating a brace data.frame
If you want more flexibility, you might prefer the data frame the brace is built from. For that you can call the seekBrace() function. It takes the same parameters as the geom_brace() function, except ggplot specifics like color, size, line_type, etc. and produces a data.frame from it. You can use edit this data.frame as you wish and then plug it into a geom_path object to plot it with ggplot.
``` r
mybrace <- seekBrace()
ggplot() + geom_path(aes(x,y), data=mybrace)
```
