" Prevent the script from loading multiple times
"if exists("g:extest_loaded") || &cp
  "finish
"endif
"let g:extest_loaded = 1

" Default configuration if not set from another location
if !exists("g:extest_exunit_run_file_cmd")
  let g:extest_exunit_run_file_cmd = "mix test '%f'"
endif
if !exists("g:extest_exunit_run_test_cmd")
  let g:extest_exunit_run_test_cmd = "mix test '%f'"
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

  return s:RunTestCommand(g:extest_last_cmd)
endfunction

function s:ExecTestRun(type)
  let l:framework = s:IdentifyFramework()

  if empty(l:framework)
    echo 'No test case found.'
    return
  endif

  return s:RunTestCommand(s:TestCommandFor(l:framework, a:type))
endfunction

function s:TestCommandFor(framework, type)
  let l:cmd =  eval("g:extest_" . a:framework . "_run_" . a:type . "_cmd")
  let l:cmd = substitute(l:cmd, '%f', @%, 'g')
  let l:cmd = substitute(l:cmd, '%l', getpos(".")[1], 'g')
  return l:cmd
endfunction

function s:RunTestCommand(testCommand)
  let g:extest_last_cmd = a:testCommand
  exe "!echo '" . a:testCommand . "' && " . a:testCommand
endfunction

let s:framework_identifiers = {}
let s:framework_identifiers['^\s*test\s*"'] = "exunit"
let s:framework_identifiers['^\s*use ExUnit.Case\s*'] = "exunit"
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
