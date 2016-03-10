# Copyright 2016 Meik Michalke <meik.michalke@hhu.de>
#
# This file is part of the R package rkwarddev.
#
# rkwarddev is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# rkwarddev is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with rkwarddev.  If not, see <http://www.gnu.org/licenses/>.


#' Simple JavaScript method generator
#' 
#' Combines argument values into a JS method to append to an object call.
#' 
#' @param name Character string, name of the mthod to call on the JS object.
#' @param values Character vector, argument values for the method.
#' @param suffix Character string, will be appended to the foll call as-is.
#' @param object Either a character string (name of the JS object), a XiMpLe node (whose
#'    ID will be used), or an object of class \code{rk.JS.var} (whose JS name will be used).
#' @param var Character string, name of a JS variable to define. This will also append
#'    ";" at the end of the generated string.
#' @return A character string.
#' @export
#' @examples
#' rk.JS.method("split", values="[[", suffix="[0]")
rk.JS.method <- function(name, values=NULL, suffix=NULL, object=NULL, var=NULL){
  if(!is.null(values)){
    stopifnot(is.character(values))
    # do proper quoting
    values <- gsub("\"", "\\\\\"", values)
    values <- gsub("\t", "\\\\t", values)
    values <- gsub("\n", "\\\\n", values)
    values <- paste0("\"", paste0(values, collapse="\", \""), "\"")
  } else {}
  if(is.character(object) | is.XiMpLe.node(object)){
    object <- check.ID(object)
  } else if(inherits(object, "rk.JS.var")){
    object <- slot(slot(object, "vars")[[1]], "JS.var")
  } else if(!is.null(object)){
    stop(simpleError("\"object\" must be character, XiMpLe node or a rk.JS.var object!"))
  }
  method.call <- paste0(object, ".", name, "(", values, ")", suffix)
  if(!is.null(var)){
    stopifnot(is.character(var))
    result <- paste0("var ", var, " = ", method.call, ";")
  } else {
    result <- method.call
  }
  return(result)
}
