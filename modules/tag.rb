#!/bin/env ruby
# encoding: utf-8

class CorpseHttp
  
  def style
    
    return ""
    
  end

  def view

    html = results ? "<p>Terms with the #{@term.name} tag.</p>" : "<p>There are no term tagged as <b>#{@term.name}</b>.</p>"
      
    results.each do |term|
      html += term.to_s(:long)
    end

    return html

  end

  def results

    a = []
    $lexicon.to_h("term").each do |name,term|
      if !term.tags then next end
      if !term.tags.include?(@term.name.downcase) then next end
      a.push(term)
    end
    return a

  end

end