#!/bin/env ruby
# encoding: utf-8

corpse = $nataniev.vessels[:oscean].corpse

def corpse.index

  ladder = children(@term.name)
  index = Index.new
  ladder.each do |term|
    if @term.name.like("home") then next end
    index.add(:root,term.name)
    children(@term.name).each do |term|
      index.add(@term.parent.name,@term.name)
    end
  end
  return index

end

def corpse.children topic

  a = []
  @lexicon.to_h("term").each do |name,term|
    if !term.unde.like(topic) then next end
    a.push(term)
  end
  return a

end

def corpse.featured_topics

  l = @lexicon.to_h("term")
  topics = []
  terms = []

  c = 0
  @horaire.to_a(:log).each do |log|
    if c > 30 then break end
    topics.push(log.topic)      
    c += 1
  end

  c = 0
  topics.uniq.each do |name|
    if c > 8 then break end
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

def corpse.view
  
  return  "
  #{index}#{@term.long.runes}\n
  <h2>Recent Activity</h2>
  #{Graph_Timeline.new(@term,0,90)}\n
  <p>The above interface displays the current project activity recorded during the previous 90 days. Learn more about the {{Horaire}} tracking tool.</p>
  <mini>Learn more about {{Horaire}}.</mini>
  #{featured_topics}
  <h2>Notice</h2>
  <p id='notice'>I am currently in {*{{$ hundredrabbits get_location}}*}, {{sailing|Hundred rabbits}} across the Pacific Ocean toward New Zealand. My access to internet is limited and will not be able to answer emails as frequently. I will get back to you upon {{landfall|http://100r.co/#map}}.</p>".markup

end
