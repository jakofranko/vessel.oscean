#: The graph object creates the Horaire previews.

class Graph

	def initialize(logs)
		@logs = logs
		@segments = equalSegments
		@sumHours = 0
	end

	def segmentMemory

		memory = []
		segments_limit = 28
		i = 0
		while i < 28
			memory[i] = {}
			memory[i]["audio"] = 0
			memory[i]["visual"] = 0
			memory[i]["research"] = 0
			memory[i]["misc"] = 0
			i += 1
		end
		return memory

	end

	def equalSegments 

		segments = segmentMemory

		@from = @logs.first.elapsed
		@to = @logs.last.elapsed
		@length = @to - @from

		@logs.each do |log|
			progressFloat = (log.elapsed/@to.to_f) * 28
			progressPrev = progressFloat.to_i
			progressNext  = progressFloat.ceil
			distributePrev = progressNext - progressFloat
			distributeNext = 1 - distributePrev

			if segments[progressPrev] then segments[progressPrev][log.sector] += log.value * distributePrev end
			if segments[progressNext] then segments[progressNext][log.sector] += log.value * distributeNext end
		end
		return segments

	end

	def findHighestValue

		highest = 1
		@segments.each do |values|
			if values["audio"] > highest then highest = values["audio"]end
			if values["visual"] > highest then highest = values["visual"]end
			if values["research"] > highest then highest = values["research"]end
			@sumHours += values["audio"] + values["visual"] + values["research"]
		end
		return highest

	end

	def draw

		html = ""
		width = 640
		height = 150
		lineWidth = 660/28
		segmentWidth = lineWidth/3
		highestValue = findHighestValue

		lineAudio_html = ""
		lineVisual_html = ""
		lineResearch_html = ""
		lineAverage_html = ""

		count = 0
		@segments.reverse.each do |values|
			value = height - ((values["audio"]/highestValue) * height)
			lineAudio_html += "#{(count * lineWidth + (segmentWidth))},#{(value).to_i} "
			lineAudio_html += "#{(count * lineWidth + (segmentWidth * 3))},#{(value).to_i} "
			value = height - (values["visual"]/highestValue * height)
			lineVisual_html += "#{(count * lineWidth + (segmentWidth))},#{(value).to_i} "
			lineVisual_html += "#{(count * lineWidth + (segmentWidth * 3))},#{(value).to_i} "
			value = height - (values["research"]/highestValue * height)
			lineResearch_html += "#{(count * lineWidth + (segmentWidth))},#{(value).to_i} "
			lineResearch_html += "#{(count * lineWidth + (segmentWidth * 3))},#{(value).to_i} "
			value = height - (((values["audio"] + values["visual"] + values["research"])/3)/highestValue * height)
			lineAverage_html += "#{(count * lineWidth + (segmentWidth))},#{(value).to_i} "
			lineAverage_html += "#{(count * lineWidth + (segmentWidth * 3))},#{(value).to_i} "
			count += 1
		end

		# Lines

		html += "<polyline points='#{lineAverage_html}' style='fill:none;stroke:grey;stroke-width:1' stroke-dasharray='1,2' />"
		html += "<polyline points='#{lineAudio_html}' style='fill:none;stroke:#72dec2;stroke-width:1' />"
		html += "<polyline points='#{lineVisual_html}' style='fill:none;stroke:red;stroke-width:1' />"
		html += "<polyline points='#{lineResearch_html}' style='fill:none;stroke:white;stroke-width:1' />"

		# Markers
		markers = ""
		markers += "<span style='position:absolute; top:15px;left:30px; color:grey'>#{@logs.last.offset}</span>"
		markers += "<span style='position:absolute; top:15px;right:30px; text-align:right; color:grey'>#{@logs.first.offset}</span>"

		markers += "<span style='position:absolute; bottom:15px;left:30px; text-align:right'><line style='border-top:1px solid #72dec2'></line>Audio</span>"
		markers += "<span style='position:absolute; bottom:15px;left:110px; text-align:right'><line style='border-top:1px solid red'></line>Visual</span>"
		markers += "<span style='position:absolute; bottom:15px;left:190px; text-align:right'><line style='border-top:1px solid white'></line>Research</span>"
		markers += "<span style='position:absolute; bottom:15px;right:30px; text-align:right'>{{#{@sumHours.to_i} hours|Horaire}}</span>"

		return "<content class='graph'><svg style='width:#{width}px; height:#{height}px; background:black'>"+html+"<svg>#{markers}</content>"

	end

