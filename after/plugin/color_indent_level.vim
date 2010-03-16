for i in range(1,g:color_indent_level_max,2)
  exec 'highlight default colorIndentLevel'.i.' ctermbg=233'
endfor
for i in range(2,g:color_indent_level_max,2)
  exec 'highlight default colorIndentLevel'.i.' ctermbg=235'
endfor
