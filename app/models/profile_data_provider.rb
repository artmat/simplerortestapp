require 'open-uri'

class ProfileDataProvider
  FNLNCNL_PATTERN = %r{
    <font\ size="4"><strong>\s*         # unique string before FirstName
    (\S+)\s+(.*)                        # conventional FirstName and LastName
    </strong>(?:.+)<div>\s*             # HTML between Name and Country
    (.+)                                # Country
    \s*<div\ style="padding-top:2px;">  # unique string after Country
    (?:.+)Native\ in</b>:\s*            # HTML between Country and NativeLang
    (\w+)                               # NativeLang
  }x

  LANGS_PATTERN = %r{
    <span\ style="color:black;">\s*     # unique string before a Lang
    (\w+)\s+to\s+(\w+)                  # a double Lang combination
    \s*</span></span>                   # HTML after a Lang record
  }x

  attr_accessor :error

  def initialize(url)
  	@url   = url
  	@error = 0

    if @url.nil?
      @error = 1
      return nil
    end

  	unless @url.match /^https:\/\/www\.proz\.com\/\w+\/\d+$/
  	  @error = 1
  	end
  end

  def get_data
  	begin
      html = open(@url).read

      # extracting [FirstName, LastName, Country, NativeLang]
      profile_data = html.match(FNLNCNL_PATTERN)[1..4]

	    # a hash container for gathering all the languages
	    all_langs = {}

	    # extracting all the languages from HTML code; maybe better to use a "set" datastrcuture for this?
	    html.scan(LANGS_PATTERN).each do |found|
	    found.each { |lang| all_langs[lang] = 1 }
	    end

  	  # removing the NativeLang from the hash keys
	    if all_langs.key?(profile_data[3])
	      all_langs.delete(profile_data[3])
	    end

      lang1, lang2, lang3 = all_langs.keys

  	  return {
	      :url         => @url,
	      :firstname   => profile_data[0],
	      :lastname    => profile_data[1],
	      :country     => profile_data[2].split(',')[-1].strip,
  	    :nativelang  => profile_data[3],
        :targetlangs => all_langs.keys,
	      :lang1       => lang1,
        :lang2       => lang2,
        :lang3       => lang3,
	    }
    rescue
      @error = 1
      return nil
    end
  end

  def error?
  	@error == 1
  end
end
