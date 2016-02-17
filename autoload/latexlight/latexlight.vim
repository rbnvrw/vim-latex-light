if exists("g:autoloaded_latexlight")
  finish
endif
let g:autoloaded_latexlight = 1

if !exists("g:latexlight_command")
  let g:latexlight_command = "make"
endif

if !exists("g:latexlight_quick_command")
  let g:latexlight_quick_command = "pdflatex -synctex=1 -interaction=nonstopmode --shell-escape"
endif

if !exists("g:latexlight_quick_command_append_file")
  let g:latexlight_quick_command_append_file = "%:t"
endif

if !exists("g:latexlight_quick_view_command")
  if has("win32") || has("win16")
    let g:latexlight_quick_view_command = "start '' /max %"
  else
    let g:latexlight_quick_view_command = "xdg-open %"
  endif
endif

if !exists("g:latexlight_startpattern_list")
  let g:latexlight_startpattern_list = [{'pattern': 'LaTeX\s\+Error:', 'type':'E'}, {'type':'W', 'pattern': 'LaTeX\s\+Warning:'}]
endif

if !exists("g:latexlight_subpattern")
  let g:latexlight_subpattern = '.\{-}line\s*\(\d\+\).*'
endif

let s:currentdirectory = expand('%:p:h')
let s:file=expand('%:t:r')  
let s:filename=expand('%')

function! latexlight#latexlight#SortQFListUnique(list)
  let unique_dict = {}
  let unique_list = []

  for warning in a:list
    let uniquekey = shellescape(warning['filename'] . warning['lnum'] . warning['type'] . warning['text'])
    if !has_key(unique_dict, uniquekey)
      call add(unique_list, warning)
      let unique_dict[uniquekey] = 1
    endif
  endfor
  return unique_list
endfunction

function! latexlight#latexlight#QuickCompile()
  let compile_command=g:latexlight_quick_command.' '.shellescape(expand(g:latexlight_quick_command_append_file))
  let command="cd ".shellescape(s:currentdirectory)." && ".compile_command
  execute ':silent !'.command
  execute ':redraw!'
endfunction

function! latexlight#latexlight#Compile()
  let command="cd ".shellescape(s:currentdirectory)." && ".g:latexlight_command
  execute ':silent !'.command
  execute ':redraw!'
endfunction

function! latexlight#latexlight#MatchToWarning(match, type)
  let linenumber = get(a:match, 1, 1)
  if(empty(linenumber))
    let linenumber = 1
  endif
  let warning = {'filename': s:currentdirectory.'/'.s:filename, 'lnum': linenumber, 'text': a:match[0], 'type': a:type}
  return warning
endfunction

function! latexlight#latexlight#MatchAWarning(startpattern, type, line)
  let warning_pattern_line_nr = a:startpattern.g:latexlight_subpattern 
  let warning_pattern = a:startpattern.'.*' 
  let warning_matches = matchlist(a:line, warning_pattern)
  let warning_nr_matches = matchlist(a:line, warning_pattern_line_nr)
  if(!empty(warning_nr_matches))
    return latexlight#latexlight#MatchToWarning(warning_nr_matches, a:type)
  endif
  if(!empty(warning_matches))
    return latexlight#latexlight#MatchToWarning(warning_matches, a:type)
  endif
  return {}
endfunction

function! latexlight#latexlight#GetQuickfixList(lines)
  let qflist = []
  for line in a:lines
    for pattern in g:latexlight_startpattern_list
      let warning = latexlight#latexlight#MatchAWarning(pattern['pattern'], pattern['type'], line)
      if(!empty(warning))
        call add(l:qflist, warning) 
      endif
    endfor
  endfor
  let qflist = latexlight#latexlight#SortQFListUnique(qflist)
  return qflist
endfunction

function! latexlight#latexlight#GetAndShowErrorsAndWarnings()
  let lines = readfile(s:currentdirectory.'/'.s:file.'.log')
  let qflist = latexlight#latexlight#GetQuickfixList(lines)
  if len(qflist) > 0 
    call setqflist(qflist, 'r')
    copen
  else
    call setqflist([], 'r')
  endif 
endfunction

function! latexlight#latexlight#CompileLatexShowErrors() 
  call latexlight#latexlight#Compile()
  call latexlight#latexlight#GetAndShowErrorsAndWarnings()
endfunction 

function! latexlight#latexlight#QuickCompileLatexShowErrors()
  call latexlight#latexlight#QuickCompile()
  call latexlight#latexlight#GetAndShowErrorsAndWarnings()
endfunction
