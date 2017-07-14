#!/bin/env ruby
# encoding: utf-8

class CorpseHttp

  def style

    return "<style>
    </style>"

  end

  def view

    html = ""

    if term.name.like("horaire")
      home_term = $lexicon.to_h("term")["HOME"]
      html += "
      #{Graph_Timeline.new(home_term,0,365)}
      #{@term.long.runes}
      <h2 id='hdf'>Hdf</h2>
      #{Graph_Daily.new(home_term)}
      <mini>Daily log sectors for the past 365 days.</mini>
      <p>The average daily {_Fh_}, or the {*Hour Day Focus*} {_Hdf_}, is an index of average focus on a specific project or task. The average {_Fh_}, of #{home_term.logs.hours}{*Fh*} over #{home_term.logs.length}{*days*}, is equal to #{home_term.logs.hour_day_focus}{*Hdf*}. Its maximal value is 9, so the Hdf ratio is currently of #{home_term.logs.hour_day_focus_percentage}%.</p>
      <h2 id='hto_hta'>HTo/HTa</h2>
      #{Graph_Yearly.new(home_term,0,365)}
      <mini>Sectors for the previous 13 months.</mini>
      <p>The {*Hour Topic*} {_HTo_} & the {*Hour Task*} {_HTa_} - where {_HTo_} is the sum of {_Fh_} over the number of different topics, or #{home_term.logs.hours}{_Fh_} over #{home_term.logs.topics.length} topics, and {_HTa_} the sum of logged {_Fh_} over the number of different tasks, or #{home_term.logs.hours}{_Fh_} over #{home_term.logs.tasks.length} tasks.</p>
      <h2 id='forecast'>Forecast</h2>
      #{Graph_Forecast.new(home_term)}
      <mini>Fh & Sector forecast for the next 7 days.</mini>
      <p>Based on previous {_Fh_} trends and ratios, predictions on upcoming optimal creative sectors and investments can be forcasted.</p>"
      return html.markup
    elsif term.logs.length > 2
      html += Graph_Timeline.new(term).to_s
      html += Graph_Daily.new(term).to_s
    else
      return "<p>The {{#{@query}}} entry does not contain enough {{Horaire}} logs.</p>".markup
    end
    
    return "<div class='horaire'>#{html}</div>"

  end
  
end