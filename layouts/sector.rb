=begin
<p>TODO:</p>
=end
class Layouts

	def sector

		html = ""
		html += sectorRecentPhotos

		return html

	end

	def sectorRecentPhotos

		html = ""

		html += "<div>"
		count = 1
		topics = []
		$horaire.all.each do |date,log|
			if log.sector != $page.topic.downcase then next end 
			if log.photo < 1 then next end
			if count > 9 then break end
			if topics.include?(log.topic) then next end
			html += "
			<div style='width:calc(33.33% - 10px); padding-right:10px; float:left '>
				<a href='/"+log.topic+"'><img src='img/diary/"+log.photo.to_s+".jpg'/></a>
				<p style='font-family:dinregular; font-size:14px; line-height:16px'>
					<a href='/"+log.topic+"' style='font-size:14px; font-family:dinbold;display:block;border-bottom:0px'>"+log.topic+"</a>
					<a href='/"+$lexicon.term(log.topic).parent+"' style='font-size:12px;border-bottom:0px'>"+$lexicon.term(log.topic).parent+"</a>
				</p>
			</div>"
			topics.push(log.topic)
			count += 1
		end
		html += "</div>"

		html += "<hr />"

		return html
	end

end