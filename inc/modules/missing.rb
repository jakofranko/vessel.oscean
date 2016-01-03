class Page

	def missing

		html = ""

		if @query.length < 4 then return "<p>Sorry, I could not find what you are looking for.</p>" end

		@searchables = find_searchables
		@candidates = find_candidates

		if @candidates.length == 0 then return "<p>I'm sorry, I couldn't find anything about <b>#{@query}</b>.</p>" end

		html += "<p>I could not locate the term that you are looking for, but I found <b>#{@candidates.length} candidates</b>, across #{@searchables.length} terms. Look at the <a href='/Dictionary'>Dictionary</a> to see the entire list of topics.</p>"
		html += "<ul>"
		@candidates.each do |topic,link|
			html += "<li><a href='/#{link}'>#{topic}</a> <i style='color:#999'>#{(link.to_i > 0) ? "diary" : "term"}</i></li>"
		end
		html += "</ul>"

		return html
	end

	def find_searchables

		hash = {}
		@lexicon.all.each do |topic,term|
			hash[topic] = topic
		end
		@horaire.all.each do |date,log|
			if log.photo.to_i == 0 then next end
			hash[log.title] = log.photo
		end
		return hash

	end

	def find_candidates
		array = []
		@searchables.sort.each do |element|
			topic = element.first.downcase
			if topic.length < 3 then next end

			if topic == @query then array.push(element)
			elsif topic.include?(@query) then array.push(element)
			elsif @query.include?(topic) then array.push(element)
			elsif "#{@query.chars.sort.join}" == "#{topic.chars.sort.join}" then array.push(element)
			elsif "#{@query.chars.sort.join}".include?("#{topic.chars.sort.join}") then array.push(element)
			elsif "#{topic.chars.sort.join}".include?("#{@query.chars.sort.join}") then array.push(element)
			end

		end
		return array
	end

end