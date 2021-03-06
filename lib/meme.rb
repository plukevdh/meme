require 'net/http'
require 'cgi'
require 'nokogiri'

##
# Generate memes using http://memegenerator.net

class Meme

  ##
  # Sometimes your meme will have an error, fix it!

  class Error < RuntimeError; end

  ##
  # Every meme generator needs a version

  VERSION = '1.10'

  ##
  # For statistics!

  USER_AGENT = "meme/#{VERSION} Ruby/#{RUBY_VERSION}"

  ##
  # We have some generators up-in-here

  GENERATORS = Hash.new do |_, k|
    raise Error, "unknown generator #{k}"
  end

  ##
  # For creating advice-dog type meme images.
  #
  # These can accept up to two lines of text

  def self.advice_dog name, id, template_name, first_line = nil
    template = [id, 'AdviceDogSpinoff', template_name, first_line]
    template.compact

    GENERATORS[name] = template
  end

  ##
  # For creating vertical type meme images
  #
  # These can accept multiple lines of text

  def self.vertical name, id, template_name
    GENERATORS[name] = [id, 'Vertical', template_name]
  end

  # keep generators in alphabetical order
  advice_dog 'ANTEATER',           41191,   'anteater'
  advice_dog 'A_DODSON',           106375,  'Antoine-Dodson'
  advice_dog 'A_DOG',              940,     'Advice-Dog'
  advice_dog 'A_FATHER',           1436,    'High-Expectations-Asian-Father'
  advice_dog 'ARNOLD',             1236,    'Angry-Arnold'
  advice_dog 'BEAR-GRYLLS',        89714,   'Bear-Grylls'
  advice_dog 'BUTTHURT_DWELLER',   1438,    'Butthurt-Dweller'
  advice_dog 'B_FROG',             1211,    'Foul-Bachelorette-Frog'
  advice_dog 'B_FROG2',            1045,    'Foul-Bachelor-Frog'
  advice_dog 'BEIBER',             11809,   'Justin-Beiber'
  advice_dog 'CATHY',              622381,  'AckCathy'
  advice_dog 'CHALLENGE_ACCEPTED', 275025,  'Challenge-Accepted'
  advice_dog 'COOL_STORY_HOUSE',   16948,   'cool-story-bro-house'
  advice_dog 'CREEPER',            173501,  'Minecraft-Creeper'
  advice_dog 'C_WOLF',             931,     'Courage-Wolf'
  advice_dog 'C_LEMUR',            1227,    'Chill-Out-Lemur'
  advice_dog 'F_FRY',              84688,   'Futurama-Fry'
  advice_dog 'G_GRANDPA',          185650,  'Grumpy-Grandpa'
  advice_dog 'H_MERMAID',          405224,  'Hipster-Mermaid'
  advice_dog 'I_DONT_ALWAYS',      38926,   'The-Most-Interesting-Man-in-the-World'
  advice_dog 'I_WOLF',             926,     'Insanity-Wolf'
  advice_dog 'JESUS',              1281,    'jesus-says'
  advice_dog 'J_DUCREUX',          1356,    'Joseph-Ducreux'
  advice_dog 'KANYE',              622033,  'kanyee'
  advice_dog 'KEANU',              47718,   'Keanu-reeves'
  advice_dog 'KJI',                5840,    'Kim-Jong-IL'
  advice_dog 'MILHOUSE',           228797,  'Millhouse'
  advice_dog 'MINECRAFT',          122309,  'Minecraft'
  advice_dog 'MORE_BEAR',          33675,   'More-Bear'
  advice_dog 'O-RLY-OWL',          117041,  'O-RLY-OWL', 'ORLY???'
  advice_dog 'OBAMA',              1332,    'Obama-'
  advice_dog 'PHILOSORAPTOR',      984,     'Philosoraptor'
  advice_dog 'P_OAK',              24321,   'Professor-Oak'
  advice_dog 'P_OBAMA',            45557,   'Pissed-off-Obama'
  advice_dog 'R_BLACK',            547955,  'Rebecca-Black-Meme'
  advice_dog 'REDSHIRT',           239371,  'red-shirt-guy'
  advice_dog 'SCUMBAG',            364688,  'Scumbag-Steve'
  advice_dog 'SERIOUS_FISH',       7054219, 'Serious-fish-spongebob'
  advice_dog 'SHEEN',              488762,  'Charlie-Sheen'
  advice_dog 'SNOB',               2994,    'Snob'
  advice_dog 'SPARTA',             1013,    'sparta'
  advice_dog 'SPIDERMAN',          1037,    'Question-Spiderman'
  advice_dog 'SPILLMAN',           622133,  'Sassy-Spillman'
  advice_dog 'SWEDISH_CHEF',       186651,  'Swedish-Chef'
  advice_dog 'S_AWKWARD_PENGUIN',  983,     'Socially-Awkward-Penguin'
  advice_dog 'TOWNCRIER',          434537,  'Towncrier'
  advice_dog 'TROLLFACE',          1030,    'Troll-Face'
  advice_dog 'UNICORN_BOY',        57022,   'unicorn-boy'
  advice_dog 'US_POINT',           131083,  'Uncle-Sam-Point', 'I WANT YOU'
  advice_dog 'V_BABY',             11140,   'Victory-Baby'
  advice_dog 'XZIBIT',             3114,    'XZIBIT'
  advice_dog 'Y_U_NO',             165241,  'Y-U-NO', 'Y U NO'
  advice_dog 'YODA',               963,     'Advice-Yoda-Gives'

  vertical 'BATMAN',    148359, 'batman-panal-ryan'
  vertical 'INCEPTION', 107949, 'Inception'
  vertical 'NEO',       173419, 'Neo'
  vertical 'THE_ROCK',  417195, 'The-Rock-driving'

  # keep generators in alphabetical order

  ## =>
  # Looks up generator name

  def GENERATORS.match(name)
    # TODO  meme Y U NO DEMETAPHONE?
    return self[name] if has_key? name
    matcher = Regexp.new(name, Regexp::IGNORECASE)
    _, generator = find { |k,v| matcher =~ k || v.grep(matcher).any? }
    generator || self[name] # raises the error if generator is nil
  end

  ##
  # Interface for the executable

  def self.run argv = ARGV
    generator = argv.shift

    if generator == '--list' then
      width = GENERATORS.keys.map { |command| command.length }.max

      list = []
      GENERATORS.sort.each do |command, (id, name, _)|
        list << "%-*s  %s" % [width, command, name]
      end
    
      return list.join("\n")
    end

    text_only = if generator == '--text'
      generator = argv.shift
      true
    else
      false
    end

    # puts "text_only:#{text_only} generator:#{generator}"

    return "#{$0} [GENERATOR|--list] LINE [ADDITONAL_LINES]" if argv.empty?

    meme = new generator
    link = meme.generate(*argv)

    meme.paste(link) unless text_only

    if $stdout.tty? || text_only
      return link
    else
      return meme.fetch link
    end
    link
  rescue Interrupt
    exit
  rescue SystemExit
    raise
  rescue Exception => e
    return e.backtrace.join "\n\t" if $DEBUG
  end

  ##
  # Generates links for +generator+

  def initialize generator
    @template_id, @template_type, @generator_name, @default_line = GENERATORS.match generator
  end

  ##
  # Generates a meme with +line1+ and +line2+.  For some generators you only
  # have to supply one line because the first line is defaulted for you.
  # Isn't that great?

  def generate *args
    url = URI.parse 'http://memegenerator.net/Instance/CreateOrEdit'
    res = nil
    location = nil

    # Prepend the default line if this meme has one and we only had 1 text input
    args.unshift @default_line if @default_line and args.size <= 1

    raise Error, "two lines are required for #{@generator_name}" unless
      args.size > 1

    post_data = { 'templateType'  => @template_type,
                  'templateID'    => @template_id,
                  'generatorName' => @generator_name }

    # go through each argument and add it back into the post data as textN
    (0..args.size).map {|num| post_data.merge! "text#{num}" => args[num] }

    Net::HTTP.start url.host do |http|
      post = Net::HTTP::Post.new url.path
      post['User-Agent'] = USER_AGENT
      post.set_form_data post_data

      res = http.request post

      location = res['Location']
      redirect = url + location

      get = Net::HTTP::Get.new redirect.request_uri
      get['User-Agent'] = USER_AGENT

      res = http.request get
    end

    if Net::HTTPSuccess === res then
      doc = Nokogiri.HTML res.body
      doc.css("a[href=\"#{location}\"] img").first['src']
    else
      raise Error, "memegenerator.net appears to be down, got #{res.code}"
    end
  end

  def fetch link
    url = URI.parse link
    res = nil

    Net::HTTP.start url.host do |http|
      get = Net::HTTP::Get.new url.request_uri
      get['User-Agent'] = USER_AGENT

      res = http.request get
    end
    res.body
  end

  ##
  # Tries to find clipboard copy executable and if found puts +link+ in your
  # clipboard.

  def paste link
    require 'pasteboard'

    clipboard = Pasteboard.new

    jpeg = fetch link

    clipboard.put_jpeg_url jpeg, link
  rescue LoadError
    clipboard = %w{
      /usr/bin/pbcopy
      /usr/bin/xclip
    }.find { |path| File.exist? path }

    if clipboard
      IO.popen clipboard, 'w' do |io| io.write link end
    end
  end

end
