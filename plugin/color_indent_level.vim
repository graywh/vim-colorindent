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

" Define the highlight groups, but don't override the user's pre-defined
" colors.
for i in range(1,g:color_indent_max)
  exec 'highlight default clear colorIndent'.i
  exec 'highlight default link colorIndent'.i.'post colorIndent'.i
endfor
for i in range(3,g:color_indent_max,2)
  exec 'highlight default link colorIndent'.i.' colorIndent1'
endfor
for i in range(4,g:color_indent_max,2)
  exec 'highlight default link colorIndent'.i.' colorIndent2'
endfor
" For alternating colors for each indent level
"
" assume that Normal is 234, #1C1C1C
"
highlight default colorIndent1 ctermbg=Black guibg=#121212
highlight default colorIndent2 ctermbg=DarkGray guibg=#262626

" For only coloring each 'shiftwidth'+1 column
"
" assume that Normal is 234, #1C1C1C
"
"highlight colorIndent1 ctermbg=Black guibg=#262626
"highlight colorIndent2 ctermbg=Black guibg=#262626
"for i in range(1,g:color_indent_max,1)
"  exec 'highlight clear colorIndent'.i.'post'
"endfor

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
    call add(w:color_indent_matches, matchadd('colorIndent'.i, '^\s*\%'.((i-1)*&l:sw+1).'v\s*\%'.(i*&l:sw+1).'v', g:color_indent_max-i+1))
  endfor
endfunction

function! s:match2()
  for i in range(g:color_indent_start, g:color_indent_max)
    call add(w:color_indent_matches, matchadd('colorIndent'.i.'post', '^\s*\%'.((i-1)*&l:sw+2).'v\zs\s*\%'.(i*&l:sw+1).'v'))
    call add(w:color_indent_matches, matchadd('colorIndent'.i, '^\s*\%'.((i-1)*&l:sw+1).'v\zs\s*\%'.((i-1)*&l:sw+2).'v'))
  endfor
endfunction

command! -bang -bar ColorIndentEnable call s:Enable("<bang>")
command! -bang -bar ColorIndentDisable call s:Disable("<bang>")

augroup colorindent
  autocmd!
  autocmd BufEnter,WinEnter * call <SID>DefineMatches()
  "autocmd BufWinLeave * call <SID>ClearMatches()
augroup END
