#!/bin/env ruby
# encoding: utf-8

class ActionDebug

  include Action
  
  def initialize q = nil

    super

    @name = "Debug"
    @docs = "List missing logs and terms."

  end

  def act q = "Home"

    load_folder("#{@host.path}/objects/*")

    @horaire = Memory_Array.new("horaire",@host.path)
    @lexicon = Memory_Hash.new("lexicon",@host.path)

    text = "REVIEW\n"
    text += "========================\n"
    text =  "AVAILABLE #{next_available_diary}\n"
    text += "========================\n"
    text += missing_logs
    text += "========================\n"
    text += missing_terms
    text += "========================\n"
    text += broken_links

    return text

  end

  private

  def next_available_diary

    diaries = []
    @horaire.to_a.each do |log|
      if !log["PICT"] then next end
      diaries.push(log["PICT"].to_i)
    end
    diaries = diaries.sort

    i = 1
    while i < 9999
      if !diaries.include?(i) then return i end
      i += 1
    end
    return nil

  end

  def missing_logs

    array = []
    dates = []
    @horaire.to_a.each do |log|
      dates.push(log['DATE'])
    end
    i = 0
    while i < (365 * 10)
      test2 = Time.now - (i * 24 * 60 * 60)
      y = test2.to_s[0,4]
      m = test2.to_s[5,2]
      d = test2.to_s[8,2]
      i += 1
      if !dates.include?("#{y} #{m} #{d}")
        array.push("#{y} #{m} #{d}")
      end
    end

    text = "MISSING LOGS #{array.length}\n"
    array.each do |log|
      text += "- #{log}\n"
    end
    return text

  end

  def missing_terms

    array = []

    @horaire.to_a("log").each do |log|
      if !@lexicon.filter("term",log.topic,"term").type.to_s.like("missing") then next end
      array.push(log.topic)
    end
    
    text = "MISSING TERMS #{array.uniq.length}\n"
    array.uniq.each do |term|
      text += "- #{term.upcase}\n"
    end

    return text

  end

  def broken_links

    links = {}

    @lexicon.render.each do |name,hash|
      links[name] = hash["BREF"].to_s.scan(/(?:\{\{)([\w\W]*?)(?=\}\})/) 
      links[name] += hash["LONG"].to_s.scan(/(?:\{\{)([\w\W]*?)(?=\}\})/) 
    end

    missing = {}
    count = 0
    count_missing = 0
    links.each do |source,links|
      links.each do |link|
        if link.first.include?("http") then next end
        link = link.first.include?("|") ? link.first.split("|").last : link.first
        count += 1
        if @lexicon.render[link.upcase] then next end
        if !missing[source] then missing[source] = [] end
        missing[source].push(link)
        count_missing += 1
      end
    end

    text = "BROKEN LINKS #{count_missing}/#{count}\n"

    missing.each do |source,links|
      text += "- #{source}(#{links.length}) #{links.first}\n"
    end

    return "#{text}"

  end

end