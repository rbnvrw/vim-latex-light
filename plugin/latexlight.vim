if !exist('g:latexlight_map_keys')
  let g:latexlight_map_keys = 1
endif

if !exists('g:latexlight_map_prefix')
    let g:latexlight_map_prefix = '<leader>'
endif

if g:latexlight_map_keys
  execute "autocommand FileType tex" "nnoremap <buffer>" g:latexlight_map_prefix."p"  ":call <sid>latexlight#CompileLatexShowErrors()<CR>"
endif
