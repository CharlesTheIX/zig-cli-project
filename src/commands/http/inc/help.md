-------------------------------------------------------------------------------
  _    _ _______ _______ _____             _    _ ______ _      _____  
 | |  | |__   __|__   __|  __ \           | |  | |  ____| |    |  __ \ 
 | |__| |  | |     | |  | |__) |  ______  | |__| | |__  | |    | |__) |
 |  __  |  | |     | |  |  ___/  |______| |  __  |  __| | |    |  ___/ 
 | |  | |  | |     | |  | |               | |  | | |____| |____| |     
 |_|  |_|  |_|     |_|  |_|               |_|  |_|______|______|_|     
-------------------------------------------------------------------------------
LAST REVIEWED | 21/02/25

The http COMMAND starts up a HTTP1.1 server that contains a REST api.
To view a list of the endpoints use: -endpoints

⚡ http -start --host=127.0.0.1 --port=4221

-------------------------------------------------------------------------------
FUNCTIONS

-endpoints OR -e
  This function will read the endpoints file using the file library.

-start OR -s
  This function will start a HTTP1.1 server at --host on port --port.

  ARGS
    --host OR --h [DEFAULT: 127.0.0.1]
    --port OR --p [DEFAULT: 4221]
-------------------------------------------------------------------------------