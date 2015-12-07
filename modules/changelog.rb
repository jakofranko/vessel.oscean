class Layouts

	def module_changelog

		html = ""
		$horaire.all.each do |date,log|
			if log.topic != $page.topic then next end
			if log.task != "Update" then next end
			if log.full == "" then next end
			html += "<h2>Revision <b>"+log.title+"</b><small>"+log.offset+"</small></h2>"
			html += log.full
		end
		return "<content class='changelog'>"+html+"</content>"

	end

	def changelog

		html = ""
		Oscean.new($page.topic).horaireFind("location","Update").each do |log|
			if log.full == "" then next end
			html += "<h2>"+log.topic+" Revision <b>"+log.title+"</b><small>"+log.offset+"</small></h2>"
			html += log.full
		end
		return "<content class='changelog'>"+html+"</content>"

	end

end