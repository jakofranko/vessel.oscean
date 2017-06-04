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
  .activity > ln { width:33%; min-width:200px; display:inline-block; height:30px;overflow: hidden; font-size: 14px !important; vertical-align:top}
  .activity .value { color:#555; margin-left:10px; font-size:14px }
  #notice { font-family:'din_regular'; font-size:16px; line-height:26px; background:#fff; padding:15px 20px; border-radius:3px}
  #notice a { font-family: 'din_medium'}
    </style>"

  end

  def view

    html = ""

    if term.logs.length > 2
      html += Graph_Timeline.new(term).to_s
      html += Graph_Overview.new(term).to_s
      html += tasks
      html += legend
    else
      return "<p>The {{#{@query}}} entry does not contain enough {{Horaire}} logs.</p>".markup
    end
    
    return "<div class='horaire'>#{html}</div>"

  end

  def tasks

    tasksHash = term.tasks
    html = ""

    $sum_hours = 0
    $sum_logs = 0
    $max_hours = 0
    $max_logs = 0
    tasksHash.sort.each do |name,data|
      if name == "" then next end
      if data[:sum_hours] > $max_hours then $max_hours = data[:sum_hours] end
      if data[:sum_logs] > $max_logs then $max_logs = data[:sum_logs] end
      $sum_hours += data[:sum_hours]
      $sum_logs += 1
    end

    tasksHash.sort_by {|_key, value| value[:sum_hours]}.reverse.each do |name,data|
      if name == "" then next end
      if data[:sum_hours] == 0 then next end
      html += Task.new(data,$max_hours).to_s
    end

    return html

  end

  def legend

    return "
    <ul>
      <li>* <b>Focus Hours</b>, FH, are the sum of a task's logged hours over the number of days.</li>
      <li>* <b>Focus Balance</b>, FB, is the index of a task's logged hours balanced over the audio, visual and research sectors.</li>
    </ul>"
  end
  
end