# Copyright 2010-2014 Meik Michalke <meik.michalke@hhu.de>
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


#' Create XML node "preview" for RKWard plugins
#'
#' @param label A character string, text label for the preview checkbox.
#' @param mode A character string, must be either \code{"plot"}, \code{"output"}, \code{"data"}, or \code{"custom"}.
#' @param placement A character string, must be either \code{"default"}, \code{"attached"}, \code{"detached"}, or \code{"docked"}.
#' @param active Logical, whether the preview should be enabled by default.
#' @param i18n Either a character string or a named list with the optional elements \code{context}
#'    or \code{comment}, to give some \code{i18n_context} information for this node. If set to \code{FALSE},
#'    the attribute \code{label} will be renamed into \code{noi18n_label}.
#' @param id.name Character string, a unique ID for this plugin element.
#'    If \code{"auto"} and a label was provided, an ID will be generated automatically from the label
#'    if present, otherwise from the objects in the frame.
#'    If \code{NULL}, no ID will be given.
#' @return An object of class \code{XiMpLe.node}.
#' @export
#' @seealso \href{help:rkwardplugins}{Introduction to Writing Plugins for RKWard}
#' @examples
#' test.preview <- rk.XML.preview("See a preview?")
#' cat(pasteXML(test.preview))

rk.XML.preview <- function(label="Preview", mode="plot", placement="default", active=FALSE, id.name="auto", i18n=NULL){
  if(!identical(label, "Preview")){
    attr.list <- list(label=label)
  } else {
    attr.list <- list()
  }

  if(identical(id.name, "auto")){
    attr.list[["id"]] <- auto.ids(label, prefix=ID.prefix("preview"))
  } else if(!is.null(id.name)){
    attr.list[["id"]] <- id.name
  } else {}

  if(mode %in% c("plot", "output", "data", "custom")){
    if(!identical(mode, "plot")){
        attr.list[["mode"]] <- mode
    } else {}
  } else {
    stop(simpleError("rk.XML.preview: \"mode\" must be one of \"plot\", \"output\", \"data\", or \"custom\"!"))
  }

  if(placement %in% c("default", "attached", "detached", "docked")){
    if(!identical(placement, "default")){
        attr.list[["placement"]] <- placement
    } else {}
  } else {
    stop(simpleError("rk.XML.preview: \"placement\" must be one of \"default\", \"attached\", \"detached\", or \"docked\"!"))
  }
  
  if(isTRUE(active)){
    attr.list[["active"]] <- "true"
  } else {}

  # check for additional i18n info; if FALSE, "label" will be renamed to "noi18n_label"
  attr.list <- check.i18n(i18n=i18n, attrs=attr.list)

  node <- check.i18n(
    i18n=i18n,
    node=XMLNode("preview", attrs=attr.list),
    comment=TRUE
  )

  return(node)
}
