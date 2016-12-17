#!/bin/env ruby
# encoding: utf-8

class CorpseHttp

  def view

    html = ""

    used = []
    terms = $lexicon.to_h("term")

    terms.each do |parent,term|
      if !term.type then next end
      if !term.type.to_s.like("portal") && !term.type.to_s.like("archive") then next end

      html += "#{media = Media.new("badge",term.name.downcase) ; media.set_style('width:100px;height:100px;margin-left:30px') ; media}"
      html += "<h2><a href='/#{term.name}'>#{term.name}</a></h2>"
      terms.each do |name,term|
        if !term.unde.like(parent) then next end
        html += "<li style='display:inline-block; width:150px'><a href='/#{name}'>#{name.capitalize}</a></li>"
        used.push(name.downcase)
        terms.each do |child,term|
          if !term.unde.like(name) then next end
          if used.include?(child.downcase) then next end
          html += "<li style='display:inline-block; width:150px'><a href='/#{child}'>#{child.capitalize}</a></li>"
          used.push(child.downcase)
        end
      end
      html += "<br /><br /></td></tr>"
      used.push(parent.downcase)
    end
    
    lastLetter = "4"
    html += "<ul style='column-count:3'>"
    terms.each do |topic,term|
      if used.include?(topic.downcase) then next end
      if term.name[0,1].downcase != lastLetter.downcase
        lastLetter = term.name[0,1]
        html += "<h2 style='font-size: 30px;line-height: 50px;margin: 0px;'>#{lastLetter}</h2>"
      end
      html += "<li style='font-size:16px'><a href='/#{term.name}'>#{(term.type.to_s.like("portal")) ? "<b>"+term.name+"</b>" : term.name}</a></li>"
    end
    html += "</ul>"
    return html

  end

  def photoForTerm term

    $horaire.to_a("log").each do |log|
      if !log.topic.like(term) then next end
      if log.photo < 1 then next end
      return log.photo
    end

    return nil

  end

end