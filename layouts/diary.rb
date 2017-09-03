#!/bin/env ruby
# encoding: utf-8

corpse = $nataniev.vessels[:oscean].corpse

def corpse.view

  if @term.diaries.count < 1 then return "<wr><p>There are no diaries for #{@term.name}.</p></wr>" end

  html = @term.name.like("home") ? "" : @term.long.runes

  @term.diaries.each do |log|
    html += log.to_s
  end

  return html

end

corpse.style = "body > media.photo { display:none} body yu.hd { margin-top:90px}"