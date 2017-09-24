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
    #{@term.long.runes}
    #{Graph_Since.new(filtered_logs)}
    <h2 id='hdf'>Hdf</h2>
    #{Graph_Daily.new(home_term)}
    <mini>Daily log sectors for the past 365 days.</mini>
    <p>The average daily {_Fh_}, or the {*Hour Day Focus*} {_Hdf_}, is an index of average focus on a specific project or task. The average {_Fh_}, of #{home_term.logs[0,365].hours}{*Fh*} over #{home_term.logs[0,365].length}{*days*}, is equal to #{home_term.logs[0,365].hour_day_focus}{*Hdf*}. Its maximal value is 9, so the Hdf ratio is currently of #{home_term.logs[0,365].hour_day_focus_percentage}%.</p>
    <h2 id='hto_hta'>HTo/HTa</h2>
    <mini>Sector balance for the previous {{13 months|Desamber}}.</mini>
    <p>The {*Hour Topic*} {_HTo_} & the {*Hour Task*} {_HTa_} - where {_HTo_} is the sum of {_Fh_} over the number of different topics, or #{home_term.logs[0,365].hours}{_Fh_} over #{home_term.logs[0,365].topics.length} topics, and {_HTa_} the sum of logged {_Fh_} over the number of different tasks, or #{home_term.logs[0,365].hours}{_Fh_} over #{home_term.logs[0,365].tasks.length} tasks.</p>
    <h2 id='forecast'>Forecast</h2>
    #{Graph_Forecast.new(filtered_logs)}
    <mini>Fh & Sector forecast for the next 7 days.</mini>
    <p>And finally, based on previous {_Fh_} trends and ratios, {*predictions*} on upcoming optimal creative sectors and time investments can be forcasted and used to make better decisions during week-planning.</p>
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