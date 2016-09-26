#!/bin/env ruby
# encoding: utf-8

class Page

  def body

    template = "There is no entry for {_"+@query.capitalize+"_} on this wiki.<br />"

    if @query.to_i < 1 && @query.length < 4 then return "<wr>Your search query is too short, try again with something longer than 4 characters.</wr>" end

    searchResult = search()

    if searchResult.length == 0 then return ("<wr><p>"+template+"</p></wr>").markup end
    
    if searchResult.length == 1 then return ("<wr><p>"+template+"Did you mean {{"+searchResult[0].to_s+"}}?</p></wr>").markup end
    if searchResult.length == 2 then return ("<wr><p>"+template+"Did you mean {{"+searchResult[0].to_s+"}} or {{"+searchResult[1].to_s+"}}?</p></wr>").markup end

    return ("<wr><p>"+template+"Did you mean {{"+searchResult[0].to_s+"}}, {{"+searchResult[1].to_s+"}} or {{"+searchResult[2].to_s+"}}?</p><p>If you believe that this page should exist, contact {{@neauoire|https://twitter.com/neauoire}}</p></wr>").markup

  end

  def search

    searchResult = {}

    # Lexicon
    lexicon.all.each do |topic,term|
      topic = topic.downcase
      if !searchResult[topic] then searchResult[topic] = 0 end

      if topic.downcase == @query then searchResult[topic] += 5 end
      if topic.downcase.include?(@query.downcase) then searchResult[topic] += 1 end

      if term.unde.to_s.include?(@query) then searchResult[topic] += 1 end
      if term.link.to_s.include?(@query) then searchResult[topic] += 1 end
    end

    # Horaire
    horaire.all.each do |date,log|
      # if !searchResult[log.topic] then searchResult[log.topic.downcase] = 0 end

      # if log.topic.downcase == @query then searchResult[log.topic] += 5 end
      # if log.topic.downcase.include?(@query.downcase) then searchResult[log.topic.downcase] += 1 end

      # if log.name.downcase.include?(@query.downcase) then searchResult[log.topic.downcase] += 1 end
      # if log.name.downcase.include?(@query.downcase) then searchResult[log.topic.downcase] += 1 end

      # if log.photo.to_i > 0 && log.photo.to_i == @query.to_i then searchResult[log.topic.downcase] = 100 end
    end

    searchResult = searchResult.sort_by {|_key, value| value}.reverse

    strippedResults = []
    searchResult.each do |term,value|
      if value == 0 then break end
      strippedResults.push(term)
    end

    return strippedResults
  end

 end