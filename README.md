gem-man(1) -- view a gem's man page
===================================

## SYNOPSIS

    gem man <GEM>
    gem man <SECTION> <GEM>
    gem man --system <GEM>
    gem man --latest <GEM>
    gem man --exact <GEM>
    gem man --all

## DESCRIPTION

The `gem man` command can be used to display a man page for an
installed RubyGem. The man page must be included with the gem -
`gem-man` does no generation or magic.

For an introduction to man pages, see `man(1)` (or type `man man` in
your shell).

## QUICKSTART

    gem install gem-man
    gem man gem-man

Metalicious.

## GEM

`gem man` expects to be passed the name of an installed gem. If there
are multiple man pages found for the gem, you will be asked which
you'd like to view. If only a single man page is found it will be
displayed.

Man pages are any files whose extension is a single digit [0-9],
e.g. `ron.1`.

## SECTION

Specifying a `SECTION` as the first argument narrows the search to man
pages matching the provided section. For example, if the "mustache"
gem includes `man/mustache.1` and `man/mustache.5` the command `gem
man 1 mustache` will display `man/mustache.1` without asking if you'd
like to see `man/mustache.5`.

## OPTIONS

`gem man`'s default mode of operation is to open a man page for a
single gem or, if multiple man pages are found, ask which you'd like
to open. If there are any ambiguities as to which gem to use, `gem
man` will ask which you'd prefer.

You can specify gems or list available gems using a few options.

  * `-s`, `--system`:
    Fall back to searching for system manuals. That is, `gem man -s
    mac` will first look for a gem named `mac` with a man page before
    looking for any system man pages named `mac`. `gem man -s fork`
    should find the fork(2) manual, for instance.

  * `-l`, `--latest`:
    If there are multiple versions of a gem, open the latest.

  * `-v`, `--version`:
    Specify version of gem to man.

  * `-e`, `--exact`:
    Only list exact matches.

  * `-a`, `--all`:
    List all installed gems that have manuals.

See `gem help man` to view the options at any time.

## INSTALL

    gem install gem-man

## EXAMPLES

    gem man mustache
    gem man 1 ron
    gem man -a

## AUTHORING

For information on authoring man pages, see [`ron(7)`][r7]:

    gem install ron
    gem man 7 ron

## CHEATING

If you want `man` to find RubyGems, it's this easy:

    alias man="gem man -s"

Now:

    man say
    man rails
    man 1 ronn
    man 2 fork

## BUGS

Requires the `man(1)` script to be in your path, executable, and to
accept a full path to a manual.

Requires Ruby and RubyGems 1.3.2 (or higher).

Please report other bugs at <http://github.com/defunkt/gem-man/issues>

## THANKS

* adamsanderson for open_gem
* rtomayko for ron

## COPYRIGHT

gem-man is Copyright (C) 2010 Chris Wanstrath with parts from Adam
Sanderson.

## SEE ALSO

ron(7), man(1), less(1), roff(7), groff(1),
<http://en.wikipedia.org/wiki/Man_page>,
<http://github.com/defunkt/gem-man>

[r7]: http://rtomayko.github.com/ron/
