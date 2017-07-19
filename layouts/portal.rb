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
      html += child.diary ? child.diary.media.to_s : ''
      html += "<h2><a href='/#{child.name}'>#{child.name}</a></h2><p>#{child.bref}</p>"
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

    term.children.each do |child|
      html += child.to_s(@term.type_value ? @term.type_value : :long)
    end

    return html

  end

end