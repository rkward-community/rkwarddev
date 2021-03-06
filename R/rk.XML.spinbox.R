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


#' Create XML node "spinbox" for RKWard plugins
#'
#' @param label Character string, a text label for this plugin element.
#' @param min Numeric, the lowest value allowed. Defaults to the lowest value technically representable in the spinbox.
#' @param max Numeric, the largest value allowed. Defaults to the highest value technically representable in the spinbox.
#' @param initial Numeric, will be used as the initial value.
#' @param real Logical, whether values should be real or integer numbers.
#' @param precision Numeric, if \code{real=TRUE} defines the default number of decimal places shown in the spinbox.
#' @param max.precision Numeric, maximum number of digits that can be meaningfully represented.
#' @param id.name Character string, a unique ID for this plugin element.
#'    If \code{"auto"} and a label was provided, an ID will be generated automatically from the label.
#' @param help Character string or list of character values and XiMpLe nodes, will be used as the \code{text} value for a setting node in the .rkh file.
#'    If set to \code{FALSE}, \code{\link[rkwarddev:rk.rkh.scan]{rk.rkh.scan}} will ignore this node.
#'    Also needs \code{component} to be set accordingly!
#' @param component Character string, name of the component this node belongs to. Only needed if you
#'    want to use the scan features for automatic help file generation; needs \code{help} to be set
#'    accordingly, too!
#' @param i18n Either a character string or a named list with the optional elements \code{context}
#'    or \code{comment}, to give some \code{i18n_context} information for this node. If set to \code{FALSE},
#'    the attribute \code{label} will be renamed into \code{noi18n_label}.
#' @return An object of class \code{XiMpLe.node}.
#' @export
#' @seealso \href{help:rkwardplugins}{Introduction to Writing Plugins for RKWard}
#' @examples
#' test.spinbox <- rk.XML.spinbox("Spin this:")
#' cat(pasteXML(test.spinbox))


rk.XML.spinbox <- function(label, min=NULL, max=NULL, initial=0, real=TRUE, precision=2, max.precision=8, id.name="auto",
  help=NULL, component=rk.get.comp(), i18n=NULL){
  attr.list <- list(label=label)

  if(identical(id.name, "auto")){
    attr.list[["id"]] <- auto.ids(label, prefix=ID.prefix("spinbox"))
  } else if(!is.null(id.name)){
    attr.list[["id"]] <- id.name
  } else {}

  if(initial != 0){
    check.type(initial, "numeric", "initial")
    attr.list[["initial"]] <- as.numeric(initial)
  } else {}
  if(!is.null(min)){
    check.type(min, "numeric", "min")
    attr.list[["min"]] <- as.numeric(min)
  } else {}
  if(!is.null(max)){
    check.type(max, "numeric", "max")
    attr.list[["max"]] <- as.numeric(max)
  } else {}
  if(!isTRUE(real)){
    attr.list[["type"]] <- "integer"
  } else {}
  if(precision != 2){
    check.type(precision, "numeric", "precision")
    attr.list[["precision"]] <- as.numeric(precision)
  } else {}
  if(max.precision != 8){
    check.type(max.precision, "numeric", "max.precision")
    attr.list[["max_precision"]] <- as.numeric(max.precision)
  } else {}

  # check for additional i18n info; if FALSE, "label" will be renamed to "noi18n_label"
  attr.list <- check.i18n(i18n=i18n, attrs=attr.list)

  node <- check.i18n(
    i18n=i18n,
    node=XMLNode("spinbox", attrs=attr.list),
    comment=TRUE
  )

  # check for .rkh content
  rk.set.rkh.prompter(component=component, id=attr.list[["id"]], help=help)

  return(node)
}
