#: The timeline page displays various visualisations of Horaire.

require 'date'

class Page

  def body

    time1 = Time.new
    html = "<p>This is my life.<br />Every week, a cell goes dark</p>"
    html += timelineStyle
    year = 1
    while year < 60
    	html += year % 10 == 0 ? "<small class='divider'>"+year.to_s+"</small>" : ""
    	week = 0
    	while week < 52
    		if (year * 52)+week < (DateTime.now.mjd - DateTime.parse("22-03-1986").mjd)/7
    			html += "<cell style='background:black'></cell>"
    		else
    			html += "<cell></cell>"
    		end
    		week += 1
    	end
    	html += "<hr/>"
    	year += 1
    end
    return "<content class='wrap'>"+html+"</content>"

  end

  def timelineStyle

  	html = "
  	<style>
  		cell { float:left; width:9px; border:1px solid #000; height:3px; margin-right:1px; display:block; margin-bottom:1px}
  		small.divider { display: block;font-family: 'dinbold';font-size: 11px;line-height: 20px;color:#777}
  	</style>
  	"
  	return html

  end

end