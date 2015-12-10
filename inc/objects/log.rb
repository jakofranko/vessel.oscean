#: The {{Log}} object are {{Horaire}} contructs.

class Log

	def initialize(log)
		@log = log
	end

	def time
		Date.new(year,month,day).to_time.to_i
	end

	def year
		return @log['date'][0,4].to_i
	end

	def month
		return @log['date'][5,2].to_i
	end

	def day
		return @log['date'][8,2].to_i
	end

	def date
		return Desamber.new(@log['date'])
	end

	def elapsed
		return Time.new.to_i - Date.new(year,month,day).to_time.to_i
	end

	def offset

		if year < 1 then return "" end

		timeDiff = (elapsed/86400)

		if timeDiff < -1 then return "In "+(timeDiff*-1).to_s+" days" end
		if timeDiff == -1 then return "tomorrow" end
		if timeDiff == 0 then return "today" end
		if timeDiff == 1 then return "yesterday" end
		if timeDiff == 7 then return "a week ago" end
		if timeDiff > 740 then return (timeDiff/30/12).to_s+" years ago" end
		if timeDiff > 60 then return (timeDiff/30).to_s+" months ago" end
		if timeDiff > 30 then return "a month ago" end

		return timeDiff.to_s+" days ago"
	end

	def isPassed
		if Time.new.to_i > Date.new(year,month,day).to_time.to_i then return true end
		return false
	end

	def value
		return @log['verb'][1,1].to_i
	end

	def verb
		return @log['verb'].to_i
	end

	def sector
		if @log['verb'][0,1].to_i == 1
			return "audio"
		elsif @log['verb'][0,1].to_i == 2
			return "visual"
		elsif @log['verb'][0,1].to_i == 3
			return "research"
		end
		return "misc"
	end

	def title
		return @log['title'].to_s.force_encoding("UTF-8")
	end

	def full
		return macros(@log['full'].to_s.force_encoding("UTF-8"))
	end

	def task
		return @log['location'].to_s
	end

	def photo
		return @log['photo']
	end

	def topic
		return @log['topic'].to_s
	end

	def tags
		words = []

		title.split(" ").each do |word|
			words.push(word.downcase)
		end
		topic.split(" ").each do |word|
			words.push(word.downcase)
		end
		task.split(" ").each do |word|
			words.push(word.downcase)
		end
		full.gsub("{{"," ").gsub("}}"," ").gsub("'"," ").split(" ").each do |word|
			words.push(word.downcase)
		end
		tags = []
		words.each do |word|
			if !$lexicon.find(word) then next end
			if word.to_s == "" then next end
			if tags.include?(word) then next end
			tags.push(word)
		end
		return tags.uniq
	end

	def image
		if File.exist?("content/diary/"+photo.to_s+".jpg") && photo > 0
		  return "<img src='content/diary/"+photo.to_s+".jpg' class='photo'/>"
		end
		return ""
	end

	def storage
		return @log['storage'].to_s
	end

	def isFeatured
		if @log['storage'].to_s.include?('featured')
			return true
		end
		return false
	end

	def isDiary
		if @log['photo'].to_i > 0
			return true
		end
		return false
	end

	# Templates

	def icon
		return ""
		return "<svg><line x1='0' y1='9.5' x2='19' y2='9.5' style='stroke:#fff;stroke-width:2'></line></svg>"
	end

	def template
		html = ""
		html += icon
		html += "<a class='topic' href='/#{topic}'>#{topic}</a>"
		if photo > 0
			html += "<a class='title' href='/#{topic}:diary'>#{title}</a>"
		elsif task.downcase == "update"
			html += "<a class='title' href='/#{topic}:changelog'>v#{title}</a>"
		else
			html += "<a class='title' href='/#{topic}:diary'>#{title}</a>"
		end
		html += task
		html += "<span class='date'>#{offset}</span>"
		return "<log>"+html+"</log>"
	end

	def templateDiary
		html = ""
		if $horaire.photo != photo || $page.topic == "Diary" then html += image end
		html += "<div class='wrap'>"
		html += "<content class='details'><h3><b>#{title}</b><br />#{date.default}</h3></content>"

		html += full

		html += "<hr />"

		html += "</div>"
		return "<content class='diary'>"+html+"</content>"
	end

	# Macros

	def macros article
		testArray = article.scan(/(?:\{\{)([\w\W]*?)(?=\}\})/)
		testArray.each do |str,details|
			return article.gsub("{{"+str+"}}",macroParser(str))
		end
		return article
	end

	def macroParser str
		if str[0,1] == "$" then return macroIssues(str.sub("$","")) # Issues
		elsif str.include?("|") then return "<a href='"+str.split("|")[1]+"'>"+str.split("|")[0]+"</a>"
		elsif $lexicon.term(str) then return "<a href='"+str.gsub(" ","+")+"'>"+str+"</a>"
		end
		return str
	end

	def macroIssues version
		html = ""
		$lexicon.term(topic).issues.each do |issue|
			if issue.release != version then next end
			html += issue.template
		end
		return "<ul>"+html+"</ul>"
	end

end
