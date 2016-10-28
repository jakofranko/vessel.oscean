#!/bin/env ruby
# encoding: utf-8

class CorpseHttp

  def view

    html = term.long.runes+"\n"
    
    html += "<h2>Tasks</h2>\n"
    term.tasks.to_a.each do |task|
      html += "<ln>#{task}</ln>\n"
    end

    return "<wr>#{html}</wr>"

  end
  
end