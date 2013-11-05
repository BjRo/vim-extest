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

command ExTestRunFile call <SID>RunFile()
command ExTestRunTest call <SID>RunTest()
command ExTestRunLast call <SID>RunLast()

function s:RunFile()
  echo "RunFile called."
endfunction

function s:RunTest()
  echo "RunTest called."
endfunction

function s:RunLast()
  echo "RunLast called."
endfunction
