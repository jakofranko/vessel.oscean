# encoding: utf-8

class Page

	def body

		if @query.like("portal")
			return body_land
		else
			return body_module
		end

	end

	def body_land

		html = "#{macros(@term.bref)}"

		used = []

		html += "<table>"
		@lexicon.all.each do |parent,term|
			if !term.type then next end
			if !term.type.to_s.like("portal") then next end
		    if !File.exist?("content/badges/#{term.name.downcase.gsub(' ','.')}.png") then next end

			html += "<tr><td style='width:100px'><img src='content/badges/#{term.name.downcase.gsub(' ','.')}.png' style='margin:15px 0px 0px 0px'/></td>"
			html += "<td><h2><a href='/#{term.name}'>#{term.name}</a></h2>"
			@lexicon.all.each do |name,term|
				if !term.unde.like(parent) then next end
					if used.include?(name.downcase) then next end
				html += "<li style='display:inline-block; width:150px'><a href='/#{name}'>#{name.capitalize}</a></li>"
				used.push(name.downcase)
				@lexicon.all.each do |child,term|
					if !term.unde.like(name) then next end
					if used.include?(child.downcase) then next end
					html += "<li style='display:inline-block; width:150px'><a href='/#{child}'>#{child.capitalize}</a></li>"
					used.push(child.downcase)
				end
			end
			html += "<br /><br /></td></tr>"
			used.push(parent.downcase)
		end
		html += "</table>"
    
		lastLetter = "4"
		html += "<ul style='column-count:3'>"
		@lexicon.all.each do |topic,term|
			if used.include?(topic.downcase) then next end
			if term.name[0,1].downcase != lastLetter.downcase
				lastLetter = term.name[0,1]
				html += "<h2 style='font-size: 30px;line-height: 50px;margin: 0px;'>#{lastLetter}</h2>"
			end
			html += "<li style='font-size:16px'><a href='/#{term.name}'>#{(term.type.to_s.like("portal")) ? "<b>"+term.name+"</b>" : term.name}</a></li>"
		end
		html += "</ul>"
		return html

	end

	def body_module

		html = "#{@term.bref}#{@term.long}"

		@lexicon.all.each do |name,term|
	    	if !term.unde.like(@term.name) then next end
	    	if term.name.like(@term.name) then next end

	    	photoTest = photoForTerm(term.name)

	    	if !term.bref && !photoTest then next end

	    	html += "<content>
		      "+(photoTest ? "<a href='/#{term.name}'><img src='content/diary/#{photoTest}.jpg'/></a>" : "<h2><a href='/#{term.name}'>#{term.name}</a></h2>")+"
		      <div class='full'>#{term.bref}</div>
		    </content>"
	    end

	    return macros(html)

	end

	def photoForTerm term

		@horaire.all.each do |date,log|
			if !log.topic.like(term) then next end
			if log.photo < 1 then next end
			return log.photo
		end

		return nil

	end

	
end