require 'uri'
require 'sinatra'
require 'nokogiri'
require 'open-uri'

get '/' do

end

get '/index' do
  erb :index
end

post '/index' do
  
  time = Time.new

  class TeamBuilder
  	@@team_data = [
  		{ :code => "bobcats"      , :name => "Charlotte Bobcats"      , :subreddit => "CharlotteBobcats"  , :shortcode => "CHA" , },
  		{ :code => "bucks"        , :name => "Milwaukee Bucks"        , :subreddit => "mkebucks"          , :shortcode => "MIL" , },
  		{ :code => "bulls"        , :name => "Chicago Bulls"          , :subreddit => "chicagobulls"      , :shortcode => "CHI" , },
  		{ :code => "cavaliers"    , :name => "Cleveland Cavaliers"    , :subreddit => "clevelandcavs"     , :shortcode => "CLE" , },
  		{ :code => "celtics"      , :name => "Boston Celtics"         , :subreddit => "bostonceltics"     , :shortcode => "BOS" , },
  		{ :code => "clippers"     , :name => "Los Angeles Clippers"   , :subreddit => "LAClippers"        , :shortcode => "LAC" , },
  		{ :code => "grizzlies"    , :name => "Memphis Grizzlies"      , :subreddit => "memphisgrizzlies"  , :shortcode => "MEM" , },
  		{ :code => "hawks"        , :name => "Atlanta Hawks"          , :subreddit => "AtlantaHawks"      , :shortcode => "ATL" , },
  		{ :code => "heat"         , :name => "Miami Heat"             , :subreddit => "heat"              , :shortcode => "MIA" , },
  		{ :code => "jazz"         , :name => "Utah Jazz"              , :subreddit => "UtahJazz"          , :shortcode => "UTA" , },
  		{ :code => "kings"        , :name => "Sacramento Kings"       , :subreddit => "kings"             , :shortcode => "SAC" , },
  		{ :code => "knicks"       , :name => "New York Knicks"        , :subreddit => "NYKnicks"          , :shortcode => "NYK" , },
  		{ :code => "lakers"       , :name => "Los Angeles Lakers"     , :subreddit => "lakers"            , :shortcode => "LAL" , },
  		{ :code => "magic"        , :name => "Orlando Magic"          , :subreddit => "orlandomagic"      , :shortcode => "ORL" , },
  		{ :code => "mavericks"    , :name => "Dallas Maverics"        , :subreddit => "Mavericks"         , :shortcode => "DAL" , },
  		{ :code => "nets"         , :name => "Brooklyn Nets"          , :subreddit => "GoNets"            , :shortcode => "BKN" , },
  		{ :code => "nuggets"      , :name => "Denver Nuggets"         , :subreddit => "denvernuggets"     , :shortcode => "DEN" , },
  		{ :code => "pacers"       , :name => "Indiana Pacers"         , :subreddit => "IndianaPacers"     , :shortcode => "IND" , },
  		{ :code => "pelicans"     , :name => "New Orleans Pelicans"   , :subreddit => "NOLAPelicans"      , :shortcode => "NOP" , },
  		{ :code => "pistons"      , :name => "Detroit Pistons"        , :subreddit => "DetroitPistons"    , :shortcode => "DET" , },
  		{ :code => "raptors"      , :name => "Toronto Raptors"        , :subreddit => "torontoraptors"    , :shortcode => "TOR" , },
  		{ :code => "rockets"      , :name => "Houston Rockets"        , :subreddit => "rockets"           , :shortcode => "HOU" , },
  		{ :code => "sixers"       , :name => "Philadelphia 76ers"     , :subreddit => "sixers"            , :shortcode => "PHI" , },
  		{ :code => "spurs"        , :name => "San Antonio Spurs"      , :subreddit => "NBASpurs"          , :shortcode => "SAS" , },
  		{ :code => "suns"         , :name => "Phoenix Suns"           , :subreddit => "SUNS"              , :shortcode => "PHX" , },
  		{ :code => "thunder"      , :name => "Oklahoma City Thunder"  , :subreddit => "Thunder"           , :shortcode => "OKC" , },
  		{ :code => "trailblazers" , :name => "Portland Trail Blazers" , :subreddit => "ripcity"           , :shortcode => "POR" , },
  		{ :code => "timberwolves" , :name => "Minnesota Timberwolves" , :subreddit => "timberwolves"      , :shortcode => "MIN" , },
  		{ :code => "warriors"     , :name => "Golden State Warriors"  , :subreddit => "warriors"          , :shortcode => "GSW" , },
  		{ :code => "wizards"      , :name => "Washington Wizards"     , :subreddit => "washingtonwizards" , :shortcode => "WAS" , },
  	];

  	def self.get_team_by_code(code)
  		data = @@team_data.select { |team| team[:code] == code }.first
  		if defined? data
  			return Team.new(data)
  		end
  	end
  end

  class Team
  	attr_reader :name, :subreddit, :shortcode

  	def initialize(data)
  		@name = data[:name]
  		@subreddit = data[:subreddit]
  		@shortcode = data[:shortcode]
  	end

  	def subreddit_url()
  		return URI.join("http://reddit.com/", "/r/", @subreddit)
  	end
  
    def subreddit()
      return "/r/" + @subreddit
    end
  
    def shortcode()
      return @shortcode
    end
  end

  #POST PARAMETERS---------------------------------------
  
  opponent = params[:opponent]  
  home_last = params[:homelast10]
  away_last = params[:awaylast10]
  tv_channel = params[:tvchannel].to_s
  message = params[:message].to_s
  
  #TEAM---------------------------------------
  opponent_team = TeamBuilder.get_team_by_code(opponent)
  if not defined? opponent_team
    puts "Something went wrong. um yea...... you broke it"
  end
  rockets = "rockets"
  rockets_team = TeamBuilder.get_team_by_code(rockets)
  if not defined? rockets_team
    puts "Something went wrong. um yea...... you broke it"
  end
  
  #DATE---------------------------------------
  curYear = time.year.to_s
  curMonth = time.month
  curDay = time.day

  if time.month < 10
    curMonth = time.month.to_s
    curMonth = "0" + curMonth
  end
  if time.day < 10
    curDay = time.day.to_s
    curDay = "0" + curDay
  end

  curMonth = curMonth.to_s
  curDay = curDay.to_s

  today = curYear + curMonth + curDay

  #PAGE DATA---------------------------------------
  
  PAGE_URL = "http://www.nba.com/games/" + today + "/" + opponent_team.shortcode + rockets_team.shortcode + "/gameinfo.html#nbaGIlive"
  #PAGE_URL = "http://www.nba.com/games/20140205/PHXHOU/gameinfo.html"
  
  page = Nokogiri::HTML(open(PAGE_URL))
  
  
  error = false
   if page.css("h1")[0].text.to_s == "Sorry, Page Not Found"
     error = true
   else
     error = false
   end
   
   if error
     "Sorry, Either you picked the wrong team or there is no game today. Try again tomorrow... If neiter of these is true then I'm broken and need to be fixed. Please contact the moron that made me"
   else
   
     location = page.css('a')[178].text.to_s
     puts location
     puts page.css('a')[179].text.to_s
  
     if location != "HOU" 
       home_team = rockets_team.name
       away_team = opponent_team.name
       home_game = true
     else
       home_team = opponent_team.name
       away_team = rockets_team.name
       home_game = false
     end
   
     game_hour_et = page.css("p")[0].text[0].to_i 
     game_minute = page.css("p")[0].text[2..3].to_i   # => title
   
    #TIME---------------------------------------
    if game_minute < 10
      game_minute = "0" + game_minute.to_s
    end
    game_minute = game_minute.to_s

    game_hour = Array.new(4)

    for i in 0..3
      game_hour[i] = game_hour_et
      game_hour_et = game_hour_et - 1
    end
    for i in 0..3
       if game_hour[i] < 10
         game_hour[i] = "0" + game_hour[i].to_s
       else
         game_hour[i] = game_hour[i].to_s
       end
    end 
  
    #OUTPUT---------------------------------------

    if home_game            
      "<a href=\"http://www.reddit.com/r/rockets/submit?selftext=true&title=GAME%20THREAD:%20" + away_team + "%20@%20" + home_team + "&text=" +
      "%23%23General%20Information" + "%0A" + 
      "%2A%2ATIME%2A%2A%20%20%20%20%20%7C%2A%2AMEDIA%2A%2A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%7C%2A%2ALOCATION%2A%2A%20%20%20%20%20%20%20%20" + "%0A" + 
       "%3A%2D%2D%2D%2D%2D%2D%2D%2D%2D%2D%2D%2D%7C%3A%2D%2D%2D%2D%2D%2D%2D%2D%2D%2D%2D%2D%2D%2D%2D%2D%2D%2D%2D%2D%2D%2D%2D%2D%2D%2D%2D%2D%2D%2D%2D%2D%2D%2D%2D%2D%7C%3A%2D%2D%2D%2D%2D%2D%2D%2D%2D%2D%2D%2D%2D%2D%2D%2D%2D%2D%2D%7C%3A%2D%2D%2D%2D%2D%2D%2D%2D%2D%2D%2D%2D%2D%2D%2D%2D%2D%2D%2D%2D%2D%2D%2D%2D%2D" + "%0A" + 
        game_hour[0] + "%3A"+ game_minute + "%20Eastern%20%7C%2A%2ATV%2A%2A%3A%20National%3A%20NBATV%2C%20%20Home%3A%20" + tv_channel + "%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%7C%20Toyota%20Center%2C%20Houston%2C%20TX%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20" + "%0A" + 
        game_hour[1] + "%3A"+ game_minute + "%20Central%20%7C%2A%2AStreaming%2A%2A%3A%20N%2FA%20%7C%20%2A%2ATeam%20Subreddits%2A%2A%7C" + "%0A" + 
        game_hour[2] + "%3A" + game_minute + "%20Mountain%7C%2A%2AGame%20Story%2A%2A%3A%20%5BNBA%2Ecom%5D%28http%3A%2F%2Fwww%2Enba%2Ecom%2Fgames%2F" + today + "%2F" + opponent_team.shortcode + rockets_team.shortcode + "%2Fgameinfo%2Ehtml%23nbaGIlive%29%7C%20%5B" + opponent_team.subreddit + "%5D%28" + opponent_team.subreddit_url.to_s + "%29%20%20%20%20%20%20%20%20%20%20%7C" + "%0A" + 
        game_hour[3] + "%3A" + game_minute + "%20Pacific%20%7C%2A%2ABox%20Score%2A%2A%3A%20%5BNBA%2Ecom%5D%28http%3A%2F%2Fwww%2Enba%2Ecom%2Fgames%2F" + today + "%2F" + opponent_team.shortcode + rockets_team.shortcode + "%2Fgameinfo%2Ehtml%23nbaGIboxscore%29%20%7C%20%5B%2Fr%2Frockets%5D%28http%3A%2F%2Freddit%2Ecom%2Fr%2Frockets%29%20%20%20%20%20%20%20%20%20%20%7C" + "%0A" + 
        "Last%2010%7C%2A%2ARockets%2A%2A:%20" + home_last + "%20%7C%2A%2A" + opponent.capitalize + "%2A%2A:%20" + away_last + "%0A" + 
        "%2D%2D%2D%2D%2D" + "%0A" + 
        "%2A%2AMisc%2A%2A%20" + "%0A" + 
        "%0A" + message + "%0A" +
        "%0A" + "%2D%2D%2D%2D%2D" + "%0A" + 
      "\">Click here to Submit to Reddit</a>"
    else 
      "<a href=\"http://www.reddit.com/r/rockets/submit?selftext=true&title=GAME%20THREAD:%20" + away_team + "%20@%20" + home_team + "&text=" +
      "%23%23General%20Information" + "%0A" + 
      "%2A%2ATIME%2A%2A%20%20%20%20%20%7C%2A%2AMEDIA%2A%2A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%7C%2A%2ALOCATION%2A%2A%20%20%20%20%20%20%20%20" + "%0A" + 
       "%3A%2D%2D%2D%2D%2D%2D%2D%2D%2D%2D%2D%2D%7C%3A%2D%2D%2D%2D%2D%2D%2D%2D%2D%2D%2D%2D%2D%2D%2D%2D%2D%2D%2D%2D%2D%2D%2D%2D%2D%2D%2D%2D%2D%2D%2D%2D%2D%2D%2D%2D%7C%3A%2D%2D%2D%2D%2D%2D%2D%2D%2D%2D%2D%2D%2D%2D%2D%2D%2D%2D%2D%7C%3A%2D%2D%2D%2D%2D%2D%2D%2D%2D%2D%2D%2D%2D%2D%2D%2D%2D%2D%2D%2D%2D%2D%2D%2D%2D" + "%0A" + 
        game_hour[0] + "%3A"+ game_minute + "%20Eastern%20%7C%2A%2ATV%2A%2A%3A%20National%3A%20NBATV%2C%20%20Home%3A%20" + tv_channel + "%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%7C%20Toyota%20Center%2C%20Houston%2C%20TX%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20" + "%0A" + 
        game_hour[1] + "%3A"+ game_minute + "%20Central%20%7C%2A%2AStreaming%2A%2A%3A%20N%2FA%20%7C%20%2A%2ATeam%20Subreddits%2A%2A%7C" + "%0A" + 
        game_hour[2] + "%3A" + game_minute + "%20Mountain%7C%2A%2AGame%20Story%2A%2A%3A%20%5BNBA%2Ecom%5D%28http%3A%2F%2Fwww%2Enba%2Ecom%2Fgames%2F" + today + "%2F" + rockets_team.shortcode + opponent_team.shortcode + "%2Fgameinfo%2Ehtml%23nbaGIlive%29%7C%20%5B" + opponent_team.subreddit + "%5D%28" + opponent_team.subreddit_url.to_s + "%29%20%20%20%20%20%20%20%20%20%20%7C" + "%0A" + 
        game_hour[3] + "%3A" + game_minute + "%20Pacific%20%7C%2A%2ABox%20Score%2A%2A%3A%20%5BNBA%2Ecom%5D%28http%3A%2F%2Fwww%2Enba%2Ecom%2Fgames%2F" + today + "%2F" + rockets_team.shortcode + opponent_team.shortcode + "%2Fgameinfo%2Ehtml%23nbaGIboxscore%29%20%7C%20%5B%2Fr%2Frockets%5D%28http%3A%2F%2Freddit%2Ecom%2Fr%2Frockets%29%20%20%20%20%20%20%20%20%20%20%7C" + "%0A" + 
        "Last%2010%7C%2A%2ARockets%2A%2A:%20" + home_last + "%20%7C%2A%2A" + opponent.capitalize + "%2A%2A:%20" + away_last + "%0A" + 
        "%2D%2D%2D%2D%2D" + "%0A" + 
        "%2A%2AMisc%2A%2A%20" + "%0A" + 
        "%0A" + message + "%0A" +
        "%0A" + "%2D%2D%2D%2D%2D" + "%0A" + 
      "\">Click here to Submit to Reddit</a>"
    end
    
  end
  
end
