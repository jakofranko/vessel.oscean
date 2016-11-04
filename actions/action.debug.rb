class ActionDebug

  include Action

  def act q = "Home"

    load_folder("#{@host.path}/objects/*")

    @horaire = Memory_Array.new("horaire",@host.path)
    @lexicon = Memory_Hash.new("lexicon",@host.path)

    text =  "Next Available Diary  : #{next_available_diary}\n"
    text += "Missing Horaire Logs  : #{missing_logs.first}\n"
    text += "Missing Lexicon Terms : #{missing_terms.first}\n"

    return text

  end

  private

  def next_available_diary

    diaries = []
    @horaire.to_a.each do |log|
      if !log["PICT"] then next end
      diaries.push(log["PICT"].to_i)
    end
    diaries = diaries.sort

    i = 1
    while i < 9999
      if !diaries.include?(i) then return i end
      i += 1
    end
    return nil

  end

  def missing_logs    

    array = []
    dates = []
    @horaire.to_a.each do |log|
      dates.push(log['DATE'])
    end
    i = 0
    while i < (365 * 10)
      test2 = Time.now - (i * 24 * 60 * 60)
      y = test2.to_s[0,4]
      m = test2.to_s[5,2]
      d = test2.to_s[8,2]
      i += 1
      if !dates.include?("#{y} #{m} #{d}")
        array.push("#{y} #{m} #{d}")
      end
    end
    return array

  end

  def missing_terms

    array = []

    @horaire.to_a("log").each do |log|
      if !@lexicon.filter("term",log.topic,"term").type.to_s.like("missing") then next end
      array.push(log.topic)
    end
    
    return array.uniq

  end

end