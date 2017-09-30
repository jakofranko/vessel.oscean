#!/bin/env ruby
# encoding: utf-8

class Graph_Timeline

  def initialize(logs,from = 0,to = logs.length)
    
    @width = 798
    @height = 100
    @LOD = 50

    @logs = sort_logs(logs)[from,to]
    @against = @logs.length > to * 2 ? @logs[to,to] : nil

    @segments = equalSegments

  end

  def sort_logs logs

    sorted_logs_hash = {}

    logs.each do |log|
      sorted_logs_hash[log.time.to_s.to_i] = log
    end

    sorted_logs_array = []

    sorted_logs_hash.sort.each do |date,log|
      sorted_logs_array.push(log)
    end

    return sorted_logs_array.reverse

  end

  def segmentMemory

    memory = []
    i = 0
    while i < @LOD
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
      pos = 1 - (@to - log.time.elapsed)/(@length).to_f
      progressFloat = pos * @LOD.to_f
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
    circles = ""
    lineWidth = ((@width)/@LOD.to_f).to_i + 1
    segmentWidth = lineWidth/4
    highestValue = findHighestValue

    paths = {}

    count = 0
    @segments.reverse.each do |values|

      step = 5
      prev = 0
      values.sort.reverse.each do |name,v|
        if name == :sum then next end
        if name == :misc then next end
        if !paths[name] then paths[name] = "" end
        
        value = (v/highestValue) * @height
        value = (value / step).to_i * step
        pos_x = (lineWidth * 0.5).to_i + (count * lineWidth)
        pos_y1 = prev
        pos_y2 = prev+value
        paths[name] += "M#{pos_x},#{@height - pos_y1.to_i} L#{pos_x},#{@height - pos_y2.to_i} "
        circles += "<circle cx='#{pos_x}' cy='#{@height - pos_y2.to_i}' r='1.5'/>"
        prev += value
      end

      count += 1
    end

    paths.each do |name,d|
      html += "<path class='#{name}' d='#{d}'/>"
    end

    return "#{style}<yu class='graph timeline'><svg style='width:100%; height:#{@height}px;'>#{html}#{circles}</svg>#{summary}</yu>"

  end

  def summary

    html = "
    <t class='origin'></t>
    <t class='sector latest'>#{@logs.last.time.ago}</t>
    <t class='sector audio'><svg><line x1='1' y1='1' x2='15' y2='1'/></svg>#{@logs.audio_ratio_percentage}% <t style='color:#999'>Audio</t></t>
    <t class='sector visual'><svg><line x1='1' y1='1' x2='15' y2='1'/></svg>#{@logs.visual_ratio_percentage}% <t style='color:#999'>Visual</t></t>
    <t class='sector research'><svg><line x1='1' y1='1' x2='15' y2='1'/></svg>#{@logs.research_ratio_percentage}% <t style='color:#999'>Research</t></t>
    <t class='sector sb'>#{@logs.sector_balance_percentage}% <t style='color:#999'>Sb</t></t>
    <t class='sector right'>#{@against ? against_diff(@logs.hours,@against.hours) : ''} <a href='/Horaire'>#{@logs.hours} <t style='color:#999'>Fh</t></a></t>
    <t class='sector right'>#{@against ? against_diff(@logs.hour_day_focus,@against.hour_day_focus) : ''} #{@logs.hour_day_focus} <t style='color:#999'>Hdf</t></t>
    <t class='sector right'>#{@logs.focus.trim(2)} <t style='color:#999'>Focus</t></t>"

    return "<ln>#{html}</ln>"

  end

  def against_diff current,against

    color = against.to_f < current.to_f ? "gain" : "loss"

    return current.to_f != against.to_f ? "<t class='against #{color}'>#{against.to_f < current.to_f ? '+' : ''}#{(current.to_f - against.to_f).trim(1)}</t>" : ''

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

    line_width = ((@width)/@LOD.to_f).to_i
    line_width = 2

    return "<style>
    .graph.timeline { margin-bottom:30px; font-family:'input_mono_regular'; font-size:11px;}
    .graph.timeline svg { overflow: hidden; padding-top:5px; height:149px; padding-bottom:10px}
    .graph.timeline svg path { stroke-width: #{line_width}; stroke:pink; stroke-linecap:round;}
    .graph.timeline svg path.audio { fill:#72dec2; stroke:#72dec2}
    .graph.timeline svg path.visual { fill:#000; stroke:black }
    .graph.timeline svg path.research { fill:none; stroke:#ccc }
    .graph.timeline ln { display:block; position:relative;}
    .graph.timeline t.origin { position: absolute;left: 0px;color: #999 }
    .graph.timeline t.sector { color: #000; display: inline-block;line-height: 30px; margin-right:15px;}
    .graph.timeline t.sector svg { width: 25px;height: 3px;display: inline-block;stroke: black;padding: 0px;stroke-width: 2px;stroke-linecap: round}
    .graph.timeline t.sector.audio svg { stroke:#72dec2 }
    .graph.timeline t.sector.visual svg { stroke:black }
    .graph.timeline t.sector.research svg { stroke:#ccc }
    .graph.timeline t.sector.right { float:right; margin-right:0px; margin-left:15px}
    .graph.timeline t.against { color:#fff; border-radius:30px; padding:0px 5px}
    .graph.timeline t.against.loss { background:#ccc}
    .graph.timeline t.against.gain { background:#72dec2}
    </style>"
  end

end