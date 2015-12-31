# encoding: utf-8
#: The {{Term}} object are {{Lexicon}} contructs.

class Image

  def initialize name
  	@name = name
  end

  def file
  	if File.exist?("content/diary/#{@name}.jpg") then return "content/diary/#{@name}.jpg" end
  end

  def view
  	if file then return "<img src='#{file}'>" end
  	return ""
  end

end