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

if !exists('g:color_indent_start')
  " let g:color_indent_start = g:color_indent_start
" else
  let g:color_indent_start = 1
endif

if g:color_indent_start <= 0
  let g:color_indent_start = 1
endif

if !exists('g:color_indent_max')
  " let g:color_indent_max = g:color_indent_max
" else
  let g:color_indent_max = &foldnestmax
endif

" Comment out for only coloring 1-character
highlight default link colorIndentOddpost colorIndentOdd
highlight default link colorIndentEvenpost colorIndentEven

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
  call s:DefineMatches()
endfunction

function! s:Disable(...)
  if a:0 > 0 && a:1 ==# '!'
    let g:color_indent_disabled = 1
  else
    let b:color_indent_disabled = 1
  endif
  call s:ClearMatches()
endfunction

function! s:skipMatches()
  return exists('b:color_indent_disabled') && b:color_indent_disabled || g:color_indent_disabled
endfunction

function! s:ClearMatches()
  " Remove old matches
  if exists('w:color_indent_matches')
    for id in w:color_indent_matches
      call matchdelete(id)
    endfor
  endif
  let w:color_indent_matches = []
endfunction

function! s:DefineMatches()
  if s:skipMatches()
    return
  endif
  call s:ClearMatches()
  " Create new matches
  call s:match2()
endfunction

function! s:match1()
  for i in range(g:color_indent_start, g:color_indent_max)
    call add(w:color_indent_matches, matchadd('colorIndent'.s:cycle[i%2], '^\s*\%'.((i-1)*&l:sw+1).'v\s*\%'.(i*&l:sw+1).'v', g:color_indent_max-i+1))
  endfor
endfunction

function! s:match2()
  for i in range(g:color_indent_start, g:color_indent_max)
    call add(w:color_indent_matches, matchadd('colorIndent'.s:cycle[i%2].'post', '^\s*\%'.((i-1)*&l:sw+2).'v\zs\s*\%'.(i*&l:sw+1).'v'))
    call add(w:color_indent_matches, matchadd('colorIndent'.s:cycle[i%2], '^\s*\%'.((i-1)*&l:sw+1).'v\zs\s*\%'.((i-1)*&l:sw+2).'v'))
  endfor
endfunction

command! -bang -bar ColorIndentEnable call s:Enable("<bang>")
command! -bang -bar ColorIndentDisable call s:Disable("<bang>")

augroup colorindent
  autocmd!
  autocmd BufEnter,WinEnter * call <SID>DefineMatches()
  "autocmd BufWinLeave * call <SID>ClearMatches()
  autocmd ColorScheme * call <SID>Colors()
augroup END
