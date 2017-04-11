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

    text = "\nREVIEW\n"
    text += next_available_diary
    text += missing_logs
    text += empty_logs
    text += missing_terms
    text += broken_links
    text += misformatted
    text += "\n\n"

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
      if !diaries.include?(i) then return "AVAILABLE #{i}\n" end
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
      if log.topic.to_s == "" then next end
      array.push(log.topic)
    end
    
    text = "MISSING TERMS #{array.uniq.length}\n"
    array.uniq.each do |term|
      text += "  #{term.upcase}\n"
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
        if link[0,1] == "!" then next end
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

  def empty_logs

    a = []

    @horaire.to_a.each do |log|
      if !log["CODE"] then next end
      if log["CODE"][2,2].to_i > 0 && !log["TERM"] then a.push(log) end
    end

    text = "EMPTY LOGS #{a.length}\n"

    a.each do |log|
      text += "- #{log["DATE"]}\n"
    end

    return text

  end

  def misformatted

    h = {}

    @lexicon.render.each do |name,hash|
      if !hash["BREF"] then h[name] = "Missing BREF" end
      if hash["BREF"].to_s.length > 150 then h[name] = "BREF is too long(#{hash["BREF"].to_s.length} characters)" end
    end

    text = "MISFORMATTED #{h.length}\n"

    h.each do |name,issue|
      text += " #{name}: #{issue}\n"
    end

    return text

  end

end