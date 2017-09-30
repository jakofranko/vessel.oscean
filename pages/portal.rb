#!/bin/env ruby
# encoding: utf-8

corpse = $nataniev.vessels[:oscean].corpse

def corpse.view

  html = "#{@term.long.runes}\n"

  topics = {}
  @horaire.to_a(:log).each do |log|
    if !topics[log.topic.to_url] then topics[log.topic.to_url] = {} ; topics[log.topic.to_url][:from] = log.date ; topics[log.topic.to_url][:sum] = 0 end
    if log.task.like("release") then topics[log.topic.to_url][:release] = log.date end
    topics[log.topic.to_url][:to] = log.date
    topics[log.topic.to_url][:sum] += log.value
  end

  html += "<h2>Pages</h2>"
  html += "<list>"
  @lexicon.to_h(:term).sort.each do |topic,term|
    if topics[term.name.to_url] then next end
    if term.bref.to_s == "" then next end
    if term.name.to_i > 0 then next end
    html += "<ln><a href='#{term.name.to_url}'>#{term.name}</a></ln>"
  end
  html += "</list>"

  html += "<h2>Projects</h2>"
  html += "<h3>Released</h3>"
  html += "<list>"
  @lexicon.to_h(:term).sort.each do |topic,term|
    if !topics[term.name.to_url] then next end
    if !topics[term.name.to_url][:release] then next end
    html += "<ln><a href='#{term.name.to_url}'>#{term.name}</a></ln>"
  end
  html += "</list>"
  html += "<h3>Archives</h3>"
  html += "<list>"
  @lexicon.to_h(:term).sort.each do |topic,term|
    if !topics[term.name.to_url] then next end
    if topics[term.name.to_url][:release] then next end
    if topics[term.name.to_url][:sum] < 15 then next end
    html += "<ln><a href='#{term.name.to_url}'>#{term.name}</a></ln>"
  end
  html += "</list>"

  html += "<h3>B-Sides</h3>"
  html += "<list>"
  @lexicon.to_h(:term).sort.each do |topic,term|
    if !topics[term.name.to_url] then next end
    if topics[term.name.to_url][:release] then next end
    if topics[term.name.to_url][:sum] > 15 then next end
    html += "<ln><a href='#{term.name.to_url}'>#{term.name}</a></ln>"
  end
  html += "</list>"

  return html

end