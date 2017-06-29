#!/bin/env ruby
# encoding: utf-8

class Graph_Timeline

  def initialize(term,from = 0,to = term.logs.length)
    
    @logs = term.logs[from,to]
    @segments = equalSegments
    @width = 798
    @height = 100

  end

  def segmentMemory

    memory = []
    segments_limit = 28
    i = 0
    while i < 28
      memory[i] = {}
      memory[i][:audio] = 0
      memory[i][:visual] = 0
      memory[i][:research] = 0
      memory[i][:misc] = 0
      memory[i][:sum] = 0
      i += 1
    end
    return memory

  end

  def equalSegments

    segments = segmentMemory

    @from = @logs.first.time.elapsed
    @to = @logs.last.time.elapsed
    @length = @to - @from

    @logs.each do |log|
      progressFloat = (log.time.elapsed/@to.to_f) * 28
      progressPrev = progressFloat.to_i
      progressNext  = progressFloat.ceil
      distributePrev = progressNext - progressFloat
      distributeNext = 1 - distributePrev

      if segments[progressPrev] then segments[progressPrev][log.sector] += log.value * distributePrev end
      if segments[progressNext] then segments[progressNext][log.sector] += log.value * distributeNext end
      if segments[progressPrev] then segments[progressPrev][:sum] += log.value * distributePrev end
      if segments[progressNext] then segments[progressNext][:sum] += log.value * distributeNext end
    end
    return segments

  end

  def findHighestValue

    highest = 1
    @segments.each do |values|
      if values[:sum] > highest then highest = values[:sum] end
    end
    return highest

  end

  def to_s

    html = ""
    lineWidth = (@width+30)/28.0
    segmentWidth = lineWidth/4
    highestValue = findHighestValue

    lineAudio_html = "0,#{highestValue * @height} "
    lineVisual_html = ""
    lineResearch_html = ""
    lineAverage_html = ""

    polyline_audio = "0,#{@height} "
    polyline_visual = "0,#{@height} "
    polyline_research = "0,#{@height} "

    count = 0
    @segments.reverse.each do |values|

      # Max
      max = ((values[:sum])/highestValue * @height).to_i
      sum = values[:sum] > 0 ? values[:sum] : 1
      gap = (segmentWidth * 4.5).to_i
      step = 4

      # Research
      value = ((values[:research]/sum) * max).to_i
      value = (value / step).to_i * step
      polyline_research += "#{(count * lineWidth + (segmentWidth) - segmentWidth)},#{(@height - value).to_i} #{(count * lineWidth + gap - segmentWidth)},#{(@height - value).to_i} "

      # Visual
      value = (((values[:visual] + values[:research])/sum) * max).to_i
      value = (value / step).to_i * step
      polyline_visual += "#{(count * lineWidth + (segmentWidth) - segmentWidth)},#{(@height - value).to_i} #{(count * lineWidth + gap - segmentWidth)},#{(@height - value).to_i} "

      # Audio
      value = (((values[:audio] + values[:visual] + values[:research])/sum) * max).to_i
      value = (value / step).to_i * step
      polyline_audio += "#{(count * lineWidth + (segmentWidth) - segmentWidth)},#{(@height - value).to_i} #{(count * lineWidth + gap - segmentWidth)},#{(@height - value).to_i} "

      count += 1
    end

    # Lines
    html += "<polyline class='audio' points='#{polyline_audio} #{@width},#{@height}' />"
    html += "<polyline class='visual' points='#{polyline_visual} #{@width},#{@height}' />"
    html += "<polyline class='research' points='#{polyline_research} #{@width},#{@height}' />"

    # Markers
    markers = ""
    markers += "<t class='origin'>#{@logs.last.time.ago}</t>"
    markers += "<t class='sector audio'>#{@logs.audio_ratio_percentage}% <t style='color:#999'>Audio</t></t>"
    markers += "<t class='sector visual'>#{@logs.visual_ratio_percentage}% <t style='color:#999'>Visual</t></t>"
    markers += "<t class='sector research'>#{@logs.research_ratio_percentage}% <t style='color:#999'>Research</t></t>"
    markers += "<t class='sector sb'>#{@logs.sector_balance_percentage}% <t style='color:#999'>Sb</t></t>"

    markers += "<t class='sector right'><a href='/Horaire'>#{@logs.hours} <t style='color:#999'>Fh</t></a></t>"
    markers += "<t class='sector right'>#{@logs.hour_day_focus} <t style='color:#999'>Hdf</t></t>"
    markers += "<t class='sector right'>#{@logs.hour_task_focus} <t style='color:#999'>HTa</t></t>"
    markers += "<t class='sector right'>#{@logs.hour_topic_focus} <t style='color:#999'>HTo</t></t>"

    return "#{style}<yu class='graph timeline'><svg style='width:100%; height:#{@height}px;'>"+html+"</svg><ln>#{markers}</ln></yu>"

  end

  ##########

  def tasksData

    h = {}
    @logs.each do |log|
      if !h[log.task] then h[log.task] = {"name" => log.task, :sum_hours => 0, :sum_logs => 0, :audio => 0, :visual => 0, :research => 0, :misc => 0, :topics => []} end
      h[log.task][log.sector] += log.value
      h[log.task][:sum_logs] += 1
      h[log.task][:sum_hours] += log.value
      h[log.task][:topics].push(log.topic)
    end
    return h

  end

  def tasks

    tasksHash = tasksData
    a = []

    $sum_hours = 0
    $sum_logs = 0
    $max_hours = 0
    $max_logs = 0
    tasksHash.sort.each do |name,data|
      if name == "" then next end
      if data[:sum_hours] > $max_hours then $max_hours = data[:sum_hours] end
      if data[:sum_logs] > $max_logs then $max_logs = data[:sum_logs] end
      $sum_hours += data[:sum_hours]
      $sum_logs += 1
    end

    tasksHash.sort.each do |name,data|
      if name == "" then next end
      if data[:sum_hours] == 0 then next end
      a.push(Task.new(data,$max_hours))
    end

    return a

  end

  def focus_hours

    a = []
    sum = 0
    tasks.each do |task|
      sum += task.focus_hours
    end
    return "#{((sum/tasks.length.to_f)*100).to_i/100.0}"

  end

  def style

    return "<style>
    .graph.timeline { margin-bottom:30px}
    .graph.timeline svg { overflow: hidden; padding-top:5px; height:149px}
    .graph.timeline svg polyline.audio { fill:#72dec2; stroke:none}
    .graph.timeline svg polyline.visual { fill:#000; stroke:none }
    .graph.timeline svg polyline.research { fill:#ddd; stroke:none }
    .graph.timeline svg polyline.average { fill:#eee; }
    .graph.timeline ln { display:block; position:relative; font-family:'din_regular'; font-size:12px;}
    .graph.timeline t.origin { position: absolute;top: -#{@height + 30}px;left: 0px;color: #999 }
    .graph.timeline t.sector { color: #000; display: inline-block;line-height: 30px; margin-right:15px}
    .graph.timeline t.sector.audio { left:0px; border-bottom:1px solid #72dec2 }
    .graph.timeline t.sector.visual { left:100px; border-bottom:1px solid black }
    .graph.timeline t.sector.research { left:200px; border-bottom:1px dotted black }
    .graph.timeline t.sector.right { float:right; margin-right:0px; margin-left:15px}
    </style>"
  end

end