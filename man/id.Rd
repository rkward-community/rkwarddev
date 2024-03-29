% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/id.R
\name{id}
\alias{id}
\title{Replace XiMpLe.node objects with their ID value}
\usage{
id(
  ...,
  quote = FALSE,
  collapse = "",
  js = TRUE,
  guess.modifier = TRUE,
  .objects = list(...)
)
}
\arguments{
\item{...}{One or several character strings and/or \code{XiMpLe.node} objects with plugin nodes,
and/or objects of classes \code{rk.JS.arr}, \code{rk.JS.opt} or \code{rk.JS.var},
      simply separated by comma.}

\item{quote}{Logical, if the character strings should be deparsed,
      so they come out "as-is" when
written to files, e.g. by \code{cat}.}

\item{collapse}{Character string,
      defining if and how the individual elements should be glued together.}

\item{js}{Logical,
      if \code{TRUE} returns JavaScript varaible names for \code{XiMpLe.node} objects.
Otherwise their actual ID is returned.}

\item{guess.modifier}{Logical,
      if \code{TRUE} will append the \code{"checked"} modifier to \code{<frame>} nodes,
but only if \code{js=TRUE} as well.}

\item{.objects}{Alternative way of specifying objects,
      if you already have them as a list.}
}
\value{
A character string.
}
\description{
This function is intended to be used for generating JavaScript code for
RKWard plugins. Its sole purpose is to replace objects of class \code{XiMpLe.node}
which hold an XML node of some plugin GUI definition,
      and objects of classes \code{rk.JS.arr},
\code{rk.JS.opt} or \code{rk.JS.var} with their ID (or JS variable name),
      and combine these
replacements with character strings.
}
\examples{
# an example checkbox XML node
cbox1 <- rk.XML.cbox(label="foo", value="foo1", id.name="CheckboxFoo.ID")
id("The variable name is: ", cbox1, "!")
}
\seealso{
\code{\link[rkwarddev:rk.JS.vars]{rk.JS.vars}},
   \code{\link[rkwarddev:rk.JS.array]{rk.JS.array}},
   \code{\link[rkwarddev:rk.JS.options]{rk.JS.options}},
   \code{\link[rkwarddev:echo]{echo}},
   \code{\link[rkwarddev:qp]{qp}} (a shortcut for \code{id} with different defaults),
   and the \href{help:rkwardplugins}{Introduction to Writing Plugins for RKWard}
}
