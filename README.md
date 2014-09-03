# Jiragit

TODO: Write a gem description

## Installation

    $ gem install jiragit

## Usage



### Jiragit CLI

      :install,
      :uninstall,
      :jira,
      :branch,
      :jira_branch,
      :browse,
      :remote,
      :local

#### jiragit install
Installs git hooks into current repository

#### jiragit uninstall
Uninstalls git hooks into current repository

#### jiragit jira [ jira number ]
List related branches and commits for the specified jira

#### jiragit branch [ branch name = current branch ]
List related jiras and commits for the specified branch

#### jiragit browse [ jira number || branch name || commit SHA ]
Opens web browser to the jira, branch or commit specified

#### jiragit browse jira [ jira number ]
Opens web browser to the JIRA page specified

#### jiragit browse
Opens web browser to the Github page for the current branch

#### jiragit browse branch [ branch name = current branch ]
Opens web browser to the Github page for the branch specified

#### jiragit browse jira [ jira number = jira number for the current branch ]
Opens web browser to the JIRA page for the jira specified

#### jiragit browse commit [ commit SHA = latest commit for the current branch ]
Opens web browser to the Github page for the commit specified

#### jiragit remote
List all remote branches in reverse chronological order

#### jiragit local
List all local branches in reverse chronological order

## Contributing

1. Fork it ( http://github.com/<my-github-username>/jiragit/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## License

Copyright (c) 2014 Derrick Parkhurst

MIT License

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
