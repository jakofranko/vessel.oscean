# encoding: utf-8

class Icon

	def logo scale
	  return "
	  <svg height='"+(110*scale).to_s+"' width='"+(600*scale).to_s+"' class='logo'>
	    <path d='
	    M "+(10*scale).to_s+" "+(10*scale).to_s+" 
	    l 0 "+(70*scale).to_s+" 
	    a "+(25*scale).to_s+","+(25*scale).to_s+" 0 0,0 "+(50*scale).to_s+",0
	    l 0 -"+(50*scale).to_s+"
	    a "+(25*scale).to_s+","+(25*scale).to_s+" 0 1,1 "+(50*scale).to_s+",0
	    l 0 "+(50*scale).to_s+" 
	    a "+(25*scale).to_s+","+(25*scale).to_s+" 0 0,0 "+(50*scale).to_s+",0
	    l 0 -"+(50*scale).to_s+"
	    a "+(25*scale).to_s+","+(25*scale).to_s+" 0 1,1 "+(50*scale).to_s+",0
	    l 0 "+(75*scale).to_s+" 
	    l "+(50*scale).to_s+" 0 
	    l 0 -"+(100*scale).to_s+"
	    l "+(50*scale).to_s+" 0 
	    l 0 "+(100*scale).to_s+" 
	    l "+(50*scale).to_s+" 0 
	    l 0 -"+(100*scale).to_s+"
	    l "+(2*scale).to_s+" 0 
	    l "+(50*scale).to_s+" "+(95*scale).to_s+" 
	    l "+(50*scale).to_s+" -"+(90*scale).to_s+"
	    l "+(70*scale).to_s+" "+(120*scale).to_s+"
	    ' stroke='white' stroke-width='2' fill='none'/>
	  </svg>"

	end

	def diary
	  return "<svg class='icon'>
	  <line x1='3' y1='17.5' x2='12.5' y2='17.5' style='stroke:#fff;stroke-width:2' />
	  <line x1='3' y1='12.5' x2='22' y2='12.5' style='stroke:#fff;stroke-width:2' />
	  <line x1='3' y1='7.5' x2='22' y2='7.5' style='stroke:#fff;stroke-width:2' />
	  </svg>"
	end

	def horaire
	  return "<svg class='icon'><path d='
	    M 3 12.5 
	    l 5 0
	    l 4 -5
	    l 4 10
	    l 4 -5
	    l 5 0
	    ' stroke='white' stroke-width='2' fill='none'/>
	  </svg>"
	end

	def version
	  return "<svg class='icon'>
	  <line x1='3' y1='17.5' x2='22' y2='17.5' style='stroke:#fff;stroke-width:2' />
	  <line x1='3' y1='12.5' x2='10.5' y2='12.5' style='stroke:#fff;stroke-width:2' />
	  <line x1='14.5' y1='12.5' x2='22' y2='12.5' style='stroke:#fff;stroke-width:2' />
	  <line x1='3' y1='7.5' x2='22' y2='7.5' style='stroke:#fff;stroke-width:2' />
	  </svg>"
	end

	def return
	  return "<svg class='icon'>
	  <line x1='3' y1='12.5' x2='8' y2='17.5' style='stroke:#fff;stroke-width:2' />
	  <line x1='3' y1='12.5' x2='8' y2='7.5' style='stroke:#fff;stroke-width:2' />
	  <line x1='3' y1='12.5' x2='16' y2='12.5' style='stroke:#fff;stroke-width:2' />
	  </svg>"
	end

	def photo
	  return "<svg class='icon'>
	  <line x1='3' y1='12.5' x2='22' y2='12.5' style='stroke:#ccc;stroke-width:2' />
	  <circle cx='12.5' cy='12.5' r='7' stroke='#ccc' stroke-width='2' fill='none'/>
	  </svg>"
	end

end