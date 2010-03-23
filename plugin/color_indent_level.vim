if exists('g:color_indent_level_loaded') && g:color_indent_level_loaded == 1
  finish
else
  let g:color_indent_level_loaded = 1
endif

if exists('g:color_indent_level_max')
  let s:color_indent_level_max = g:color_indent_level_max
else
  let s:color_indent_level_max = &foldnestmax
  let g:color_indent_level_max = s:color_indent_level_max
endif

" Define the highlight groups, but don't override the user's pre-defined
" colors.
for i in range(1,g:color_indent_level_max)
  exec 'highlight default clear colorIndentLevel'.i
  exec 'highlight default link colorIndentLevel'.i.'pre colorIndentLevel'.i
endfor
for i in range(3,g:color_indent_level_max,2)
  exec 'highlight default link colorIndentLevel'.i.' colorIndentLevel1'
endfor
for i in range(4,g:color_indent_level_max,2)
  exec 'highlight default link colorIndentLevel'.i.' colorIndentLevel2'
endfor

function! s:skipMatches()
  return exists('b:skip_color_indent_level') && b:skip_color_indent_level == 1
endfunction

function! s:ClearMatches()
  if s:skipMatches()
    return
  endif
  " Remove old matches
  if exists('w:matches')
    for m in w:matches
      call matchdelete(m)
    endfor
  endif
  let w:matches = []
endfunction

function! s:DefineMatches()
  if s:skipMatches()
    return
  endif
  let w:matches = []
  " Create new matches
  call s:match2()
endfunction

function! s:match1()
  for i in range(1,s:color_indent_level_max,1)
    let w:matches = extend(w:matches, [matchadd('colorIndentLevel'.i, '^\s*\%'.((i-1)*&l:sw+1).'v\s*\%'.(i*&l:sw+1).'v', s:color_indent_level_max-i+1)])
  endfor
endfunction

function! s:match2()
  for i in range(1,s:color_indent_level_max,1)
    let w:matches = extend(w:matches, [matchadd('colorIndentLevel'.i.'pre', '^\s*\%'.((i-1)*&l:sw+1).'v\zs\s*\%'.(i*&l:sw).'v', i)])
    let w:matches = extend(w:matches, [matchadd('colorIndentLevel'.i, '^\s*\%'.(i*&l:sw).'v\zs\s*\%'.(i*&l:sw+1).'v', i)])
  endfor
endfunction

augroup colorindent
  autocmd!
  autocmd BufWinEnter * call <SID>DefineMatches()
  autocmd BufWinLeave * call <SID>ClearMatches()
augroup END
