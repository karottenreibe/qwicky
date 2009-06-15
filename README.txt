Share and enjoy!
================

Hi dear visitor, this is the README file of
**Qwicky**, the really quick wiki (yeah I
know -- what a splendid name that is).

You are obviously reading this, so the README
has already fulfilled it's purpose. Feel free
to close this file now.

If, of course, you'd like to know how Qwicky
is to be operated, feel also free to read on!

Usage
-----

1.  Start it:

        qwicky

2.  Open it in your browser

        http://localhost:4567

3.  Set the page you want to be displayed when
    starting Qwicky, set the Markup language
    you want to use, press save.

4.  Enjoy! (and don't forget to share...)

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

    or any of the other nice Markdown libraries, e.g.
    Maruku, peg-markdown etc.
    I wouldn't recommend BlueCloth, unless you really
    think you need that, see [this Blog post] [1].
    (As you might have already guessed from the layout
    of this document, I prefer Markdown. But it's your
    choice.)

*   For Textile, you can do

        gem install redcloth

Qwicky will automatically pick out the right gem to
require.

[1]: http://tomayko.com/writings/ruby-markdown-libraries-real-cheap-for-you-two-for-price-of-one
    "Post about why not to use BlueCloth"

Links
-----

To link to other wiki pages, use the old, familiar

    [[other page]]
    [[other page|title]]

syntax.

