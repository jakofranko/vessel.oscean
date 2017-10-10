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

  @term_count = 0

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
    @term_count += 1
  end

  # Stats
  text += "<b>Logs</b>          : #{@by_date.length} <comment>#{(@by_date.length/365.0).trim(2)} years</comment>\n"
  text += "  Diaries     : #{@diaries.length} <comment>#{((@diaries.length/@by_date.length.to_f) * 100).trim(2)}% of logs</comment> \n"

  # Find next id
  i = 1
  while i < 9999
    if !@diaries[i] then text += "  next        : <t style='color:#72dec2'>#{i}</t>\n" ; break end
    i += 1
  end

  text += "<b>Terms</b>         : #{@term_count}\n"
  text += "  Projects    : #{@projects.uniq.length} <comment>#{((@projects.uniq.length/@term_count.to_f) * 100).trim(2)}% of terms</comment>\n"

  # Missing Topics
  @missing_topics.uniq.each do |topic| text += "  Missing     : #{topic} <comment>1/#{@missing_topics.uniq.length}</comment>\n" ; break end
  text += "\n"

  # Find missing log
  i = 0
  while i < (365 * 10)
    test2 = Time.now - (i * 24 * 60 * 60)
    y = test2.to_s[0,4]
    m = test2.to_s[5,2]
    d = test2.to_s[8,2]
    i += 1
    if !@by_date["#{y}#{m}#{d}"] then text += "<b>X Log</b>       #{y}#{m}#{d}\n" ; break end
  end

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
      if link[4,1] == "-" then next end
      if !_lexicon[link.upcase] then text += "<b>X Links</b>     #{source}:#{link}\n" ; end
    end
  end

  return "<code>#{text}</code>"
  
end