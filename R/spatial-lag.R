calculate_lag <- function(.data, field, conceptualization = c("knn", "contiguity"), k) {
  
  # verify the conceptualization 
  concept <- match.arg(conceptualization)
  if (concept == "knn" && missing(k)) stop("`k` must be included for `knn`")
  
  # extract the geometry from the data
  geo <- sf::st_geometry(.data)
  
  # make a neighbor and weights object based on the concept
  if (concept == "knn") {
    nb <- sfdep::st_knn(geo, k)
  } else {
    nb <- sfdep::st_contiguity(geo)
  }
  
  # calculate weights
  wt <- sfdep::st_weights(nb)
  
  # calculate lag
  field_lag <- sfdep::st_lag(.data[[field]], nb, wt)
  
  # output column name is field with _lag
  out_name <- paste0(field, "_lag")
  
  # add to .data
  .data[[out_name]] <- field_lag
  
  # return .data
  .data
}


# calculate_lag(guerry, "count", "contiguity")

# Input Parameter names

# fclass
# field
# conceptualization

# Output Parameter Names
# out_flcass

tool_exec <- function(in_params, out_params) {
  
  arcgisbinding::arc.check_product()
  
  # extract the fclass path and open it
  fclarcgisbinding::arc.open(in_params[["flcass"]])
  
}