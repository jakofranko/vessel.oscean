#!/bin/env ruby
# encoding: utf-8

class Graph_Timeline

  def initialize(term,from = 0,to = term.logs.length)
    
    @logs = term.logs[from,to]
    @sum_hours = 0
    @sums = {}
    @segments = equalSegments

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

      if !@sums[log.sector] then @sums[log.sector] = 0 end
      @sums[log.sector] += log.value
      @sum_hours += log.value

      if segments[progressPrev] then segments[progressPrev][log.sector] += log.value * distributePrev end
      if segments[progressNext] then segments[progressNext][log.sector] += log.value * distributeNext end
    end
    return segments

  end

  def findHighestValue

    highest = 1
    @segments.each do |values|
      if values[:audio] > highest then highest = values[:audio]end
      if values[:visual] > highest then highest = values[:visual]end
      if values[:research] > highest then highest = values[:research]end
    end
    return highest

  end

  def to_s

    html = ""
    width = 798
    height = 150
    lineWidth = (width+30)/28.0
    segmentWidth = lineWidth/4
    highestValue = findHighestValue
    width += segmentWidth

    lineAudio_html = "0,#{highestValue * height} "
    lineVisual_html = ""
    lineResearch_html = ""
    lineAverage_html = ""

    count = 0
    @segments.reverse.each do |values|
      value = height - ((values[:audio]/highestValue) * height)
      if count == 0 then value = height end
      # if count == 27 then value = height end
      lineAudio_html += "#{(count * lineWidth + (segmentWidth) - segmentWidth)},#{(value).to_i} "
      lineAudio_html += "#{(count * lineWidth + (segmentWidth * 3) - segmentWidth)},#{(value).to_i} "
      value = height - (values[:visual]/highestValue * height)
      if count == 0 then value = height end
      # if count == 27 then value = height end
      lineVisual_html += "#{(count * lineWidth + (segmentWidth) - segmentWidth)},#{(value).to_i} "
      lineVisual_html += "#{(count * lineWidth + (segmentWidth * 3) - segmentWidth)},#{(value).to_i} "
      value = height - (values[:research]/highestValue * height)
      if count == 0 then value = height end
      # if count == 27 then value = height end
      lineResearch_html += "#{(count * lineWidth + (segmentWidth) - segmentWidth)},#{(value).to_i} "
      lineResearch_html += "#{(count * lineWidth + (segmentWidth * 3) - segmentWidth)},#{(value).to_i} "
      value = height - (((values[:audio] + values[:visual] + values[:research])/3)/highestValue * height)
      if count == 0 then value = height end
      if count == 27 then value = height end
      lineAverage_html += "#{(count * lineWidth + (segmentWidth) - segmentWidth)},#{(value).to_i} "
      lineAverage_html += "#{(count * lineWidth + (segmentWidth * 3) - segmentWidth)},#{(value).to_i} "
      count += 1
    end

    # Lines

    html += "<polyline class='average' points='#{lineAverage_html}'/>"
    html += "<polyline class='research' points='#{lineResearch_html}' />"
    html += "<polyline class='visual' points='#{lineVisual_html}' />"
    html += "<polyline class='audio' points='#{lineAudio_html}' />"

    # Markers
    markers = ""
    markers += "<t class='origin'>#{@logs.last.time.ago}</t>"
    markers += "<t class='sector audio'>#{@logs.audio_ratio_percentage}% <t style='color:#999'>Audio</t></t>"
    markers += "<t class='sector visual'>#{@logs.visual_ratio_percentage}% <t style='color:#999'>Visual</t></t>"
    markers += "<t class='sector research'>#{@logs.research_ratio_percentage}% <t style='color:#999'>Research</t></t>"
    markers += "<t class='sector hdf'>#{@logs.hour_day_focus} <t style='color:#999'>Hdf</t></t>"
    markers += "<t class='sector sb'>#{@logs.sector_balance_percentage}% <t style='color:#999'>Sb</t></t>"

    markers += "<t class='sector sum'><a href='/Horaire'>#{@sum_hours.to_i} hours</a></t>"

    return "#{style}<yu class='graph timeline'><svg style='width:100%; height:#{height}px;'>"+html+"</svg><ln>#{markers}</ln></yu>"

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
    .graph.timeline svg { overflow: hidden; border-bottom: 1px solid #000; padding-top:5px; height:149px}
    .graph.timeline svg polyline.audio { fill:none; stroke:#72dec2; stroke-width:1}
    .graph.timeline svg polyline.visual { fill:none; stroke:black }
    .graph.timeline svg polyline.research { fill:none; stroke-dasharray:1,1; stroke:#000; stroke-width:1 }
    .graph.timeline svg polyline.average { fill:#eee; }
    .graph.timeline ln { display:block; position:relative; font-family:'din_regular'; font-size:12px; padding-top:30px}
    .graph.timeline t.origin { position: absolute;top: -150px;left: 0px;color: #999 }
    .graph.timeline t.sector { position: absolute;top: 0px;color: #000; display: block;line-height: 30px; margin-left:10px }
    .graph.timeline t.sector.audio { left:0px; border-bottom:1px solid #72dec2 }
    .graph.timeline t.sector.visual { left:100px; border-bottom:1px solid black }
    .graph.timeline t.sector.research { left:200px; border-bottom:1px dotted black }
    .graph.timeline t.sector.hdf { left:400px;}
    .graph.timeline t.sector.sb { left:450px;}
    .graph.timeline t.sector.sum { right:15px;}
    </style>"
  end

end