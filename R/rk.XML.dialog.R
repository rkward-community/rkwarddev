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


#' Create XML dialog section for RKWard plugins
#'
#' This function will create a dialog section with optional child nodes "browser", "checkbox",
#' "column", "copy", "dropdown", "embed", "formula", "frame", "include", "input", "insert",
#' "preview", "radio", "row", "saveobject", "select", "spinbox", "stretch", "tabbook", "text",
#' "valueselector", "valueslot", "varselector" and "varslot".
#'
#' @param ... Objects of class \code{XiMpLe.node}.
#' @param label Character string, a text label for this plugin element.
#' @param recommended Logical, whether the dialog should be the recommended interface (unless the user has configured
#'    RKWard to default to a specific interface). This attribute currently has no effect, as it is implicitly "true",
#'    unless the wizard is recommended.
#' @param i18n Either a character string or a named list with the optional elements \code{context}
#'    or \code{comment}, to give some \code{i18n_context} information for this node. If set to \code{FALSE},
#'    the attribute \code{label} will be renamed into \code{noi18n_label}.
#' @return An object of class \code{XiMpLe.node}.
#' @export
#' @seealso
#'    \code{\link[rkwarddev:rk.XML.plugin]{rk.XML.plugin}},
#'    \code{\link[rkwarddev:rk.plugin.skeleton]{rk.plugin.skeleton}},
#'    and the \href{help:rkwardplugins}{Introduction to Writing Plugins for RKWard}
#' @examples
#' # define an input field and two checkboxes
#' test.input <- rk.XML.input("Type some text")
#' test.cbox1 <- rk.XML.cbox(label="Want to type?", val="true")
#' test.cbox2 <- rk.XML.cbox(label="Are you shure?", val="true")
#' test.dialog <- rk.XML.dialog(rk.XML.col(test.input, test.cbox1, test.cbox2))
#' cat(pasteXML(test.dialog))

rk.XML.dialog <- function(..., label=NULL, recommended=FALSE, i18n=NULL){
  nodes <- list(...)

  # check the node names and allow only valid ones
  valid.child("dialog", children=nodes)

  if(!is.null(label)){
    attr.list <- list(label=label)
  } else {
    attr.list <- list()
  }

  if(isTRUE(recommended)){
    attr.list[["recommended"]] <- "true"
  } else {}

  # check for additional i18n info; if FALSE, "label" will be renamed to "noi18n_label"
  attr.list <- check.i18n(i18n=i18n, attrs=attr.list)
  
  node <- check.i18n(
    i18n=i18n,
    node=XMLNode("dialog", attrs=attr.list, .children=child.list(nodes, empty=FALSE)),
    comment=TRUE
  )

  return(node)
}
