#!/bin/env ruby
# encoding: utf-8

class CorpseHttp

  def view

    ladder = children(term.name)

    html = "<p>#{@term.bref}</p>#{indexes(ladder)}#{@term.long.runes}\n"

    ladder.each do |term|
      html += "<h2 id='#{term.name}'><a href='/#{term.name}'>#{term.name}</a></h2>\n"
      html += "<p>#{term.bref}</p>\n"
      children(term.name).each do |term|
        html += "<div class='child'><h4 id='#{term.name}'></h4>\n<p>#{term.bref}</p>\n</div>"
      end
    end
    return html

  end

  def indexes ladder

    if ladder.length < 3 then return "" end
    html = ""
    counter = 1
    html += "<ul class='index'>"
    ladder.each do |term|    
      html += "<li class='main'><span class='counter'>#{counter}</span> <a href='##{term.name}'>#{term.name}</a></li>"
      sub_counter = 1
      children(term.name).each do |term|
        sub_counter += 1
        html += "<li><span class='counter'>#{counter}.#{sub_counter}</span> <a href='##{term.name}'>#{term.name}</a></li>"
      end
      counter += 1
    end
    html += "</ul>"

    return html

  end

  def children topic

    a = []
    lexicon.to_h("term").each do |name,term|
      if !term.unde.like(topic) then next end
      a.push(term)
    end
    return a

  end

  def style

    return "<style>

    .index { margin-bottom:30px; column-count:3}
    .index li { font-family:'din_regular'; font-size:16px; line-height:25px; }
    .index li a:hover { text-decoration:underline}
    .index li span.counter { color: #aaa;display: inline-block;margin-right: 15px;width: 15px;}
    .index li.main a { font-family: 'din_medium'}
    yu.cr div.child { padding-left:30px; border-left:5px solid #ddd}
    yu.cr div.child p { font-size:18px; line-height:30px;}
    </style>"

  end

end