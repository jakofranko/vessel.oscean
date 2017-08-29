#!/bin/env ruby
# encoding: utf-8

corpse = $nataniev.vessel.corpse

corpse.style = "
span.result { background:white; font-family:'din_medium'; font-size:12px; color:white; display:block; overflow:hidden; position:relative; height:30px; border-radius:3px; margin-bottom:5px; background:#ccc}
span.bar { background: black;min-width: 175px;display: block;height:30px;position: absolute;top:0px;left:0px; z-index:900; color:white; position:absolute; line-height: 30px;padding-left:15px}
span.value { float:right; padding-right:15px; color:#999}
span.result a:hover { text-decoration:underline}
span.result t.time_left { float: right;line-height: 30px;margin-right:15px;}
span.result t.hours { color:#999}"

def corpse.view

  count = @horaire.to_a(:log).length
  cats = {:sector => {},:task => {}}
  @horaire.to_a(:log).each do |log|
    if log.sector == :misc then next end
    if !log.task then next end
    if !cats[:sector][log.sector] then cats[:sector][log.sector] = {:logs => 0, :hours => 0} end
    if !cats[:task][log.task] then cats[:task][log.task] = {:logs => 0, :hours => 0} end
    cats[:sector][log.sector][:hours] += log.value
    cats[:sector][log.sector][:logs] += 1
    cats[:task][log.task][:hours] += log.value
    cats[:task][log.task][:logs] += 1
  end

  html = "#{@term.long.runes}\n"

  cats.each do |cat,elements|
    html += "<h2>By #{cat.capitalize}</h2>"
    html += "<yu style='margin-bottom:30px'>"
    elements.sort_by {|_key, value| value[:hours]}.reverse.each do |k,values|
      perc = values[:hours]/100.0
      per_log = values[:hours]/count.to_f
      time_left = (10000 - values[:hours])/per_log
      time_left = time_left/365.0
      html += "<span class='result'><span class='bar' style='width:#{perc}%'>#{k.capitalize} <t class='hours'>#{values[:hours]}h</t><span class='value'>#{perc.to_i}%</span></span><t class='time_left'>#{time_left.trim(1)} years left</t></span>"
    end
    html += "</yu>"
  end
  return html

end