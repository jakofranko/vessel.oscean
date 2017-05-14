#!/bin/env ruby
# encoding: utf-8

class CorpseHttp

  def view

    template = "There is no entry for <i>#{@query.capitalize}</i> on this wiki.<br />"

    if @query.to_i < 1 && @query.length < 4 then return "<p>Your search query is too short, try again with something longer than 4 characters.</p>" end

    searchResult = search()

    if searchResult.length == 0 then return ("<p>"+template+"</p>") end
    
    if searchResult.length == 1 then return ("<p>"+template+"Did you mean {{"+searchResult[0].first.to_s+"}}?</p>").markup end
    if searchResult.length == 2 then return ("<p>"+template+"Did you mean {{"+searchResult[0].first.to_s+"}} or {{"+searchResult[1].first.to_s+"}}?</p>").markup end

    return ("<p>"+template+"Did you mean {{"+searchResult[0].first.to_s+"}}, {{"+searchResult[1].first.to_s+"}} or {{"+searchResult[2].first.to_s+"}}?</p><p>If you believe that this page should exist, contact {{@neauoire|https://twitter.com/neauoire}}</p>").markup

  end

  def search

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

    searchResult = searchResult.sort_by {|_key, value| value}.reverse

    return searchResult

  end

end