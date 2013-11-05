" Prevent the script from loading multiple times
"if exists("extest_loaded")
  "finish
"endif
"let extest_loaded = 1

" Default configuration if not set from another location
if !exists("extest_exunit_run_file_cmd")
  let s:extest_exunit_run_file_cmd = "mix test '%f'"
endif
if !exists("extest_exunit_run_test_cmd")
  let s:extest_exunit_run_test_cmd = "mix test '%f'"
endif
if !exists("extest_amrita_run_file_cmd")
  let s:extest_amrita_run_file_cmd = "mix amrita '%f'"
endif
if !exists("extest_amrita_run_test_cmd")
  let s:extest_amrita_run_test_cmd = "mix amrita '%f:%l'"
endif

" Exported commands
command ExTestRunFile call <SID>RunFile()
command ExTestRunTest call <SID>RunTest()
command ExTestRunLast call <SID>RunLast()

function s:RunFile()
  echo "RunFile called."
  echo s:IdentifyFramework()
endfunction

function s:RunTest()
  echo "RunTest called."
endfunction

function s:RunLast()
  echo "RunLast called."
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
  return 0
endfunction
