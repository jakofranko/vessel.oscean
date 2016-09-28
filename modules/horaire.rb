#!/bin/env ruby
# encoding: utf-8

class Oscea

  class Corpse

    def style

      return "<style>
      yu.cr { background:black }
      .horaire .task { width:140px; color:white; display:inline-block; padding:15px; }
      .horaire .task svg { width:140px; height:140px }
      .horaire .task p { border-top: 1px solid #555;font-family: 'dinregular';font-size: 11px;line-height: 15px;margin-bottom: 0px;padding-top: 14px }
      .horaire .task p b { font-family:'dinbold'; font-weight:normal; text-transform: uppercase; }
      .horaire circle.audio { fill:#72dec2 }
      .horaire circle.visual { fill:red }
      .horaire circle.research { fill:#ccc }
      .horaire content.storage a { background:white }
      .horaire { margin-bottom:30px }
      </style>"

    end

    def view

      html = ""
      
      @graphData = graphData
      if @graphData.length > 0 
        html += Graph.new(@graphData).to_s
      end
      html += tasks

      return "<wr class='horaire'>#{html}</wr>"

    end

    def graphData

      graphData = []
      $horaire.to_a("log").each do |log|
        if @term.name != "Horaire" && log.topic != @term.name then next end
        if log.sector == "misc" then next end
        graphData.push(log)
      end
      return graphData

    end

    def tasksData

      hash = {}
      $horaire.to_a("log").each do |log|
        if @term.name != "Horaire" && log.topic != @term.name then next end
        if log.sector == "misc" then next end
        if !hash[log.task] then hash[log.task] = {"name" => log.task, "hours" => 0, "logs" => 0} end
        hash[log.task]["hours"] += log.value
        hash[log.task]["logs"] += 1
        hash[log.task]["sector"] = log.sector
      end

      return hash

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

end