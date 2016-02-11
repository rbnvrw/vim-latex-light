if exists("g:autoloaded_latexlight")
  finish
endif
let g:autoloaded_latexlight = 1

if !exists("g:latexlight_command")
  let g:latexlight_command = "make"
endif

set errorformat=%f:%l:%c:%m 
let s:currentdirectory = expand('%:p:h')

function! latexlight#latexlight#CompileLatexShowErrors() 
  echo "LaTeX started"
  update 
  let file=expand('%:t:r')  
  let compile_command=shellescape(g:latexlight_command)
  let command="cd ".shellescape(s:currentdirectory)." && ".compile_command
  echo command
  let errors=system(command)
  if errors=="" 
    echo 'LaTeX: finished successfully' 
  else 
    cexpr errors 
  endif 
endfunction 
