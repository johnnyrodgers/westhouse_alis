#http://www.gotripod.com/2007/10/07/tip-running-command-line-shell-commands-in-ruby-using-x/
JUGGERNAUT_SERVER = Thread.new { %x[juggernaut -c config/juggernaut.yml] } # OSX / LINUX 
#JUGGERNAUT_SERVER = Thread.new { system('juggernaut -c config/juggernaut.yml') }  # WINDOWS
