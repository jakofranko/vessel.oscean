#!/bin/env ruby
# encoding: utf-8

class CorpseHttp

  def view

    html = "" # @term.long.runes

    $lexicon.filter("unde",term.name,"term").each do |name,term|
      if !term.unde.like(@term.name) then next end
      if term.name.like(@term.name) then next end

      html += term.name

    end

    return html

  end

end