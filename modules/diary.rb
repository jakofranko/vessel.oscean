#!/bin/env ruby
# encoding: utf-8

corpse = $nataniev.vessel.corpse

corpse.style = "
.pagination { margin-bottom: 30px; position:relative}
.pagination .progress_bar { background: black;border: 2px solid black;border-radius: 100px;padding: 1px;width:calc(100% - 100px) }
.pagination .progress_bar .bar { background:white; height:3px; border-radius:10px; min-width:3px }
.pagination a { font-family: 'din_medium' !important;font-weight: normal;text-align: center;display: inline-block;border-radius: 3px;font-size: 11px;text-transform: uppercase;position: absolute;top: -2px;right: 0px}
.pagination a:hover { text-decoration: underline}"

def corpse.view

  html = @term.name.like("home") ? "" : @term.long.runes
  html += @term.diaries.count > 0 ? diaries_list : "<p>There are no diaries for #{@term.name}.</p>"
  return html

end

def corpse.diaries_list

  html = ""
  
  page = @module.to_i
  perPage = 10

  i = 0
  @term.diaries.each do |log|
    from = page*perPage
    to = from+perPage
    if i >= from && i < to then html += log.to_s end
    i += 1
  end

  if @term.name.like("home") || @term.name.like("diary")
    progress_html = "<div class='progress_bar'><div class='bar' style='width:#{((page.to_f/@term.diaries.length.to_f)*1000)}%'></div></div>"
    html += "<div class='pagination'>#{progress_html}<a href='/Diary:#{(page+1)}'>Page #{page+1} of #{(@term.diaries.length/perPage).to_i+1}</a></div>"
  end
  return html

end