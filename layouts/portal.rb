#!/bin/env ruby
# encoding: utf-8

class CorpseHttp

  def view

    html = "<p>#{@term.bref}</p>#{@term.long.runes}\n"

    $lexicon.to_h("term").each do |name,term|
      if !term.unde.like(@term.name) then next end
      if term.name.like(@term.name) then next end
      if !term.bref then next end
      html += term.to_s(@term.type_value ? @term.type_value : :long)

    end

    return html

  end

end