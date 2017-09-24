#!/bin/env ruby
# encoding: utf-8

class Graph_Overview

  def initialize(term,from = 0,to = term.logs.length)
    
    @term = term
    @logs = term.logs[from,to]

    @width = 140
    @height = 35
    @LOD = 40
    @segments = equalSegments

  end

  def segmentMemory

    memory = []
    i = 0
    while i < @LOD
      memory[i] = 0
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
      progressFloat = (log.time.elapsed/@to.to_f) * @LOD.to_f
      progressPrev = progressFloat.to_i
      progressNext  = progressFloat.ceil
      distributePrev = progressNext - progressFloat
      distributeNext = 1 - distributePrev
      if segments[progressPrev] then segments[progressPrev] += log.value * distributePrev end
      if segments[progressNext] then segments[progressNext] += log.value * distributeNext end
    end
    return segments

  end

  def find_highest

    max = 0
    @segments.each do |value|
      max = value > max ? value : max
    end
    return max

  end

  def to_s

    html = ""
    line_width = ((@width)/@LOD.to_f).to_i + 1
    highest = find_highest
    
    d = "M-#{line_width},#{@height} "
    c = 0

    seg_prev = 0
    seg_next = 0
    @segments.reverse.each do |v|
      value = v
      soft_value = (seg_prev+value+seg_next)/3.0
      value = (soft_value / highest) * @height
      d += "L#{(c * line_width).to_i},#{(@height - (value)).to_i} "
      c += 1
      seg_next = @segments.reverse[c+1] ? @segments.reverse[c+1] : @segments.reverse[c]
      seg_prev = v
    end

    return "#{style}<yu class='graph overview'><a href='/#{@term.name}:Horaire'><svg style='width:#{@width}px; height:#{@height}px;'><path d='#{d}'/></svg></a></yu>"

  end

  def style

    return "<style>
    .graph.overview svg { padding-bottom:5px; padding-left:15px; padding-right:8px}
    .graph.overview svg path { stroke-width:1; stroke:black; fill:none; stroke-linecap:round}
    </style>"
    
  end

  def summary

    html = "<a href='/Horaire'><b>#{@logs.hours}</b>Fh</a></a> <a href='/Horaire#hdf'><b>#{@logs.hour_day_focus}</b>Hdf</a> <a href='/#{@term.name}:Horaire'>Updated #{@logs.first.time.ago}</a>"

    return "<ln class='summary'>#{html}</ln><hr />"

  end

end