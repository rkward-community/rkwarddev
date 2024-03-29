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


#' Generate skeletons for RKWard plugins
#' 
#' With this function you can write everything from a basic skeleton structure to a complete functional plugin, including several
#' components/dialogs. You should always define one main component (by \code{xml}, \code{js}, \code{rkh} etc.) before you provide
#' additional features by \code{components}.
#'
#' @param about Either an object of class \code{XiMpLe.node} with descriptive information on the plugin and its authors
#'    (see \code{link[XiMpLe:rk.XML.about]{rk.XML.about}} for details), or a character string with the name of the plugin package.
#'    If the latter, no \code{DESCRIPTION} file will be created.
#' @param path Character sting, path to the main directory where the skeleton should be created.
#' @param provides Character vector with possible entries of \code{"logic"}, \code{"dialog"} or \code{"wizard"}, defining what
#'    sections the GUI XML file should provide even if \code{dialog}, \code{wizard} and \code{logic} are \code{NULL}.
#'    These sections must be edited manually and some parts are therefore commented out.
#' @param scan A character vector to trigger various automatic scans of the generated GUI XML file. Valid enties are:
#'    \describe{
#'      \item{\code{"var"}}{Calls \code{\link{rk.JS.scan}} to define all needed variables in the \code{calculate()} function
#'        of the JavaScript file. These variables will be added to variables defined by the \code{js} option, if any (see below).}
#'      \item{\code{"saveobj"}}{Calls \code{\link{rk.JS.saveobj}} to generate code to save R results in the \code{printout()}
#'        function of the JavaScript file. This code will be added to the code defined by the \code{js} option, if any (see below).}
#'      \item{\code{"settings"}}{Calls \code{\link{rk.rkh.scan}} to generate \code{<setting>} sections for each relevant GUI element in
#'        the \code{<settings>} section of the help file. This option will be overruled if you provide that section manually
#'        by the \code{rkh} option (see below).}
#'      \item{\code{"preview"}}{Calls \code{\link{rk.JS.scan}} to search for \code{<preview>} nodes in the XML code.
#'        An according \code{preview()} function will be added to the JS code if needed. Will be overwritten by a
#'        preview function that was defined by the \code{js} option.}
#'    }
#' @param unused.vars Logical, if \code{TRUE} all variables found by \code{scan} are being defined, even if they are not used in the
#'    JavaScript code. By default only matching variables will be kept. This option should only be used for debugging.
#' @param guess.getter Logical, if \code{TRUE} try to get a good default getter function for JavaScript
#'    variable values (if \code{scan} is active). This will use some functions which were added with RKWard 0.6.1, and therefore
#'    raise the dependencies for your plugin/component accordingly. Nonetheless, it's recommended.
#' @param xml A named list of options to be forwarded to \code{\link[rkwarddev:rk.XML.plugin]{rk.XML.plugin}}, to generate the GUI XML file.
#'    Not all options are supported because some don't make sense in this context. Valid options are:
#'    \code{"dialog"}, \code{"wizard"}, \code{"logic"} and \code{"snippets"}.
#'    If not set, their default values are used. See \code{\link[rkwarddev:rk.XML.plugin]{rk.XML.plugin}} for details.
#' @param js A named list of options to be forwarded to \code{\link[rkwarddev:rk.JS.doc]{rk.JS.doc}}, to generate the JavaScript file.
#'    Not all options are supported because some don't make sense in this context. Valid options are:
#'    \code{"require"}, \code{"results.header"}, \code{"header.add"}, \code{"variables"}, \code{"globals"}, \code{"preprocess"},
#'    \code{"calculate"}, \code{"printout"}, \code{"doPrintout"}, \code{"preview"} and \code{"load.silencer"}.
#'    If not set, their default values are used. See \code{\link[rkwarddev:rk.JS.doc]{rk.JS.doc}} for details.
#' @param pluginmap A named list of options to be forwarded to \code{\link[rkwarddev:rk.XML.pluginmap]{rk.XML.pluginmap}}, to generate the pluginmap file.
#'    Not all options are supported because some don't make sense in this context. Valid options are:
#'    \code{"name"}, \code{"namespace"} (see also \code{internal}), \code{"hierarchy"} and \code{"require"}.
#'    If not set, their default values are used. See \code{\link[rkwarddev:rk.XML.pluginmap]{rk.XML.pluginmap}} for details.
#' @param rkh A named list of options to be forwarded to \code{\link[rkwarddev:rk.rkh.doc]{rk.rkh.doc}}, to generate the help file.
#'    Not all options are supported because some don't make sense in this context. Valid options are:
#'    \code{"summary"}, \code{"usage"}, \code{"sections"}, \code{"settings"}, \code{"related"} and \code{"technical"}.
#'    If not set, their default values are used. See \code{\link[rkwarddev:rk.rkh.doc]{rk.rkh.doc}} for details.
#' @param overwrite Logical, whether existing files should be replaced. Defaults to \code{FALSE}.
#' @param tests Logical, whether directories and files for plugin tests should be created.
#'    Defaults to \code{TRUE}. A new testsuite file will only be generated if none is present
#'    (\code{overwrite} is ignored).
#' @param lazyLoad Logical, whether the package should be prepared for lazy loading or not. Should be left \code{TRUE},
#'    unless you have very good reasons not to.
#' @param create A character vector with one or more of these possible entries:
#'    \describe{
#'      \item{\code{"pmap"}}{Create the \code{.pluginmap} file.}
#'      \item{\code{"xml"}}{Create the plugin \code{.xml} XML file skeleton.}
#'      \item{\code{"js"}}{Create the plugin \code{.js} JavaScript file skeleton.}
#'      \item{\code{"rkh"}}{Create the plugin \code{.rkh} help file skeleton.}
#'      \item{\code{"desc"}}{Create the \code{DESCRIPTION} file.}
#'      \item{\code{"clog"}}{Create the \code{ChangeLog} file (only if none exists).}
#'    }
#'    Default is to create all of these files. Existing files will only be overwritten if \code{overwrite=TRUE}.
#' @param suggest.required Logical, if \code{TRUE} R package dependencies in \code{about} will be added to the \code{Suggests:}
#'    field of the \code{DESCRIPTION} file, otherwise to the \code{Depends:} field.
#' @param components A list of plugin components. See \code{\link[rkwarddev:rk.XML.component]{rk.XML.component}} for details.
#' @param dependencies An object of class \code{XiMpLe.node} to be pasted as the \code{<dependencies>} section,
#'    See \code{\link[rkwarddev:rk.XML.dependencies]{rk.XML.dependencies}} for details. Skipped if \code{NULL}.
#' @param edit Logical, if \code{TRUE} RKWard will automatically open the created files for editing, by calling \code{rk.show.files}.
#'    This applies to all files defined in \code{create}.
#' @param load Logical, if \code{TRUE} and \code{"pmap"} in \code{create}, RKWard will automatically add the created .pluginmap file
#'    to its menu structure by calling \code{rk.load.pluginmaps}. You can then try the plugin immediately.
#' @param show Logical, if \code{TRUE} and \code{"pmap"} in \code{create}, RKWard will automatically call the created plugin after
#'    it was loaded (i.e., this implies and also sets \code{load=TRUE}). This will only work on the main component, though.
#' @param gen.info Logical, if \code{TRUE} comment notes will be written into the genrated documents,
#'    that they were generated by \code{rkwarddev} and changes should be done to the script.
#'    You can also provide a character string naming the very rkwarddev script file that generates this plugin and its main component,
#'    which will then also be added to the comment.
#' @param hints Logical, if \code{TRUE} and you leave out optional entries (like \code{dependencies=NULL}), dummy sections will be added as comments.
#' @param indent.by A character string defining the indentation string to use.
#' @param internal Logical, a simple switch to build an internal plugin for official distribution with RKWard. If set to \code{TRUE}:
#'    \itemize{
#'      \item{The plugin will have its namespace set to \code{"rkward"}.}
#'      \item{The \code{<about>} info will also be available in the main component.}
#'      \item{\code{require.defaults} of \code{\link[rkwarddev:rk.XML.pluginmap]{rk.XML.pluginmap}} will be set to \code{FALSE}.}
#'      \item{No \code{DESCRIPTION} or \code{NAMESPACE} file will be written.}
#'    } 
#' @return Character string with the path to the plugin root directory.
#' @seealso \href{help:rkwardplugins}{Introduction to Writing Plugins for RKWard}
#' @importFrom utils file_test
#' @importFrom rkward rk.show.files rk.load.pluginmaps rk.call.plugin 
#' @export
#' @examples
#' \dontrun{
#' # a simple example with only basic information
#' about.info <- rk.XML.about(
#'   name="Square the circle",
#'   author=c(
#'     person(given="E.A.", family="Dölle",
#'       email="doelle@@eternalwondermaths.example.org", role="aut"),
#'     person(given="A.", family="Assistant",
#'       email="alterego@@eternalwondermaths.example.org", role=c("cre","ctb"))
#'     ))
#' 
#' rk.plugin.skeleton(about.info)
#' 
#' # a more complex example, already including some dialog elements
#' about.info <- rk.XML.about(
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
#'     category="Geometry"),
#'   dependencies=list(
#'     rkward.min="0.5.3",
#'     rkward.max="",
#'     R.min="2.10",
#'     R.max=""),
#'   package=list(
#'     c(name="heisenberg", min="0.11-2", max="",
#'       repository="http://rforge.r-project.org"),
#'     c(name="DreamsOfPi", min="0.2", max="", repository="")),
#'   pluginmap=list(
#'     c(name="heisenberg.pluginmap", url="http://eternalwondermaths.example.org/hsb"))
#' )
#'
#' test.dropdown <- rk.XML.dropdown("mydrop",
#'   opts=list("First Option"=c(val="val1"),
#'   "Second Option"=c(val="val2", chk=TRUE)))
#' test.checkboxes <- rk.XML.row(rk.XML.col(
#'   list(test.dropdown,
#'     rk.XML.cbox(label="foo", val="foo1", chk=TRUE),
#'     rk.XML.cbox(label="bar", val="bar2"))
#'   ))
#' test.vars <- rk.XML.vars("select some vars", "vars go here")
#' test.tabbook <- rk.XML.dialog(rk.XML.tabbook("My Tabbook", tab.labels=c("First Tab",
#'   "Second Tab"), children=list(test.checkboxes, test.vars)))
#' 
#' rk.plugin.skeleton(about.info, xml=list(dialog=test.tabbook),
#'   overwrite=TRUE)
#' }

