if exists('g:color_indent_loaded')
  finish
endif
let g:loaded_indent_guides = 1
let g:color_indent_loaded = 1

if !exists('*matchadd')
  finish
endif

if !exists('g:color_indent_disabled')
  " let g:color_indent_disabled = g:color_indent_disabled
" else
  let g:color_indent_disabled = 0
end

if !exists('g:color_indent_size')
  " let g:color_indent_size = g:color_indent_size
" else
  let g:color_indent_size = 0
endif

if g:color_indent_size < 0
  let g:color_indent_size = 0
endif

if !exists('g:color_indent_start')
  " let g:color_indent_start = g:color_indent_start
" else
  let g:color_indent_start = 1 + (g:color_indent_size == 1)
endif

if g:color_indent_start <= 0
  let g:color_indent_start = 1
endif

if !exists('g:color_indent_max')
  " let g:color_indent_max = g:color_indent_max
" else
  let g:color_indent_max = &foldnestmax
endif

let s:cycle = ['Even', 'Odd']

function! s:Colors()
  highlight default link colorIndentOdd CursorColumn
  highlight default link colorIndentEven FoldColumn
endfunction

call s:Colors()

function! s:Enable(...)
  if a:0 > 0 && a:1 ==# '!'
    let g:color_indent_disabled = 0
  else
    if g:color_indent_disabled
      echom 'ColorIndent is disabled globally'
    endif
    let b:color_indent_disabled = 0
  endif
  call s:Define()
endfunction

function! s:Disable(...)
  if a:0 > 0 && a:1 ==# '!'
    let g:color_indent_disabled = 1
  else
    let b:color_indent_disabled = 1
  endif
  call s:Clear()
endfunction

function! s:skip()
  return exists('b:color_indent_disabled') && b:color_indent_disabled || g:color_indent_disabled
endfunction

function! s:Clear()
  " Remove old matches
  if exists('w:color_indent_matches')
    for id in w:color_indent_matches
      call matchdelete(id)
    endfor
  endif
  let w:color_indent_matches = []
endfunction

function! s:Define()
  if s:skip()
    return
  endif
  call s:Clear()
  " Create new matches
  call s:match3()
endfunction

function! s:match1()
  for i in range(g:color_indent_start, g:color_indent_max)
    call add(w:color_indent_matches, matchadd('colorIndent'.i, '^\s*\%'.((i-1)*&l:sw+1).'v\s*\%'.(i*&l:sw+1).'v', 0-i+1))
  endfor
endfunction

function! s:match2()
  for i in range(g:color_indent_start, g:color_indent_max)
    call add(w:color_indent_matches, matchadd('colorIndent'.s:cycle[i%2].'post', '^\s*\%'.((i-1)*&l:sw+2).'v\zs\s*\%'.(i*&l:sw+1).'v', 0-i+1))
    call add(w:color_indent_matches, matchadd('colorIndent'.s:cycle[i%2], '^\s*\%'.((i-1)*&l:sw+1).'v\zs\s*\%'.((i-1)*&l:sw+2).'v', 0-i+1))
  endfor
endfunction

function! s:size()
  if exists('b:color_indent_size')
    let l:size = b:color_indent_size
  else
    let l:size = g:color_indent_size
  endif
  if l:size == 0
    return &l:sw
  else
    return l:size
  endif
endfunction

function! s:match3()
  let l:size = s:size()
  for i in range(g:color_indent_start, g:color_indent_max)
    call add(w:color_indent_matches, matchadd('colorIndent'.s:cycle[i%2], '^\s*\%'.((i-1)*&l:sw+1).'v\zs\s*\%'.((i-1)*&l:sw+1+l:size).'v', 0-i+1))
  endfor
endfunction

command! -bang -bar ColorIndentEnable call s:Enable("<bang>")
command! -bang -bar ColorIndentDisable call s:Disable("<bang>")

augroup colorindent
  autocmd!
  autocmd BufEnter,WinEnter * call <SID>Define()
  autocmd ColorScheme * call <SID>Colors()
  autocmd FileType help let b:color_indent_disable = 1
augroup END
