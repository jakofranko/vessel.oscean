#!/bin/env ruby
# encoding: utf-8

class CorpseHttp

  def view

    html = "" # @term.long.runes

    children(term.name).each do |term|
      html += "<h2>#{term.name}</h2>\n"
      html += "<p>#{term.bref}</p>\n"
      children(term.name).each do |term|
        html += "<h4>#{term.name}</h4>\n"
        html += "<p>#{term.bref}</p>\n"
      end
    end
    return "<wr>#{html}</wr>"

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