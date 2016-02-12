# LaTeX Light
LaTeX Light is a lightweight LaTeX companion for Vim that compiles your
document and shows you LaTeX warnings and errors. Open up a LaTeX file
and use `<leader>p` to issue the build command ('p' for 'PDF').

The warnings and errors are read from the logfile generated by the compiler,
LaTeX Light looks for `<filename>.log` in the same directory.

## Features
* Document compilation via external command
* Shows errors and warnings in the quickfix window, with line numbers 
  (if provided by the LaTeX compiler).

## Configuration
### g:latexlight_map_keys                 
Set this to 0 to disable default keymapping.

`let g:latexlight_map_keys = 0`

### g:latexlight_map_prefix             
Alter the default key mapping prefix key. Default: `<leader>`.

`let g:latexlight_map_prefix = ','`

### g:latexlight_command                   
Alter the default command used to compile the LaTeX file. Default: `make`.

`let g:latexlight_command = 'make'`

### g:latexlight_startpattern_list 
Alter the list of patterns that LaTeX Light looks for in the logfile. Default:
```
let g:latexlight_startpattern_list = [
                            \ {'pattern': 'LaTeX\s\+Error:', 'type':'E'},
                            \ {'type':'W', 'pattern': 'LaTeX\s\+Warning:'}]
```

### g:latexlight_subpattern                
Modify the subpattern LaTeX Light uses to match line numbers to warnings. Default:

`let g:latexlight_subpattern = '.\{-}line\s*\(\d\+\).*'`

## Contributions
Contributions and pull requests are welcome.

## License
MIT License.  Copyright © 2016 Ruben Verweij.
