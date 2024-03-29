% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/rk.XML.about.R
\name{rk.XML.about}
\alias{rk.XML.about}
\title{Create XML node "about" for RKWard pluginmaps}
\usage{
rk.XML.about(
  name,
  author,
  about = list(desc = "SHORT_DESCRIPTION", version = "0.01-0", date = Sys.Date(), url =
    "http://EXAMPLE.com", license = "GPL (>= 3)", long.desc = NULL)
)
}
\arguments{
\item{name}{A character string with the plugin name.}

\item{author}{A vector of objects of class \code{person} with these elements (mandatory):
\describe{
  \item{given}{Author given name}
  \item{family}{Author family name}
  \item{email}{Author mail address (can be omitted if \code{role} does not include \code{"cre"})}
  \item{role}{This person's specific role, e.g. \code{"aut"} for actual author,
      \code{"cre"} for maintainer or \code{"ctb"} for contributor.}
}
See \code{\link[utils:person]{person}} for more details on this,
      especially for valid roles.}

\item{about}{A named list with these elements:
\describe{
  \item{desc}{A short description (mandatory)}
  \item{version}{Plugin version (mandatory)}
  \item{date}{Release date (mandatory); either a \code{POSIXlt} object,
      or character string in "\%Y-\%m-\%d" format}
  \item{url}{URL for the plugin (optional)}
  \item{license}{License the plugin is distributed under (mandatory)}
  \item{category}{A category for this plugin (optional)}
  \item{long.desc}{A long description (optional, defaults to \code{desc})}
}}
}
\description{
Create XML node "about" for RKWard pluginmaps
}
\examples{
about.node <- rk.XML.about(
  name="Square the circle",
  author=c(
    person(given="E.A.", family="Dölle",
      email="doelle@eternalwondermaths.example.org", role="aut"),
    person(given="A.", family="Assistant",
      email="alterego@eternalwondermaths.example.org", role=c("cre","ctb"))
    ),
  about=list(
    desc="Squares the circle using Heisenberg compensation.",
    version="0.1-3",
    date=Sys.Date(),
    url="http://eternalwondermaths.example.org/23/stc.html",
    license="GPL",
    category="Geometry")
)

cat(pasteXML(about.node, shine=2))
}
\seealso{
\code{\link[rkwarddev:rk.XML.dependencies]{rk.XML.dependencies}},
   \href{help:rkwardplugins}{Introduction to Writing Plugins for RKWard}
}
