#!/bin/env ruby
# encoding: utf-8

corpse = $nataniev.vessels[:oscean].corpse

corpse.style = ""

def corpse.view

  html = ""

  @lexicon.to_h(:term).each do |topic,term|
    if !term.type.to_s.like("portal") then next end
    html += term.diary.to_s
  end

  return "<yu class='portal_list'>#{html}</yu>"
  
end