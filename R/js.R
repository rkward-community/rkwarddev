# Copyright 2010-2015 Meik Michalke <meik.michalke@hhu.de>
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


#' R to JavaScript translation
#' 
#' This function is a wrapper for \code{\link[rkwarddev:id]{id}} similar to \code{\link[rkwarddev:qp]{qp}}
#' that uses \code{eval(substitute(alist(...)))} to preserve the value of \code{...} as-is to be able to
#' both keep operators like \code{">="} or \code{"!="} unevaluated in the resulting output, as well as translating
#' \code{if/else} clauses from R to JavaScript.
#' 
#' Normally, \code{id} would simply evaluate the condition and then return the result of that evaluation, which
#' most of the time is not what you want. With this function, you can test conditions in usual R syntax, yet
#' the operators and \code{if/else} clauses will end up pasted in the result.
#' 
#' The following operators are supported: +, -, *, /, ==, !=, >, <, >=, <=, || and &&
#' 
#' These are currently unsupported and still need to be quoted: \%, ++, --, =, +=, -=, *=, /=, \%=, === and !==
#' 
#' @section Previews: The current approach to toggle code parts for previews on and off is to query the value of
#'    the JavaScript variable \code{is_preview}. Only if it is false or unset the code is executed. You can construct
#'    code working this way by nesting it inside \code{js(if("!is_preview"){<your code>})}. Note that you must not
#'    place the exclamation mark before the quotes, but inside.
#'
#' @note You should nest your plugin script inside \code{\link[rkwarddev:rk.local]{rk.local}} if you're
#'    making use of js(), to be sure it can find all defined objects.
#'
#' @param ... One or several character strings and/or \code{XiMpLe.node} objects with plugin nodes,
#'   and/or objects of classes \code{rk.JS.arr} or \code{rk.JS.opt}, simply separated by comma.
#'   JavaScript operators and \code{if} conditions will be kept as-is.
#' @param level Integer value, first indetation level.
#' @param indent.by A character string defining the indentation string to use.
#' @param linebreaks Logical, should there be line breaks between the elements in this call?
#' @param empty.e For \code{if} conditions only: Logical, if \code{TRUE} will force to add empty \code{else \{\}} brackets when
#'    there is no \code{else} statement defined, which is considered to enhance code readability by some.
#' @param keep.ite Logical, if \code{TRUE} returns \code{if/else} conditions in a list of objects of class \code{rk.JS.ite} instead
#'    of a pasted character string. Comes in handy if used inside \code{\link[rkwarddev:rk.JS.options]{rk.JS.options}}.
#' @return A character string (or \code{rk.JS.ite}, if \code{keep.ite=TRUE} and input is an \code{if/else} condition).
#' @export
#' @seealso \code{\link[rkwarddev:rk.local]{rk.local}},
#'    \code{\link[rkwarddev:rk.JS.vars]{rk.JS.vars}},
#'    \code{\link[rkwarddev:rk.JS.array]{rk.JS.array}},
#'    \code{\link[rkwarddev:rk.JS.options]{rk.JS.options}},
#'    \code{\link[rkwarddev:echo]{echo}},
#'    \code{\link[rkwarddev:id]{id}},
#'    and the \href{help:rkwardplugins}{Introduction to Writing Plugins for RKWard}
#' @examples
#' # an example checkbox XML node
#' cbox1 <- rk.XML.cbox(label="foo", value="foo1", id.name="CheckboxFoo.ID")
#' cat(rk.paste.JS(js(
#'   if(cbox1 == "foo1") {
#'     echo("gotcha!")
#'   } else {
#'     echo("nothing!")
#'   }
#' )))

js <- function(..., level=2, indent.by=rk.get.indent(), linebreaks=TRUE, empty.e=rk.get.empty.e(), keep.ite=FALSE){
  full.content <- eval(substitute(alist(...)))

  if(isTRUE(linebreaks)){
    collapse <- paste0("\n", indent(level=level, by=indent.by))
  } else {
    collapse <- ""
  }
  
  ID.content <- lapply(
    full.content,
    function(this.part){
      # get the object, not just a name from eval(substitute(alist(...)))
      if (is.name(this.part)){
        # also, if this gets called inside a local() call, make sure we fetch
        # the referenced object at all
        this.part <- dynGet(as.character(this.part), ifnotfound=get(as.character(this.part)))
      } else {}
      if(is.call(this.part)){
        # recursively check for if conditions
        if(inherits(this.part, "if")){
          this.part <- replaceJSIf(this.part, level=level, paste=!keep.ite, indent.by=indent.by, empty.e=empty.e)
        } else {}
        if(inherits(this.part, "for")){
          this.part <- replaceJSFor(this.part, level=level, indent.by=indent.by)
        } else {}
        if(isTRUE(keep.ite)){
          return(this.part)
        } else {
          if(as.character(this.part[[1]]) %in% c("rk.comment", "tf", "rk.JS.optionset")){
            return(trim(rk.paste.JS(eval(this.part, envir=.rk.local.env), level=level, indent.by=indent.by, empty.e=empty.e)))
          } else {}
          # replace JS operators
          return(do.call("replaceJSOperators", args=list(this.part)))
        }
      } else if(is.XiMpLe.node(this.part)){
        if(XMLName(this.part) == "!--"){
          return(rk.paste.JS(this.part, level=level, indent.by=indent.by, empty.e=empty.e))
        } else {
          return(this.part)
        }
      } else {
        return(this.part)
      }
    }
  )
  
  if(isTRUE(keep.ite)){
    return(ID.content)
  } else {
    return(id(js=TRUE, collapse=collapse, .objects=ID.content))
  }
}
