#!/bin/env ruby
# encoding: utf-8

class CorpseHttp

  def view

    html = ""

    if term.like("home") || term.like("issues")
      term.tasks.to_a.each do |topic,tasks|
        html += "<h2>#{topic}</h2>\n"
        tasks.each do |task|
          html += "<ln>#{task}</ln>\n"
        end
      end
    else
      html += "<h2>Tasks</h2>\n"
      term.tasks.to_a.each do |task|
        html += "<ln>#{task}</ln>\n"
      end
    end
    
    return "<wr>#{html}</wr>"

  end
  
end