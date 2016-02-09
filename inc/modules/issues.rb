#: Missing

class Page

	def body

		html = ""
		html += "<p>This list shows the latest issues for the <b>#{@term.topic}</b> project.</p>"
	
		if @issues[""]
			html += "<h3>Next Version</h3>"
			@issues[""].each do |issue|
				if issue.active != true then next end
				html += issue.template
			end
		else
			html += "<p>There are currently no open issues.</p>"
		end
		html += "<br />"
		@issues.each do |release,issues|
			if release == "" then next end
			html += "<h3>Version #{release}</h3>"
			issues.each do |issue|
				html += issue.template
			end
			html += "<br />"
		end
		html += "<br />"
		return "<content class='issues'>#{macros(html)}</content>"

	end

end