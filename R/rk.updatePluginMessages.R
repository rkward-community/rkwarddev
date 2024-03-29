# Copyright 2010-2022 Meik Michalke <meik.michalke@hhu.de>
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

#' Update plugin i18n messages
#'
#' A wrapper for calling \code{update_plugin_messages.py} to extract translatable
#' strings from a plugin or update/merge translations.
#' 
#' @note For details on the translating process, please refer to the chapter
#' \href{help:rkwardplugins/i18n.html}{Plugin translations}
#' of the  \emph{Introduction to Writing Plugins for RKWard}, especially
#' subsection \href{help:rkwardplugins/i18n_workflow.html}{Translation maintainance}.
#' 
#' @param pluginmap Character string, full path to the main pluginmap file of the plugin to translate.
#' @param extractOnly Logical, should translatable strings only be extracted? If \code{FALSE}, translatable
#'   strings will be updated and installed.
#' @param default_po Optional character string, fallback default name for \code{*.pot} file.
#' @param outdir Optional character string, change the output directory for generated files.
#' @param bug_reports Character string, URL to a bug tracker, mailing list or similar, where translation
#'   issues should be reported.
#' @seealso \href{help:rkwardplugins}{Introduction to Writing Plugins for RKWard}
#' @importFrom utils installed.packages
#' @export
#' @examples \dontrun{
#' rk.updatePluginMessages("~/myPlugins/lifeSaver/rkward/lifeSaver.pluginmap")
#' }

rk.updatePluginMessages <- function(pluginmap, extractOnly=FALSE, default_po=NULL, outdir=NULL,
  bug_reports="https://mail.kde.org/mailman/listinfo/kde-i18n-doc"){
  # --default_po=PO_ID -> rkward_${PO_ID}.pot
  # --outdir=DIR       -> pluginmap basedir
  rkdPatch <- installed.packages()["rkwarddev", "LibPath"]
  upmScript <- file.path(rkdPatch, "rkwarddev", "scripts", "update_plugin_messages.py")
  # make sure we're running python 3
  python <- Sys.which(c("python3", "python"))
  if(identical(base::.Platform[["OS.type"]], "unix")){
    python <- python[sapply(python, function(x){identical(system(paste0(x, " -c 'import sys; print(sys.version_info[0])'"), intern=TRUE), "3")})]
  } else {
    python <- python[sapply(python, function(x){identical(shell(paste0(x, " -c 'import sys; print(sys.version_info[0])'"), translate=TRUE, intern=TRUE), "3")})]
  }
  
  # check system setup
  if(!file.exists(upmScript)){
    stop(simpleError("Can't find 'update_plugin_messages.py' script!"))
  } else {}
  if(identical(python[[1]], "")){
    stop(simpleError("Can't find 'python' executable (version 3) in search path!"))
  } else {}
  if(identical(Sys.which("xgettext")[[1]], "")){
    stop(simpleError("Can't find 'xgettext' executable in search path!"))
  } else {}
  stopifnot(length(pluginmap) == 1 | !is.character(pluginmap))
  if(!file.exists(pluginmap)){
    stop(simpleError(paste0("Can't find pluginmap file:\n  ", pluginmap)))
  } else {}

  upmOptions <- ""
  if(isTRUE(extractOnly)){
    upmOptions <- " --extract-only"
  } else {}
  if(!is.null(default_po)){
    stopifnot(length(default_po) == 1 | !is.character(default_po))
    upmOptions <- paste0(upmOptions, " --default_po=\"", default_po, "\"")
  } else {}
  if(!is.null(outdir)){
    stopifnot(length(outdir) == 1 | !is.character(outdir))
    upmOptions <- paste0(upmOptions, " --outdir=\"", outdir, "\"")
  } else {}
  
  upmCall <- paste0(
    "export BUGADDR=\"", bug_reports, "\"; ",
    python[[1]], " ", upmScript, upmOptions, " \"", pluginmap, "\""
  )
  message(upmCall)
  if(identical(base::.Platform[["OS.type"]], "unix")){
    system(upmCall, intern=TRUE)
  } else {
    shell(upmCall, translate=TRUE, intern=TRUE)
  }

  return(invisible(NULL))
}
