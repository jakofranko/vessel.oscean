#!/bin/env ruby
# encoding: utf-8

corpse = $nataniev.vessels[:oscean].corpse

corpse.style = "
span.result { background:white; font-family:'din_medium'; font-size:12px; color:white; display:block; overflow:hidden; position:relative; height:30px; border-radius:3px; margin-bottom:5px}
span.bar { background: black;min-width: 150px;display: block;height:30px;position: absolute;top:0px;left:0px; z-index:900; color:white; position:absolute; line-height: 30px;padding-left:15px}
span.value { float:right; padding-right:15px; color:#999}
span.result a:hover { text-decoration:underline}"

def corpse.view

  @template = "Sorry, I could not find any entry for <i>#{@query.capitalize}</i>, in my lexicon. "

  if @query.to_i < 1 && @query.length < 4 then return "<p>Your search query is too short, try again with something longer than 4 characters.</p>" end

  searchResult = search()

  if searchResult.length == 0 then return ("<p>#{@template}</p>") end
  if searchResult.length == 1 then return ("<p>#{@template} Did you mean {{"+searchResult[0].first.to_s+"}}?</p>").markup end
  if searchResult.length == 2 then return ("<p>#{@template} Did you mean {{"+searchResult[0].first.to_s+"}} or {{"+searchResult[1].first.to_s+"}}?</p>").markup end

  return detail_view(searchResult)

end

def corpse.detail_view searchResult

  html = ("<p>#{@template} Did you mean {{"+searchResult[0].first.to_s+"}}, {{"+searchResult[1].first.to_s+"}} or {{"+searchResult[2].first.to_s+"}}?</p>").markup

  sum = 0
  searchResult.each do |name,value|
    sum += value
  end

  searchResult.each do |name,value|
    perc = (value/sum.to_f) * 100
    html += "<span class='result'><span class='bar' style='width:calc(#{perc}%)'><a href='/#{name}'>#{name}</a><span class='value'>#{perc.to_i}%</span></span></span>"
  end

  return html

end

def corpse.search

  searchResult = {}
  query = @query.downcase

  # Lexicon

  lexicon.to_h("term").each do |topic,term|
    
    topic = topic.downcase

    if !searchResult[topic] then searchResult[topic] = 0 end

    if term.name.to_s.downcase.include?(query) then searchResult[topic] += 3 end
    if term.bref.to_s.downcase.include?(query) then searchResult[topic] += 2 end
    if term.long.to_s.downcase.include?(query) then searchResult[topic] += 2 end
    if term.unde.to_s.downcase.include?(query) then searchResult[topic] += 1 end
    if term.link.to_s.downcase.include?(query) then searchResult[topic] += 1 end

  end

  # Horaire

  horaire.to_a("log").each do |log|
    
    topic = log.topic.downcase

    if !searchResult[topic] then searchResult[topic] = 0 end

    if log.name.to_s.downcase.include?(query) then searchResult[topic] += 3 end
    if log.topic.to_s.downcase.include?(query) then searchResult[topic] += 2 end
    if log.task.to_s.downcase.include?(query) then searchResult[topic] += 2 end
    if log.full.to_s.downcase.include?(query) then searchResult[topic] += 2 end

  end

  searchResult = searchResult.sort_by {|_key, value| value}

  filteredResults = []
  searchResult.each do |result,value|
    if value == 0 then next end
    filteredResults.push([result.capitalize,value])
  end

  return filteredResults.reverse

end
