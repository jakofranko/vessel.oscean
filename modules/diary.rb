#!/bin/env ruby
# encoding: utf-8

class Page

	def body

		html = "<p>#{@term.bref}</p>#{@term.long}".markup
		
		if @term.name.like("diary")
			html = diaryList
		elsif @diaries.count > 0
			html = diaryTopic
		else
			html = "<p>There are no diaries for #{@term.name}.</p>"
		end

		return "<wr>#{html}</wr>"

	end

	def diaryTopic

		html = "<p>#{@term.bref}</p>#{@term.long}".markup
    
		@diaries[0,10].each do |log|
			if log.photo == diary.photo then next end
			html += log.template
		end
		return html

	end

	def diaryList

		html = ""
    page = @module.to_i
    perPage = 10

    i = 0
    $horaire.diaries.each do |log|
    	from = page*perPage
    	to = from+perPage
    	if i >= from && i < to then html += log.template end
    	i += 1
    end

    html += "<p><a href='/Diary:#{(page+1)}' style='background: #ddd;padding: 15px;font-size: 12px;display: block;border-radius: 100px;text-align: center'>Page #{page+1}</a></p>"

  	return html

	end

end