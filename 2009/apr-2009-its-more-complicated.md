Title: It's more complicated than you think
Date-Rfc822: Sun, 05 Apr 2009 21:39:20 +0200
Description: A 5-minute fix that did not take 5 minutes
Tags: perl

Today, after two weeks, I looked at my wxPerl inbox and found a bug
report (with patch!) to make <a
href="http://search.cpan.org/dist/Alien-wxWidgets/">Alien::wxWidgets</a>
work with <a href="http://www.wxwidgets.org/">wxWidgets 2.8.10</a>;
feeling guilty for not answering it in a timely manner, I proceeded to
apply the patch.

After testing it on Mac, I had almost hit "Send" for the
thanks-applied mail, when my conscience suddenly awoke and told me I
should at least test the change under Windows.  Foolishly, I decided
to upgrade to the latest and greatest Module::Build and MakeMaker (it
will only take 5 minutes!).

Bad Idea.

Module::Install failed halfway through Module::Build and
Compress::Zlib installation, being unable to replace some files: one
hour wasted in fixing the Perl installation.

Another hour wasted in tracking a build bug unrelated to the patch in
question.

With some luck I will manage to commit the one-line patch today...
