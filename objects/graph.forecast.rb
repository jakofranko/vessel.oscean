#!/bin/env ruby
# encoding: utf-8

class Graph_Forecast

  def initialize(logs,from = 0,to = logs.length)
    
    @logs = logs[from,to]
    @count_topics = 0

    @days_ahead = 28
    @width = 600
    @height = 75
    @line_spacing = (@width/(@days_ahead + 7).to_f).to_i

  end

  def to_s

    if @logs.length < 56 then return "" end
      
    html = ""

    graph = ""

    this_week = @logs[0,7]

    i = 0.5
    this_week.reverse.each do |log|
      graph += "<line x1='#{@line_spacing * i}' y1='#{@height}' x2='#{@line_spacing * i}' y2='#{(@height - ((log.value/10.0) * @height))}' class='#{log.sector}'></line>"
      html += "<t class='date' style='left:#{@line_spacing/3 + (@line_spacing * (i-1))}px'>#{i == 6.5 ? '<b>▾</b>' : log.time.d}</t>"
      i += 1
    end

    generate_forecast(@days_ahead).each do |log|
      graph += "<line x1='#{@line_spacing * i}' y1='#{@height}' x2='#{@line_spacing * i}' y2='#{(@height - ((log.value/10.0) * @height)).to_i}' class='forecast #{log.sector}'></line>"
      i += 1
    end

    html += "<svg class='graph' width='#{@width}' height='#{@height}'>#{graph}</svg>"


    return "#{style}<yu class='graph forecast'>#{html}</yu>"

  end

  def style

    return "<style>
    .graph.forecast { position:relative; height:#{@height + 45}px; font-family:'din_regular' }
    .graph.forecast svg { overflow: hidden; padding-top:5px; height:149px}
    .graph.forecast svg line { stroke:black; stroke-width:#{(@width/42.0).to_i - 1}; stroke-linecap:round; }
    .graph.forecast svg line.audio { fill:#72dec2; stroke:#72dec2}
    .graph.forecast svg line.visual { fill:#000; stroke:#000 }
    .graph.forecast svg line.research { fill:#ddd; stroke:#ddd }
    .graph.forecast svg line.forecast { }
    .graph.forecast ln { display:block; position:relative; font-family:'din_regular'; font-size:12px;}
    .graph.forecast t { position: absolute;top: -15px;left: 0px;color: #999; font-size:12px; color:#000; width:#{@width/21.0}px; display:block;text-align:center }
    .graph.forecast t b { font-family:'din_bold'}
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