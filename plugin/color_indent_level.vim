if exists('g:color_indent_loaded')
  finish
endif
let g:loaded_indent_guides = 1
let g:color_indent_loaded = 1

if exists('g:color_indent_max')
  let s:color_indent_max = g:color_indent_max
else
  let s:color_indent_max = &foldnestmax
endif

" Define the highlight groups, but don't override the user's pre-defined
" colors.
for i in range(1,s:color_indent_max)
  exec 'highlight default clear colorIndent'.i
  exec 'highlight default link colorIndent'.i.'pre colorIndent'.i
endfor
for i in range(3,s:color_indent_max,2)
  exec 'highlight default link colorIndent'.i.' colorIndent1'
endfor
for i in range(4,s:color_indent_max,2)
  exec 'highlight default link colorIndent'.i.' colorIndent2'
endfor
" For alternating colors for each indent level
"
" assume that Normal is 234, #1C1C1C
"
highlight default colorIndent1 ctermbg=Black guibg=#121212
highlight default colorIndent2 ctermbg=DarkGray guibg=#262626

" For only coloring each 'shiftwidth' column
"
" assume that Normal is 234, #1C1C1C
"
"highlight colorIndent1 ctermbg=Black guibg=#262626
"highlight colorIndent2 ctermbg=Black guibg=#262626
"for i in range(1,s:color_indent_max,1)
"  exec 'highlight clear colorIndent'.i.'pre'
"endfor

function! s:skipMatches()
  return exists('b:skip_color_indent') && b:skip_color_indent == 1
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
  for i in range(1,s:color_indent_max,1)
    call add(w:color_indent_matches, matchadd('colorIndent'.i, '^\s*\%'.((i-1)*&l:sw+1).'v\s*\%'.(i*&l:sw+1).'v', s:color_indent_max-i+1))
  endfor
endfunction

function! s:match2()
  for i in range(1,s:color_indent_max,1)
    call add(w:color_indent_matches, matchadd('colorIndent'.i.'pre', '^\s*\%'.((i-1)*&l:sw+1).'v\zs\s*\%'.(i*&l:sw).'v', i))
    call add(w:color_indent_matches, matchadd('colorIndent'.i, '^\s*\%'.(i*&l:sw).'v\zs\s*\%'.(i*&l:sw+1).'v', i))
  endfor
endfunction

command! -bar ColorIndentEnable call s:DefineMatches()
command! -bar ColorIndentDisable call s:ClearMatches()

augroup colorindent
  autocmd!
  autocmd BufEnter,WinEnter * call <SID>DefineMatches()
  "autocmd BufWinLeave * call <SID>ClearMatches()
augroup END
