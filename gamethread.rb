require 'uri'
require 'sinatra'

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
  home_game = params[:home] 
  home_last = params[:homelast10]
  away_last = params[:awaylast10]
  game_hour_et = params[:hour].to_i
  game_minute = params[:minute].to_i
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
 
  #STREAM---------------------------------------

  if home_game              
    "##General Information" + "<br>" + 
    "**TIME**     |**MEDIA**                            |**LOCATION**        |**MISC**" + "<br>" + 
    ":------------|:------------------------------------|:-------------------|:-------------------------" + "<br>" + 
    game_hour[0] + ":"+ game_minute + " Eastern |**TV**: National: NBATV,  Home: " + tv_channel + "                       | Toyota Center, Houston, TX               | [Live chat](http://webchat.freenode.net/?channels=r/NBA&uio=MTE9MjQ255/)" + "<br>" + 
    game_hour[1] + ":"+ game_minute + " Central |**Streaming**: N/A | **Team Subreddits**|" + "<br>" + 
    game_hour[2] + ":" + game_minute + " Mountain|**Game Story**: [NBA.com](http://www.nba.com/games/" + today + "/" + opponent_team.shortcode + rockets_team.shortcode + "/gameinfo.html#nbaGIlive)| [/r/" + opponent_team.subreddit + "](" + opponent_team.subreddit_url.to_s + ")          |" + "<br>" + 
    game_hour[3] + ":" + game_minute + " Pacific |**Box Score**: [NBA.com](http://www.nba.com/games/" + today + "/" + opponent_team.shortcode + rockets_team.shortcode + "/gameinfo.html#nbaGIboxscore) | [/r/rockets](http://reddit.com/r/rockets)          |" + "<br>" + 
    "Last 10|**Rockets**: " + home_last + " |**" + opponent.capitalize + "**: " + away_last + "<br>" + 
    "-----" + "<br>" + 
    "**Misc** " + "<br>" + 
    "<br>" + message + "<br>" +
    "<br>" + "-----" + "<br>" + 
    "[Reddit Stream](http://nba-gamethread.herokuapp.com/reddit-stream/) (You must click this link from the comment page.)"
  else 
    "##General Information" + "<br>" + 
    "**TIME**     |**MEDIA**                            |**LOCATION**        |**MISC**" + "<br>" + 
    ":------------|:------------------------------------|:-------------------|:-------------------------" + "<br>" + 
    game_hour[0] + ":"+ game_minute + " Eastern |**TV**: National: NBATV,  Home: " + tv_channel + "                       | Toyota Center, Houston, TX               | [Live chat](http://webchat.freenode.net/?channels=r/NBA&uio=MTE9MjQ255/)" + "<br>" + 
    game_hour[1] + ":"+ game_minute + " Central |**Streaming**: N/A | **Team Subreddits**|" + "<br>" + 
    game_hour[2] + ":" + game_minute + " Mountain|**Game Story**: [NBA.com](http://www.nba.com/games/" + today + "/" + rockets_team.shortcode + opponent_team.shortcode + "/gameinfo.html#nbaGIlive)| [/r/" + opponent_team.subreddit + "](" + opponent_team.subreddit_url.to_s + ")          |" + "<br>" + 
    game_hour[3] + ":" + game_minute + " Pacific |**Box Score**: [NBA.com](http://www.nba.com/games/" + today + "/" + rockets_team.shortcode + opponent_team.shortcode + "/gameinfo.html#nbaGIboxscore) | [/r/rockets](http://reddit.com/r/rockets)          |" + "<br>" + 
    "Last 10|**Rockets**: |**" + opponent.capitalize + "**:" + "<br>" + 
    "-----" + "<br>" + 
    "**Misc** " + "<br>" + 
    "<br>" + message + "<br>" +
    "<br>" + "-----" + "<br>" + 
    "[Reddit Stream](http://nba-gamethread.herokuapp.com/reddit-stream/) (You must click this link from the comment page.)"
  end
end
