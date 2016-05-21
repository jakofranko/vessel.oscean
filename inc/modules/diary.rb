#: Missing

class Page

	def body

		html = "#{@term.bref}#{@term.long}"
		
		if @diaries.count == 0
			html = "<p>The Diary page is currently down, visit <a href='/Home:Diary'>this page</a> in the meantime.</p>"
		else
			@diaries[0,10].each do |log|
				html += log.diary_template
			end
		end
		return "<content class='issues'>#{macros(html)}</content>"

	end

end