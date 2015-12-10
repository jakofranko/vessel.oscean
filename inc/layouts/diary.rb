class Layouts

  def theater_diary

    if $page.topic == "Diary" then return printDiaries(diaryArrayGeneral) end
    html = ""

    diaries = $page.diaries

    $page.diaries.reverse.each do |log|
      html += log.templateDiary
    end

    return html

  end

  def printDiaries diaryArray

    diaryPage = 1

    if $module.to_i > 0
      diaryPage = $module.to_i
    end

    html = ""

    pageFrom = ((diaryPage*5)-6)
    pageUntil = 5
    pageNext = (diaryPage+1)
    pagePrev = (diaryPage-1)


    # List

    count = -1
    diaryArray.each do |log|

      count += 1

      if count < pageFrom+1 then next end
      if count > pageFrom+pageUntil then break end

      html += log.templateDiary

    end 

    # Pagination

    html += "<content class='pagination'>"
    if pageFrom > 1
      html += "<a href='/"+$page.topic+":"+pagePrev.to_s+"' class='left'>Previous Entries</a>"
    end
    if diaryArray.count > pageFrom+pageUntil+1
      html += "<a href='/"+$page.topic+":"+pageNext.to_s+"' class='right'>Next Entries</a>"
    end
    html += "<hr/></content>"

    return "<content class='wide'>"+html+"</content>"

  end

  def diaryArrayGeneral
    diaries = []
    qr_lexicon = $quest.query("SELECT * FROM XIV_Horaire WHERE photo > 0 order by date DESC")
    while row = qr_lexicon.fetch_row do
      log = Log.new({'date' => row[0], 'verb' => row[1], 'topic' => row[2], 'location' => row[3], 'photo' => row[4].to_i, 'title' => row[5], 'full' => row[6],'storage' => row[7]})
      diaries.push(log)
    end
    return diaries
  end

end