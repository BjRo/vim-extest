# !!! Deprecated !!!
This plugin is deprecated. [vim-test](https://github.com/janko-m/vim-test) offers much more (and is what I personally use nowadays).

# extest.vim

`extest.vim` is a [vim](http://www.vim.org) plugin, which helps you to run tests written in the [elixir](http://elixir-lang.org/) language from inside vim.
Currently it supports elixirs native test framework exunit as well as [Amitra](https://github.com/josephwilk/amrita).

## Installation

If you don't have a preferred installation method, I recommend
installing [pathogen.vim](https://github.com/tpope/vim-pathogen), and
then simply copy and paste:

```console
cd ~/.vim/bundle
git clone git://github.com/BjRo/vim-extest.git
```

## Key Bindings
By default extest.vim doesn't bind to any keys but is available in the form of commands

* `:ExTestRunFile` runs all the tests in the file that is loaded into the current buffer
* `:ExTestRunTest` runs the test case under the cursor
* `:ExTestRunLast` runs the last test, from any buffer
* `:ExTestRunCurrentOrLast` runs test case under the cursor or the last test (from any buffer)

If you want to bind those commands to your leader keys, you can do so nevertheless. For example:

```vim
map <leader>T :ExTestRunFile<CR>
map <leader>t :ExTestRunCurrentOrLast<CR>
```
or:
```vim
map <leader>T :ExTestRunFile<CR>
map <leader>t :ExTestRunTest<CR>
map <leader>lt :ExTestRunLast<CR>
```

## Customizing
You can customize the command which will be used to run each test by setting these options in your `.vimrc` file:

```vim
let g:extest_exunit_run_file_cmd = "mix test '%f'"
let g:extest_exunit_run_test_cmd = "mix test '%f'"
let g:extest_amrita_run_file_cmd = "mix amrita '%f'"
let g:extest_amrita_run_test_cmd = "mix amrita '%f:%l'"
```

Placeholders:

* `%f`: path of test file
* `%l`: line number

## Kudos
This plugin has been heavily influenced and inspired by [rubytest.vim](https://github.com/janx/vim-rubytest) by [janx](https://github.com/janx).
I've used it daily when developing stuff in Ruby in the last 2 years and wouldn't want to miss it. It's awesome. Go check it out!

## License
(The MIT License)

Copyright (c) 2013 Björn Rochel

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
