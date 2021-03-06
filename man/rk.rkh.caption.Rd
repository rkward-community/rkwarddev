% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/rk.rkh.caption.R
\name{rk.rkh.caption}
\alias{rk.rkh.caption}
\title{Create XML "caption" node for RKWard help pages}
\usage{
rk.rkh.caption(id, title = NULL, i18n = NULL)
}
\arguments{
\item{id}{Either a character string (the \code{id} of the XML element to explain),
or an object of class \code{XiMpLe.node} (whose \code{id} will be extracted and used).}

\item{title}{Character string, title to be displayed. If \code{NULL}, the \code{label}
of the element will be shown.}

\item{i18n}{Either a character string or a named list with the optional elements \code{context}
or \code{comment}, to give some \code{i18n_context} information for this node.}
}
\value{
An object of class \code{XiMpLe.node}.
}
\description{
This function will create a caption node for settings sections in RKWard help files.
}
\examples{
# define a sample frame
test.dropdown <- rk.XML.dropdown("mydrop",
  options=list("First Option"=c(val="val1"),
  "Second Option"=c(val="val2", chk=TRUE)))
test.frame <- rk.XML.frame(test.dropdown, label="Some options")
# create the caption
test.caption <- rk.rkh.caption(test.frame)
cat(pasteXML(test.caption))
}
\seealso{
\code{\link[rkwarddev:rk.rkh.doc]{rk.rkh.doc}},
   \code{\link[rkwarddev:rk.rkh.settings]{rk.rkh.settings}}
   and the \href{help:rkwardplugins}{Introduction to Writing Plugins for RKWard}
}
