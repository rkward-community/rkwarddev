# Copyright 2010-2018 Meik Michalke <meik.michalke@hhu.de>
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


#' Create XML node "connect" for RKWard plugins
#'
#' If you define a \code{XiMpLe.node} object as \code{governor} which is not a \code{<convert>} node
#' and \code{not=FALSE}, the function will automatically append  to its \code{id}.
#' 
#' @section Connect embedded plugins: To connect to properties of embedded plugins, the validity check of the \code{set}
#'  modifier needs to be skipped. You do this by providing an \code{<external>} XiMpLe node instead, whose ID is
#'  then taken unvalidated. This can be useful in combination with \code{rk.plug.comp} object provided as \code{client}.
#' 
#' @note To get a list of the implemented modifiers in this package see \code{\link[rkwarddev:modifiers]{modifiers}}.
#'
#' @param governor Either a character string (the \code{id} of the property whose state should control
#'    the \code{client}), or an object of class \code{XiMpLe.node} (whose \code{id} will be extracted
#'    and used). Usually a \code{<convert>} node defined earlier (see
#'    \code{\link[rkwarddev:rk.XML.convert]{rk.XML.convert}}).
#' @param client Either a character string (the \code{id} if the element to be controlled by \code{governor})m
#'    an object of class \code{XiMpLe.node} (whose \code{id} will be extracted and used), or an object of class
#'    \code{\link[rkwarddev:rk.plug.comp-class]{rk.plug.comp}} (whose name will be used).
#' @param get Character string, a valid modifier for the node property of \code{governor}, often
#'    the ".state" value of some apropriate node. If set to an empty \code{""}, no modifier will be appended.
#' @param set Character string, a valid modifier for the node property of \code{client}, usually
#'    one of \code{"enabled"}, \code{"visible"} or \code{"required"}. If you provide an \code{<external>}
#'    node instead, its ID will be used as the modifier without validation (see above).
#' @param not Logical, if \code{TRUE}, the state of \code{governor} (\code{TRUE/FALSE}) will be inversed.
#' @param reconcile Logical, forces the \code{governor} to only accept values which are valid for
#'    the \code{client} as well.
#' @return An object of class \code{XiMpLe.node}.
#' @export
#' @seealso
#'    \code{\link[rkwarddev:rk.XML.convert]{rk.XML.convert}},
#'    \code{\link[rkwarddev:rk.XML.external]{rk.XML.external}},
#'    \code{\link[rkwarddev:rk.XML.logic]{rk.XML.logic}},
#'    \code{\link[rkwarddev:rk.XML.set]{rk.XML.set}},
#'    \code{\link[rkwarddev:rk.XML.switch]{rk.XML.switch}},
#'    \code{\link[rkwarddev:modifiers]{modifiers}},
#'    and the \href{help:rkwardplugins}{Introduction to Writing Plugins for RKWard}
#' @examples
#' test.connect <- rk.XML.connect(governor="lgc_foobar", client="frame_bar")
#' cat(pasteXML(test.connect))

rk.XML.connect <- function(governor, client, get="state", set="enabled", not=FALSE, reconcile=FALSE){

  # check for container objects
  governor <- stripXML(governor)
  if(inherits(client, "rk.plug.comp")){
    client <- slot(client, "name")
  } else if(inherits(client, "rk.plot.opts")){
    client <- stripXML(slot(client, "XML"))
  } else if(is.character(client) | is.XiMpLe.node(client)){
    client <- stripXML(client)
  } else {
    stop(simpleError("\"client\" must be a character string, an object of class \"rk.plot.opts\" or \"rk.plug.comp\", or a XiMpLe node!"))
  }

  if(length(governor) > 1 | length(client) > 1){
    stop(simpleError("\"governor\" and \"client\" must be of length 1!"))
  } else {}

  # let's see if we need to extract IDs first
  client.id <- check.ID(client, search.environment=TRUE)
  governor.id <- check.ID(governor)
  # if governor is an XML node but not <convert>, append ".state"
  if(is.XiMpLe.node(governor)){
    node.name <- slot(governor, "name")
    if(!identical(node.name, "convert")){
      # validate get modifier
      if(modif.validity(governor, modifier=get)){
        if(isTRUE(!identical(get, ""))){
          governor.id <- paste(governor.id, get, sep=".")
        } else {}
      } else {}
    } else {}
  } else {
    if(modif.validity("all", modifier=get)){
      if(isTRUE(!identical(get, ""))){
        governor.id <- paste(governor.id, get, sep=".")
      } else {}
    } else {}
  }
  if(isTRUE(not)){
    governor.id <- paste(governor.id, "not", sep=".")
  } else {}

  attr.list <- list(governor=as.character(governor.id))

  if(is.XiMpLe.node(set)){
    if(identical(XMLName(set), "external")){
      set <- check.ID(set)
    } else {
      stop(simpleError("\"set\" must either be a character string or an <external> node!"))
    }
  } else {
    # validate set modifier
    if(is.XiMpLe.node(client)){
      modif.validity(client, modifier=set, warn.only=FALSE)
    } else {
      modif.validity("all", modifier=set, warn.only=FALSE)
    }
  }
  attr.list[["client"]] <- paste(client.id, set, sep=".")

  if(isTRUE(reconcile)){
      attr.list[["reconcile"]] <- "true"
  } else {}

  node <- XMLNode("connect", attrs=attr.list)

  return(node)
}
