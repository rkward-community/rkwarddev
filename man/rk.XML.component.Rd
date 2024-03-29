% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/rk.XML.component.R
\name{rk.XML.component}
\alias{rk.XML.component}
\title{Create XML "component" node for RKWard plugins}
\usage{
rk.XML.component(
  label,
  file,
  id.name = "auto",
  type = "standard",
  dependencies = NULL,
  i18n = NULL
)
}
\arguments{
\item{label}{Character string, a label for the component.}

\item{file}{Character string, file name of a plugin XML file defining the GUI.}

\item{id.name}{Character string, a unique ID for this plugin element.
If \code{"auto"}, an ID will be generated automatically from the label.}

\item{type}{Character string, type of component. As of now,
      only "standard" is supported. The option is
just implemented for completeness.}

\item{dependencies}{An object of class \code{XiMpLe.node} to define \code{<dependencies>} for this component.
See \code{\link[rkwarddev:rk.XML.dependencies]{rk.XML.dependencies}} for details. Skipped if \code{NULL}.}

\item{i18n}{Either a character string or a named list with the optional elements \code{context}
or \code{comment},
      to give some \code{i18n_context} information for this node. If set to \code{FALSE},
the attribute \code{label} will be renamed into \code{noi18n_label}.}
}
\value{
An object of class \code{XiMpLe.node}.
}
\description{
This function will create a component node for components sections of .pluginmap files.
}
\examples{
test.component <- rk.XML.component("My GUI dialog", "plugins/MyGUIdialog.xml")
}
\seealso{
\code{\link[rkwarddev:rk.XML.components]{rk.XML.components}},
   \code{\link[rkwarddev:rk.XML.dependencies]{rk.XML.dependencies}},
   and the \href{help:rkwardplugins}{Introduction to Writing Plugins for RKWard}
}
