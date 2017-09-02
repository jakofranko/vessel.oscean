#!/bin/env ruby
# encoding: utf-8

corpse = $nataniev.vessels[:oscean].corpse

corpse.style = ""

def corpse.view

  text = ""

  @links = {}
  @diaries = {}
  @by_date = {}
  @projects = []
  @missing_topics = []

  _horaire = @horaire.to_a(:log)
  _lexicon = @lexicon.to_h(:term)

  _horaire.each do |log|
    @diaries[log.photo] = log
    @by_date[log.time.to_s] = log
    @projects.push(log.topic)
    if !_lexicon[log.topic.upcase] && log.topic != "" then @missing_topics.push(log.topic) end
  end

  _lexicon.each do |topic,term|
    @links[topic] = term.data["BREF"].to_s.scan(/(?:\{\{)([\w\W]*?)(?=\}\})/) 
    @links[topic] += term.long.to_s.scan(/(?:\{\{)([\w\W]*?)(?=\}\})/) 
  end

  # Stats
  text += "<b>Logs</b>        #{@by_date.length}\n"
  text += "<b>Diaries</b>     #{@diaries.length}\n"
  text += "<b>Projects</b>    #{@projects.uniq.length}\n"

  # Find next id
  i = 1
  while i < 9999
    if !@diaries[i] then text += "<b>Available</b>   ##{i}\n" ; break end
    i += 1
  end

  # Find missing log
  i = 0
  while i < (365 * 10)
    test2 = Time.now - (i * 24 * 60 * 60)
    y = test2.to_s[0,4]
    m = test2.to_s[5,2]
    d = test2.to_s[8,2]
    i += 1
    if !@by_date["#{y}#{m}#{d}"] then text += "<b>X Log</b>     #{y}#{m}#{d}" ; break end
  end

  # Missing Topics
  @missing_topics.uniq.each do |topic| text += "<b>X Topic</b>     #{topic} <comment>1/#{@missing_topics.uniq.length}</comment>\n" ; break end
  
  # Broken Links
  missing = {}
  @links.each do |source,links|
    links.each do |link|
      link = link.first
      if link.include?("|") then link = link.split("|").last end
      if link.include?("http") then next end
      if link[0,1] == "$" then next end
      if link[0,1] == "#" then next end
      if link[0,1] == "!" then next end
      if !_lexicon[link.upcase] then text += "<b>X Links</b>     #{source}:#{link}\n" ; end
    end
  end

  text += "<b>Anniversary</b> "
  text += "\n\n"

  return "<code>#{text}</code>"
  
end