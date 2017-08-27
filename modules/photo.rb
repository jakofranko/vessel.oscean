#!/bin/env ruby
# encoding: utf-8

class CorpseHttp
  
  def style
    
    return "<style>
    body { overflow-x:hidden}
    yu.hd { display:none}
    yu.mi > a media { width:100%; height:80vh; margin:0px}
    yu.mi wr .tag { display:none !important}
    yu.ft { border-top:0px}
    </style>"
    
  end

  def _mi

    return "<yu class='mi'><a href='/#{term.name}'>#{Media.new("diary",@query)}</a></yu>"

  end
  
end