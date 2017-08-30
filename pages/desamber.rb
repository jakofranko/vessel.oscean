#!/bin/env ruby
# encoding: utf-8

corpse = $nataniev.vessels[:oscean].corpse

def corpse.view

  html = "#{@term.long.runes}"
  html += "<mini>Read more {{International Fixed Calendar|https://en.wikipedia.org/wiki/International_Fixed_Calendar}}.</mini>".markup
  html += "<h2>Equivalency Table</h2>"
  html += "<list>"
  desamber_calendar.each do |month_name,dates|
    html += "<ln><b>#{month_name}</b> #{dates.first} #{dates.first != dates.last ? 'to '+dates.last : ''}</ln>"
  end
  html += "</list>"

  return html

end

def corpse.desamber_calendar

  h = {}
  now = Date.new(2017,01,01)
  d = 0
  while d < 365
    date = (now + d).to_s.gsub("-","")
    greg = Timestamp.new(date)
    desa = Desamber.new(date)
    if !h[desa.month_name] then h[desa.month_name] = [] end
    h[desa.month_name].push("#{greg.month_name} #{greg.d}")
    d += 1
  end
  return h

end