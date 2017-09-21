#!/bin/env ruby
# encoding: utf-8

corpse = $nataniev.vessels[:oscean].corpse

corpse.style = ""

def corpse.view

  html = ""

  @lexicon.to_h(:term).each do |topic,term|
    html += "<ln><a href='/#{topic.to_url}'>#{topic.capitalize}</a>, #{term.bref.to_s.downcase}</ln>"
  end

  return "<list>#{html}</list>"
  
end