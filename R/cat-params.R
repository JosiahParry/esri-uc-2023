tool_exec <- function(in_params, out_params) {
  print(names(in_params))
  lapply(in_params, str)
  lapply(out_params, str)
}