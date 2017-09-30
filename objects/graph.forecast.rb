#!/bin/env ruby
# encoding: utf-8

class Graph_Forecast

  def initialize(logs,from = 0,to = logs.length)
    
    @logs = logs[from,to]
    @count_topics = 0

    @days_ahead = 21
    @width = 800
    @height = 75
    @line_spacing = (@width/(@days_ahead + 7).to_f).to_i

    @y = {}
    @y[:audio] = 10
    @y[:visual] = 30
    @y[:research] = 50

  end

  def build_graph

    a = []

    i = 0.5
    @logs[0,7].reverse.each do |log|
      a.push({:day => log.time.d, :sector => log.sector, :value => log.value, :past => true})
    end

    generate_forecast(@days_ahead).each do |log|
      a.push({:day => log.time.d, :sector => log.sector, :value => log.value})
    end

    return a

  end

  def to_s

    if @logs.length < 56 then return "" end
    
    graph_data = build_graph

    html = ""
    circles = ""
    labels = ""
    path = "M60,#{@y[graph_data[0][:sector]]} "

    lines = ""

    # lines += "<line x1='60' y1='#{@y[:audio]}' x2='#{@width-60}' y2='#{@y[:audio]}'/>"
    # lines += "<line x1='60' y1='#{@y[:visual]}' x2='#{@width-60}' y2='#{@y[:visual]}'/>"
    # lines += "<line x1='60' y1='#{@y[:research]}' x2='#{@width-60}' y2='#{@y[:research]}'/>"

    arc = 10
    i = 0
    prev = @y[graph_data[0][:sector]]
    graph_data.each do |vertex|
      seg_width = (@width/graph_data.length)
      x = i * (arc * 2) + 60
      y = @y[vertex[:sector]]
      if prev > y
        path += "a#{arc},#{arc} 0 0,0 #{arc},-#{arc} "
        path += "L#{x-arc},#{y+arc}"
        path += "a#{arc},#{arc} 0 0,1 #{arc},-#{arc} "
        path += "L#{x},#{y} "
      elsif prev < y
        path += "a#{arc},#{arc} 0 0,1 #{arc},#{arc} "
        path += "L#{x-arc},#{y-arc}"
        path += "a#{arc},#{arc} 0 0,0 #{arc},#{arc} "
        path += "L#{x},#{y} "
      else
        path += "L#{x},#{y} "
      end
      circles += "<circle cx='#{x}' cy='#{y}' r='1.5'/>"
      prev = y
      i += 1
    end

    lines += "<line x1='#{graph_data.length * (arc * 2) + 45}' y1='#{@y[graph_data.last[:sector]]}' x2='#{@width}' y2='#{@y[graph_data.last[:sector]]}' style='stroke:black; stroke-dasharray:2,4'/>"

    lines += "<line x1='#{7.5 * (arc * 2) + 30}' y1='#{0}' x2='#{7.5 * (arc * 2) + 30}' y2='#{65}' style='stroke:black; stroke-dasharray:2,4'/>"
    labels += "<text x='#{6.8 * (arc * 2) + 30}' y='#{-15}'>Today</text>"

    lines += "<line x1='#{28.5 * (arc * 2) + 30}' y1='#{0}' x2='#{28.5 * (arc * 2) + 30}' y2='#{65}' style='stroke:black; stroke-dasharray:2,4'/>"
    labels += "<text x='#{27.2 * (arc * 2) + 30}' y='#{-15}'>In 21 Days</text>"


    labels += "<text x='2' y='#{@y[:audio]+2}'>Audio</text>"
    labels += "<text x='2' y='#{@y[:visual]+2}'>Visual</text>"
    labels += "<text x='2' y='#{@y[:research]+2}'>Research</text>"
    html += "<svg class='graph' width='#{@width}' height='#{@height}'>#{lines}<path d='#{path}'/>#{circles}#{labels}</svg>"

    return "#{style}<yu class='graph forecast'>#{html}</yu>"

  end

  def style

    return "<style>
    .graph.forecast { position:relative; height:#{@height + 45}px; font-family:'din_regular'; margin-bottom:30px }
    .graph.forecast svg { overflow: hidden; padding-top:5px; height:149px; padding-top:30px; font-size:11px}
    .graph.forecast svg path { stroke:black; stroke-width:2; stroke-linecap:round; fill:none }
    .graph.forecast svg line { stroke:#ccc; stroke-width:2; stroke-linecap:round; fill:none }
    .graph.forecast svg circle { stroke:black; fill:black; stroke-width:0 }
    </style>"

  end

  def generate_forecast days_count

    forecast = []

    logs = @logs
    i = 0
    while i < days_count
      next_day = find_next_day(i+1,logs)
      logs.insert(0,next_day)
      forecast.push(next_day)
      i += 1
    end

    return forecast

  end

  def calculate_offset a,b

    return { :audio => a.audio_ratio - b.audio_ratio, :visual => a.visual_ratio - b.visual_ratio, :research => a.research_ratio - b.research_ratio }

  end

  def find_next_day id,logs

    all_time_logs = logs[29,56]
    recent_logs = logs[0,28]
    offset = calculate_offset(all_time_logs,recent_logs)
    offset_sorted = offset.sort_by {|_key, value| value}.reverse

    next_sector = offset_sorted.first.first
    next_fh = ((offset_sorted.first.last) * 66 + all_time_logs.sector_hour_day_focus(next_sector))/2
    if next_fh > 9 then next_fh = 9 end
    next_rating = offset_sorted.first.last - offset_sorted.last.last
    next_date = DateTime.parse((Time.now + (86400*id)).to_s).strftime("%Y%m%d")

    new_log = Log.new({"DATE" => next_date, "CODE" => generate_code(next_sector,next_fh)})
    new_log.forecast = next_fh/10

    return new_log

  end

  def generate_code sector,value

    if sector == :audio    then sector_code = 1 end
    if sector == :visual   then sector_code = 2 end
    if sector == :research then sector_code = 3 end

    return "- #{sector_code}#{value.to_i}"

  end

end