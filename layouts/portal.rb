#!/bin/env ruby
# encoding: utf-8

class CorpseHttp

  def view

    html = "#{@term.long.runes}\n"

    html += term.type_value == :summary ? summary : full

    return html

  end

  def summary

    html = ""

    term.children.each do |child|
      html += "<h2>#{child.name}</h2><p>#{child.bref}</p>"
      html += "<list>"
      child.children.each do |sub_child|
        html += "<ln>#{sub_child.bref}</ln>"
      end
      html += "</list>"
    end

    return html.markup

  end

  def full

    html = ""

    $lexicon.to_h("term").each do |name,term|
      if !term.unde.like(@term.name) then next end
      if term.name.like(@term.name) then next end
      if !term.bref then next end
      html += term.to_s(@term.type_value ? @term.type_value : :long)
    end

    return html

  end

end