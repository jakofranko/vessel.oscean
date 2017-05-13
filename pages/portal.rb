#!/bin/env ruby
# encoding: utf-8

class CorpseHttp

  def style

    return "
    <style>
    yu.cr div.portal { margin-bottom:30px; min-height:130px; padding-left:160px; position:relative; padding-top:15px}
    yu.cr div.portal media { width:130px; height:130px; position:absolute; left:0px; top:0px}
    </style>"

  end

  def view

    html = "<p>#{@term.bref}</p>#{@term.long.runes}\n"

    @used = []
    @terms = $lexicon.to_h("term")
    @terms_logs = find_logs
    
    @used.push("home")
    
    html += find_children(@terms["AUDIO"],0) ; @used.push("audio")
    html += find_children(@terms["VISUAL"],0) ; @used.push("audio")
    html += find_children(@terms["RESEARCH"],0) ; @used.push("audio")
    html += find_lost_children+"\n"
    
    return html

  end
  
  def find_children target, depth
    
    html = ""
    html += target.has_tag("portal") ? create_portal(target) : ""
    
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
  
  def find_logs
    
    h = {}
    $horaire.to_a(:log).reverse.each do |log|
      if !h[log.topic] then h[log.topic] = {:logs => 0, :diaries => 0, :offset => ""} end
      h[log.topic][:logs] += 1
      h[log.topic][:offset] = log.offset
    end
    return h
    
  end

  def create_portal term

    return "
    <div class='portal'>
      #{ Media.new("badge",term.name).exists ? Media.new("badge",term.name).to_s : ''}
      <p>#{term.bref}</p>

    </div>"

  end

end