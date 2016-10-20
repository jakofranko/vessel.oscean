#!/bin/env ruby
# encoding: utf-8

class Oscea

  class Corpse

    def view

      html = "<p>#{term.bref}</p>#{term.long}".markup
      
      if term.diaries.count > 0
        html = diaryTopic
      else
        html = "<p>There are no diaries for #{term.name}.</p>"
      end

      return "<wr>#{html}</wr>"

    end

    def diaryTopic

      html = "<p>#{term.bref}</p>#{term.long}".markup
      
      i = 0
      term.diaries.each do |log|
        from = page*perPage
        to = from+perPage
        if i >= from && i < to then html += log.to_s end
        i += 1
      end

      if term.name.like("home")
        html += "<p><a href='/Diary:#{(page+1)}' style='background: #ddd;padding: 15px;font-size: 12px;display: block;border-radius: 100px;text-align: center'>Page #{page+1}</a></p>"
      end
      return html

    end
    
  end

end