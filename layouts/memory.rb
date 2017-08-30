#!/bin/env ruby
# encoding: utf-8

corpse = $nataniev.vessels[:oscean].corpse

def corpse.view

  html = ""
  ladder = Memory_Hash.new(@term.name,@host.path).to_h
  index = Index.new

  ladder.each do |cat,con|
    index.add(:root,cat)
    html += "<h2 id='#{cat.downcase.gsub(' ','_')}'>#{cat.capitalize}</h2>\n"
    if con.kind_of?(Hash)
      con.each do |k,v|
        index.add(cat,k)
        html += "<h4 id='#{k.downcase.gsub(' ','_')}'>#{k}</h4>\n"
        if v.kind_of?(Array)
          html += v.runes
        end
      end
    elsif con.kind_of?(Array)
      html += con.runes
    else
      html += con
    end
  end
  return "#{index.to_s(true)}#{@term.long.runes}#{html.markup}"

end