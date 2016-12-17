#!/bin/env ruby
# encoding: utf-8

class CorpseHttp

  def style

    return "<style>
    yu.cr { background:black; }
    yu.si { display:none !important}
    .horaire .task { width:140px; color:white; display:inline-block; padding:15px; }
    .horaire .task svg { width:140px; height:140px }
    .horaire .task p { border-top: 1px solid #555;font-family: 'din_regular';font-size: 11px;line-height: 15px;margin-bottom: 0px;padding-top: 14px }
    .horaire .task p b { font-family:'din_bold'; font-weight:normal; text-transform: uppercase; }
    .horaire circle.audio { fill:#72dec2 }
    .horaire circle.visual { fill:red }
    .horaire circle.research { fill:#ccc }
    .horaire content.storage a { background:white }
    .horaire { margin-bottom:30px }
    .horaire p { color:white}
    </style>"

  end

  def view

    html = ""

    if term.logs.length > 0
      html += Graph_Timeline.new(term.logs).to_s
      html += tasks
    else
      html += "<p>The lexicon entry {{@query}} does not contain any {{Horaire}} log.</p>"
    end
    
    return "<div class='horaire'>#{html}</div>"

  end

  def tasksData

    h = {}
    term.logs.each do |log|
      if !h[log.task] then h[log.task] = {"name" => log.task, "hours" => 0, "logs" => 0} end
      h[log.task]["hours"] += log.value
      h[log.task]["logs"] += 1
      h[log.task]["sector"] = log.sector
    end

    return h

  end

  def tasks

    tasksHash = tasksData
    html = ""

    $sum_hours = 0
    $sum_logs = 0
    $max_hours = 0
    $max_logs = 0
    tasksHash.sort.each do |name,data|
      if name == "" then next end
      if data['hours'] > $max_hours then $max_hours = data['hours'] end
      if data['logs'] > $max_logs then $max_logs = data['logs'] end
      $sum_hours += data['hours']
      $sum_logs += 1
    end

    tasksHash.sort.each do |name,data|
      if name == "" then next end
      html += taskView(data)
    end

    return html

  end

  def taskView task

    max_radius = 65

    radius = (task['hours']/$max_hours.to_f) * max_radius
    percentage = (((task['hours']/$sum_hours.to_f) * 1000).to_i)/10.to_f

    return "
    <div class='task'>
      <svg>
        <circle cx='70' cy='70' r='#{radius}' class='#{task['sector']}' />
      </svg>
      <p><b>#{task['name']}</b><span style='float:right; color:grey'>#{percentage}%</span><br />#{task['hours']} Hours <br />#{task['logs']} Logs</p>
    </div>"

  end
  
end
