# spatial auto regressive models

SAR <- function(.data, concept_of_nbs = c("contiguity", "knn"), k, dependent_var = "crime_pers", independent_vars = "literacy", output_fc) {
  
  independent_vars <- unlist(independent_vars)
  
  .data = sfdep::guerry
  # extract geometry
  geo <- sf::st_geometry(.data)
  # drop geometry from data frame
  .data <- sf::st_drop_geometry(.data)
  
  
  if (concept_of_nbs == "contiguity") {
    
    nb <- sfdep::st_contiguity(geo)
    # going to be row-standardized
    wt <- sfdep::st_weights(nb)
    listw <- sfdep::recreate_listw(nb, wt)
    
  } else if (concept_of_nbs == "knn") {
    
    if (missing(k)) {
      cli::cli_abort("{.var k} cannot be missing when K-NN neighbors are chosen")
    }
    
    nb <- sfdep::st_knn(geo, k)
    # row-standardized for simplicity
    wt <- sfdep::st_weights(nb)
    listw <- sfdep::recreate_listw(nb, wt)
    
  }
  
  # create a formula from variables
  form <- reformulate(independent_vars, dependent_var)
  mod <- spatialreg::lagsarlm(form, data = .data, listw = listw)
  
  cat(c("SAR model Summary",
        capture.output(summary(mod))), sep = "\n")
  
  # prepare output
  preds <- mod$fitted.values
  resids <- residuals(mod)
  
  cat(c(
    "SAR Model Residuals Autocorrelation",
    capture.output(spdep::moran.test(resids, listw))
  ), sep = "\n")
  
  
  # prepare output
  sf::st_sf(
    predictions = preds,
    residuals = resids,
    geometry = geo
  )
}