#!/bin/env ruby
# encoding: utf-8

class Graph_Yearly

  def initialize(term,from = 0,to = term.logs.length)
    
    @logs = term.logs[from,to]
    @width = 800
    @height = 75
    @line_width = @width/13.0

    h = {}

    @logs.each do |log|
      if log.date.month_name.to_s.like("year day") then next end
      if log.date.month_name.to_s.like("leap day") then next end
      if !h[log.date.month_name] then h[log.date.month_name] = {} ; h[log.date.month_name] = {:sum => 0, :audio => 0, :visual => 0, :research => 0, :misc => 0} end
      h[log.date.month_name][log.sector] += log.value
      h[log.date.month_name][:sum] += log.value
    end

    @logs_by_desamber = h.to_a.reverse

  end

  def to_s

    html = ""

    svg = ""
    m = 0
    @logs_by_desamber.each do |month,sectors|
      pos_x = @line_width * m + (@line_width/2)

      r_audio = (((sectors[:audio]/sectors[:sum].to_f) * @height).to_i)/2
      r_visual = (((sectors[:visual]/sectors[:sum].to_f) * @height).to_i)/2
      r_research = (((sectors[:research]/sectors[:sum].to_f) * @height).to_i)/2

      pos_audio = ((sectors[:audio]/sectors[:sum].to_f) * @height).to_i
      pos_visual = (((sectors[:audio] + sectors[:visual])/sectors[:sum].to_f) * @height).to_i
      pos_research = (((sectors[:audio] + sectors[:visual] + sectors[:research])/sectors[:sum].to_f) * @height).to_i
      
      svg += "<circle cx='#{pos_x}' cy='#{r_audio}' r='#{r_audio}' stroke='#72dec2'/>"
      svg += "<circle cx='#{pos_x}' cy='#{r_visual + pos_audio}' r='#{r_visual}' fill='#000'/>"
      svg += "<circle cx='#{pos_x}' cy='#{r_research + pos_visual}' r='#{r_research}' fill='#ddd'/>"
      svg += "<text x='#{pos_x}' y='95' fill='#000'>#{month[0,4]}</text>"

      m += 1
    end

    return "#{style}
    <yu class='graph yearly'>
      <svg width='#{@width}' height='#{@height}'>#{svg}</svg>
    </yu>"

  end

  def style

    return "<style>
    .graph.yearly { margin-bottom:15px; }
    .graph.yearly svg { padding-bottom:30px; }
    .graph.yearly text { font-family:'din_regular'; font-size:12px; text-anchor:middle;}
    .graph.yearly svg circle { fill: none; stroke-width:2}
    </style>"

  end

end