class Layouts

    def divieths

        $dictionaery = $oscean.dictionaery()

        traumaeAeths = ["ki","ti","pi","xi","di","bi","si","li","vi","ka","ta","pa","xa","da","ba","sa","la","va","ko","to","po","xo","do","bo","so","lo","vo"]
        
        html = ""
        traumaeAeths.each do |currentTerm,v|
            html += "<h2><i>"+currentTerm.capitalize+"</i> "+$dictionaery.english(currentTerm)+"</h2>"
            html += $dictionaery.solver(currentTerm)
        end

        return html
    end

end