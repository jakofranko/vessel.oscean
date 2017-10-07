#!/bin/env ruby
# encoding: utf-8

corpse = $nataniev.vessels[:oscean].corpse

corpse.style = "
.calendar { clear:both; margin-bottom:30px}
.calendar month { display:block; width:20%;float:left; font-family:'din_regular'; font-size:11px; margin-bottom:15px; text-align:center}
.calendar month yu.name { margin-bottom:5px; margin-right:15px; text-align:left; line-height:20px; padding-left:5px; font-family:'din_medium'; text-transform:uppercase}
.calendar day { display:block; float:left; width:14%; line-height:20px; text-align:center; color:#ccc}
.calendar day.log { color:#000}
.calendar day.event { font-family:'din_medium'; background:#ddd; color:black} 
.calendar day.today { background:#72dec2; color:black}
.calendar day.recurring { background:black; color:white}
ln.recurring:after { content:'*'; color:#72dec2;}
ln.today a { color:#72dec2;}"

def corpse.find_logs

  a = []
  y = @query.to_i

  $nataniev.vessels[:oscean].corpse.horaire.to_a(:log).each do |log|
    if log.date.y != y then next end
    a.push(log)
  end
  return a

end

def corpse.make_day y,m,d

  if !@events[y] then return nil end
  if !@events[y][m] then return nil end
  if !@events[y][m][d] then return nil end
  if @events[y][m][d][:style] then return @events[y][m][d][:style] end

  return ""

end

def corpse.build_calendar

  html = ""

  y = @query.to_i
  m = 1
  while m <= 13
    html += "<month>"
    html += "<yu class='name'>#{Desamber.new.dict[m-1]}</yu>"
    d = 1
    while d <= 28
      html += "<day class='#{make_day(y,m,d)} #{y == Desamber.new.y && m < Desamber.new.m || m == Desamber.new.m && d < Desamber.new.d || Desamber.new.y > @query.to_i ? 'log' : ''}'>#{d.to_s.prepend("0",2)}</day>"
      d += 1
    end
    html += "<hr/>"
    html += "</month>"
    m += 1
  end

  return "<yu class='calendar'>#{html}<hr /></yu>"

end

def corpse.build_desamber

  h = {}
  @year_logs.each do |log|
    if !log.is_event then next end
    add_event(log.date.y,log.date.m,log.date.d,log.name,"event",log.topic)
  end
  return h

end

def corpse.add_event y, m, d, name, style, project = @query

  if !@events[y] then @events[y] = {} end
  if !@events[y][m] then @events[y][m] = {} end
  @events[y][m][d] = {:name => name, :style => style, :project => project}

end

def corpse.add_recurring_event timestamp, year, name, project = ""

  if @query.to_i - year < 1 then return end

  des = Desamber.new("#{@query}#{timestamp}")
  add_event(des.y,des.m,des.d,"#{name} #{@query.to_i - year} Year Anniversary","recurring",project)

end

def corpse.layout_previous_years

  html = "<h2>Previous Years</h2>"
  html += Graph_Since.new(@horaire.to_a(:log)).to_s
  y = Desamber.new.y
  html += "<p class='simple'>"
  while y >= 2008
    name = $nataniev.vessels[:oscean].corpse.lexicon.filter(:term,y.to_s,:term).bref
    html += "#{y == @query.to_i ? '<t style=\'color:#aaa\'>'+y.to_s+'</t>' : '<a href=\'/'+y.to_s+'\'>'+y.to_s+'</a>'} #{name}<br />"
    y -= 1
  end
  html += "</p>"

  return html

end

def corpse.layout_activity

  html = "<h2>Activity</h2>"
  html += Graph_Timeline.new(@year_logs).to_s

  topics = {}
  tasks = {}
  sum = 0
  @year_logs.each do |log|
    if !topics[log.topic] then topics[log.topic] = 0 end
    if !tasks[log.task] then tasks[log.task] = 0 end
    topics[log.topic] += log.value
    tasks[log.task] += log.value
    sum += log.value
  end

  html += "<h3>Projects</h3><list class='simple' style='columns:2'>"
  count = 0
  misc = 0
  topics.sort_by {|_key, value| value}.reverse.each do |name,value|
    if count > 14 then misc += value ; next end
    if value == 0 then next end
    html += "<ln><a href='/#{name.to_url}' title='#{value}fh'>#{name}</a> <t style='float:right; color:#aaa'>#{value.to_f.percent_of(sum).trim(2)}%</t></ln>"
    count += 1
  end
  html += topics.length > 14 ? "<ln>#{topics.length - 14} Misc <t style='float:right; color:#aaa'>#{misc.to_f.percent_of(sum).trim(2)}%</t></ln>" : ""
  html += "<hr /></list>"
  html += "<h3>Tasks</h3><list class='simple' style='columns:2'>"
  count = 0
  tasks.sort_by {|_key, value| value}.reverse.each do |name,value|
    if count > 14 then misc += value ; next end
    if value == 0 then next end
    html += "<ln><a href='/#{name.to_url}' title='#{value}fh'>#{name}</a> <t style='float:right; color:#aaa'>#{value.to_f.percent_of(sum).trim(2)}%</t></ln>"
    count += 1
  end
  html += tasks.length > 14 ? "<ln>#{tasks.length - 14} Misc <t style='float:right; color:#aaa'>#{misc.to_f.percent_of(sum).trim(2)}%</t></ln>" : ""
  html += "<hr /></list>"

  return html

end

def corpse.view

  @events = {}
  @year_logs = find_logs
  @horaire_desamber = build_desamber

  # Add today
  if @query.to_i == Desamber.new.y 
    add_event(Desamber.new.y,Desamber.new.m,Desamber.new.d,"Today",:today,@query)
  end
  add_recurring_event("0710",2008,"XXIIVV")
  add_recurring_event("0214",2016,"Pino")

  html = "#{@term.long.runes.to_s}"
  
  html += "<h2>#{@query}</h2>"
  html += build_calendar
  html += "<h3>Events</h3>"
  html += "<list class='simple' style='columns:2'>"
  @events.sort.reverse.each do |y,ms|
    ms.sort.reverse.each do |m,ds|
      ds.sort.reverse.each do |d,data|
        date_str = "#{y.to_s.prepend("0",2)}#{m.to_s.prepend("0",2)}#{d.to_s.prepend("0",2)}"
        html += "<ln class='#{data[:style]}'><a href='/#{data[:project].to_url}'>#{data[:name]}</a></ln>"
      end
    end
  end
  html += "</list>"

  html += layout_activity
  html += layout_previous_years
  return html
  
end