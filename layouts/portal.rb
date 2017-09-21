#!/bin/env ruby
# encoding: utf-8

corpse = $nataniev.vessels[:oscean].corpse

def corpse.view

  html = "#{@term.long.runes}\n"

  @term.children.each do |child|
    html += child.diary ? "<a href='/#{child.name}'>#{child.diary.media}</a>" : ''
    html += "#{child.banner}"
    html += "<list>"
    child.children.each do |sub_child|
      html += "<ln>#{sub_child.bref}</ln>"
    end
    html += "</list>"
  end

  return html

end