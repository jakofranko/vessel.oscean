# encoding: utf-8

class Page

    def body

        @dict = $oscean.dictionaery()

        html = ""

        html += @term.definition
        html += docs_alphabet

        return "<content><wrapper>#{macros(html)}</wrapper></content>"

    end

    def docs_alphabet

        return "

        <h2>The Alphabet</h2>

        <p>It wouldn't be wrong to assume that traumae has 27 core words, and to learn these few concepts should be enough to guess at what a new word might mean. In practice, the relationship between sounds and meanings can become very blurry, it is good to rely on both memory and logic while learning traumae.</p>

        <table>
        <tr><th colspan='2'>Traversing</th><th colspan='2'>State</th><th colspan='2'>Origin</th></tr>

        <tr>
            <td>ki</td>
            <td>#{@dict["ki"].english}</td>
            <td>xi</td>
            <td>#{@dict["xi"].english}</td>
            <td>si</td>
            <td>#{@dict["si"].english}</td>
        </tr>

        <tr>
            <td>ti</td>
            <td>#{@dict["ti"].english}</td>
            <td>di</td>
            <td>#{@dict["di"].english}</td>
            <td>li</td>
            <td>#{@dict["li"].english}</td>
        </tr>

        <tr>
            <td>pi</td>
            <td>#{@dict["pi"].english}</td>
            <td>bi</td>
            <td>#{@dict["bi"].english}</td>
            <td>vi</td>
            <td>#{@dict["vi"].english}</td>
        </tr>

        <tr><th colspan='2'>Direction</th><th colspan='2'>Transformation</th><th colspan='2'>Counters</th></tr>

        <tr>
            <td>ka</td>
            <td>#{@dict["ka"].english}</td>
            <td>xa</td>
            <td>#{@dict["xa"].english}</td>
            <td>sa</td>
            <td>#{@dict["sa"].english}</td>
        </tr>

        <tr>
            <td>ta</td>
            <td>#{@dict["ta"].english}</td>
            <td>da</td>
            <td>#{@dict["da"].english}</td>
            <td>la</td>
            <td>#{@dict["la"].english}</td>
        </tr>
        <tr>
            <td>pa</td>
            <td>#{@dict["pa"].english}</td>
            <td>ba</td>
            <td>#{@dict["ba"].english}</td>
            <td>va</td>
            <td>#{@dict["va"].english}</td>
        </tr>

        <tr><th colspan='2'>Modality</th><th colspan='2'>Alignment</th><th colspan='2'>Interaction</th></tr>

        <tr>
            <td>ko</td>
            <td>#{@dict["ko"].english}</td>
            <td>xo</td>
            <td>#{@dict["xo"].english}</td>
            <td>so</td>
            <td>#{@dict["so"].english}</td>
        </tr>
        <tr>
            <td>to</td>
            <td>#{@dict["to"].english}</td>
            <td>do</td>
            <td>#{@dict["do"].english}</td>
            <td>lo</td>
            <td>#{@dict["lo"].english}</td>
        </tr>

        <tr>
            <td>po</td>
            <td>#{@dict["po"].english}</td>
            <td>bo</td>
            <td>#{@dict["bo"].english}</td>
            <td>vo</td>
            <td>#{@dict["vo"].english}</td>
        </tr>

        </table>

        <p>Similarly to how kanji compound words work, Traumae constructs are formed by combining letters from its alphabet. To give you a sense of the possibilities of Traumae, the following table will show you how to create many words stemming from the <a href='So'>so</a> letter, in combination with the <a href='Ka'>ka</a>, <a href='Ta'>ta</a> & <a href='Pa'>pa</a> syllables.</p>

        <table>
        <tr><th></th><th colspan='2'>ka</th><th colspan='2'>ta</th><th colspan='2'>pa</th></tr>
        <tr><th>so</th><td>soka</td><td>#{@dict["soka"].english}</td><td>sota</td><td>#{@dict["sota"].english}</td><td>sopa</td><td>#{@dict["sopa"].english}</td></tr>
        <tr><th>lo</th><td>loka</td><td>#{@dict["loka"].english}</td><td>lota</td><td>#{@dict["lota"].english}</td><td>lopa</td><td>#{@dict["lopa"].english}</td></tr>
        <tr><th>vo</th><td>voka</td><td>#{@dict["voka"].english}</td><td>vota</td><td>#{@dict["vota"].english}</td><td>vopa</td><td>#{@dict["vopa"].english}</td></tr>
        </table>

        <p>A common difficulty with Traumae is to properly divide the words and to use the correct sequence of letter to express a specific concept - or which letter comes first in <a href='xoka'>xoka</a>, why is it not <a href='kaxo'>kaxo</a>.</p>

        <table><tr><th>Do loka</th><td>#{@dict["do loka"].english}</td><th>Dolo ka</th><td>#{@dict["dolo ka"].english}</td></tr></table>"

    end

    def traumaeDocumentation

        return "

        
        <h2>The Pronouns</h2>

        <p>Traumae's grammar is asexual and its pronouns are divided into four families and three persons, where \"it\" is included in the third family.</p>

        <table>
        <tr>
        <th colspan='2'>&nbsp;</th>
        <th colspan='2'><b>Nominative</b></th>
        <th colspan='2'><b>Oblique</b></th>
        <th colspan='2'><b>Genitive</b></th>
        <th colspan='2'><b>Possessive</b></th>
        </tr>
        <tr>
          <th></th>
          <th></th>
          <th>English</th>
          <th>traumae</th>
          <th>English</th>
          <th>traumae</th>
          <th>English</th>
          <th>traumae</th>
          <th>English</th>
          <th>traumae</th>
        </tr>
        <tr>
        <th rowspan='2'><b>1st person</b></th>
        <th><i>singular</i></th>
        <td>I</td><td>"+$dictionaery.traumae('first person singular nominative')+"</td>
        <td>me</td><td>"+$dictionaery.traumae('first person singular oblique')+"</td>
        <td>my</td><td>"+$dictionaery.traumae('first person singular genitive')+"</td>
        <td>mine</td><td>"+$dictionaery.traumae('first person singular possessive')+"</td>
        </tr>
        <tr>
        <th><i>plural</i></th>
        <td>we</td><td>"+$dictionaery.traumae('first person plural nominative')+"</td>
        <td>us</td><td>"+$dictionaery.traumae('first person plural oblique')+"</td>
        <td>our</td><td>"+$dictionaery.traumae('first person plural genitive')+"</td>
        <td>ours</td><td>"+$dictionaery.traumae('first person plural possessive')+"</td>
        </tr>
        <tr>
        <th rowspan='2'><b>2nd person</b></th>
        <th><i>singular</i></th>
        <td>you</td><td>"+$dictionaery.traumae('second person singular nominative')+"</td>
        <td>you</td><td>"+$dictionaery.traumae('second person singular oblique')+"</td>
        <td>your</td><td>"+$dictionaery.traumae('second person singular genitive')+"</td>
        <td>yours</td><td>"+$dictionaery.traumae('second person singular possessive')+"</td>
        </tr>
        <tr>
        <th><i>plural</i></th>
        <td>you</td><td>"+$dictionaery.traumae('second person plural nominative')+"</td>
        <td>you</td><td>"+$dictionaery.traumae('second person plural oblique')+"</td>
        <td>your</td><td>"+$dictionaery.traumae('second person plural genitive')+"</td>
        <td>yours</td><td>"+$dictionaery.traumae('second person plural possessive')+"</td>
        </tr>
        <tr>
        <th rowspan='2'><b>3rd person</b></th>
        <th><i>singular</i></th>
        <td>he/she/it</td><td>"+$dictionaery.traumae('third person singular nominative')+"</td>
        <td>them</td><td>"+$dictionaery.traumae('third person singular oblique')+"</td>
        <td>their</td><td>"+$dictionaery.traumae('third person singular genitive')+"</td>
        <td>theirs</td><td>"+$dictionaery.traumae('third person singular possessive')+"</td>
        </tr>
        <tr>
        <th><i>plural</i></th>
        <td>they</td><td>"+$dictionaery.traumae('third person plural nominative')+"</td>
        <td>them</td><td>"+$dictionaery.traumae('third person plural oblique')+"</td>
        <td>their</td><td>"+$dictionaery.traumae('third person plural genitive')+"</td>
        <td>theirs</td><td>"+$dictionaery.traumae('third person plural possessive')+"</td>
        </tr>
        </table>

        <h2 id='verbs'>The Verbs</h2>

        <p>The following table shows the permutations of tenses and modality of the three main traumae verbs/actions. Additional verbs can be created by mixing traumae axioms, for example, <i>soxi</i> means "+$dictionaery.english('soxi')+" and <i>palo</i> means "+$dictionaery.english('palo')+".</p>

        <table>
            <tr><th>Tense</th><th colspan='2'><b>Past</b></th><th colspan='2'><b>Present</b></th><th colspan='2'><b>Future</b></th></tr>

            <tr>
              <th></th>
              <th>English</th>
              <th>traumae</th>
              <th>English</th>
              <th>traumae</th>
              <th>English</th>
              <th>traumae</th>
            </tr>
            <tr><th rowspan='3'><b>Normal</b></th>
                <td>was seeing</td><td>"+$dictionaery.traumae('past')+" "+$dictionaery.traumae('to see')+"</td>
                <td>am seeing</td>   <td> "+$dictionaery.traumae('to see')+"</td>
                <td>will be seeing</td> <td>"+$dictionaery.traumae('future')+" "+$dictionaery.traumae('to see')+"</td></tr>
            <tr>
                <td>was being</td>   <td>"+$dictionaery.traumae('past')+" "+$dictionaery.traumae('to be')+"</td>
                <td>am being</td>      <td>"+$dictionaery.traumae('to be')+"</td>
                <td>will be</td>    <td>"+$dictionaery.traumae('future')+" "+$dictionaery.traumae('to be')+"</td>
            </tr>
            <tr>
                <td>was doing</td>   <td>"+$dictionaery.traumae('past')+" "+$dictionaery.traumae('to do')+"</td>
                <td>am doing</td>      <td> "+$dictionaery.traumae('to do')+"</td>
                <td>will be doing</td>    <td>"+$dictionaery.traumae('future')+" "+$dictionaery.traumae('to do')+"</td>
            </tr>

            <tr><th rowspan='3'><b>Impossible</b></th>
                <td>could not see</td><td>"+$dictionaery.traumae('past')+" "+$dictionaery.traumae('impossible')+" "+$dictionaery.traumae('to see')+"</td>
                <td>cannot see</td>   <td>"+$dictionaery.traumae('impossible')+" "+$dictionaery.traumae('to see')+"</td>
                <td>will not see</td> <td>"+$dictionaery.traumae('future')+" "+$dictionaery.traumae('impossible')+" "+$dictionaery.traumae('to see')+"</td></tr>
            <tr>
                <td>could not be</td>   <td>"+$dictionaery.traumae('past')+" "+$dictionaery.traumae('impossible')+" "+$dictionaery.traumae('to be')+"</td>
                <td>cannot be</td>      <td>"+$dictionaery.traumae('impossible')+" "+$dictionaery.traumae('to be')+"</td>
                <td>will not be</td>    <td>"+$dictionaery.traumae('future')+" "+$dictionaery.traumae('impossible')+" "+$dictionaery.traumae('to be')+"</td>
            </tr>
            <tr>
                <td>could not do</td>   <td>"+$dictionaery.traumae('past')+" "+$dictionaery.traumae('impossible')+" "+$dictionaery.traumae('to do')+"</td>
                <td>cannot do</td>      <td>"+$dictionaery.traumae('impossible')+" "+$dictionaery.traumae('to do')+"</td>
                <td>will not do</td>    <td>"+$dictionaery.traumae('future')+" "+$dictionaery.traumae('impossible')+" "+$dictionaery.traumae('to do')+"</td>
            </tr>

            <tr><th rowspan='3'><b>Potential</b></th>
                <td>could see</td>    <td>"+$dictionaery.traumae('past')+" "+$dictionaery.traumae('possible')+" "+$dictionaery.traumae('to see')+"</td>
                <td>can see</td>      <td>"+$dictionaery.traumae('possible')+" "+$dictionaery.traumae('to see')+"</td>
                <td>might see</td>    <td>"+$dictionaery.traumae('future')+" "+$dictionaery.traumae('possible')+" "+$dictionaery.traumae('to see')+"</td>
            </tr>
            <tr>
                <td>could be</td>           <td>"+$dictionaery.traumae('past')+" "+$dictionaery.traumae('possible')+" "+$dictionaery.traumae('to be')+"</td>
                <td>can be</td>             <td>"+$dictionaery.traumae('possible')+" "+$dictionaery.traumae('to be')+"</td>
                <td>might be</td>           <td>"+$dictionaery.traumae('future')+" "+$dictionaery.traumae('possible')+" "+$dictionaery.traumae('to be')+"</td>
            </tr>
            <tr>
                <td>could do</td>           <td>"+$dictionaery.traumae('past')+" "+$dictionaery.traumae('possible')+" "+$dictionaery.traumae('to do')+"</td>
                <td>can do</td>             <td>"+$dictionaery.traumae('possible')+" "+$dictionaery.traumae('to do')+"</td>
                <td>might do</td>           <td>"+$dictionaery.traumae('future')+" "+$dictionaery.traumae('possible')+" "+$dictionaery.traumae('to do')+"</td>
            </tr>

            <tr><th rowspan='3'><b>Certainty</b></th>
                <td>must have seen</td>  <td>"+$dictionaery.traumae('past')+" "+$dictionaery.traumae('possible')+" "+$dictionaery.traumae('to see')+"</td>
                <td>must see</td>         <td>"+$dictionaery.traumae('possible')+" "+$dictionaery.traumae('to see')+"</td>
                <td>will have to see</td> <td>"+$dictionaery.traumae('future')+" "+$dictionaery.traumae('possible')+" "+$dictionaery.traumae('to see')+"</td>
            </tr>
            <tr>
                <td>must have been</td>     <td>"+$dictionaery.traumae('past')+" "+$dictionaery.traumae('certainty')+" "+$dictionaery.traumae('to be')+"</td>
                <td>must be</td>            <td>"+$dictionaery.traumae('certainty')+" "+$dictionaery.traumae('to be')+"</td>
                <td>will have to be</td>    <td>"+$dictionaery.traumae('future')+" "+$dictionaery.traumae('certainty')+" "+$dictionaery.traumae('to be')+"</td>
            </tr>
            <tr><td>must have done</td>     <td>"+$dictionaery.traumae('past')+" "+$dictionaery.traumae('certainty')+" "+$dictionaery.traumae('to do')+"</td>
                <td>must do</td>            <td>"+$dictionaery.traumae('certainty')+" "+$dictionaery.traumae('to do')+"</td>
                <td>will have to do</td>    <td>"+$dictionaery.traumae('future')+" "+$dictionaery.traumae('certainty')+" "+$dictionaery.traumae('to do')+"</td>
            </tr>

        </table>

        <p>Feel free to contact me at aliceffekt@gmail.com if you have any further question.</p>

        "

    end

end