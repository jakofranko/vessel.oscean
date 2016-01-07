#: The timeline page displays various visualisations of Horaire.

require 'date'

class Page

  def body

    html = macros(@term.definition)
    time1 = Time.new
    html += timelineStyle
    year = 1
    while year < 60
    	html += year % 10 == 0 ? "<small class='divider'>"+year.to_s+"</small>" : ""
    	week = 0
    	while week < 52
    		if (year * 52)+week < (DateTime.now.mjd - DateTime.parse("22-03-1986").mjd)/7
    			html += "<cell class='black'></cell>"
    		else
    			html += "<cell></cell>"
    		end
    		week += 1
    	end
    	html += "<hr/>"
    	year += 1
    end
    return "<content class='wrap' style='line-height:3px'>"+html+"</content>"

  end

  def timelineStyle

  	html = "
  	<style>
  		cell { display: inline-block;width: calc(1.9% - 2px);background: white;height: 6px;margin: 1px 0px 0px 1px;border-radius: 10px}
      cell.black { background:black}
  		small.divider { display: block;font-family: 'dinbold';font-size: 11px;line-height: 30px;color: #000;}
  	</style>
  	"
  	return html

  end

end