#!/bin/env ruby
# encoding: utf-8

class ActionQuery

  include Action
  
  def initialize q = nil

    super

    @name = "Query"
    @docs = "List missing logs and terms."

  end

  def act q = "Home"

    load_folder("#{@host.path}/objects/*")

    @horaire = Memory_Array.new("horaire",@host.path)
    @lexicon = Memory_Hash.new("lexicon",@host.path)

    if q.like("calendar") then return get_calendar end
    if q.like("tasks") then return get_tasks end
    if q.like("diary") then return get_diary end

  end

  private

  def get_calendar

    h = {}
    @horaire.to_a(:log).each do |log|
      if log.date.y != Time.now.year then next end
      h[log.date.stamp] = {:topic => log.topic,:sector => log.sector,:value => log.value}
    end
    return h

  end

  def get_tasks

    a = []

    h = {}
    h[:available_id] = next_available_diary
    h[:missing_log] = next_missing_log
    h[:missing_term] = next_missing_term
    h[:broken_link] = next_broken_link
    h[:empty_log] = next_empty_log
    h[:orphan] = next_orphan
    h[:misformatted] = next_misformatted

    h.each do |name,value|
      if !value then next end
      a.push("#{name} -> #{value}")
    end

    return a

  end

  def get_diary

    logs = @horaire.to_a(:log)

    average = 0
    selected_logs = []
    logs[0,7].each do |log|
      selected_logs.push(log.value)
      average += log.value
    end

    average_lw = 0
    logs[7,7].each do |log|
      average_lw += log.value
    end

    average_percent = ((average/7.0) * 10)
    average_percent_lw = ((average_lw/7.0) * 10)

    return {
      :unit => "DHF",
      :logs => selected_logs.reverse,
      :percentage => average_percent,
      :difference => average_percent - average_percent_lw,
      :tips => nil
    }

  end

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

  def next_missing_log

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
      if !dates.include?("#{y}#{m}#{d}")
        array.push("#{y}#{m}#{d}")
      end
    end

    array.each do |log|
      return log+"(#{array.length})"
    end
    return nil

  end

  def next_missing_term

    array = []

    @horaire.to_a("log").each do |log|
      if !@lexicon.filter("term",log.topic,"term").type.to_s.like("missing") then next end
      if log.topic.to_s == "" then next end
      array.push(log.topic)
    end
    
    array.uniq.each do |term|
      return "#{term}(#{array.uniq.length})"
    end

    return nil

  end

  def next_broken_link

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
        if link.first[0,1] == "$" then next end
        link = link.first.include?("|") ? link.first.split("|").last : link.first
        count += 1
        if @lexicon.render[link.upcase] then next end
        if link[0,1] == "!" then next end
        if !missing[source] then missing[source] = [] end
        missing[source].push(link)
        count_missing += 1
      end
    end

    missing.each do |source,links|
      return "#{source}(#{links.length}) #{links.first}(#{missing.length})"
    end

    return nil

  end

  def next_empty_log

    a = []

    @horaire.to_a.each do |log|
      if !log["CODE"] then next end
      if log["CODE"][2,2].to_i > 0 && (!log["TERM"] || !log["TASK"]) then a.push(log) end
    end

    a.each do |log|
      return "#{log["DATE"]}(#{a.length})"
    end

    return nil

  end

  def next_misformatted

    h = {}

    @lexicon.render.each do |name,hash|
      if hash["TYPE"].to_s.downcase.include?("redirect") then next end
      if !hash["BREF"] then h[name] = "Missing BREF" end
      if !hash["BREF"].include?("#{name.capitalize}}}") && !name.include?(" ") then h[name] = "Missing self-reference" end
      if !hash["LONG"] then h[name] = "Stub" end
      if !(hash["BREF"].to_s+hash["LONG"].to_s).include?("\{\{") then h[name] = "Dead-End" end
      if hash["BREF"].to_s.length > 250 then h[name] = "BREF is too long(#{hash["BREF"].to_s.length} characters)" end
      if hash["BREF"].to_s.length < 20 then h[name] = "BREF is too short(#{hash["BREF"].to_s.length} characters)" end
    end

    h.sort.each do |name,issue|
      return "#{name}:#{issue}(#{h.length})"
    end

    return nil

  end

  def next_orphan

    a = []

    @lexicon.render.each do |name,hash|
      if hash["TYPE"].to_s.downcase.include?("redirect") then next end
      if !@lexicon.render[hash["UNDE"].upcase] then a.push(name) end
    end

    a.each do |name|
      return "#{name}(#{a.length})"
    end

    return nil

  end

end