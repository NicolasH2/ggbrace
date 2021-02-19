# curlybRaces
Wanna draw curly braces into your ggplot or plotly graph? This package provides the function seekBrace(), which outputs a data.frame, ready to be plotted.

## Installation

Install the culybRaces package from the git repository:
``` r
devtools::install_github("solatar/curlybRaces")
```

## Use

Load the package and create your brace:
``` r
library(curlybRaces)
mybrace <- seekkBrace()
```

Plot the brace. Here we use ggplot:
``` r
library(ggplot2)
ggplot() + geom_line(aes(x,y), data=mybrace)
```
