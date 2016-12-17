#!/bin/env ruby
# encoding: utf-8

class CorpseHttp

  def style
    
    return ""
    
  end
  
  def view

    html = ""

    if term.name.like("home") || term.name.like("issues")
      term.tasks.to_a.each do |topic,task|
        html += "<h2><a href='/#{topic}:issues'>#{topic}</a></h2>\n"
        html += task.to_s
      end
    else
      html += "<p>This page lists the issues for the <a href='/#{term.name}'>#{term.name}</a> project.</p>"
      html += term.tasks.to_s
    end
    
    return html.markup

  end
  
end
