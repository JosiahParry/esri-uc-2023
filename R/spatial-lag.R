calculate_lag <- function(.data, field, k) {
  
  # extract the geometry from the data
  geo <- sf::st_geometry(.data)
  
  # exterct the field from the data
  x <- .data[[field]]
  
  # create neighbors
  nb <- sfdep::st_knn(geo, k)
  
  # calculate weights
  wt <- sfdep::st_weights(nb)
  
  # calculate lag
  field_lag <- sfdep::st_lag(x, nb, wt)
  
  # output column name is field with _lag
  out_name <- paste0(field, "_lag")
  
  # add to .data
  .data[[out_name]] <- field_lag
  
  # return .data
  .data
}



# Input Parameter names
# fclass - feature class path
# field - character of the field to use 
# k - the number of neighbors to use

# Output Parameter Names
# out_flcass - where the results will be written

tool_exec <- function(in_params, out_params) {
  
  # extract input params
  fclass_path <- in_params[["fclass"]]
  field_name <- in_params[["field"]]
  k <- in_params[["k"]]
  
  # output params
  outpath <- out_params[["outpath"]]
  
  # verify license info
  arcgisbinding::arc.check_product()
  
  # open the feature class
  fc <- arcgisbinding::arc.open(fclass_path) |> 
    # select the feature we want
    arcgisbinding::arc.select(fields = field_name) |> 
    # convert to sf object
    arcgisbinding::arc.data2sf()
  
  # run helper function
  result <- calculate_lag(fc, field, k)
  
  # write the results out
  arcgisbinding::arc.write(outpath, result)
}