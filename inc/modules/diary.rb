# encoding: utf-8

class Page

	def body

		html = macros("<p>#{@term.bref}</p>#{@term.long}")
		
		if @term.name.like("diary")
			return diaryList
		elsif @diaries.count > 0
			return diaryTopic
		else
			return "<p>There are no diaries for this #{@term.name}.</p>"
		end

	end

	def diaryTopic

		html = macros("<p>#{@term.bref}</p>#{@term.long}")
		@diaries[0,10].each do |log|
			if log.photo == diary.photo then next end
			html += log.template
		end
		return "<wr>#{html}</wr>"

	end

	def diaryList

		html = ""
	    page = @module.to_i
	    perPage = 10

	    i = 0
	    @horaire.diaries.each do |log|
	    	from = page*perPage
	    	to = from+perPage
	    	if i >= from && i < to then html += log.template end
	    	i += 1
	    end

	    html += "<p><a href='/Diary:#{(page+1)}' style='background: #ddd;padding: 15px;font-size: 12px;display: block;border-radius: 100px;text-align: center'>Page #{page+1}</a></p>"

	  	return "<wr>#{html}</wr>"

	end

end