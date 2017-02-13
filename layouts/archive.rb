#!/bin/env ruby
# encoding: utf-8

class CorpseHttp

  def view

    html = "<p>#{@term.bref}</p>#{@term.long.runes}\n"

    children(term.name).each do |term|
      html += "<h2><a href='/#{term.name}'>#{term.name}</a></h2>\n"
      html += "<p>#{term.bref}</p>\n"
      children(term.name).each do |term|
        html += "<h4>#{term.name}</h4>\n"
        html += "<p>#{term.bref}</p>\n"
      end
    end
    return html

  end

  def children topic

    a = []
    lexicon.to_h("term").each do |name,term|
      if !term.unde.like(topic) then next end
      a.push(term)
    end
    return a

  end

end