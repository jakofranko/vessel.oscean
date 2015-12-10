# encoding: utf-8
#: {{Dictionaery}} is a wrapper for {{Laeth}} objects.

class Dictionaery

	def initialize(laeths)
		@laeths = laeths

		@englishTraumae = englishTraumae
		@traumaeEnglish = traumaeEnglish
	end

	def all
		return @laeths
	end

	def englishTraumae

		result = {}
		@laeths.each do |laeth|
			if !result[laeth.english] then result[laeth.english] = [] end
			result[laeth.english].push(laeth.traumae)
		end

		return result

	end

	def traumaeEnglish

		result = {}
		@laeths.each do |laeth|
			if !result[laeth.traumae] then result[laeth.traumae] = [] end
			result[laeth.traumae].push(laeth.english)
		end

		return result

	end

	def english str

		if !@traumaeEnglish[str] then return "Unknown" end
		return @traumaeEnglish[str].first.to_s

	end

	def traumae str

		if !@englishTraumae[str] then return "Unknown" end
		return @englishTraumae[str].first.to_s

	end

	def solver prefix

        return "
        <table>
        <tr><th colspan='2'>Traversing</th><th colspan='2'>State</th><th colspan='2'>Origin</th></tr>

        <tr>
        <td>#{prefix}ki <i>"+Laeth.new({"traumae" => prefix+"ki"}).adultspeak+"</td>
        <td>"+english(prefix+"ki")+"</td>
        <td>#{prefix}xi <i>"+Laeth.new({"traumae" => prefix+"xi"}).adultspeak+"</td>
        <td>"+english(prefix+"xi")+"</td>
        <td>#{prefix}si <i>"+Laeth.new({"traumae" => prefix+"si"}).adultspeak+"</td>
        <td>"+english(prefix+"si")+"</td>
        </tr>

        <tr>
        <td>#{prefix}ti <i>"+Laeth.new({"traumae" => prefix+"ti"}).adultspeak()+"</td>
        <td>"+english(prefix+"ti")+"</td>
        <td>#{prefix}di <i>"+Laeth.new({"traumae" => prefix+"di"}).adultspeak()+"</td>
        <td>"+english(prefix+"di")+"</td>
        <td>#{prefix}li <i>"+Laeth.new({"traumae" => prefix+"li"}).adultspeak()+"</td>
        <td>"+english(prefix+"li")+"</td>
        </tr>

        <tr>
        <td>#{prefix}pi <i>"+Laeth.new({"traumae" => prefix+"pi"}).adultspeak()+"</td>
        <td>"+english(prefix+"pi")+"</td>
        <td>#{prefix}bi <i>"+Laeth.new({"traumae" => prefix+"bi"}).adultspeak()+"</td>
        <td>"+english(prefix+"bi")+"</td>
        <td>#{prefix}vi <i>"+Laeth.new({"traumae" => prefix+"vi"}).adultspeak()+"</td>
        <td>"+english(prefix+"vi")+"</td>
        </tr>

        <tr><th colspan='2'>Direction</th><th colspan='2'>Transformation</th><th colspan='2'>Counters</th></tr>

        <tr>
        <td>#{prefix}ka <i>"+Laeth.new({"traumae" => prefix+"ka"}).adultspeak()+"</td>
        <td>"+english(prefix+"ka")+"</td>
        <td>#{prefix}xa <i>"+Laeth.new({"traumae" => prefix+"xa"}).adultspeak()+"</td>
        <td>"+english(prefix+"xa")+"</td>
        <td>#{prefix}sa <i>"+Laeth.new({"traumae" => prefix+"sa"}).adultspeak()+"</td>
        <td>"+english(prefix+"sa")+"</td>
        </tr>

        <tr>
        <td>#{prefix}ta <i>"+Laeth.new({"traumae" => prefix+"ta"}).adultspeak()+"</td>
        <td>"+english(prefix+"ta")+"</td>
        <td>#{prefix}da <i>"+Laeth.new({"traumae" => prefix+"da"}).adultspeak()+"</td>
        <td>"+english(prefix+"da")+"</td>
        <td>#{prefix}la <i>"+Laeth.new({"traumae" => prefix+"la"}).adultspeak()+"</td>
        <td>"+english(prefix+"la")+"</td>
        </tr>

        <tr>
        <td>#{prefix}pa <i>"+Laeth.new({"traumae" => prefix+"pa"}).adultspeak()+"</td>
        <td>"+english(prefix+"pa")+"</td>
        <td>#{prefix}ba <i>"+Laeth.new({"traumae" => prefix+"ba"}).adultspeak()+"</td>
        <td>"+english(prefix+"ba")+"</td>
        <td>#{prefix}va <i>"+Laeth.new({"traumae" => prefix+"va"}).adultspeak()+"</td>
        <td>"+english(prefix+"va")+"</td>
        </tr>

        <tr><th colspan='2'>Modality</th><th colspan='2'>Alignment</th><th colspan='2'>Interaction</th></tr>

        <tr>
        <td>#{prefix}ko <i>"+Laeth.new({"traumae" => prefix+"ko"}).adultspeak()+"</td>
        <td>"+english(prefix+"ko")+"</td>
        <td>#{prefix}xo <i>"+Laeth.new({"traumae" => prefix+"xo"}).adultspeak()+"</td>
        <td>"+english(prefix+"xo")+"</td>
        <td>#{prefix}so <i>"+Laeth.new({"traumae" => prefix+"so"}).adultspeak()+"</td>
        <td>"+english(prefix+"so")+"</td>
        </tr>

        <tr>
        <td>#{prefix}to <i>"+Laeth.new({"traumae" => prefix+"to"}).adultspeak()+"</td>
        <td>"+english(prefix+"to")+"</td>
        <td>#{prefix}do <i>"+Laeth.new({"traumae" => prefix+"do"}).adultspeak()+"</td>
        <td>"+english(prefix+"do")+"</td>
        <td>#{prefix}lo <i>"+Laeth.new({"traumae" => prefix+"lo"}).adultspeak()+"</td>
        <td>"+english(prefix+"lo")+"</td>
        </tr>

        <tr>
        <td>#{prefix}po <i>"+Laeth.new({"traumae" => prefix+"po"}).adultspeak()+"</td>
        <td>"+english(prefix+"po")+"</td>
        <td>#{prefix}bo <i>"+Laeth.new({"traumae" => prefix+"bo"}).adultspeak()+"</td>
        <td>"+english(prefix+"bo")+"</td>
        <td>#{prefix}vo <i>"+Laeth.new({"traumae" => prefix+"vo"}).adultspeak()+"</td>
        <td>"+english(prefix+"vo")+"</td>
        </tr>

        </table>
        "
    end

end
