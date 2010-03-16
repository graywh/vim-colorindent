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
for i in range(1,s:color_indent_level_max)
  exec 'highlight default clear colorIndentLevel'.i
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
  " Determine how to match
  if &l:expandtab
    let l:str = '\s'
    let l:mult = &l:sw
  else
    let l:str = '\t'
    let l:mult = 1
  endif
  " Create new matches
  for i in range(1,s:color_indent_level_max,1)
    let w:matches = extend(w:matches, [matchadd('colorIndentLevel'.i, '^'.l:str.'\{'.(i*l:mult-1).'}'.l:str, s:color_indent_level_max-i+1)])
  endfor
endfunction

autocmd BufWinEnter * call <SID>DefineMatches()
autocmd BufWinLeave * call <SID>ClearMatches()