#!/bin/env ruby
# encoding: utf-8

class CorpseHttp
  
  def style
    
    return ""
    
  end

  def view

    html = term.name.like("home") ? "" : term.long.runes
    
    if term.diaries.count > 0
      html += diary_list
    else
      html += "<p>There are no diaries for #{term.name}.</p>"
    end

    return html

  end

  def diary_list

    html = ""
    
    page = @module.to_i
    perPage = 10

    i = 0
    term.diaries.each do |log|
      from = page*perPage
      to = from+perPage
      if i >= from && i < to then html += log.to_s end
      i += 1
    end

    if term.name.like("home") || term.name.like("diary")
      html += "<div style='background:white; height:1px'><div style='background:black; height:1px; width:#{((page.to_f/term.diaries.length.to_f)*1000)}%'></div></div>"
      html += "<p><a href='/Diary:#{(page+1)}' style='font-family:\"dinregular\";font-weight: normal;text-align: center;display: block;border-radius: 3px;font-size:14px;padding: 15px'>Continue to page #{page+1} of #{(term.diaries.length/perPage).to_i+1}</a></p>"
    end
    return html

  end
  
end