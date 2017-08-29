#!/bin/env ruby
# encoding: utf-8

corpse = $nataniev.vessel.corpse

def corpse.view

  html = "#{@term.long.runes}\n"

  @term.children.each do |child|
    html += child.diary ? child.diary.media.to_s : ''
    html += "<h2><a href='/#{child.name}'>#{child.name}</a></h2><p>#{child.bref}</p>"
    html += "<list>"
    child.children.each do |sub_child|
      html += "<ln>#{sub_child.bref}</ln>"
    end
    html += "</list>"
  end

  return html

end