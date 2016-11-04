class Term

  def rating

    v = 0
    tips = []

    # Unde

    if @unde 
      v += 1
    else
      tips.push("Unde is missing.")
    end

    # Bref

    if @bref 
      v += 1
      if @bref.length > 170 then tips.push("Bref is too long(#{@bref.length}).")
      elsif @bref.length < 70 then tips.push("Bref is too short(#{@bref.length}).")
      else v += 1 end
    else
      tips.push("Bref is missing.")
    end

    # Long

    if @long.length > 0
      v += 1
      if @long.length > 5 then tips.push("Long is too long, convert to MemoryHash.")
      elsif @long.length < 2 then tips.push("Long is too short.")
      else v += 1 end
    end
    
    return v,tips

  end

end

class ActionComplete

  include Action

  def act q = nil

    @horaire = Memory_Array.new("horaire",@host.path)
    @lexicon = Memory_Hash.new("lexicon",@host.path)

    load_folder("#{@host.path}/objects/*")

    @lexicon.to_h("term").each do |name,term|
      rating = term.rating
      if rating.last.length < 1 then next end
      puts "#{term.name} #{rating.first}pts"
      rating.last.each do |tip|
        puts "- #{tip}"
      end
    end

    return ""

  end

  def lexicon_missing_brefs

    return []

  end

end