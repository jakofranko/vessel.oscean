#!/bin/env ruby
# encoding: utf-8

class Graph_Topics

  def initialize(term,from = 0,to = term.logs.length)
    
    @logs = term.logs[from,to]
    @count_topics = 0

    @sum_hours = 0

  end

  def to_s

    html = ""

    @topics = {}

    @tasks = {}
    @tasks[:audio] = {:sum => 0}
    @tasks[:visual] = {:sum => 0}
    @tasks[:research] = {:sum => 0}

    @logs.each do |log|
      if !@topics[log.topic] then @topics[log.topic] = {} ; @topics[log.topic][:sum] = 0 end  
      if !@topics[log.topic][log.sector] then @topics[log.topic][log.sector] = 0 end
      # Topic
      @topics[log.topic][log.sector] += log.value
      @topics[log.topic][:sum] += log.value
      # Task
      if !@tasks[log.sector] then @tasks[log.sector] = {} ; @tasks[log.sector][:sum] = 0 end
      if !@tasks[log.sector][log.task] then @tasks[log.sector][log.task] = 0 end
      @tasks[log.sector][log.task] += log.value
      @tasks[log.sector][:sum] += log.value
      # Generics
      @sum_hours += log.value
    end

    h = @topics.sort_by {|_key, value| value[:sum]}.reverse
    max = h.first.last[:sum]

    count = 0
    h.each do |name,val|
      if count > 13 then break end
      values = {:audio => val[:audio], :visual => val[:visual], :research => val[:research]}
      html += "<ln><a href='/#{name}'>#{name}</a><span class='value'>#{val[:sum]}h</span>#{Progress.new(values,max)}<hr/></ln>"
      count += 1
    end

    displays = "<span style='position:absolute; left:30px; top:27px; font-size:11px'>#{@logs.hour_topic_focus} <span style='color:grey'>HTo</span></span>"

    return "<list class='activity' style='position:relative'>#{displays} #{task_graph(@tasks)}#{html}<hr/></list>"

  end

  def task_graph tasks

    max_radius = 105
    possible = @logs.length * 9.0
    occupied = (@tasks[:audio] ? @tasks[:audio][:sum] : 0) + (@tasks[:visual] ? @tasks[:visual][:sum] : 0) + (@tasks[:research] ? @tasks[:research][:sum] : 0)

    r_available = (possible - occupied)/possible * max_radius
    r_audio = (@tasks[:audio][:sum]/possible.to_f) * max_radius + r_available - 1
    r_visual = (@tasks[:visual][:sum]/possible.to_f) * max_radius + r_audio - 1
    r_research = (@tasks[:research][:sum]/possible.to_f) * max_radius + r_visual - 1

    html = ""

    html += "<circle cx='#{max_radius}' cy='#{max_radius}' r='#{r_research}' fill='#fff' stroke='black' stroke-width='1' />"

    i = 0
    while i < @tasks[:research].length
      html += "<g transform='translate(#{max_radius},#{max_radius}),rotate(#{360/@tasks[:research].length.to_f * i} 0 0)'><line x1='0' y1='0' x2='#{max_radius}' y2='0' stroke='black' stroke-width='1'/></g>"
      i += 1
    end

    html += "<circle cx='#{max_radius}' cy='#{max_radius}' r='#{r_visual}' fill='#ff0000' stroke='black' stroke-width='1' />"

    i = 0
    while i < @tasks[:visual].length
      html += "<g transform='translate(#{max_radius},#{max_radius}),rotate(#{360/@tasks[:visual].length.to_f * i} 0 0)'><line x1='0' y1='0' x2='#{r_visual}' y2='0' stroke='black' stroke-width='1'/></g>"
      i += 1
    end

    html += "<circle cx='#{max_radius}' cy='#{max_radius}' r='#{r_audio}' fill='#72dec2' stroke='black' stroke-width='1' />"

    i = 0
    while i < @tasks[:audio].length
      html += "<g transform='translate(#{max_radius},#{max_radius}),rotate(#{360/@tasks[:audio].length.to_f * i} 0 0)'><line x1='0' y1='0' x2='#{r_audio}' y2='0' stroke='black' stroke-width='1'/></g>"
      i += 1
    end

    html += "<circle cx='#{max_radius}' cy='#{max_radius}' r='#{r_available}' fill='#000' />"

    # Focus
    range = max_radius - r_available
    r_topic_focus = r_available + 10
    r_task_focus = r_available + ((2/@topics.length.to_f) * range)

    return "<svg width='#{max_radius*2}' height='#{max_radius*2}' style='float:left; margin-right:15px'>#{html}</svg>"

  end

end