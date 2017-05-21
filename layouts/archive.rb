#!/bin/env ruby
# encoding: utf-8

class CorpseHttp

  def view

    ladder = children(term.name)

    html = ""

    index = Index.new

    ladder.each do |term|
      index.add(:root,term.name)
      html += "<h2 id='#{term.name.downcase}'><a href='/#{term.name}'>#{term.name}</a></h2>\n"
      html += "<p>#{term.bref}</p>\n"
      html += "<div class='children'>"
      children(term.name).each do |term|
        index.add(term.parent.name,term.name)
        html += "<div class='child' id='#{term.name.downcase}'>#{term.bref}\n</div>"
      end
      html += "</div>"
    end
    return "<p>#{@term.bref}</p>#{index}#{@term.long.runes}#{html}"

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
    yu.cr div.child { font-size: 18px;line-height: 30px;margin-bottom: 1px;background: #ddd;padding: 5px 15px}
    yu.cr div.children { margin-bottom: 30px;border-radius: 5px;overflow: hidden}
    yu.cr div.children a { font-family:'lora_bold'}
    </style>"

  end

end