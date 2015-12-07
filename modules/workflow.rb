require_relative "../objects/graph.rb"

class Layouts

  def workflow

    html = ""

    @issuesList = getIssues

    html += printIssues(@issuesList)

    return html
    
  end

  def module_workflow

    return printIssues(getIssues)

  end

  def calendar

    calReturn = {}
    $issues.each do |issue|

      if !calReturn[issue.year] then calReturn[issue.year] = {} end
      if !calReturn[issue.year][issue.month] then calReturn[issue.year][issue.month] = {} end
      if !calReturn[issue.year][issue.month]["active"] then calReturn[issue.year][issue.month]["active"] = 0 end
      if !calReturn[issue.year][issue.month]["closed"] then calReturn[issue.year][issue.month]["closed"] = 0 end

      if issue.active
        calReturn[issue.year][issue.month]["active"] += 1
      else
        calReturn[issue.year][issue.month]["closed"] += 1
      end
    end

    return calReturn

  end

  def getIssues

    # Dynamic tasks
    if $page.topic == "Workflow" || $page.topic == "Oscean"
      $issues.push(Issue.new({'id' => 0, 'topic' => "Oscean", 'task' => availableDiary, 'release' => "", 'date' => ""}))
      $issues.push(Issue.new({'id' => 0, 'topic' => "Oscean", 'task' => termMissingInLexicon, 'release' => "", 'date' => ""}))
      $issues.push(Issue.new({'id' => 0, 'topic' => "Oscean", 'task' => logMissingInHoraire, 'release' => "", 'date' => ""}))
    end
    if $page.topic == "Workflow" || $page.topic == "Traumae"
      $issues.push(Issue.new({'id' => 0, 'topic' => "Traumae", 'task' => diviethCompletion, 'release' => "", 'date' => ""}))
    end
    
    # Sort issues by topic
    tasks = {}
    $issues.each do |issue|
      if !tasks[issue.topic] then tasks[issue.topic] = [] end
      tasks[issue.topic].push(issue)
    end

    # Get updates logs
    updatesLogs = {}
    $horaire.all.each do |date,log|
      if log.task != "Update" then next end
      if !updatesLogs[log.topic] then updatesLogs[log.topic] = [] end
      updatesLogs[log.topic].push(log.title)
    end

    sortedTasks = {}
    tasks.each do |topic,issues|
      issues.each do |issue|
        if !sortedTasks[issue.topic] then sortedTasks[issue.topic] = {"open" => [],"unreleased" => [],"closed" => []} end
        if !updatesLogs[issue.topic] then updatesLogs[issue.topic] = [] end
        if issue.active
          sortedTasks[issue.topic]["open"].push(issue)
        elsif !issue.active && !updatesLogs[issue.topic].include?(issue.release)
          sortedTasks[issue.topic]["unreleased"].push(issue)
        else
          sortedTasks[issue.topic]["closed"].push(issue)
        end
      end
    end

    return sortedTasks

  end

  def printIssues issuesArray

  	html = ""

    list_ready = printByTopicsStatus(issuesArray,"ready")
    list_active = printByTopicsStatus(issuesArray,"active")
    list_new = printByTopicsStatus(issuesArray,"new")

    if list_ready[1] > 0
    	html += "<h2>#{list_ready[1]} Ready for Release</h2>"
	    html += list_ready[0]
	end
    if list_active[1] > 0
    	html += "<h2>#{list_active[1]} Active Updates</h2>"
	    html += list_active[0]
	end
    if list_new[1] > 0
    	html += "<h2>#{list_new[1]} Upcoming Updates</h2>"
	    html += list_new[0]
	end

    return html

  end

  def printByTopicsStatus issuesArray, status

  	count = 0
  	html = "<ul class='minimal'>"
    issuesArray.sort.each do |topic,issuesTypes|

	  if status == "ready" && issuesTypes["open"].length != 0 then next end
	  if status == "active" && issuesTypes["unreleased"].length == 0 || status == "active" &&  issuesTypes["open"].length == 0 then next end
	  if status == "new" && issuesTypes["unreleased"].length != 0 then next end

      # Skip Inactive topics
      if issuesTypes["open"].length == 0 && issuesTypes["unreleased"].length == 0 then next end

      # Get next version
      if issuesTypes["unreleased"].length > 0
        nextVersion = issuesTypes["unreleased"].first.release 
      else 
        nextVersion = "" 
      end

      # Get completion percentage
      percentage = (issuesTypes["unreleased"].length / (issuesTypes["open"].length.to_f + issuesTypes["unreleased"].length.to_f)) * 100
      if percentage == 100
        completion = "<span>Complete</span>"
      elsif percentage > 0
        completion = "<span>#{percentage.to_i}% Progress</span>"
      else 
        completion = "" 
      end

      # Heading
      html += "<li class='head' style='padding: 10px 62px;'>{{#{topic}}} #{nextVersion} #{completion}</li>"
      issuesTypes["open"].each do |issue|
      	html += issue.template
      end
      issuesTypes["unreleased"].each do |issue|
      	html += issue.template
      end
      if issuesTypes["closed"].length > 0
        html += "<a href='/#{topic}:Issues' style='font-size:14px;margin-left:65px;color:#999;line-height: 12px'>"+issuesTypes["closed"].length.to_s+" Closed Issues.</a>"
      end

      count += 1
    end
    html += "</ul>"

    return html, count
  end

  def diviethCompletion

    dict = $oscean.dictionaery()

    divieths = {}
    dict.all.each do |laeth|
      if laeth.traumae.length != 4 then next end
      divieths[laeth.traumae] = 0
    end

    return "Complete {{Divieths}}, "+((divieths.length/729.0)*100).to_i.to_s+"% completed."

  end

  def logMissingInHoraire

    now = Time.new

    year = 2011
    while year <= now.year.to_i
      month = 1
      while month <= 12
        day = 1
        while day <= days_in_month(year, month)
          if year >= now.year.to_i && month >= now.month.to_i && day >= now.day.to_i then return "There are no missing days in {{Horaire}}." end
          if !$horaire.logOnDate(year,month,day) then return "Add missing {{Horaire}} entry for <code>#{year}-#{month}-#{day}</code>." end
          day += 1
        end
        month += 1
      end
      year += 1
    end

    return "There are no missing days in {{Horaire}}."

  end

  def availableDiary

    photos = []
    $horaire.all.each do |date,log|
      if log.photo == 0 then next end
      photos.push(log.photo)
    end

    available = 1
    while available < 999
      if !photos.include?(available) then return "The next available diary is #{available}." end
      available += 1
    end

  end

  def termMissingInLexicon

    $horaire.all.each do |date,log|
      if $lexicon.find(log.topic) then next end
      return "Add missing lexicon entry for {{#{log.topic}}}."
    end
    return "There are no missing lexicon entries."

  end

  def days_in_month(year, month)
    Date.new(year, month, -1).day
  end

end