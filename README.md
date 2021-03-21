# ggbrace

An R package that draws highly modifiable curly braces in [ggplot2](https://ggplot2.tidyverse.org/). The brace can easily be modified and added to an existing ggplot object. ggbrace vizualizes the brace using a ggplot2's geom_path layer.

## Installation
Install the package from the git repository:
``` r
devtools::install_github("solatar/ggbrace")
```

## Default braces
Load the package, create a brace. You can also add a label.
``` r
library(ggbrace)
library(ggplot2)

ggplot() + geom_brace()
ggplot() + geom_brace(label="mylabel") + ylim(0,1.2)
```

<img src="readme_files/up_and_uplabel.png"/>
We can also produce a brace that points sideways instead of up or down. However, we must then spefify the orientation parameter in ggplot, otherwise our brace will end up as a zickzack line (if for some reason the above already results in a zickzack line for you, specify orientation="x"):

To put the brace anywhere in your graph, change its x and y coordinates. This can also change where the bracket is pointing to. The brace will always point towards yend, or xend if parameter="side" is specified.

To change where the brace is pointing, we change the mid parameter. This is always between 0.25 and 0.75 (even if you type in something smaller or higher), with 0.5 being the default. 
``` r
ggplot() + geom_brace(pointing="side")
ggplot() + geom_brace(ystart=2, yend= -2)
ggplot() + geom_brace(mid=0.7)
```
<img src="readme_files/default_braces.png"/>

## Custom braces

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

## Label customization

The label can be customized with the arguement labelsize and labelcolor, as well as any arguements that could be used for ggplot's annotate function, such as fontface or family.

``` r
ggplot() + 
  geom_brace(label="mylabel", labelcolor="red", fontface="bold") + 
  ylim(0,1.2)
```

<img src="readme_files/custom_text.png"/>
