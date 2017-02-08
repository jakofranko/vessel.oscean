#!/bin/env ruby
# encoding: utf-8

class CorpseHttp

  def view

    html = ""

    @used = []
    @terms = $lexicon.to_h("term")
    @terms_logs = find_logs
    
    @used.push("home")
    
    html += "<code>"
    html += find_children(@terms["AUDIO"],0)+"\n"             ; @used.push("audio")
    html += find_children(@terms["VISUAL"],0)+"\n"            ; @used.push("visual")
    html += find_children(@terms["RESEARCH"],0)+"\n"          ; @used.push("research")
    
    html += find_lost_children+"\n"
    html += "</code>"
    
    return html

  end
  
  def find_children target, depth
    
    html = ""
    html += "<a href='/#{target.name}'><span style='padding-left:#{depth*15}px'>#{target.name}</span></a> #{@terms_logs[target.name] ? "<comment style='position:absolute; left:300px; color:#777'>#{@terms_logs[target.name][:offset]}</comment>" : ""}\n"
    
    @terms.each do |name,term|
      if depth > 5 then break end
      if !term.unde.like(target.name) then next end
      html += find_children(term,depth+1)
      @used.push(name.downcase)
    end
    
    return html
    
  end
  
  def find_lost_children
    
    html = "Lost\n"
    
    @terms.each do |name,term|
      if @used.include?(name.downcase) then next end
      if term.type.to_s.like("chapter") then next end
      if term.type.to_s.like("redirect") then next end
      html += "  "+name.capitalize+"\n"
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

end