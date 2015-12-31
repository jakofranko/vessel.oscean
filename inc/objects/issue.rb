#: The {{Issue}} object contains informations relative to the {{Issues}} list and {{Changelog}}.
class Issue

	def initialize(issue)
		@issue = issue
	end

	def id
		return @issue['id'].to_i
	end

	def code
		return id.to_s.rjust(3, '0')
	end

	def topic
		return @issue['topic'].to_s
	end

	def task
		return @issue['task'].to_s
	end

	def type
		word = @issue['task'].to_s.split(" ")[0].downcase
		if word == "add"
			return "Feature"
		elsif word == "fix"
			return "Bug"
		elsif word == "create"
			return "Related"
		elsif word == "improve"
			return "Improvement"
		else
			return "Update"
		end
	end

	def year
		if @issue['date'].length > 3 then return @issue['date'][0,4].to_i end
		return 2000
	end
	
	def month
		if @issue['date'].length > 6 then return @issue['date'][5,2].to_i end
		return 1
	end
	
	def day
		if @issue['date'].length > 9 then return @issue['date'][8,2].to_i end
		return 1
	end

	def date
		return @issue['date']
	end

	def time
		return Time.new(year,month,day).to_time.to_i
	end

	def release
		return @issue['release'].to_s
	end

	def active
		if @issue['release'].to_s == "" then return true end
		return false
	end
	
	def offset
		timeDiff = Time.new.to_i - time
		timeDiff = (timeDiff/86400)

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

	def template
		if Time.new.to_i - time < 0 then timeLeft = "<i>"+offset.downcase.sub("in ","")+" left</i>" else timeLeft = offset end
		if !active then activeStyle = "complete" end
		return "<issue class='#{type.downcase} #{activeStyle}'><a href='/issues##{id}' class='tag'>#{code}</a><a href='/#{topic}' class='topic'>#{topic}</a>#{task}<span class='date'>#{timeLeft}</span></issue>"
	end

end