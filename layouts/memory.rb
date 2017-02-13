#!/bin/env ruby
# encoding: utf-8

class CorpseHttp

  def view

    html = "<p>#{@term.bref}</p>#{@term.long.runes}\n"

    ladder = Memory_Hash.new(term.name,@host.path).to_h
    
    counter = 1
    html += "<ul class='index'>"
    ladder.each do |cat,con|    
      html += "<li><span class='counter'>#{counter}</span> <a href='##{cat.downcase.gsub(' ','_')}'>#{cat.capitalize}</a></li>"
      counter += 1
    end
    html += "</ul>"

    ladder.each do |cat,con|
      html += "<h2 id='#{cat.downcase.gsub(' ','_')}'>#{cat.capitalize}</h2>\n"
      if con.kind_of?(Hash)
        con.each do |k,v|
          html += "<h4>#{k}</h4>\n"
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

    return html.markup

  end

  def style

    return "<style>

    .index { margin-bottom:30px; column-count:3}
    .index li { font-family:'din_regular'; font-size:16px; line-height:25px; }
    .index li a:hover { text-decoration:underline}
    .index li span.counter { color:#aaa; display:inline-block; margin-right:15px; width:15px; text-align:right}
    </style>"

  end

end
