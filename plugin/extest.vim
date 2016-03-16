" (The MIT License)
"
" Copyright (c) 2013 Björn Rochel
"
" Permission is hereby granted, free of charge, to any person obtaining a copy of this
" software and associated documentation files (the 'Software'), to deal in the Software
" without restriction, including without limitation the rights to use, copy, modify, merge,
" publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons
" to whom the Software is furnished to do so, subject to the following conditions:

" The above copyright notice and this permission notice shall be included in all
" copies or substantial portions of the Software.

" THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT
" LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
" IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES
" OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
" OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

" Prevent the script from loading multiple times
if exists("g:extest_loaded") || &cp
  finish
endif
let g:extest_loaded = 1

" Default configuration if not set from another location
if !exists("g:extest_exunit_run_file_cmd")
  let g:extest_exunit_run_file_cmd = "mix test '%f'"
endif
if !exists("g:extest_exunit_run_test_cmd")
  let g:extest_exunit_run_test_cmd = "mix test '%f:%l'"
endif
if !exists("g:extest_amrita_run_file_cmd")
  let g:extest_amrita_run_file_cmd = "mix amrita '%f'"
endif
if !exists("g:extest_amrita_run_test_cmd")
  let g:extest_amrita_run_test_cmd = "mix amrita '%f:%l'"
endif

" Exported commands
command ExTestRunFile call <SID>RunFile()
command ExTestRunTest call <SID>RunTest()
command ExTestRunLast call <SID>RunLast()
command ExTestRunCurrentOrLast call <SID>RunCurrentOrLast()

function s:RunFile()
  return s:ExecTestRun("file")
endfunction

function s:RunTest()
  return s:ExecTestRun("test")
endfunction

function s:RunLast()
  if !exists("g:extest_last_cmd")
    echo "No previous test has been run"
    return
  endif

  return s:RunCommand(g:extest_last_cmd)
endfunction

function s:RunCurrentOrLast()
  let l:framework = s:IdentifyFramework()

  if empty(l:framework)
    return s:RunLast()
  else
    return s:RunTest()
  endif
endfunction


" Starts a test run.
" @param type ["test" | "file"]
function s:ExecTestRun(type)
  let l:framework = s:IdentifyFramework()

  if empty(l:framework)
    echo 'No test case found.'
    return
  endif

  return s:RunCommand(s:ShellCommandFor(l:framework, a:type))
endfunction

" Builds up the shellcommand for the particular test framework
" and replaces all placeholders with the actual values from the current buffer
function s:ShellCommandFor(framework, type)
  let l:cmd =  eval("g:extest_" . a:framework . "_run_" . a:type . "_cmd")
  let l:cmd = substitute(l:cmd, '%f', @%, 'g')
  let l:cmd = substitute(l:cmd, '%l', getpos(".")[1], 'g')
  return l:cmd
endfunction

function s:RunCommand(testCommand)
  let g:extest_last_cmd = a:testCommand
  exe "!echo '" . a:testCommand . "' && " . a:testCommand
endfunction

" Identifies the testframework used in the current buffer
" @returns (amrita | exunit | "")
let s:framework_identifiers = {}
let s:framework_identifiers['^\s*test\s*"'] = "exunit"
let s:framework_identifiers['^\s*use ExUnit.Case\s*'] = "exunit"
let s:framework_identifiers['^\s*\(should\|with\) \s*"'] = "exunit"
let s:framework_identifiers['^\s*\(it\|fact\|facts\|describe\|context\|specify\) \s*'] = "amrita"
let s:framework_identifiers['^\s*use Amrita.Sweet\s*'] = "amrita"
function s:IdentifyFramework()
  let l:ln = a:firstline
  while ln > 0
    let line = getline(l:ln)
    for pattern in keys(s:framework_identifiers)
      if line =~ pattern
        return s:framework_identifiers[pattern]
      endif
    endfor
    let l:ln -= 1
  endwhile
  return ""
endfunction
