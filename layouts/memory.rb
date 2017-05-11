#!/bin/env ruby
# encoding: utf-8

class CorpseHttp

  def view

    html = "<p>#{@term.bref}</p>#{@term.long.runes}\n"

    memory_name = term.name.downcase.gsub(" ",".")
    ladder = Memory_Hash.new(memory_name,@host.path).to_h
    
    html += indexes(ladder)

    ladder.each do |cat,con|
      html += "<h2 id='#{cat.downcase.gsub(' ','_')}'>#{cat.capitalize}</h2>\n"
      if con.kind_of?(Hash)
        con.each do |k,v|
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

    return html.markup

  end

  def indexes ladder

    html = ""
    counter = 0
    html += "<ul class='index'>"
    ladder.each do |cat,con|  
      counter += 1  
      html += "<li class='main'><span class='counter'>#{counter}</span> <a href='##{cat.downcase.gsub(' ','_')}'>#{cat.capitalize}</a></li>"
      if con.kind_of?(Hash)
        con.each do |name,content|
          counter += 1
          html += "<li><span class='counter'>#{counter}</span> <a href='##{name.downcase.gsub(' ','_')}'>#{name.capitalize}</a></li>"
        end
      end
    end
    html += "</ul>"

    return html

  end

  def style

    return "<style>

    .index { margin-bottom:30px; column-count:3}
    .index li { font-family:'din_regular'; font-size:16px; line-height:25px; }
    .index li a:hover { text-decoration:underline}
    .index li span.counter { color:#aaa; display:inline-block; margin-right:15px; width:15px; text-align:right}
    .index li.main a { font-family: 'din_medium'}
    </style>"

  end

end
