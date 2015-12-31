#: Main Traumae lessons

require_relative "traumae.tools.rb"

class Page

    def lessons
    	
        @dictionaery = {}
        @dictionaery = traumaeDatabase

        html = ""

        html += $page.definition
        html += traumaeLessons

        return "<content><wrapper>"+html+"</wrapper></content>"

    end

    def traumaeLessons

        html = ""

        lessonsArray = Hash.new

        # Lesson 1

        lessonsArray[0] = Hash.new
        lessonsArray[0]['title'] = "Say yes and no"
        lessonsArray[0]['subtitle'] = "Expressing agreement or disagreement"
        lessonsArray[0]['description'] = "<p>The first family that these lessons will explore is the \"alignment family\". The following 2 words/<a href='/Aeth'>Aeths</a> will speaks of your position/stance on a topic. \"Yes\" or \"No\", \"Good\" or \"Bad\". And so your first Traumae word will be <b>Yes</b>, <a href='/Traumae:xo'>xo</a>.<p>"
        lessonsArray[0]['type'] = "affirmation"
        lessonsArray[0]['examples'] = Hash.new
        lessonsArray[0]['examples'] = ["xo","bo"]

        lessonsArray[1] = Hash.new
        lessonsArray[1]['title'] = "Asking a question"
        lessonsArray[1]['subtitle'] = "Asking for agreement or disagreement"
        lessonsArray[1]['description'] = "<p>You now know <b>2 simple words</b>, that can now be mixed with eachother. As a third word, you need to learn \"<a href='/traumae:do'>do</a>\". Do is an interogation letter, transforming anything into a question. When combined with \"<a href='/traumae:xo'>xo</a>\", as \"<a href='/traumae:doxo'>doxo</a>\", it creates the construct \"Is it good?\", or simply \"good?\". </p>"
        lessonsArray[1]['type'] = "question"
        lessonsArray[1]['examples'] = Hash.new
        lessonsArray[1]['examples'] = ["doxo","dobo"]

        lessonsArray[2] = Hash.new
        lessonsArray[2]['title'] = "Making Verbs"
        lessonsArray[2]['subtitle'] = "Creating simple actions"
        lessonsArray[2]['description'] = "<p>The next most important word family is for actions-type words, or verbs. When used in the beginning of a word, the word will become an action. For instance, turning \"a thought\" into \"to think\".</p>"
        lessonsArray[2]['type'] = "verb"
        lessonsArray[2]['examples'] = Hash.new
        lessonsArray[2]['examples'] = ["so","lo","vo"]

        lessonsArray[3] = Hash.new
        lessonsArray[3]['title'] = "Combining previous lessons"
        lessonsArray[3]['subtitle'] = "will be updated soon"
        lessonsArray[3]['description'] = "<p>Simple enough, these constructs can also be mixed together to create new concepts.</p>"
        lessonsArray[3]['type'] = "misc"
        lessonsArray[3]['examples'] = Hash.new
        lessonsArray[3]['examples'] = ["loso","xoso","soxo"]

        lessonsArray[4] = Hash.new
        lessonsArray[4]['title'] = "Different types of verbs"
        lessonsArray[4]['subtitle'] = "will be updated soon"
        lessonsArray[4]['description'] = "<p>The third most important family talks of \"direction\". We are reaching more complex nuances with this family and the ability to create sentences and to imply directions within constructs. Direction in traumae can be explained as a relative motion from the self. For instance, giving would be an outward gesture, and taking would be inward as it is something that is coming closer to the self.</p><p>The following explains will show verbs which do not start with either so,lo or vo.</p>"
        lessonsArray[4]['type'] = "verb"
        lessonsArray[4]['examples'] = Hash.new
        lessonsArray[4]['examples'] = ["kaso","taso","paso"]

        lessonsArray[5] = Hash.new
        lessonsArray[5]['title'] = "Greetings"
        lessonsArray[5]['subtitle'] = "will be updated soon"
        lessonsArray[5]['description'] = "<p>Let us take a moment to learn how to say \"Hello\".</p>"
        lessonsArray[5]['type'] = "action"
        lessonsArray[5]['examples'] = Hash.new
        lessonsArray[5]['examples'] = ["xoka","xopa"]

        # Lessons print
        knownWords = Hash.new

        lessonsArray.sort.each do |k,v|

            html += "<h3 id='lesson"+(k+1).to_s+"'>"+(k+1).to_s+". "+v['title']+"</h3>"
            
            html += "<table style='width:auto;'>"
            html += "<tr><th>English</th><th>Traumae</th><th>Adultspeak</th></tr>"
            v['examples'].each do |k1,v1|
                html += "<tr><td>"+translate(k1,'english','core')+"</td><td>"+k1+"</td><td>"+adultSpeak(k1)+"</td></tr>"
                knownWords[k1] = v['type']
            end
            html += "</table>"

            html += v['description']
            html += "<hr/>"

        end

        return html

    end

end