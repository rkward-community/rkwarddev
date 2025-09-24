# Copyright 2024 Meik Michalke <meik.michalke@hhu.de>
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


#' Create REUSE comment for RKWard plugin code
#'
#' Can be used to write a REUSE compliant comments to the document headers of generated files. For this, use
#' the resulting object in calls to \code{\link[rkwarddev:rk.JS.doc]{rk.JS.doc}}, \code{\link[rkwarddev:rk.XML.plugin]{rk.XML.plugin}},
#' \code{\link[rkwarddev:rk.XML.pluginmap]{rk.XML.pluginmap}}, \code{\link[rkwarddev:rk.rkh.doc]{rk.rkh.doc}}, or
#' \code{\link[rkwarddev:rk.plugin.skeleton]{rk.plugin.skeleton}}.
#'
#' Values of \code{author} and \code{contributor} should be provided in the format \code{Full Name <mail@example.org>}.
#'
#' @param author Character string in \code{Full Name <mail@example.org>} format, naming the author of the plugin.
#' @param contributor Character string in \code{Full Name <mail@example.org>} format, naming the contributor of the plugin.
#' @param project Character string, name of the project this plugin is a part of.
#' @param url Character string, URL to the project homepage.
#' @param license Character string, one if the available license strings.
#' @return An object of class \code{XiMpLe.node}.
#' @export
#' @examples
#' reuse_comment <- rk.comment.reuse(
#'     author = "Foo Bar <foo@example.com>"
#' )
#' cat(pasteXML(reuse_comment))

rk.comment.reuse <- function(
    author
  , contributor = "The RKWard Team <rkward-devel@kde.org>"
  , project = "RKWard"
  , url = "https://rkward.kde.org"
  , license = c(
      "GPL-2.0-or-later"
    , "BSD-3-Clause"
    , "LGPL-2.1-or-later"
    , "GFDL-1.2-no-invariants-or-later"
    , "CC0-1.0"
    , "MIT"
  )
){
  license <- match.arg(license)
  text <- paste0(
    "This file is part of the ", project, " project (", url, ").\n",
    "SPDX-FileCopyrightText: by ", author, "\n",
    "SPDX-FileContributor: ", contributor, "\n",
    "SPDX-License-Identifier: ", license, "\n"
  )
  return(XMLNode("!--", text))
}
