#!/bin/env ruby
# encoding: utf-8

class CorpseHttp

  def style

    return "
<style>
</style>"

  end

  def index

    ladder = children(term.name)
    index = Index.new

    html = ""
    ladder.each do |term|
      if term.name.like("home") then next end
      index.add(:root,term.name)
      children(term.name).each do |term|
        index.add(term.parent.name,term.name)
      end
      html += "</list>"
    end

    return index

  end

  def view

    html = ""

    html += "#{index}#{@term.long.runes}\n"

    html += Graph_Timeline.new(term,0,100).to_s
    html += "<p>The above {{Horaire}} interface displays the current active projects and the amount of hours invested in each during the previous 100 days.</p>".markup

    html += "<p id='notice'>I am currently in {*{{$ hundredrabbits get_location}}*}, {{sailing|Hundred rabbits}} across the Pacific Ocean toward New Zealand. My access to internet is limited and will not be able to answer emails as frequently. I will get back to you upon {{landfall|http://100r.co/#map}}.</p>".markup
    
    
    return html

  end

end