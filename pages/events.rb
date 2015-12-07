=begin
<p>TODO:</p>
=end
class Layouts

  def events

  	@lastEvent = ""
  	@lastAlt = ""
  	return timeline

  end


  def timeline

  	html = ""

  	html += "
  	<style>
  	.timeline { font-family:'dinregular'; font-size:14px}
  	year { display:block; position:relative;}
  	year .label { text-align:center; display:block; font-family:'dinbold'; line-height: 60px}
  	month { display:block; width:1px; background:#ccc; height:20px; margin-left:50%; position:relative}
  	month .label { text-align:center; display:block; font-family:'dinregular'; font-size:14px;line-height: 15px;margin-top: 20px; left:-380px; position:absolute}
  	month .label .subtitle { font-size:12px; display:block; color:#bbb}
  	month event { display:block; position:absolute; top:calc(50% - 2px); height:5px; width:5px; border-radius:6px; background:#999; left:-2px }
  	month event .label { padding-left:30px;display:block;position: relative;top:-24px;left:15px; width:200px;text-align: left}
  	month event .label.now { font-family:'dinbold'}
  	month event.alt .label { text-align: right;left:-270px}
  	month event line { display: block;width: 30px;height: 1px;background: #999;position: absolute;top:2px}
  	month event.alt line { left:-30px;}
  	</style>
  	"

  	year = 2016
  	while year > 2005

  		html += "<year>"
  		html += "<span class='label'>"+year.to_s+"</span>"

  		month = 12
  		while month > 0
  			html += "<month>"
	  		html += monthEvents(year,month)
  			html += "</month>"
  			month -= 1
  		end

  		html += "</year>"
  		year -= 1
  	end

  	return "<div class='timeline'>"+html+"</div>"

  end

  def monthEvents year,month

  	html = ""

  	monthData = []

  	$horaire.all.each do |date,log|
  		if log.year != year then next end
  		if log.month != month then next end
  		monthData.push(log)
  	end

  	# Events
  	
  	monthData.each do |log|
  		if log.task != "Event" then next end
  		timeCode = year.to_s+month.to_s
  		lastCode = year.to_s+(month+1).to_s
  		subtitle = ""
  		subtitle = log.offset
  		if @lastEvent == lastCode && @lastAlt != 1
  			@lastEvent = timeCode
  			@lastAlt = 1
  			return "<event class='alt'><span class='label'>"+log.title+"<span class='subtitle'>"+subtitle+"</span></span><line></line></event>"
  		else
  			@lastEvent = timeCode
  			@lastAlt = 0
  			return "<event><span class='label'>"+log.title+"<span class='subtitle'>"+subtitle+"</span></span><line></line></event>"
  		end
  	end

  	if Time.now.month == month && Time.now.year == year
  		return "<event class='alt'><span class='label now'>Today</span><line></line></event>"
  	end

  	return html

  end

end