#!/bin/env ruby
# encoding: utf-8

class Graph_Timeline

  def initialize(logs)
    
    @logs = logs
    @sums = {}
    @segments = equalSegments
    @sumHours = 0

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

    @from = @logs.first.elapsed
    @to = @logs.last.elapsed
    @length = @to - @from

    @logs.each do |log|
      progressFloat = (log.elapsed/@to.to_f) * 28
      progressPrev = progressFloat.to_i
      progressNext  = progressFloat.ceil
      distributePrev = progressNext - progressFloat
      distributeNext = 1 - distributePrev

      if !@sums[log.sector] then @sums[log.sector] = 0 end
      @sums[log.sector] += log.value

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
      @sumHours += values[:audio] + values[:visual] + values[:research]
    end
    return highest

  end

  def to_s

    html = ""
    width = 640
    height = 150
    lineWidth = 660/28
    segmentWidth = lineWidth/10
    highestValue = findHighestValue
    width += segmentWidth

    lineAudio_html = ""
    lineVisual_html = ""
    lineResearch_html = ""
    lineAverage_html = ""

    count = 0
    @segments.reverse.each do |values|
      value = height - ((values[:audio]/highestValue) * height)
      lineAudio_html += "#{(count * lineWidth + (segmentWidth) - segmentWidth)},#{(value).to_i} "
      lineAudio_html += "#{(count * lineWidth + (segmentWidth * 3) - segmentWidth)},#{(value).to_i} "
      value = height - (values[:visual]/highestValue * height)
      lineVisual_html += "#{(count * lineWidth + (segmentWidth) - segmentWidth)},#{(value).to_i} "
      lineVisual_html += "#{(count * lineWidth + (segmentWidth * 3) - segmentWidth)},#{(value).to_i} "
      value = height - (values[:research]/highestValue * height)
      lineResearch_html += "#{(count * lineWidth + (segmentWidth) - segmentWidth)},#{(value).to_i} "
      lineResearch_html += "#{(count * lineWidth + (segmentWidth * 3) - segmentWidth)},#{(value).to_i} "
      value = height - (((values[:audio] + values[:visual] + values[:research])/3)/highestValue * height)
      lineAverage_html += "#{(count * lineWidth + (segmentWidth) - segmentWidth)},#{(value).to_i} "
      lineAverage_html += "#{(count * lineWidth + (segmentWidth * 3) - segmentWidth)},#{(value).to_i} "
      count += 1
    end

    # Lines

    html += "<polyline points='#{lineAverage_html}' style='fill:none;stroke:grey;stroke-width:1' stroke-dasharray='1,2' />"
    html += "<polyline points='#{lineAudio_html}' style='fill:none;stroke:#72dec2;stroke-width:1' />"
    html += "<polyline points='#{lineVisual_html}' style='fill:none;stroke:red;stroke-width:1' />"
    html += "<polyline points='#{lineResearch_html}' style='fill:none;stroke:white;stroke-width:1' />"

    # Markers
    markers = ""
    markers += "<span style='position:absolute; top:15px;left:30px; color:grey'>#{@logs.last.offset}</span>"
    markers += "<span style='position:absolute; top:15px;right:30px; text-align:right; color:grey'>#{@logs.first.offset}</span>"

    markers += "<span style='position:absolute; bottom:15px;left:30px'><tt style='color:#72dec2; padding-right:5px'>— </tt> Audio <span style='color:#999'>#{@sums[:audio] ? ((@sums[:audio].to_i/@sumHours.to_f)*100).to_i : 0}%</span></span>"
    markers += "<span style='position:absolute; bottom:15px;left:120px'><tt style='color:red; padding-right:5px'>— </tt> Visual <span style='color:#999'>#{@sums[:visual] ? ((@sums[:visual].to_i/@sumHours.to_f)*100).to_i : 0}%</span></span>"
    markers += "<span style='position:absolute; bottom:15px;left:210px'><tt style='color:white; padding-right:5px'>— </tt> Research <span style='color:#999'>#{@sums[:research] ? ((@sums[:research].to_i/@sumHours.to_f)*100).to_i : 0}%</span></span>"
    markers += "<span style='position:absolute; bottom:15px;left:350px'>#{focus_hours} <span style='color:#999'>FH</span></span>"
    markers += "<span style='position:absolute; bottom:15px;left:400px'>#{focus_balance} <span style='color:#999'>FB</span></span>"
    markers += "<span style='position:absolute; bottom:15px;right:30px'><a href='/Home:Horaire'><b style='font-family:\"din_medium\"; font-weight:normal; color:#999'>#{@sumHours.to_i} hours</b></a></span>"

    return "<vz><svg style='width:#{width}px; height:#{height}px; background:black; overflow: visible'>"+html+"<svg>#{markers}</vz>"

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
    return "#{(sum/tasks.length.to_f).to_i}"

  end

  def focus_balance

    a = []
    sum = 0
    tasks.each do |task|
      sum += task.focus_balance
    end
    return "#{(sum/tasks.length.to_f).to_i}"

  end


end