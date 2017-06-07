#!/bin/env ruby
# encoding: utf-8

class CorpseHttp

  def style

    return "<style>
    yu.si { display:none !important}
    .horaire { background:black; border-radius:3px}
    .horaire .task { width:230px; color:white; display:inline-block; padding:0px; margin-bottom:15px }
    .horaire .task svg { width: 70px;height: 70px;display: inline-block;border-radius: 3px; }
    .horaire .task p { font-family: 'din_regular';font-size: 11px;line-height: 15px;margin-bottom: 0px;display: inline-block;vertical-align: top;margin-top:15px;padding-left:15px;width:140px}
    .horaire .task p b { font-family:'din_medium'; font-weight:normal; text-transform: uppercase; line-height:30px }
    .horaire circle.audio { fill:#72dec2 }
    .horaire circle.visual { fill:red }
    .horaire circle.research { fill:#ccc }
    .horaire circle.focus_hours { stroke:#333; stroke-width:1px; fill:none}
    .horaire circle.focus_balance { stroke:#fff; stroke-width:1px; fill:none; stroke-dasharray:1,3; display:none}
    .horaire content.storage a { background:white }
    .horaire { margin-bottom:30px }
    .horaire p { color:white}
    ul.legend { font-size: 12px;padding: 15px 0px 0px 0px;}
    ul.legend li { font-family:'din_regular'; color:grey; line-height:15px}
    ul.legend li b { font-weight:normal; font-family:'din_medium'}
    .activity { background:black; color:white; margin-top:-30px; padding:30px; vertical-align:top; border-bottom:1px solid #efefef }
    .activity > ln { min-width:200px; display:inline-block; height:30px;overflow: hidden; font-size: 14px !important; vertical-align:top}
    .activity .value { color:#555; margin-left:10px; font-size:14px }
    #notice { font-family:'din_regular'; font-size:16px; line-height:26px; background:#fff; padding:15px 20px; border-radius:3px}
    #notice a { font-family: 'din_medium'}
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
      html += Graph_Topics.new(term).to_s
      html += Graph_Tasks.new(term).to_s
      html += Graph_Forecast.new(term).to_s
    else
      return "<p>The {{#{@query}}} entry does not contain enough {{Horaire}} logs.</p>".markup
    end
    
    return "<div class='horaire'>#{html}</div>"

  end
  
end