rk.plugin.skeleton <- function(about, path=tempdir(),
  provides=c("logic", "dialog"),
  scan=c("var", "saveobj", "settings", "preview"), unused.vars=FALSE, guess.getter=FALSE,
  xml=list(), js=list(), pluginmap=list(), rkh=list(),
  overwrite=FALSE, tests=TRUE, lazyLoad=TRUE,
  create=c("pmap", "xml", "js", "rkh", "desc", "clog"), suggest.required=TRUE,
  components=list(), dependencies=NULL, edit=FALSE, load=FALSE, show=FALSE, gen.info=TRUE,
  hints=TRUE, indent.by=rk.get.indent(), internal=FALSE){

  if(is.XiMpLe.node(about)){
    # check about and dependencies
    # result is a named list with "about" and "dependencies"
    about.dep.list <- dependenciesCompatWrapper(dependencies=dependencies, about=about, hints=hints)
    dependencies.node <- about.dep.list[["dependencies"]]
    about.node <- about.dep.list[["about"]]
    # fetch the plugin name
    name <- XMLAttrs(about.node)[["name"]]
  } else if(is.character(about) & length(about) == 1) {
    name <- about
    about.node <- NULL
    dependencies.node <- dependenciesCompatWrapper(dependencies=dependencies,
      about=NULL, hints=hints)[["dependencies"]]
    # also stop creation of DESCRIPTION and ChangeLog files
    create <- create[!create %in% c("desc", "clog")]
  } else {
    stop(simpleError("'about' must be a character string or XiMpLe.node, see ?rk.XML.about()!"))
  }
  # internal plugins don't need their own DESCRIPTION file
  if(isTRUE(internal)){
    create <- create[!create %in% "desc"]
  } else {}

  # to besure, remove all non-character symbols from name
  name.orig <- name
  name <- clean.name(name)

  # define paths an file names
  main.dir <- file.path(path, name)
  R.dir <- file.path(main.dir, "R")
  description.file <- file.path(main.dir, "DESCRIPTION")
  namespace.file <- file.path(main.dir, "NAMESPACE")
  changelog.file <- file.path(main.dir, "ChangeLog")
  rkward.dir <- file.path(main.dir, "inst", "rkward")
  plugin.dir <- file.path(rkward.dir, "plugins")
  # file names with paths
  toplevel.fname.pluginmap <- paste0(name, ".pluginmap")
  plugin.fname.pluginmap <- paste0(name, ".pluginmap")
  plugin.pluginmap <- file.path(rkward.dir, toplevel.fname.pluginmap)
  tests.main.dir <- file.path(rkward.dir, "tests")
  tests.dir <- file.path(rkward.dir, "tests", name)
  testsuite.file <- file.path(tests.main.dir, "testsuite.R")

  # check if we can access the given root directory
  # create it, if necessary
  if(!file_test("-d", main.dir)){
    stopifnot(dir.create(main.dir, recursive=TRUE))
    message(paste0("Created directory ", main.dir, "."))
  } else {}

  # create empty R directory, e.g. for smooth roxyPackage runs
  if(!file_test("-d", R.dir)){
    stopifnot(dir.create(R.dir, recursive=TRUE))
    message(paste0("Created directory ", R.dir, "."))
  } else {}

  # create directory structure
  if(!file_test("-d", plugin.dir)){
    stopifnot(dir.create(plugin.dir, recursive=TRUE))
    message(paste0("Created directory ", plugin.dir, "."))
  } else {}
  if(isTRUE(tests) & !file_test("-d", tests.dir)){
    stopifnot(dir.create(tests.dir, recursive=TRUE))
    message(paste0("Created directory ", tests.dir, "."))
  } else {}

  ## create the main component
  got.pm.options <- names(pluginmap)
  # check for name of main component. if it's set, use it
  if(!"name" %in% got.pm.options){
    pluginmap[["name"]] <- name.orig
  } else {}
  if(!"hierarchy" %in% got.pm.options) {
    pluginmap[["hierarchy"]] <- eval(formals(rk.XML.pluginmap)[["hierarchy"]])
  } else {}
  if(isTRUE(internal)){
    main.comp.about <- about
    # make sure the main component is named after the pluginmap entry
    XMLAttrs(main.comp.about)[["name"]] <- pluginmap[["name"]]
  } else {
    main.comp.about <- pluginmap[["name"]]
  }
  main.component <- rk.plugin.component(
    about=main.comp.about,
    xml=xml,
    js=js,
    rkh=rkh,
    provides=provides,
    scan=scan,
    unused.vars=unused.vars,
    guess.getter=guess.getter,
    hierarchy=pluginmap[["hierarchy"]],
    create=create[create %in% c("xml", "js", "rkh")],
    gen.info=gen.info,
    indent.by=indent.by)
  components[[length(components)+1]] <- main.component

  # check for components
  sapply(components, function(this.comp){
    if(!inherits(this.comp, "rk.plug.comp")){
      warning("An element of list 'components' was not of class rk.plug.comp and ignored!", call.=FALSE)
    } else {
      comp.name <- clean.name(slot(this.comp, "name"))
      create <- slot(this.comp, "create")
      XML.plugin <- slot(this.comp, "xml")
      JS.code <- slot(this.comp, "js")
      rkh.doc <- slot(this.comp, "rkh")

      # the basic file names
      plugin.fname.xml <- paste0(comp.name, ".xml")
      plugin.fname.js <- paste0(comp.name, ".js")
      plugin.fname.rkh <- paste0(comp.name, ".rkh")
      # file names with paths
      plugin.xml <- file.path(plugin.dir, plugin.fname.xml)
      plugin.js <- file.path(plugin.dir, plugin.fname.js)
      plugin.rkh <- file.path(plugin.dir, plugin.fname.rkh)

      ## create plugin.xml
      if("xml" %in% create){
        if(isTRUE(checkCreateFiles(plugin.xml, ow=overwrite, action="xml"))){
          cat(pasteXML(XML.plugin, shine=1, indent.by=indent.by), file=plugin.xml)
        } else {}
        if(isTRUE(edit)){
          rk.show.files(plugin.xml, header=plugin.fname.xml, prompt=FALSE)
        } else {}
      } else {}

      ## create plugin.js
      if("js" %in% create){
        if(isTRUE(checkCreateFiles(plugin.js, ow=overwrite, action="js"))){
          cat(JS.code, file=plugin.js)
        } else {}
        if(isTRUE(edit)){
          rk.show.files(plugin.js, header=plugin.fname.js, prompt=FALSE)
        } else {}
      } else {}

      ## create plugin.rkh
      if("rkh" %in% create){
        if(isTRUE(checkCreateFiles(plugin.rkh, ow=overwrite, action="rkh"))){
          cat(pasteXML(rkh.doc, shine=1, indent.by=indent.by), file=plugin.rkh)
        } else {}
        if(isTRUE(edit)){
          rk.show.files(plugin.rkh, header=plugin.fname.rkh, prompt=FALSE)
        } else {}
      } else {}
    }
  })

  ## create plugin.pluginmap
  if("pmap" %in% create){
    if(isTRUE(checkCreateFiles(plugin.pluginmap, ow=overwrite, action="pmap"))){
      if(!"require" %in% got.pm.options) {
        pluginmap[["require"]] <- eval(formals(rk.XML.pluginmap)[["require"]])
      } else {}
      if(!"name" %in% got.pm.options){
        pluginmap[["name"]] <- name.orig
      } else {}
      # needed for "show" later
      pm.id.name <- gsub("[^[:alnum:]_]*", "", pluginmap[["name"]])
      if(isTRUE(internal)){
        pluginmap[["namespace"]] <- "rkward"
      } else {
        if(!"namespace" %in% got.pm.options){
          pluginmap[["namespace"]] <- pm.id.name
        } else {}
      }
      # get components and hierarchy info from the components list
      all.components <- sapply(components, function(this.comp){
          comp.name <- slot(this.comp, "name")
          named.compo <- paste0("plugins/", clean.name(comp.name), ".xml")
          # we'll name the component, to nicen the menu entry
          names(named.compo) <- comp.name
          return(named.compo)
        })
      all.hierarchies <- lapply(components, function(this.comp){
          comp.hier <- slot(this.comp, "hierarchy")
          return(comp.hier)
        })

      XML.pluginmap <- rk.XML.pluginmap(
        name=pluginmap[["name"]],
        about=about.node,
        components=all.components,
        hierarchy=all.hierarchies,
        require=pluginmap[["require"]],
        hints=hints,
        gen.info=gen.info,
        dependencies=dependencies.node,
        namespace=pluginmap[["namespace"]],
#        id.name=paste(gsub("[.]*|[[:space:]]*", "", pluginmap[["name"]]), "rkward", sep="_"))
        id.name=paste(pm.id.name, "rkward", sep="_"),
        require.defaults=!isTRUE(internal))
      cat(pasteXML(XML.pluginmap, shine=2, indent.by=indent.by), file=plugin.pluginmap)
    } else {
      pm.id.name <- name
    }

    if(isTRUE(edit)){
      rk.show.files(plugin.pluginmap, header=plugin.fname.pluginmap, prompt=FALSE)
    } else {}
    if(isTRUE(load) | isTRUE(show)){
      rk.load.pluginmaps(plugin.pluginmap)
      if(isTRUE(show)){
        # call the plugin; reconstructed the ID generation from rk.XML.pluginmap()
        plugin.ID <- auto.ids(paste0(pm.id.name, pm.id.name), prefix=ID.prefix("component"), chars=25)
        rk.call.plugin(paste0(pluginmap[["namespace"]], "::", plugin.ID))
      } else {}
    } else {}
  } else {}
  

  ## create testsuite.R
  if(isTRUE(tests)){
    if(isTRUE(checkCreateFiles(testsuite.file, ow=FALSE, action="tests"))){
      testsuite.doc <- rk.testsuite.doc(name=name)
      cat(testsuite.doc, file=testsuite.file)
    } else {}
  } else {}

  ## create DESCRIPTION file
  if("desc" %in% create){
    if(isTRUE(checkCreateFiles(description.file, ow=overwrite, action="desc"))){
      # R replaces the @ with a dot, so we need to rename it as a workaround
      authors.person <- data.frame(AuthorsR=paste0("c(", XML2person(about.node), ")"), stringsAsFactors=FALSE)
      colnames(authors.person)[1] <- "Authors@R"
      authors <- get.authors(authors.person, maintainer=TRUE, contributor=TRUE)
      all.authors <- authors[["aut"]]
      all.maintainers <- authors[["cre"]]

## TODO: check and add the commented values here:
      desc <- data.frame(
        Package=name,
        Type="Package",
        Title=XMLAttrs(about.node)[["shortinfo"]],
        Version=XMLAttrs(about.node)[["version"]],
        Date=XMLAttrs(about.node)[["releasedate"]],
        Author=paste(all.authors, collapse=", "),
        AuthorsR=XML2person(about.node, eval=FALSE),
        Maintainer=paste(all.maintainers, collapse=", "),
        Depends=XML2dependencies(dependencies.node, suggest=suggest.required, mode="depends"),
        Suggests=XML2dependencies(dependencies.node, suggest=suggest.required, mode="suggest"),
        Enhances="rkward",
        Description=XMLAttrs(about.node)[["longinfo"]],
        License=XMLAttrs(about.node)[["license"]],
        Encoding="UTF-8",
        LazyLoad=ifelse(isTRUE(lazyLoad), "yes", "no"),
        URL=XMLAttrs(about.node)[["url"]],
#        # R 2.14 seems to add "Namespace: auto", which invalidates source packages for R < 2.14
#        Namespace=name,
        stringsAsFactors=FALSE)

      for(this.entry in c("Depends","Suggests")){
        if(desc[[this.entry]] == ""){
          desc[[this.entry]] <- NULL
        } else {}
      }

      # i have no clue how to circumvent this workaround:
      desc$`Authors@R` <- desc[["AuthorsR"]]
      # satisfy NOTE from R CMD check
      AuthorsR <- NULL
      desc <- subset(desc, select=-AuthorsR)

      write.dcf(desc, file=description.file)
    } else {}
    if(isTRUE(edit)){
      rk.show.files(description.file, header="DESCRIPTION", prompt=FALSE)
    } else {}
    # create empty NAMESPACE file for R 2.14 compatibility
    if(!file_test("-f", namespace.file)){
      cat("", file=namespace.file)
      message(paste0("Created empty file ", namespace.file, " for R 2.14 compatibility."))
    } else {}
  } else {}

  ## create ChangeLog file (if none exists)
  if("clog" %in% create){
    if(isTRUE(checkCreateFiles(changelog.file, ow=FALSE, action="clog"))){
      changelog.text <- paste0("ChangeLog for package ", name,
        "\n\nChanges in version ", slot(about.node, "attributes")[["version"]],
        " (", slot(about.node, "attributes")[["releasedate"]],")",
        "\nChanges:\n  - initial package build\nAdded:\n  - added a ChangeLog file\nFixed:\n  - ...\n")
      cat(changelog.text, file=changelog.file)
    } else {}
    if(isTRUE(edit)){
      rk.show.files(changelog.file, header="ChangeLog", prompt=FALSE)
    } else {}
  } else {}

  return(main.dir)
}
