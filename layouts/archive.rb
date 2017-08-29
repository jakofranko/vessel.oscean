#!/bin/env ruby
# encoding: utf-8

corpse = $nataniev.vessel.corpse

corpse.style = "
yu.cr div.child { font-size: 18px;line-height: 30px;margin-bottom: 1px;background: #ddd;padding: 5px 15px}
yu.cr div.children { margin-bottom: 30px;border-radius: 5px;overflow: hidden}
yu.cr div.children a { font-family:'lora_bold'}"

def corpse.view

  html = ""

  index = Index.new

  @term.children.each do |term|
    index.add(:root,term.name)
    html += "<h2 id='#{term.name.downcase}'><a href='/#{term.name}'>#{term.name}</a></h2>\n"
    html += "<p>#{term.bref}</p>\n"
    html += "<list class='pl15'>"
    term.children.each do |term|
      index.add(term.parent.name,term.name)
      html += "<ln class='pl15' id='#{term.name.downcase}'>#{term.bref}\n</ln>"
    end
    html += "</list>"
  end
  return "#{index}#{@term.long.runes}#{html}"

end