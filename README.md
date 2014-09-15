# Jiragit

  A gem to smooth the integration of JIRA and Git in a common software development workflow. Jiragit automates the insertion of JIRA numbers and hyperlinks into Git commits, and provides a tool useful for accessing JIRA and Github while working on the command line. Pronounced 'drag it'.

## Context

  JIRA is an online service used by software development teams to track software issues as well as plan and track software development work. Each issue is assigned a number, for example PA-12345. Issues include a title, a description, user comments as well as a number of other customizable data fields. JIRA can integrate with Github. Github is an online service that provides Git repository hosting as well as a suite of software management tools, including code reviews and issue tracking. When integrated, JIRA can track pull requests and commits pushed to Github and relate them to JIRA issue numbers when the pull request description or the commit messages contain a JIRA issue number. This integration is useful in many ways, including for historical code analysis.

  A frequently used workflow for automatically including JIRA issue numbers into commit messages is to take advantage of [Git repository hooks](http://git-scm.com/book/en/Customizing-Git-Git-Hooks). With the [appropriate hook installed](https://bitbucket.org/tpettersen/prepare-commit-msg-jira) into a repository, and a Git branch name that begins with a JIRA issue number, the JIRA number will be prepended to all commit messages made on that branch. JIRA will thus recognize the relation between the commit and the JIRA when the commit is pushed to Github, and the JIRA issue will be updated with a reference to the commit automatically.

  While this workflow automates the insertion of JIRA numbers into commit messages, it has three negative side affects on Git usage. First, JIRA numbers, being serially determined, can be hard for a developer to remember, especially when multitasking on multiple issues or working in a repository shared by many developers. Beginning a branch name with a JIRA issue number requires developers to recall an arbitrary JIRA issue number while working and thus places an unnecessary cognitive burden on the developer. Second, JIRA numbers without links to the JIRA content, force the developer to take the extra steps of accessing the JIRA issue through an online search. Third, the JIRA issue numbers use up precious space in the title of the commit message and dilute the usefulness of many Git tools that only or preferentially report the first line of each commit message.

## Solution

Install the jiragit gem (globally)
```
$ gem install jiragit
```
Configure your JIRA URL
```
$ jiragit configure jira_url https://yourcompany.atlassian.net
```
Use jiragit to install the custom Git hooks into your repository
```
$ cd repository
$ jiragit install
```
When creating a feature branch, choose a name that you will be able to easily remember, such as a short word phrase. It is always easier to remember branch names that you create yourself and that are meaningful:
```
$ git checkout -b improve-one-click-purchase-form
Switched to a new branch 'improve-one-click-purchase-form'
What is the JIRA Number? []>
```
Then enter the JIRA number that describes this work, for example PA-12345.
```
$ git checkout -b improve-one-click-purchase-form
Switched to a new branch 'improve-one-click-purchase-form'
What is the JIRA Number? []> PA-12345
```
Jiragit will remember the relationship between the Git branch name and the JIRA number. When you go to create a new commit Jiragit will automiatically insert
the JIRA issue number and a hyperlink to the end of the body of the commit message.
```
$ git commit -m 'revised the form layout by updating the css'
[improve-one-click-purchase-form 3fde944] revised the form layout by updating the css
 1 file changed, 0 insertions(+), 0 deletions(-)
 create mode 100644 form.css

$ git log -1
commit 3fde94467d55bff68e78d05324ead6687b4127ce
Author: Derrick Parkhurst <derrick.parkhurst@gmail.com>
Date:   Mon Sep 8 17:49:14 2014 -0500

    revised the form layout by updating the css

    PA-12345: https://yourcompany.atlassian.net/browse/PA-12345

```
Once you push this commit to Github, JIRA will recognize this commit as belonging to the JIRA issue because the JIRA/Github integration searches the entire body of the commit message for JIRA issue numbers.

Jiragit also provides a convenient way to navigate to JIRA issues via the command line. You can view the JIRA for the current branch in your browser:
```
$ jiragit browse jira
```
or view a specified JIRA in your browser
```
$ jiragit PA-54321
```

Jiragit also provides a convenient way to navigate to branches on Github via the command line. You can view the Github page for the current branch in your browser:
```
$ jiragit browse
```
or view the specified branch in your browser
```
$ jiragit browse improve-one-click-purchase-form
```

## Requirements

* JIRA - http://www.atlassian.com/software/jira
* Github - http://github.com
* Git - http://git-scm.com/
* Ruby - https://www.ruby-lang.org/en/

## Tested on

* Mac OS X 10.8 - Ruby MRI 2.1.0

## License

Copyright (c) 2014 Derrick Parkhurst derrick.parkhurst@gmail.com

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
