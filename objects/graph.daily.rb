#!/bin/env ruby
# encoding: utf-8

class Graph_Daily

  def initialize(term,from = 0,to = term.logs.length)
    
    @logs = term.logs[from,to]
    @count_topics = 0
    @width = 800
    @cell_width = (@width / 52.0).to_i
    @cell_height = @cell_width/2

  end

  def to_s

    html = ""

    logs = horaire_hash
    now = Date.today
    d = 0
    while d < 365
      date = (now - d).to_s.gsub("-","")
      pos_y = d % 7
      pos_x = (d / 7).to_i
      html += "<cell class='#{logs[date] ? logs[date] : ''}' style='bottom:#{30 + (pos_y * @cell_height)}px; right:#{(pos_x * @cell_width)}px'></cell>"
      d += 1
    end
    html += "<hr />"

    return "#{style}<yu class='graph daily'>#{html}</yu>"

  end

  def style

    return "<style>
    .graph.daily { position:relative; height:70px; border-bottom:1px solid #000; margin-bottom:30px}
    .graph.daily cell { display:block; height:#{@cell_height - 2}px; width:#{@cell_width - 2}px; background:#222; display:block; border-radius:1px; float:left; margin-bottom:1px; margin-right:1px; position:absolute; border-radius:10px}
    .graph.daily cell.audio { background:#72dec2}
    .graph.daily cell.visual { background:#000}
    .graph.daily cell.research { background:#ccc}
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