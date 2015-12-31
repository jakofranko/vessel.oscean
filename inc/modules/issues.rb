#: Missing

class Page

	def body

		html = ""
		html += "<p>This list shows the latest active issues out of <i>"+@issues.length.to_s+" total issues</i>, across all topics of XXIIVV. Click on a topic to see the issues specific to this topic.</p>"
		html += "<table class='minimal'>"
		html += "<tr><th style='width:10px'>Ticket</th><th>Topic</th><th>Type</th><th>Task</th><th style='width:100px; text-align:right'>Updated</th></tr>"
		@issues.reverse.each do |issue|
			if issue.active != true then next end
			html += "<tr id='id"+issue.id.to_s+"'><td><span style='font-size:12px'>#"+issue.id.to_s+"</span></td><td>{{"+issue.topic+"|/"+issue.topic+":Issues}}</td><td>"+issue.type+"</td><td>"+issue.task+"</td><td style='text-align:right; color:#999'>"+issue.offset+"</td></tr>"
		end
		html += "</table>"
		return "<content class='issues'>#{macros(html)}</content>"

	end

end