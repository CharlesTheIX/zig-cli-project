-------------------------------------------------------------------------------
  ____ _____ _______      _____          _      _____ _    _ _            _______ ____  _____             _    _ ______ _      _____  
 |  _ \_   _|__   __|    / ____|   /\   | |    / ____| |  | | |        /\|__   __/ __ \|  __ \           | |  | |  ____| |    |  __ \ 
 | |_) || |    | |______| |       /  \  | |   | |    | |  | | |       /  \  | | | |  | | |__) |  ______  | |__| | |__  | |    | |__) |
 |  _ < | |    | |______| |      / /\ \ | |   | |    | |  | | |      / /\ \ | | | |  | |  _  /  |______| |  __  |  __| | |    |  ___/ 
 | |_) || |_   | |      | |____ / ____ \| |___| |____| |__| | |____ / ____ \| | | |__| | | \ \           | |  | | |____| |____| |     
 |____/_____|  |_|       \_____/_/    \_\______\_____|\____/|______/_/    \_\_|  \____/|_|  \_\          |_|  |_|______|______|_|     
-------------------------------------------------------------------------------
LAST REVIEWED | 25/02/25

This bc COMMAND finds the required bytes are needed for a number
or get the max number a set of bytes can contain for a given value.

⚡ bc -find

-------------------------------------------------------------------------------
FUNCTIONS

-find OR -f
  This will take the given value and return the ceiling of the log 2 of the number so that the user can tell what the min bit value to use.

-get OR -g
  This will take the memory type and return the max (and min values if necessary) of the given memory type.