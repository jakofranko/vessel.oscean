#!/bin/env ruby
# encoding: utf-8

class CorpseHttp
  
  def style
    
    return "<style>
    body { overflow-x:hidden}
    yu.hd { height:0px !important; padding:0px}
    yu.mi wr { width:100vw; padding:0px; margin:0px}
    yu.mi wr media { width:100vw; height:100vh; margin:0px}
    yu.mi wr .tag { display:none !important}
    yu.ft { border-top:0px}
    </style>"
    
  end

  def view

    html = ""
    
    html += "<a href='/#{term.name}'>#{Media.new("diary",@query)}</a>"
    return html

  end
  
end