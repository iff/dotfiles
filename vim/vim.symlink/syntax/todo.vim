syntax match todoTodo "\v^ *\- \[ \] .*$"
highlight link todoTodo Identifier

syntax match todoDone "\v^ *\- \[x\] .*$"
highlight link todoDone Comment

syntax match todoNow "\v^ *\- \[!\] .*$"
highlight link todoNow Error

syntax match todoRunning "\v^ *\- \[r\] .*$"
highlight link todoRunning Statement

let b:current_syntax = "todo"
