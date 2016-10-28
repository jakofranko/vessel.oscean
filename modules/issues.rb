#!/bin/env ruby
# encoding: utf-8

class CorpseHttp

  def view

    html = ""

    if term.name.like("home") || term.name.like("issues")
      term.tasks.to_a.each do |topic,tasks|
        html += "<h2>#{topic}</h2>\n"
        html += "<list>"
        tasks.each do |task|
          html += "#{task}<br />\n"
        end
        html += "</list>"
      end
    else
      html += "<h2>Issues</h2>\n"
      html += "<list>"
      term.tasks.to_a.each do |task|
        html += "#{task}<br />\n"
      end
        html += "</list>"
    end
    
    return "<wr>#{html}</wr>"

  end
  
end