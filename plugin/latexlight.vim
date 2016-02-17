if exists("g:loaded_latexlight") || v:version < 700 || &cp
  finish
endif
let g:loaded_latexlight = 1

if !exists('g:latexlight_map_keys')
  let g:latexlight_map_keys = 1
endif

if !exists('g:latexlight_map_prefix')
    let g:latexlight_map_prefix = '<leader>'
endif

if g:latexlight_map_keys
 	augroup latexlight
		autocmd!
		autocmd FileType tex execute "nnoremap <buffer>".g:latexlight_map_prefix."p :call latexlight#latexlight#CompileLatexShowErrors()<CR>"
		autocmd FileType tex execute "nnoremap <buffer>".g:latexlight_map_prefix."q :call latexlight#latexlight#QuickCompileLatexShowErrors()<CR>"
	augroup END
endif
