## ---- include=FALSE, cache=FALSE------------------------------------------------------------------
library(rkwarddev)

## ---- eval=TRUE-----------------------------------------------------------------------------------
rk.XML.frame(label="Example XML object")

## ---- eval=TRUE-----------------------------------------------------------------------------------
str(rk.XML.frame(label="Example XML object"))

## ---- eval=TRUE-----------------------------------------------------------------------------------
myCheckbox <- rk.XML.cbox(label="Check me!")
myCheckbox2 <- rk.XML.cbox(label="No, check me!!!", chk=TRUE)
(myFrame <- rk.XML.frame(myCheckbox, myCheckbox2, label="Example XML object"))

## ---- eval=TRUE-----------------------------------------------------------------------------------
rk.XML.cbox(label="Check me!", id.name="specificID")

## ---- eval=TRUE-----------------------------------------------------------------------------------
myCheckbox <- rk.XML.cbox(label="Check me!")
XMLAttrs(myCheckbox)[["id"]]

## ---- eval=TRUE-----------------------------------------------------------------------------------
(myVarselector <- rk.XML.varselector(id.name="my_vars"))
(myVars <- rk.XML.varslot(label="Chose a variable", source=myVarselector))

## ---- eval=TRUE-----------------------------------------------------------------------------------
(myDialog <- rk.XML.dialog(
    rk.XML.row(
        myVarselector,
        rk.XML.col(myVars, myFrame)
    ),
    label="Example dialog"
))

## ---- eval=FALSE----------------------------------------------------------------------------------
#  rk.plugin.skeleton(
#      about="Example plugin",
#      xml=list(dialog=myDialog),
#      load=TRUE,
#      show=TRUE
#  )

## ---- eval=TRUE-----------------------------------------------------------------------------------
cat(rk.JS.scan(myDialog))

## ---- eval=TRUE-----------------------------------------------------------------------------------
echo("# Value of the checkbox is: ", myCheckbox, "\n")

## ---- eval=TRUE-----------------------------------------------------------------------------------
ite("foo", "bar", "baz")

## ---- eval=TRUE-----------------------------------------------------------------------------------
ite(myCheckbox,
    ite(myVars,
        echo("result <- ", myVars, "\n"),
        echo("# huh?\n")
    ),
    ite(myCheckbox2,
        echo("## ouch!\n")
    )
)

## ---- eval=TRUE-----------------------------------------------------------------------------------
cat(js(
    if(myCheckbox){
        if(myVars){
            echo("result <- ", myVars, "\n")
        } else {
            echo("# huh?\n")
        }
    } else if(myCheckbox2){
        echo("## ouch!\n")
    }
))

## ---- eval=TRUE-----------------------------------------------------------------------------------
mySpinbox <- rk.XML.spinbox(label="Set a value")
cat(js(
    if(myCheckbox == "true"){
        if(myVars){
            echo("result <- ", myVars, "\n")
        } else {
            echo("# huh?\n")
        }
    } else if(mySpinbox >= 0.3){
        echo("## a huge value!\n")
    }
))

## ---- eval=FALSE----------------------------------------------------------------------------------
#  myCalculation <- rk.paste.JS(js(
#      if(myCheckbox){
#          if(myVars){
#              echo("result <- ", myVars, "\n")
#          } else {
#              echo("# huh?\n")
#          }
#      } else if(myCheckbox2){
#          echo("## ouch!\n")
#      }
#  ))
#  rk.plugin.skeleton(
#      about="Example plugin",
#      xml=list(dialog=myDialog),
#      js=list(calculate=myCalculation),
#      load=TRUE,
#      show=TRUE,
#      overwrite=TRUE
#  )

## ---- eval=TRUE-----------------------------------------------------------------------------------
(mySummary <- rk.rkh.summary("Perform some cool anaylsis."))
(myUsage <- rk.rkh.usage("Check some boxes to add your data ..."))

## ---- eval=TRUE-----------------------------------------------------------------------------------
mySpinbox <- rk.XML.spinbox(
    label="Set a value",
    help="If you spin this, the result will change.",
    component="Value setters"
)

## ---- eval=TRUE-----------------------------------------------------------------------------------
rk.get.rkh.prompter(component="Value setters", id=mySpinbox)

## ---- eval=FALSE----------------------------------------------------------------------------------
#  rk.plugin.skeleton(
#      about="Example plugin",
#      xml=list(
#          dialog=myDialog
#      ),
#      js=list(
#          calculate=myCalculation
#      ),
#      rkh=list(
#          summary=mySummary,
#          usage=myUsage
#      ),
#      load=TRUE,
#      show=TRUE,
#      overwrite=TRUE
#  )

## ---- eval=TRUE-----------------------------------------------------------------------------------
cat(plugin2script(myDialog))

## ---- eval=TRUE-----------------------------------------------------------------------------------
identical(eval(parse(text=plugin2script(myDialog))), myDialog)

