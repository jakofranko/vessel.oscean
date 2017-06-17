#!/bin/env ruby
# encoding: utf-8

class Graph_Daily

  def initialize(term,from = 0,to = term.logs.length)
    
    @logs = term.logs[from,to]
    @count_topics = 0

  end

  def to_s

    html = ""

    logs = horaire_hash
    cell_width = (630 / 52.0).to_i
    now = Date.today
    d = 0
    while d < 365
      date = (now - d).to_s.gsub("-","")
      pos_y = d % 7
      pos_x = (d / 7).to_i
      html += "<cell class='#{logs[date] ? logs[date] : ''}' style='bottom:#{30 + (pos_y * cell_width)}px; right:#{30 + (pos_x * cell_width)}px'></cell>"
      d += 1
    end
    html += "<hr />"

    return "#{style}<yu class='graph_wrapper graph_daily' style='background:black; padding:30px; margin-bottom:30px; color:white'>#{html}</yu>"

  end

  def style

    cell_width = (630 / 52.0).to_i

    return "<style>
    .graph_daily { position:relative; height:55px; border-bottom:1px solid #efefef}
    .graph_daily cell { display:block; height:#{cell_width - 2}px; width:#{cell_width - 2}px; background:#222; display:block; border-radius:1px; float:left; margin-bottom:1px; margin-right:1px; position:absolute;}
    .graph_daily cell.audio { background:#72dec2}
    .graph_daily cell.visual { background:#f00}
    .graph_daily cell.research { background:#fff}
    </style>"

  end

  def horaire_hash

    hash = {}
    @logs.each do |log|
      hash[log.time.to_s] = log.sector
    end
    return hash

  end

end