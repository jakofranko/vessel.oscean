#!/bin/env ruby
# encoding: utf-8

class CorpseHttp

  def index

    ladder = children(term.name)
    index = Index.new
    ladder.each do |term|
      if term.name.like("home") then next end
      index.add(:root,term.name)
      children(term.name).each do |term|
        index.add(term.parent.name,term.name)
      end
    end
    return index

  end

  def children topic

    a = []
    lexicon.to_h("term").each do |name,term|
      if !term.unde.like(topic) then next end
      a.push(term)
    end
    return a

  end

  def view

    html = ""

    html += "
    #{index}#{@term.long.runes}\n
    <h2>90 Days Activity</h2>
    #{Graph_Timeline.new(term,0,100)}\n
    <p>The above {{Horaire}} interface displays the current active projects and the amount of hours invested in each during the previous 100 days.</p>
    #{featured_topics}
    <h2>Notice</h2>
    <p id='notice'>I am currently in {*{{$ hundredrabbits get_location}}*}, {{sailing|Hundred rabbits}} across the Pacific Ocean toward New Zealand. My access to internet is limited and will not be able to answer emails as frequently. I will get back to you upon {{landfall|http://100r.co/#map}}.</p>
    <mini>Learn more about {{Horaire}}.</mini>
    ".markup
    
    return html

  end

  def featured_topics

    l = lexicon.to_h("term")
    topics = []
    terms = []

    c = 0
    $horaire.to_a(:log).each do |log|
      if c > 30 then break end
      topics.push(log.topic)      
      c += 1
    end

    c = 0
    topics.uniq.each do |name|
      if c > 7 then break end
      terms.push(l[name.upcase])
      c += 1
    end

    html = ""
    terms.each do |term|
      if !term then next end
      html += "<ln class='pl15'>#{term.bref}</ln>"
    end

    return "<h2>Featured Projects</h2><list>#{html}</list>"

  end

end