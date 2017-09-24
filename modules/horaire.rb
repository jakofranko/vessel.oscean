#!/bin/env ruby
# encoding: utf-8

corpse = $nataniev.vessels[:oscean].corpse

def corpse.view

  html = ""

  filtered_logs = []

  home_term = @lexicon.to_h(:term)["HOME"]

  count = 0
  home_term.logs.each do |log|
    if !log || !log.time || log.time.elapsed < 0 then next end
    filtered_logs.push(log)
    count += 1
  end

  if @term.name.like("horaire")
    
    html += "
    #{Graph_Timeline.new(filtered_logs,0,365)}

    <h2 id='hdf'>Hdf</h2>
    <p>For the past #{filtered_logs.length} days, I have rated my dedication, or enthousiasm, in the proeminent task of that day. A {*Focus Hour*}({#Fh#}), is an index of focus in a single task over the total available daily work hours. The {*Hour Day Focus*}({#Hdf#}) is the average {#Fh#} of a project or task, over a number of days; for instance, #{home_term.logs[0,365].hours}{#Fh#} over 365 days, is #{filtered_logs[0,365].hour_day_focus}{#Hdf#}. </p>
    #{Graph_Since.new(filtered_logs)}

    <h2 id='hto_hta'>HTo, HTa & Focus</h2>
    <p>The {#Fh#} sums over the number of different topics, or different tasks, are the {*Hour Topic*}({#HTo#}) and {*Hour Task*}({#HTa#}); for instance #{home_term.logs[0,365].hours}{#Fh#} over #{home_term.logs[0,365].topics.length} topics, and #{home_term.logs[0,365].tasks.length} tasks, is #{home_term.logs[0,365].hour_topic_focus}{#HTo#} and #{home_term.logs[0,365].hour_task_focus}{#HTa#}, and their average #{home_term.logs[0,365].focus.trim(2)}{#Focus#}.</p>

    #{Graph_Daily.new(home_term)}
  
    <h2 id='forecast'>Forecast</h2>
    #{Graph_Forecast.new(filtered_logs)}
    <p>Based on previous {#Fh#} trends, {*predictions*} on upcoming optimal creative sectors and time investments can be forcasted and used to make better decisions during week-planning.</p>
    <note><b>Effectiveness</b>, is doing the right thing. <br> <b>Efficiency</b>, is doing it the right way.</note>"
    return html.markup
  elsif @term.logs.length > 2
    html += Graph_Timeline.new(@term.logs).to_s
    html += Graph_Daily.new(@term).to_s
  else
    return "<p>The {{#{@query}}} entry does not contain enough {{Horaire}} logs.</p>".markup
  end
  
  return "<div class='horaire'>#{html}</div>"

end