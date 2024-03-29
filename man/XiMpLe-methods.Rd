% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/01_methods_01_plugin2script.R
\docType{methods}
\name{plugin2script}
\alias{plugin2script}
\alias{plugin2script,XiMpLe.doc-method}
\alias{plugin2script,XiMpLe.node-method}
\alias{plugin2script,character-method}
\alias{plugin2script,connection-method}
\title{Generate script code from XML objects}
\usage{
plugin2script(
  obj,
  prefix = "",
  indent = TRUE,
  level = 1,
  drop.defaults = TRUE,
  node.names = FALSE,
  collapse = ".",
  update = NULL
)

\S4method{plugin2script}{XiMpLe.doc}(
  obj,
  prefix = "",
  indent = TRUE,
  level = 1,
  drop.defaults = TRUE,
  node.names = FALSE,
  collapse = ".",
  update = NULL
)

\S4method{plugin2script}{XiMpLe.node}(
  obj,
  prefix = "",
  indent = TRUE,
  level = 1,
  drop.defaults = TRUE,
  node.names = FALSE,
  collapse = ".",
  update = NULL
)

\S4method{plugin2script}{character}(
  obj,
  prefix = "",
  indent = TRUE,
  level = 1,
  drop.defaults = TRUE,
  node.names = FALSE,
  collapse = ".",
  update = NULL
)

\S4method{plugin2script}{connection}(
  obj,
  prefix = "",
  indent = TRUE,
  level = 1,
  drop.defaults = TRUE,
  node.names = FALSE,
  collapse = ".",
  update = NULL
)
}
\arguments{
\item{obj}{Either a character vector (path to a plugin XML file to parse), a connection,
      an already
parsed XML tree (class \code{XiMpLe.doc}) or a single \code{XiMpLe.node} object.}

\item{prefix}{Character string,
      used as the prefix for the object names used in the script. Set to \code{""}
to disable the prefix.}

\item{indent}{Logical, whether the script code should be indented properly.}

\item{level}{Integer number, the starting leven of indentation.}

\item{drop.defaults}{Logical,
      whether to check for the default options in function calls. If the
parsed and translated XML code resulted in default options,
      they are omitted in the resulting script.}

\item{node.names}{Logical,
      whether the node names should become part of the generated R object names.}

\item{collapse}{Character string,
      used to collapse the parts of the generated R object names.}

\item{update}{A named list, previous result of a \code{plugin2script} call to be updated,
      e.\,.g., to add
the content of a help file to a previously scanned XML file.}
}
\value{
Either a character vector (if \code{obj} is a single XML node)
   or a list of character vectors named \code{"logic"}, \code{"dialog"}, \code{"wizard"},
   \code{"summary"}, \code{"usage"}, \code{"settings"}, \code{"related"},
      \code{"technical"},
   \code{"dependencies"}, \code{"dependency_check"}, \code{"about"}, \code{"require"},
   \code{"components"}, and \code{"hierarchy"} (if \code{obj} is a full XML document).
}
\description{
These methods try to translate plugin XML objects into \code{rkwarddev} function calls.
}
\details{
They are intended to make it easier to translate previously manually maintained plugin code
into \code{rkwarddev} scripts. The generated output should not be used as-is,
      but restructured
properly into a useful script.

You can either use a full XML document (read with \code{\link[XiMpLe:parseXMLTree]{parseXMLTree}})
or single (also nested) XiMpLe XML nodes. If you provide a character string,
      it is assumed to be
the full path to a document to be parsed with \code{parseXMLTree} and then analysed. Connections
are also accepted.
}
\note{
The methods might fail, especially with highly complex plugins. Try to break these
into sensible chunks and try those speparately. Sometimes,
      slightly changing the input file
might also do the trick to get some usable results.
}
\examples{
\dontrun{
# full XML documents
rkwarddevScript <- plugin2script("~/RKWardPlugins/plugins/myPlugin.xml")
rkwarddevScript <- plugin2script("~/RKWardPlugins/plugins/myPlugin.rkh",
      update=rkwarddevScript)
rkwarddevScript <- plugin2script("~/RKWardPlugins/myPlugin.pluginmap",
      update=rkwarddevScript)
sapply(rkwarddevScript, cat)
}

# single XML node
(test.checkboxes <- rk.XML.row(
  rk.XML.col(
    list(
      rk.XML.cbox(label="foo", value="foo1", chk=TRUE),
      rk.XML.cbox(label="bar", value="bar2")
    )
  )
))
rkwarddevScript <- plugin2script(test.checkboxes)
# see the generated script code
cat(rkwarddevScript)

# we can evaluate the generated code to check whether original
# XML and the newly generated one are identical
eval(parse(text=rkwarddevScript))
identical(row_clmndc1212, test.checkboxes)
}
