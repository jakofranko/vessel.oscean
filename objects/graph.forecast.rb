#!/bin/env ruby
# encoding: utf-8

class Graph_Forecast

  def initialize(term,from = 0,to = term.logs.length)
    
    @logs = term.logs[from,to]
    @count_topics = 0

    @days_ahead = 14
    @width = 620
    @height = 120
    @line_spacing = (@width/(@days_ahead + 7).to_f).to_i

  end

  def to_s

    html = ""

    # Find all time ratio


    graph = ""

    this_week = @logs[0,7]

    i = 0.5
    this_week.reverse.each do |log|
      graph += "<line x1='#{@line_spacing * i}' y1='#{@height}' x2='#{@line_spacing * i}' y2='#{(@height - ((log.value/10.0) * @height)) + @line_spacing}' class='#{log.sector}'></line>"
      html += "<span class='date' style='left:#{@line_spacing/2 + (@line_spacing * i)}px'>#{i == 6.5 ? '<b>today</b>' : log.date.day}</span>"
      i += 1
    end

    generate_forecast(@days_ahead).each do |log|
      graph += "<line x1='#{@line_spacing * i}' y1='#{@height}' x2='#{@line_spacing * i}' y2='#{(@height - ((log.value/10.0) * @height)) + @line_spacing}' class='forecast #{log.sector}'></line>"
      html += "<span class='date' style='left:#{@line_spacing/2 + (@line_spacing * i)}px'>#{log.date.day}</span>"
      html += "<span class='rating' style='left:#{@line_spacing/2 + (@line_spacing * i)}px'>#{log.forecast > 0.33 ? (log.forecast * 100).to_i.to_s : ''}</span>"
      i += 1
    end

    html += "<span class='this_week' style='width:#{@line_spacing*6}px; left:#{@line_spacing * 1.5}px'><b>This Week</b></span>"

    html += "<svg class='graph' width='#{@width}' height='#{@height}'>#{graph}</svg>"


    return "#{style}<yu class='graph_wrapper' style='background:black; padding:30px; margin-bottom:30px'>#{html}</yu>"

  end

  def style

    return "<style>
    .graph { background:black; border-bottom:1px solid #333}
    .graph line { stroke-width: #{@line_spacing-1}px; }
    .graph line.forecast { stroke-dasharray:1,1; }
    .graph line.audio { stroke:#72dec2 }
    .graph line.visual { stroke:#f00 }
    .graph line.research { stroke:#fff }
    .graph_wrapper { position:relative }
    .graph_wrapper span.date { position: absolute;color: grey;top:160px;font-size:11px;font-family: 'din_regular'; width: #{@line_spacing}px; display:block; text-align:center}
    .graph_wrapper span.date b { color:white; font-weight:normal}
    .graph_wrapper span.rating { position: absolute;color: white;top:30px;font-size:11px;font-family: 'din_medium';  width: #{@line_spacing}px; display:block; text-align:center}
    .graph_wrapper span.this_week { position: absolute;color: white;top:30px;font-size:11px;font-family: 'din_medium';  width: #{@line_spacing}px; display:block; text-align:center; height:6px; border-bottom:1px dotted #999}
    .graph_wrapper span.this_week b { background: black;padding:0px 10px;font-weight: normal}
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