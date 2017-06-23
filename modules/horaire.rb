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
      html += "<p>#{@term.bref}</p>#{@term.long.runes}\n"      
      html += Graph_Timeline.new(home_term).to_s
      html += "<p style='margin-bottom:60px'>The average daily {_Fh_}, is the {*Hour Day Focus*} {_Hdf_} - an index of average focus in a specific project, where its optimal value is 9. In the above graph, the average {_Fh_}, of #{home_term.logs.hours}{_Fh_} over #{home_term.logs.length} days, is equal to #{home_term.logs.hour_day_focus}{_Hdf_}. </p>".markup
      html += Graph_Topics.new(home_term).to_s
      html += "<p style='margin-bottom:60px'>This graph introduces the {*Hour Topic*} {_HTo_} & the {*Hour Task*} {_HTa_} - where {_HTo_} is the sum of logged {_Fh_} over the number of different topics, or #{home_term.logs.hours}{_Fh_} over #{home_term.logs.topics.length} topics and {_HTa_} is the sum of logged {_Fh_} over the number of different tasks, or #{home_term.logs.hours}{_Fh_} over #{home_term.logs.tasks.length} tasks.</p>".markup
      html += Graph_Tasks.new(home_term).to_s
      html += "<p>The following graph is the forecast graph, it predicts per-sector(Audio, Visual or Research) {_Fh_} values, based on previous monthly {_Hdf_}. Its purpose is to better allocate time to a specific sector before this sector's predicted {_Hdf_} falls below the previous average optimal focus.</p>".markup
      html += Graph_Forecast.new(home_term).to_s
      return html
    elsif term.logs.length > 2
      html += Graph_Timeline.new(term).to_s
      html += Graph_Daily.new(term).to_s
      html += Graph_Topics.new(term).to_s
      html += Graph_Tasks.new(term).to_s
      html += Graph_Forecast.new(term).to_s
    else
      return "<p>The {{#{@query}}} entry does not contain enough {{Horaire}} logs.</p>".markup
    end
    
    return "<div class='horaire'>#{html}</div>"

  end
  
end