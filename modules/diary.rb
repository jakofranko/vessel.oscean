#!/bin/env ruby
# encoding: utf-8

class Oscean

  class Corpse

    def view

      html = term.name.like("home") ? "" : "<p>#{term.bref}</p>#{term.long}".markup
      
      if term.diaries.count > 0
        html += diary_list
      else
        html += "<p>There are no diaries for #{term.name}.</p>"
      end

      return "<wr>#{html}</wr>"

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

      if term.name.like("home")
        html += "<p><a href='/Diary:#{(page+1)}' style='background: #ddd;padding: 15px;font-size: 12px;display: block;border-radius: 100px;text-align: center'>Page #{page+1}</a></p>"
      end
      return html

    end
    
  end

end