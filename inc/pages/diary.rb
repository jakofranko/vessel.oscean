
class Page

  def body

    html = ""
    page = @module.to_i
    perPage = 10

    i = 0
    @diaries.each do |log|
    	from = page*perPage
    	to = from+perPage
    	if i >= from && i < to then html += log.diary_template end
    	i += 1
    end

    html += "<p><a href='/Diary:#{(page+1)}'>Continue reading..</a></p>"

  	return html

  end
end