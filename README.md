# curlybRaces
Wanna draw curly braces into your ggplot or plotly graph? This package provides the function seekBrace(), which outputs a data.frame, ready to be plotted.

## Installation

Install the culybRaces package from the git repository:
``` r
devtools::install_github("solatar/curlybRaces")
```

## Use

Load the package, create your first brace and plot it with ggplot2:
``` r
library(curlybRaces, ggplot2)

mybrace <- seekBrace()
ggplot() + geom_line(aes(x,y), data=mybrace, orientation="y")
```
Note the orientation statement in ggplot. If we would not have specified it, the brace would be a zickzack line instead.

We can also produce a brace that point up oder down instead of sideways:
``` r
mybrace <- seekBrace(pointing="updown")
ggplot() + geom_line(aes(x,y), data=mybrace)
```
When we construct an up or down pointing brace, we do not need to specify the orientation in ggplot. However, if for some reason this results in a zickzack line for you, specify orientation="x".