end

class CircleGraph

	def initialize(logs)
		@logs = logs
		makeSums()
	end

	def makeSums

		@sumAudio = 0
	  	@sumVisual = 0
	  	@sumResearch = 0
	  	@sumAll = 0

	  	@dayAudio = 0
	  	@dayVisual = 0
	  	@dayResearch = 0

	  	$horaire.all.each do |date,log|
		    if $page.topic != "Horaire" && log.topic != $page.topic then next end

	  		if log.sector == "audio" then @sumAudio += log.value end
	  		if log.sector == "visual" then @sumVisual += log.value end
	  		if log.sector == "research" then @sumResearch += log.value end

	  		if log.sector == "audio" then @dayAudio += 1 end
	  		if log.sector == "visual" then @dayVisual += 1 end
	  		if log.sector == "research" then @dayResearch += 1 end
	  	end
	  	@sumAll = @sumAudio + @sumVisual + @sumResearch
	  	@sumDays = @dayAudio + @dayVisual + @dayResearch

	end

	def graph

		graph = ""
	  	strokeWidth = 20
		circleRadius = 15
	  	circumference = 2 * Math::PI * circleRadius
	  	graph += "<circle cx='"+circleRadius.to_s+"' cy='"+circleRadius.to_s+"' r='"+circleRadius.to_s+"' stroke='black' stroke-width='#{strokeWidth}' fill='none' />"

	  	# Audio
	  	strokeLength = (@sumAudio/@sumAll.to_f) * circumference
	  	strokeRemain = circumference - strokeLength

	  	graph += "<circle cx='"+circleRadius.to_s+"' cy='"+circleRadius.to_s+"' r='"+circleRadius.to_s+"' stroke='#72dec2' stroke-width='1' fill='none' stroke-dasharray='"+strokeLength.to_s+" "+strokeRemain.to_s+"' />"

	  	# Visual
	  	strokeLength = (@sumVisual/@sumAll.to_f) * circumference
	  	strokeRemain = circumference - strokeLength
	  	angle = (@sumAudio/@sumAll.to_f) * 360

	  	graph += "<circle cx='"+circleRadius.to_s+"' cy='"+circleRadius.to_s+"' r='"+circleRadius.to_s+"' stroke='#ff0000' stroke-width='1' fill='none' stroke-dasharray='"+strokeLength.to_s+" "+strokeRemain.to_s+"' transform='rotate("+angle.to_s+" "+circleRadius.to_s+" "+circleRadius.to_s+")' />"

		# Research
	  	strokeLength = (@sumResearch/@sumAll.to_f) * circumference
	  	strokeRemain = circumference - strokeLength
	  	angle = ((@sumAudio+@sumVisual)/@sumAll.to_f) * 360

	  	graph += "<circle cx='"+circleRadius.to_s+"' cy='"+circleRadius.to_s+"' r='"+circleRadius.to_s+"' stroke='#fff' stroke-width='1' fill='none' stroke-dasharray='"+strokeLength.to_s+" "+strokeRemain.to_s+"' transform='rotate("+angle.to_s+" "+circleRadius.to_s+" "+circleRadius.to_s+")' />"
	  	return "<svg style='width:"+(circleRadius*2).to_s+"px; height:"+(circleRadius*2).to_s+"px; padding:#{strokeWidth/2}px;'>#{graph}</svg>"

	end

	def tasks

		html = ""

		tasks = {}

		@logs.each do |log|
			tasks[log.task] = tasks[log.task].to_i + log.value
		end

		tasks.sort_by {|_key, value| value}.reverse.each do |task,value|
			task = "#{task}" == "" ? "Misc" : task
			percent = ((value/@sumAll.to_f)*1000).to_i/10.to_f
			# if percent < 1 then next end
			html += "
			<a class='task'>
				<span class='ratio'>#{percent}%</span>
				<strong>#{task}</strong>
				<span class='hours'>#{value}h</span>
			</a>"
		end

		return "<content class='details'>#{html}</content>"

	end

	def draw

	  	return "<content class='circlegraph'>#{graph}#{tasks}</content>"

	end

end