class Layouts

	def module_issues

		html = ""
		html += "<p>This list shows the latest <i>active issues</i> for {{"+$page.topic+"}}. <br />To see the complete list, visit the <a href='/Issues'>Issue Tracker</a> or the {{Changelog|/"+$page.topic+":Changelog}}.</p>"
		html += displayIssues($page.issues)
		return "<content class='issues'>"+html+"</content>"

	end

	def issues

		html = ""
		allIssues = Oscean.new($page.topic).issues("*")
		html += "<p>This list shows the latest active issues out of <i>"+allIssues.length.to_s+" total issues</i>, across all topics of XXIIVV. Click on a topic to see the issues specific to this topic.</p>"
		html += displayIssues(allIssues)
		return "<content class='issues'>"+html+"</content>"

	end

	def displayIssues loadedIssues

		html = ""
		html += "<table class='minimal'>"
		html += "<tr><th style='width:10px'>Ticket</th><th>Topic</th><th>Type</th><th>Task</th><th style='width:100px; text-align:right'>Updated</th></tr>"
		loadedIssues.reverse.each do |issue|
			if issue.active != true then next end
			html += "<tr id='id"+issue.id.to_s+"'><td><span style='font-size:12px'>#"+issue.id.to_s+"</span></td><td>{{"+issue.topic+"|/"+issue.topic+":Issues}}</td><td>"+issue.type+"</td><td>"+issue.task+"</td><td style='text-align:right; color:#999'>"+issue.offset+"</td></tr>"
		end
		# Closed issues
		if $page.issues.length  > $page.issuesActive.length 
			html += "<tr class='disabled'><th></th><th></th><th colspan='4'>"+($page.issues.length - $page.issuesActive.length).to_s+" Closed Issues</th></tr>"
		elsif $page.topic == "Issues"
			closedIssues = 0
			loadedIssues.each do |issue|
				if issue.active == false then closedIssues += 1 end
			end
			html += "<tr class='disabled'><th></th><th></th><th colspan='4'>"+closedIssues.to_s+" Closed Issues</th></tr>"
		end
		html += "</table>"
		return html

	end

end