#!/bin/env ruby
# encoding: utf-8

class CorpseHttp

  def style

    return "<style>
    .death yu { line-height: 0px }
    .death cell { display: inline-block;width: calc(1.9% - 4px);height: 5px;margin: 1px 0px 0px 1px;border-radius: 10px; background:#ccc}
    .death cell.black { background:black }
    .death hr.ten { height: 1px}
    </style>"
    
  end

  def view

    daysAgo = (Time.new.to_i - Date.new(1986,03,22).to_time.to_i)/86400
    
    html = ""
    
    time1 = Time.new
    year = 1
    while year < 60
      # html += year % 10 == 0 ? "<hr class='ten'/>" : ""
      week = 0
      while week < 52
        if (year * 52)+week < (daysAgo/7)-4
          html += "<cell class='black'></cell>"
        else
          html += "<cell></cell>"
        end
        week += 1
      end
      html += "<hr/>"
      year += 1
    end
    return "<div class='death'>#{@term.long.runes.to_s}<yu>#{html}</yu></div>"

  end

end