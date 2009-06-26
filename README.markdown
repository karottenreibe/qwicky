Share and enjoy!
================

Hi dear visitor, this is the README file of
**[Qwicky] [qwicky]**, the REALLY quick wiki. (and
small as well!)

You are obviously reading this, so the README
has already fulfilled it's purpose. Feel free
to close this file now.

If, of course, you'd like to know how Qwicky
is to be operated, feel also free to read on!

Contributing
------------

Got a patch? Found a bug? Need a feature?
Let me know!

    karottenreibe _at_ gmail _dot_ com

Usage
-----

0.  Install it, if you haven't already:

        gem sources -a http://gems.github.com
        gem install karottenreibe-qwicky

1.  Start it:

        qwicky

2.  Open it in your browser

        http://localhost:4567

3.  Set the page you want to be displayed when
    starting Qwicky, set the Markup language
    you want to use, press save.

4.  Enjoy! (and don't forget to share...)

BTW, did I mention that you can tell qwicky
where to put the wiki database and settings
file?

    qwicky -- some/dir/to/put/the/files/in

Oh, and also try

    qwicky --help

for additional options...

Markup
------

There's only one catch to markup: If you want
something other than plain text and RDoc (which
is most probably already installed on your system),
you'll have to install the gems yourself.
This is to not introduce any unnecessary gems to
your system.

But DON'T PANIC, it's easy:

*   For Markdown, you can do

        gem install rdiscount

    or

        gem install rpeg-markdown

    or

        gem install bluecloth

    I wouldn't recommend BlueCloth, unless you really
    think you need that, see [this Blog post] [antiblue].
    (As you might have already guessed from the layout
    of this document, I prefer Markdown. But it's your
    choice.)

*   For Textile, you can do

        gem install redcloth

Qwicky will automatically pick out the right gem to
require.

Links
-----

To link to other wiki pages, use the old, familiar

    [[other page]]
    [[other page|title]]

syntax.

Styles
------

If you don't like the looks of Qwicky -- no, of course
that's impossible... silly...

But in any case, if you create a file called _qwicky.sass_
in the directory where your database and settings are
stored, qwicky will automatically run it through
[Sass] [sass] and apply it.

Running Qwucky on a server
==========================

...is almost cruelly simple.

1.  Set it up as normal, run it, set your settings.
2.  Freeze your config file by making _qwicky.yml_ non-writable
    to the user that runs Qwicky.
3.  Share and enjoy!



[antiblue]: http://tomayko.com/writings/ruby-markdown-libraries-real-cheap-for-you-two-for-price-of-one
    "Post about why not to use BlueCloth"
[qwicky]: http://github.com/karottenreibe/qwicky/
    "Qwicky's Homepage/Git repo/Wiki/whatever :-)"
[sass]: http://haml.hamptoncatlin.com/docs/rdoc/classes/Sass.html
    "Documentation of Sass syntax"

