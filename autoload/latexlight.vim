let s:plugindir = expand('<sfile>:p:h:h')

if !exists("g:latexlight_command")
  let g:latexlight_command = "make"
endif

set errorformat=%f:%l:%c:%m 

function CompileLatexShowErrors() 
  update 
  let file=expand('%:t:r') 
  let scriptpath=fnamemodify("../latex-errorfilter", ":p:h")
  let errors=system(g:latexlight_command . ' | ' . scriptpath) 
  if errors=="" 
    echo 'LaTeX: No warnings/errors' 
  else 
    cexpr errors 
  endif 
endfunction 
