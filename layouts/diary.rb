#!/bin/env ruby
# encoding: utf-8

class CorpseHttp

  def view

    if term.diaries.count < 1 then return "<wr><p>There are no diaries for #{term.name}.</p></wr>" end

    html = term.name.like("home") ? "" : "<p>"+@term.bref+"</p>"+@term.long.runes
    term.diaries.each do |log|
      html += log.to_s
    end
    return "<wr>#{html}</wr>"

  end
  
end