=begin
<p>The Traumae documentation page.</p>
=end

require_relative "page.traumae.tools.rb"

class Layouts

    def traumaeNotes

        return "
        <h2>Additional Notes</h2>
        <p>This article has for goal to explain the reasons behind some aspects of the <a href='Traumae'>Traumae</a> syntetic language. These notes were inspired or taken from <a href='/The+voidshaper+document'>The voidshaper document</a>.</p>

        <h2>Choice of Aeths</h2>
        <p>The selection of the <i>core letters</i> are done following a few rules. </p>

        <ul>
        <li>Constructs should aspire to be immaterial, complex and infinite.</li>
        <li>Every permutation of two different letter should be comprehensible.</li>
        <li>Everything is dual, everything has two poles.</li>
        </ul>

        <p>While the choice for the simplier letters is easy to understand by comparing them against their opponent, some might be a bit harder to understand, partly due to the fact that they had to be translated into a single english word, where in some cases might not be the best of choices.</p>


        <p>The core meanings were not chosen to map the english language perfectly or even to explain everyday tasks. The language was originaly meant to talk of ideas rather than things. You can look at the <a href='Divieths'>Divieths Dictionary</a> to see the list of 2 letters permutations.</p>

        <p>As highlited in the Voidshaper document, traumae constructs are better explained using the object.method pattern, ex: observation.multiplicity, rather than the <i>X of Y</i>, ex: the multiplicity of observation. And so using this pattern we can look at the core meanings in context as follow:</p>

        <pre>saso => so.sa(observation.multiplicity) or sight.multiply </pre>

        <p>This pattern seems ideal to visualise the letters, where each core letter have 27 associated methods and sentences are but a larger set of methods created from the combination of core letters.</p>

        <pre>posaso => saso.po</pre>

        <h2>Sounds</h2>

        <p>The pattern used to create the sound is very visual and should help to form a mental image of the sound for if only a few sounds are know, the remining ones can be extrapolated. The whole alphabet can be mapped onto a cube, splitting the cube into 3 horizontal layers will look as the following table.</p>

        <table>
        <tr><th colspan='3'>Layer 1</th><th colspan='3'>Layer 2</th><th colspan='3'>Layer 3</th></tr>
        <tr><td>ki</td><td>xi</td><td>si</td><td>ka</td><td>xa</td><td>sa</td><td>ko</td><td>xo</td><td>so</td></tr>
        <tr><td>ti</td><td>di</td><td>li</td><td>ta</td><td>da</td><td>la</td><td>to</td><td>do</td><td>lo</td></tr>
        <tr><td>pi</td><td>bi</td><td>vi</td><td>pa</td><td>ba</td><td>va</td><td>po</td><td>bo</td><td>vo</td></tr>
        </table>

        <p>If we compare the sounds used in traumae against our alphabet, we get the following graph of unused letters and sounds.</p>

        <table>
        <tr>
        <th>a</th>
        <th>b</th>
        <td>c</td>
        <th>d</th>
        <td>e</td>
        <td>f</td>
        <td>g</td>
        <td>h</td>
        <th>i</th>
        <td>j</td>
        <th>k</th>
        <th>l</th>
        <td>m</td>
        </tr>
        <tr>
        <td>n</td>
        <th>o</th>
        <th>p</th>
        <td>q</td>
        <td>r</td>
        <th>s</th>
        <th>t</th>
        <td>u</td>
        <th>v</th>
        <td>w</td>
        <th>x</th>
        <td>y</td>
        <td>z</td>
        </tr>
        </table>

        <p>The sounds go from sharp to round as the letters' meaning are going toward simplicity and materiality. </p>

        <table>
        <tr><th colspan='2'>Sharp</th><th colspan='2'>Transition</th><th colspan='2'>Round</th></tr>
        <tr><td>K</td><td>></td><td>T</td><td>></td><td>P</td></tr>
        <tr><td>X</td><td>></td><td>D</td><td>></td><td>B</td></tr>
        <tr><td>S</td><td>></td><td>L</td><td>></td><td>V</td></tr>
        </table>

        <h2>Counting System</h2>

        <p>Below is a draft of the number system, currently base 8.</p>

        <table>
        <tr><td>-1</td><td>vala</td><td>Lack of 1</td></tr>
        <tr><td>0</td><td>va</td><td>Lack of</td></tr>
        <tr><td>1</td><td>la</td><td>One</td></tr>
        <tr><td>2</td><td>sa</td><td>Small plural</td></tr>
        <tr><td>3</td><td>da</td><td>Between base 2 and base 4</td></tr>
        <tr><td>4</td><td>sasa</td><td>Combine of two smallest plural(2x2)</td></tr>
        <tr><td>5</td><td>xa</td><td>Actually sasaxa, 4+1</td></tr>
        <tr><td>6</td><td>sada</td><td>Between base 4 and base 8</td></tr>
        <tr><td>7</td><td>ba</td><td>Actually sasasaba or lavaba, 8-1</td></tr>
        <tr><td>8</td><td>la va</td><td>One and 0, 10</td></tr>
        </table> 

        <h2 id='functions'>The Functions</h2>

        <p>A preliminary list of particles, this is a work in progress.</p>

        <table>

            <tr><th>Type</th><th>Category</th><th>English</th><th>Traumae</th></tr>

            <tr><th rowspan='12'>Prepositions</th><th rowspan='3'>Spacial</th><td>over</td><td>"+translate('over','traumae','core')+"</td></tr>
            <tr><td>at</td><td>"+translate('at','traumae','core')+"</td></tr>
            <tr><td>under</td><td>"+translate('under','traumae','core')+"</td></tr>

            <tr><th rowspan='3'>Spacial Inward</th><td>on</td><td>"+translate('on','traumae','core')+"</td></tr>
            <tr><td>in</td><td>"+translate('in','traumae','core')+"</td></tr>
            <tr><td>onto</td><td>"+translate('onto','traumae','core')+"</td></tr>

            <tr><th rowspan='3'>Spacial Stable</th><td>for</td><td>"+translate('for','traumae','core')+"</td></tr>
            <tr><td>to</td><td>"+translate('to','traumae','core')+"</td></tr>
            <tr><td>by</td><td>"+translate('by','traumae','core')+"</td></tr>

            <tr><th rowspan='3'>Spacial Outward</th><td>up</td><td>"+translate('up','traumae','core')+"</td></tr>
            <tr><td>between</td><td>"+translate('between','traumae','core')+"</td></tr>
            <tr><td>down</td><td>"+translate('down','traumae','core')+"</td></tr>

            <tr><th rowspan='6'>Determiners</th><th rowspan='3'>Crementations</th><td>more</td><td>"+translate('more','traumae','core')+"</td></tr>
            <tr><td>even</td><td>"+translate('even','traumae','core')+"</td></tr>
            <tr><td>less</td><td>"+translate('less','traumae','core')+"</td></tr>

            <tr><th rowspan='3'>Spacial relative</th><td>much/many</td><td>"+translate('many','traumae','core')+"</td></tr>
            <tr><td>fair</td><td>"+translate('fair','traumae','core')+"</td></tr>
            <tr><td>few/little</td><td>"+translate('few','traumae','core')+"</td></tr>

            <tr><th rowspan='9'>Conjunctions</th><th rowspan='3'>Temperal</th><td>after</td><td>"+translate('after','traumae','core')+"</td></tr>
            <tr><td>now/while</td><td>"+translate('while','traumae','core')+"</td></tr>
            <tr><td>before</td><td>"+translate('before','traumae','core')+"</td></tr>

            <tr><th rowspan='3'>Spacial relative</th><td>who</td><td>"+translate('who','traumae','core')+"</td></tr>
            <tr><td>which</td><td>"+translate('which','traumae','core')+"</td></tr>
            <tr><td>what</td><td>"+translate('what','traumae','core')+"</td></tr>

            <tr><th rowspan='3'>Spacial relative</th><td>why</td><td>"+translate('why','traumae','core')+"</td></tr>
            <tr><td>where</td><td>"+translate('where','traumae','core')+"</td></tr>
            <tr><td>how</td><td>"+translate('how','traumae','core')+"</td></tr>

        </table>
        "

    end
    
end