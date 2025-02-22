-------------------------------------------------------------------------------
  ______ _____ _      ______            _    _ ______ _      _____  
 |  ____|_   _| |    |  ____|          | |  | |  ____| |    |  __ \ 
 | |__    | | | |    | |__     ______  | |__| | |__  | |    | |__) |
 |  __|   | | | |    |  __|   |______| |  __  |  __| | |    |  ___/ 
 | |     _| |_| |____| |____           | |  | | |____| |____| |     
 |_|    |_____|______|______|          |_|  |_|______|______|_|     
-------------------------------------------------------------------------------
LAST REVIEWED | 21/02/25

The File COMMAND gives access to the file library allowing users to make use of
file file functions.

⚡ file -read --path=./path/to/file.txt

-------------------------------------------------------------------------------
RESTRICTIONS

- Editors: neovim
- File Types: txt | json | md

-------------------------------------------------------------------------------
FUNCTIONS

-read OR -r
  This FUNCTION will read the contents of the file at --path to the window buffer.

ARGS
  --path OR --p [REQUIRED]
    The file path to the file you want to read to the window buffer.

  -write OR -w
    This FUNCTION will open the file at --path in a given --editor.

  ARGS
    --path OR --p [REQUIRED]
      The file path to the file you want to open with the --editor.

    --editor OR --e [DEFAULT: neovim]
      The name of the editor the user wants to open the --path.

-update OR -u
  This FUNCTION will open the file at --path in a given --editor.

  ARGS
    --path OR --p [REQUIRED]
      The file path to the file you want to open with the --editor.

    --editor OR --e [DEFAULT: neovim]
      The name of the editor the user wants to open the --path.

-delete OR -d
  This FUNCTION will delete the file at --path.

  ARGS
    --path OR --p [REQUIRED]
      The file path to the file you want to open with the --editor.

-copy OR -c
  This FUNCTION will copy a file from the file path --from to the file path --to.

  ARGS
    --from OR -f [REQUIRED]
      The file path of the file the user wants to copy.

    --to OR --t [REQUIRED]
      The file path location of where the user wants to copy the file to.
-------------------------------------------------------------------------------