#!/bin/env ruby
# encoding: utf-8

class Graph_Overview

  def initialize(term,from = 0,to = term.logs.length)
    
    @logs = term.logs[from,to]
    @size = 30
    @full = 44

  end

  def to_s

    html = @logs.research_ratio > 0 ? "<circle cx='#{@size/2}' cy='#{@size/2}' r='#{@size/4}' class='research' />" : ''
    html += @logs.visual_ratio > 0 ? "<circle cx='#{@size/2}' cy='#{@size/2}' r='#{@size/4}' class='visual' />" : ''
    html += @logs.audio_ratio > 0 ? "<circle cx='#{@size/2}' cy='#{@size/2}' r='#{@size/4}' class='audio_mask' />" : ''
    html += @logs.audio_ratio > 0 ? "<circle cx='#{@size/2}' cy='#{@size/2}' r='#{@size/4}' class='audio' />" : ''
    # html += "<circle cx='#{@size/2}' cy='#{@size/2}' r='#{@size/4}' class='hdf' />"

    return "#{style}<yu class='graph overview'><svg style='width:#{@size}px; height:#{@size}px;'>#{html}</svg>#{summary}</yu>"

  end

  def style

    return "<style>
    .graph.overview { float:right}
    .graph.overview svg { margin-left:10px; display:inline-block; float:right}
    .graph.overview circle { fill: none; stroke:black; stroke-width:#{5}px}
    .graph.overview circle.audio { stroke:#72dec2; stroke-dasharray:#{@full * @logs.audio_ratio},999}
    .graph.overview circle.audio_mask { stroke:#fff; stroke-dasharray:#{@full * @logs.audio_ratio},999; stroke-width:15px}
    .graph.overview circle.visual { stroke:#000; stroke-dasharray:#{@full * (@logs.audio_ratio + @logs.visual_ratio)},999}
    .graph.overview circle.research { stroke:#ccc; stroke-dasharray:#{@full * (@logs.audio_ratio + @logs.visual_ratio + @logs.research_ratio)},999}
    .graph.overview circle.hdf { stroke:#fff; stroke-width:1; stroke-dasharray:#{@full * @logs.hour_day_focus_ratio},999 }
    .graph.overview .summary { font-family: 'din_regular';font-size: 12px;display: inline-block;line-height: 30px;vertical-align: top;}
    .graph.overview .summary a { display:inline-block; margin-left:10px}
    .graph.overview .summary a:hover { text-decoration:underline}
    </style>"
  end

  def summary

    html = "
    <a href='/Horaire#hdf'>#{@logs.hours}<t style='color:#999'>Fh</t></a></a>
    <a href='/Horaire#hdf'>#{@logs.hour_day_focus}<t style='color:#999'>Hdf</t></a>
    <a href='/Horaire#hto_hta'>#{@logs.hour_task_focus}<t style='color:#999'>HTa</t></a>
    <a href='/Horaire#hto_hta'>#{@logs.hour_topic_focus}<t style='color:#999'>HTo</t></a>"

    return "<ln class='summary'>#{html}</ln><hr />"

  end

end