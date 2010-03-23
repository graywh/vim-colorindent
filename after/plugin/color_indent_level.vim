" For alternating colors for each indent level
"
" assume that Normal is 234, #1C1C1C
"
"highlight colorIndentLevel1 ctermbg=233 guibg=#121212
"highlight colorIndentLevel2 ctermbg=235 guibg=#262626

" For only coloring each 'shiftwidth' column
"
" assume that Normal is 234, #1C1C1C
"
"highlight colorIndentLevel1 ctermbg=235 guibg=#262626
"highlight colorIndentLevel2 ctermbg=235 guibg=#262626
"for i in range(1,g:color_indent_level_max,1)
"  exec 'highlight clear colorIndentLevel'.i.'pre'
"endfor
