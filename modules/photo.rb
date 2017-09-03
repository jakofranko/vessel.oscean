#!/bin/env ruby
# encoding: utf-8

corpse = $nataniev.vessels[:oscean].corpse

corpse.style =  "
    body { overflow-x:hidden}
    yu.hd { display:none}
    yu.mi wr { padding:0px; max-width:100%}
    yu.mi wr media { border-radius:0px; margin-bottom:0px}"

def corpse.view

  return "#{Media.new("diary",@query)}"

end