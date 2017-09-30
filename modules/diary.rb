#!/bin/env ruby
# encoding: utf-8

corpse = $nataniev.vessels[:oscean].corpse

corpse.style = "body > media.photo { display:none} .pagination {text-align:right; font-family:'din_regular'; font-size:12px} .progress_bar { background:#ddd; display:block; height:1px; margin-bottom:15px} .progress_bar .bar { background:black; height:1px; display:block}"

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
    html += "<div class='pagination'>#{progress_html}<a href='/Diary:#{(page+1)}'>#{page+1} of #{(@term.diaries.length/perPage).to_i+1}</a></div>"
  end
  return html

end