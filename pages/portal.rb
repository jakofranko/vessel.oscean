#!/bin/env ruby
# encoding: utf-8

class CorpseHttp

  def style

    return "
    <style>
    list.portal { column-count:3 !important}
    </style>"

  end

  def view

    html = ""

    @used = []
    @terms = $lexicon.to_h("term")
    
    @used.push("home")
    
    html += "<h3>Audio Portal</h3>"
    html += "<list class='portal'>#{find_children(@terms["AUDIO"],0)}</list>" ; @used.push("audio")

    html += "<h3>Visual Portal</h3>"
    html += "<list class='portal'>#{find_children(@terms["VISUAL"],0)}</list>" ; @used.push("visual")

    html += "<h3>Research Portal</h3>"
    html += "<list class='portal'>#{find_children(@terms["RESEARCH"],0)}</list>" ; @used.push("research")
    html += "<list class='portal'>#{find_lost_children}<//list>\n"
    
    return "<p>#{@term.bref}</p>#{@term.long.runes}\n#{html}"

  end
  
  def find_children target, depth
    
    html = ""
    html += create_portal(target,depth)
    
    @terms.each do |name,term|
      if depth > 10 then break end
      if @used.include?(name.downcase) then next end
      if !term.unde.like(target.name) then next end
      html += find_children(term,depth+1)
      @used.push(name.downcase)
    end
    
    return html
    
  end
  
  def find_lost_children
    
    html = ""
    
    @terms.each do |name,term|
      if @used.include?(name.downcase) then next end
      if term.type.to_s.like("chapter") then next end
      if term.type.to_s.like("redirect") then next end
      html += term.has_tag("portal") ? create_portal(term) : ""
    end
    
    return html
    
  end

  def create_portal term, depth = 0

    return "<ln style='padding-left:#{depth * 15}px'><a href='/#{term.name.to_url}'>#{depth == 0 ? '' : term.name}</a></ln>"

  end

end