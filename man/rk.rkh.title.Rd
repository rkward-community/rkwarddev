% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/rk.rkh.title.R
\name{rk.rkh.title}
\alias{rk.rkh.title}
\title{Create XML "title" node for RKWard help pages}
\usage{
rk.rkh.title(text = NULL, i18n = NULL)
}
\arguments{
\item{text}{Character string, the text to be displayed.}

\item{i18n}{Either a character string or a named list with the optional elements \code{context}
or \code{comment}, to give some \code{i18n_context} information for this node.}
}
\value{
An object of class \code{XiMpLe.node}.
}
\description{
Create XML "title" node for RKWard help pages
}
\examples{
plugin.title <- rk.rkh.title("Spice")
cat(pasteXML(plugin.title))
}
\seealso{
\code{\link[rkwarddev:rk.rkh.doc]{rk.rkh.doc}}
   and the \href{help:rkwardplugins}{Introduction to Writing Plugins for RKWard}
}
