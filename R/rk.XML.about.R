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


#' Create XML node "about" for RKWard pluginmaps
#'
#' @param name A character string with the plugin name.
#' @param author A vector of objects of class \code{person} with these elements (mandatory):
#'    \describe{
#'      \item{given}{Author given name}
#'      \item{family}{Author family name}
#'      \item{email}{Author mail address (can be omitted if \code{role} does not include \code{"cre"})}
#'      \item{role}{This person's specific role, e.g. \code{"aut"} for actual author, \code{"cre"} for maintainer or \code{"ctb"} for contributor.}
#'    }
#'    See \code{\link[utils:person]{person}} for more details on this, especially for valid roles.
#' @param about A named list with these elements:
#'    \describe{
#'      \item{desc}{A short description (mandatory)}
#'      \item{version}{Plugin version (mandatory)}
#'      \item{date}{Release date (mandatory); either a \code{POSIXlt} object, or character string in "%Y-%m-%d" format}
#'      \item{url}{URL for the plugin (optional)}
#'      \item{license}{License the plugin is distributed under (mandatory)}
#'      \item{category}{A category for this plugin (optional)}
#'      \item{long.desc}{A long description (optional, defaults to \code{desc})}
#'    }
#' @export
#' @seealso
#'    \code{\link[rkwarddev:rk.XML.dependencies]{rk.XML.dependencies}},
#'    \href{help:rkwardplugins}{Introduction to Writing Plugins for RKWard}
#' @examples
#' about.node <- rk.XML.about(
#'   name="Square the circle",
#'   author=c(
#'     person(given="E.A.", family="Dölle",
#'       email="doelle@@eternalwondermaths.example.org", role="aut"),
#'     person(given="A.", family="Assistant",
#'       email="alterego@@eternalwondermaths.example.org", role=c("cre","ctb"))
#'     ),
#'   about=list(
#'     desc="Squares the circle using Heisenberg compensation.",
#'     version="0.1-3",
#'     date=Sys.Date(),
#'     url="http://eternalwondermaths.example.org/23/stc.html",
#'     license="GPL",
#'     category="Geometry")
#' )
#' 
#' cat(pasteXML(about.node, shine=2))


rk.XML.about <- function(name, author, about=list(desc="SHORT_DESCRIPTION", version="0.01-0", date=Sys.Date(), url="http://EXAMPLE.com", license="GPL (>= 3)", long.desc=NULL)){
  # sanity checks
  stopifnot(all(length(name), length(author)) > 0)
  if(is.null(about)){
    about <- list()
  } else {}
  if(!"desc" %in% names(about)){
    about[["desc"]] <- "SHORT_DESCRIPTION"
  } else {}
  if(!"version" %in% names(about)){
    about[["version"]] <- "0.01-0"
  } else {}
  if(!"date" %in% names(about)){
    about[["date"]] <- Sys.Date()
  } else if(is.character(about[["date"]])){
    # make shure date is a POSIXlt object
    about[["date"]] <- strptime(about[["date"]], format="%Y-%m-%d")
  } else {}
  if(!"url" %in% names(about)){
    about[["url"]] <- "http://EXAMPLE.com"
  } else {}
  if(!"license" %in% names(about)){
    about[["license"]] <- "GPL (>= 3)"
  } else {}
  if(!"long.desc" %in% names(about) | is.null(about[["long.desc"]])){
    about[["long.desc"]] <- about[["desc"]]
  } else {}

  ## author
  # - given
  # - family
  # - email
  # - role
  xml.authors <- unlist(sapply(author, function(this.author){
      stopifnot(all(c("given", "family") %in% names(unlist(this.author))))
      author.given  <- format(this.author, include="given")
      author.family <- format(this.author, include="family")
      if("email" %in% names(unlist(this.author))){
        author.email  <- format(this.author, include="email", braces=list(email=""))
      } else {
        author.email  <- NULL
      }
      author.role   <- format(this.author, include="role", braces=list(role=""), collapse=list(role=", "))
      # at least maintainers need an email address
      if("cre" %in% unlist(this.author) & is.null(author.email)){
        stop(simpleError(paste0("the maintainer ", author.given, " ", author.family, " needs an email address!")))
      } else {}
     
      result <- XMLNode("author",
        attrs=list(
          given=author.given,
          family=author.family,
          email=author.email,
          role=author.role
        ))
      return(result)
    }))

  ## about
  # - name
  # - desc="shortinfo",
  # - version
  # - date="releasedate",
  # - url
  # - license
  # - category
  # + authors
  # + dependencies
  if(is.null(xml.authors)){
    xml.authors <- list()
  } else {}
  xml.about <-  XMLNode("about",
    attrs=list(
      name=name,
      shortinfo=about[["desc"]],
      longinfo=about[["long.desc"]],
      version=about[["version"]],
      releasedate=format(about[["date"]], "%Y-%m-%d"),
      url=about[["url"]],
      license=about[["license"]],
      category=about[["category"]]
    ),
    .children=xml.authors)

  return(xml.about)
}
