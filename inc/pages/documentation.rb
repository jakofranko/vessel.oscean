class Layouts

  def documentation

    html = ""
    Dir.entries("./inc/objects").sort.each do |fileName,v|
    	if fileName == "." then next end
	    if fileName == ".." then next end
    	html += "<h2>"+fileName.to_s.gsub(".rb","").capitalize+"</h2>"
    	html += details(fileName)
    	html += methods(fileName)
    end
  	return "<content class='wrap'>"+html+"</content>"

  end

  def details fileName

  	html = ""
  	filePath = "./inc/objects/"+fileName
  	File.open(filePath, 'r') do |f1|  
		while line = f1.gets  
			if !line.include?("#: ") then next end
			html += "<p>"+line.gsub("#:","")+"</p>"
			break
		end  
	end
	return "<ul>"+html+"</ul>"

  end

  def methods fileName

  	html = ""
  	filePath = "./inc/objects/"+fileName
  	File.open(filePath, 'r') do |f1|  
		while line = f1.gets  
			if !line.include?("def ") then next end
			if line.include?("initialize") then next end
			lineFormatted = line.gsub("def ","")
			methodName = lineFormatted.split(" ")[0]
			methodParam = lineFormatted.gsub(methodName,"").strip
			html += "<li style='color:#fff; font-size:12px; line-height:14px'><code>"+methodName+" <span style='color:#777'>"+methodParam+"</span></code></li>"
		end  
	end
	return "<ul style='background:#000; padding:15px'>"+html+"</ul>"

  end

end