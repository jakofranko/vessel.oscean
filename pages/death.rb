#!/bin/env ruby
# encoding: utf-8

corpse = $nataniev.vessels[:oscean].corpse

corpse.style = "
.death yu { line-height: 0px; margin-bottom:30px }
.death cell { display: inline-block;width: calc(100% / 52);height: 5px;margin: 0px;border-radius: 10px; background:#ccc; margin-bottom:1px;}
.death cell.black { background:black }
.death hr.ten { height: 10px}"

def corpse.view

  daysAgo = (Time.new.to_i - Date.new(1986,03,22).to_time.to_i)/86400
  
  html = "<note>Nothing against Time's scythe<br/>can make defence.</note>"
  
  time1 = Time.new
  year = 1
  while year < 60
    html += year % 10 == 0 ? "<hr class='ten'/>" : ""
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