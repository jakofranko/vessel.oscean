#!/bin/env ruby
# encoding: utf-8

class Graph_Since

  attr_accessor :render
  
  def initialize(logs)
    
    @logs = logs
    @width = 800
    @height = 130
    @render = generate

  end

  def style

    return "<style>
    .graph.since svg { width:#{@width}px; height:#{@height + 100}px; padding-bottom:30px; padding-top:60px; font-family:'input_mono_regular'; font-size:11px; padding-left:2px}
    .graph.since svg path { stroke:#ccc; fill:none; stroke-width:2; stroke-linecap:round}
    .graph.since svg path.hour_day_focus { stroke:#000; z-index:9000; position:relative}
    .graph.since svg path.sector_balance { stroke:#72dec2; }
    .graph.since svg path.focus { stroke:#000; stroke-dasharray:2,3; }
    .graph.since svg path.spray { stroke:#ccc }
    .graph.since svg text.year { fill:#aaa}
    .graph.since svg text.focus { fill:#000}
    .graph.since svg text.hour_day_focus { font-family:'input_mono_medium'}
    .graph.since svg text.sector_balance { font-family:'input_mono_medium'; fill:#72dec2}
    .graph.since svg text.spray { fill:#aaa}
    </style>"

  end

  def per_year

    h = {}

    @logs.reverse.each do |log|
      if log.date.y < 2009 then next end
      if !h[log.date.y] then h[log.date.y] = [] end
      h[log.date.y].push(log)
    end

    return h

  end

  def generate

    h = {}
    per_year.each do |year,logs|
      if !h[:hour_day_focus] then h[:hour_day_focus] = {} end
      h[:hour_day_focus][year] = logs.hour_day_focus.to_f
      if !h[:sector_balance] then h[:sector_balance] = {} end
      h[:sector_balance][year] = logs.sector_balance.to_f
      h[:sector_balance][year] = h[:sector_balance][year] < 0 ? 0.0 : h[:sector_balance][year].to_f
      if !h[:focus] then h[:focus] = {} end
      h[:focus][year] = logs.focus.to_f
      if !h[:spray] then h[:spray] = {} end
      h[:spray][year] = logs.spray.to_f
    end
    return h

  end

  def find_max values

    max = 0
    values.each do |year,value|
      max = max < value ? value : max
    end
    return max.to_f

  end

  def find_min values

    min = 0
    values.each do |year,value|
      min = min > value ? value : min
    end
    return min.to_f

  end

  def to_s

    html = ""
    paths = ""
    circles = ""
    labels = ""
    v = 0

    @render.sort.reverse.each do |stat,values|
      path = ""
      i = 0
      segment_width = @width/values.length.to_f
      max_value = find_max(values)
      min_value = find_min(values)

      values.each do |year,value|
        x = (segment_width*i)
        y = @height - ((value/max_value) * @height)
        y = (y/5.0).to_i * 5
        path += path == "" ? "M#{x},#{y} " : "L#{x},#{y} "
        circles += "<circle class='#{stat}' cx='#{x}'  cy='#{y}' r='1.5'/>"
        # Create text headers
        if stat == :hour_day_focus
          labels += "<text class='year' x='#{segment_width*i}' y='-45'>#{year}</text>"
        end
        if year == 2009
          labels += "<text class='year' x='#{0}' y='#{(@height+100) - (v * 15)}'>#{stat.to_s.gsub('_',' ').capitalize}</text>"
        elsif year == 2010
          labels += ""
        else
          labels += "<text class='#{stat}' x='#{segment_width*i}' y='#{(@height+100) - (v * 15)}'>#{value.trim(2)}</text>"
        end
        
        i += 1
      end
      paths += "<path class='#{stat}' d='#{path}'/>"
      v += 1
    end

    return "#{style}<yu class='graph since'><svg>#{paths}#{circles}#{labels}</svg></a></yu>"

  end

end