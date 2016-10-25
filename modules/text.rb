#!/bin/env ruby
# encoding: utf-8

class CorpseHttp

  def view

    html = "<p>#{@term.bref}</p>#{@term.long.runes}".markup
    
    $lexicon.to_h("term").each do |name,term|
      if !term.unde.like(@term.name) then next end
      if term.name.like(@term.name) then next end
      html += term.to_s
    end
    return "<wr>#{html}</wr>"
    
  end

end