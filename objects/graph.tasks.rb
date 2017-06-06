#!/bin/env ruby
# encoding: utf-8

class Graph_Tasks

  def initialize(term,from = 0,to = term.logs.length)
    
    @logs = term.logs[from,to]
    @count_topics = 0

    @sum_hours = 0

  end

  def to_s

    html = ""

    @tasks = {}
    @logs.each do |log|
      if !@tasks[log.task] then @tasks[log.task] = {:sum => 0} end
      if !@tasks[log.task][log.sector] then @tasks[log.task][log.sector] = 0 end
      @tasks[log.task][log.sector] += log.value
      @tasks[log.task][:sum] += log.value
    end

    h = @tasks.sort_by {|_key, value| value[:sum]}.reverse
    max = h.first.last[:sum]

    count = 0
    h.each do |name,val|
      if count > 13 then break end
        values = {:audio => val[:audio], :visual => val[:visual], :research => val[:research]}
      html += "<ln><a>#{name}</a><span class='value'>#{val[:sum]}h</span>#{Progress.new(values,max)}<hr/></ln>"
      count += 1
    end

    displays = "<span style='position:absolute; left:30px; top:27px; font-size:11px'>#{@logs.hour_task_focus} <span style='color:grey'>HTo</span></span>"

    return "<list class='activity' style='position:relative'>#{displays} #{task_graph(@tasks)}#{html}<hr/>#{@logs.focus_docs}</list>"

  end

  def task_graph tasks

    max_radius = 105

    html = ""

    audioRatio = @logs.audio_ratio
    visualRatio = @logs.visual_ratio
    researchRatio = @logs.research_ratio
    max = [audioRatio,visualRatio,researchRatio].sort.reverse.first

    audio_p = max_radius,max_radius - (audioRatio/max * max_radius) - 10
    visual_p = max_radius - (visualRatio/max * max_radius) + 10,max_radius + (visualRatio/max * max_radius) - 10
    research_p = max_radius + (researchRatio/max * max_radius) - 10, max_radius + (researchRatio/max * max_radius) - 10

    middle_p = (audio_p.first + visual_p.first + research_p.first)/3.0,(audio_p.last + visual_p.last + research_p.last)/3.0

    max_radius = 105

    # Outline
    html += "<path d='M#{max_radius},1 L#{max_radius*2},#{max_radius*2-1} L0,#{max_radius*2-1} Z' fill='none' stroke='#333' stroke-dasharray='2,2'></path>"

    # Verteces
    html += "<path d='M#{max_radius},#{max_radius} L0,#{max_radius*2} M#{max_radius},#{max_radius} L#{max_radius*2},#{max_radius*2} M#{max_radius},#{max_radius} L#{max_radius},0' fill='none' stroke='#333' stroke-dasharray='1,1'></path>"
    
    # Offset Verteces
    html += "<path d='M#{audio_p.first},#{audio_p.last} L#{middle_p.first},#{middle_p.last} M#{visual_p.first},#{visual_p.last} L#{middle_p.first},#{middle_p.last} M#{research_p.first},#{research_p.last} L#{middle_p.first},#{middle_p.last}' fill='none' stroke='#333' stroke-dasharray='2,2'></path>"

    # Sector Verteces
    html += "<path d='M#{max_radius},#{max_radius} L#{audio_p.first},#{audio_p.last} ' fill='none' stroke='#72dec2'></path>"
    html += "<path d='M#{max_radius},#{max_radius} L#{visual_p.first},#{visual_p.last} ' fill='none' stroke='#f00'></path>"
    html += "<path d='M#{max_radius},#{max_radius} L#{research_p.first},#{research_p.last} ' fill='none' stroke='#fff'></path>"

    # Offset Path
    html += "<path d='M#{max_radius},#{max_radius} L#{middle_p.first},#{middle_p.last}' fill='none' stroke='#f00' stroke-dasharray='1,2'></path>"
    html += "<circle cx='#{max_radius}' cy='#{max_radius}' r='2' fill='#fff' />"
    html += "<circle cx='#{middle_p.first}' cy='#{middle_p.last}' r='2' fill='#f00' />"

    # Outline
    html += "<path d='M#{audio_p.first},#{audio_p.last} L#{visual_p.first},#{visual_p.last} L#{research_p.first},#{research_p.last} Z' fill='none' stroke='#fff'></path>"

    # Verteces
    html += "<circle cx='#{audio_p.first}' cy='#{audio_p.last}' r='2' fill='#fff' />"
    html += "<circle cx='#{visual_p.first}' cy='#{visual_p.last}' r='2' fill='#fff' />"
    html += "<circle cx='#{research_p.first}' cy='#{research_p.last}' r='2' fill='#fff' />"
    
    return "<svg width='#{max_radius*2}' height='#{max_radius*2}' style='float:left; margin-right:15px'>#{html}</svg>"

  end

end