#!/bin/env ruby
# encoding: utf-8

corpse = $nataniev.vessels[:oscean].corpse

def corpse.last_diary

  @term.diaries.each do |diary|
    if diary.photo == @term.diary.photo then next end
    return "#{diary}"
  end

end

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
    if c > 10 then break end
    terms.push(l[name.upcase])
    c += 1
  end

  html = ""
  terms.each do |term|
    if !term then next end
    html += "<ln class='pl15'>#{term.bref}</ln>"
  end

  return "<list>#{html}</list>"

end

def corpse.view
    
  filtered_logs = []

  count = 0
  @term.logs.each do |log|
    if count > 180 then break end
    if !log || !log.time || log.time.elapsed < 0 then next end
    filtered_logs.push(log)
    count += 1
  end
  
  return ""
  return  "
  #{index}#{@term.long.runes}\n
  <h2>Featured Diary</h2>
  #{last_diary}
  <h2>Recent Activity</h2>
  #{Graph_Timeline.new(filtered_logs,0,90)}\n
  #{featured_topics}
  <h2>Notice</h2>
  <p id='notice'>I am currently in {*{{$ hundredrabbits get_location}}*}, {{sailing|Hundred rabbits}} across the Pacific Ocean toward New Zealand. My access to internet is limited and will not be able to answer emails as frequently. I will get back to you upon {{landfall|http://100r.co/#map}}.</p>".markup

end
