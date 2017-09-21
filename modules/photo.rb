#!/bin/env ruby
# encoding: utf-8

corpse = $nataniev.vessels[:oscean].corpse

corpse.style =  "
    body { overflow-x:hidden}
    yu.hd { display:none}
    yu.mi wr { padding:0px; max-width:100%; margin-top:100px;}
    yu.mi wr img { display:block; width:100%}
    yu.ft {margin-bottom:30px}"

def corpse.view

  topic = $nataniev.vessels[:oscean].corpse.horaire.filter("PICT",@query,:log).first.topic

  media = Media.new("diary",@query)
  return "<a href='/#{topic.to_url}'>#{media.to_img}</a>"

end