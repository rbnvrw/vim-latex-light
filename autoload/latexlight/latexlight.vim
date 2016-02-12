if exists("g:autoloaded_latexlight")
  finish
endif
let g:autoloaded_latexlight = 1

if !exists("g:latexlight_command")
  let g:latexlight_command = "make"
endif

let s:currentdirectory = expand('%:p:h')

function! latexlight#latexlight#Compile()
  let compile_command=shellescape(g:latexlight_command)
  let command="cd ".shellescape(s:currentdirectory)." && ".compile_command
  execute ':silent !'.command
  execute ':redraw!'
endfunction

function! latexlight#latexlight#GetQuickfixList(lines)
  let qflist = []
  let warning_pattern = '^LaTeX\s\+Warning:.*\(line\s\+\(\d+\)\)*.*' 
	let last_buffer = bufnr("$")
  for line in a:lines
    let warning_matches = matchlist(line, warning_pattern)
    if(!empty(warning_matches))
      echo warning_matches
      let warning = {'bufnr': last_buffer, 'lnum': 0, 'text': warning_matches[0]}
      call add(l:qflist, warning)
    endif
  endfor
  return qflist
endfunction

function! latexlight#latexlight#CompileLatexShowErrors() 
  let file=expand('%:t:r')  
  call latexlight#latexlight#Compile()
  let lines = readfile(s:currentdirectory.'/'.file.'.log')
  let qflist = latexlight#latexlight#GetQuickfixList(lines)
  call setqflist([], 'r')
  if len(qflist) <= 0 
    echo 'LaTeX: finished successfully' 
  else 
    call setqflist(qflist, 'r')
    copen
  endif 
endfunction 
