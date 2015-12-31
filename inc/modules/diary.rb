#: Missing

class Page

	def body

		html = ""
		count = 0
		@diaries.each do |log|
			if count > 20 then break end
			html += log.diary_template
			count += 1
		end
		return "<content class='issues'>#{macros(html)}</content>"

	end

end