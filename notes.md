

- Start with showing the script tool interface
- Types of parameters determine the user experience in the GP pane
- The param types that are worthy of note are: 
  - string
    - multiple values
  - feature class
  - field
  - fields
    - dependencies on fields
- The direction of these parameters are also importat to note as well
- we build the R execute script based on the UI.
- we point to an R script
- the R script MUST have a function called `tool_exec` with the following signature

```r
tool_exec <- function(in_params, out_params) {
  # . . .
}
```

- The `in_params` and `out_params` are named lists that contain the values that were captured by the GP pane
- we can view them using `R/print-params.R` script tool which contains the body

```r
tool_exec <- function(in_params, out_params) {
  print(in_params)
  print(out_params)
}
```

- If we go back to the GP script tool properties you'll notice that the names correspond to the element names in the list
- this is important anything captured in those params can be used by your script tool
- so how would I suggest you make a script tool?
- 3 steps from my perspective: 
  - identify your problem and objective
  - create a normal R function that does what you need it to do
  - wrap that function in the `tool_exec()` format using parameters from the GP pane
  
## Spatial Lag Example

- This requires the R package `{sfdep}` to be installed.

- The goal is to take a feature class and field name and calculate the spatial lag from it
- Write the spatial lag to a new feature class
- write a basic R function:
  - takes 3 params:
  - `.data`: the dataset to use
  - `field`: the field name to calculate the lag from 
  - `k`: the number of neighbors to include in the calculation
  
- View body of `calculate_lag()`


  

  