Title: Stack unwinding for Language::P
Date-Rfc822: Sun, 16 Aug 2009 17:08:12 +0200
Description: Implementing stack unwinding for Language::P
Tags: perl language-p

I finally found a flexible way to represent scope information in the
<a href="http://github.com/mbarbon/language-p/tree/master">Language::P</a>
intermediate representation.

The newly added `scope_enter` and `scope_leave` pseudo-instructions
mark the start/end of a scope boundary; both instructions have a single
'scope' attribute that links to scope information stored in the IR
code object.  The advantage of this solution over storing scope
start/end offsets directly in the scope information is that it works
across IR code transformations and when scope entry/exit are on
separate basic blocks; the disadvantage is that finding the start/end
of a scope requires scanning all the IR representation of a
subroutine.

For example the following (dummy) Perl code

    {
        1;
    }

compiles to

    # main
    L1:
      scope_enter scope=0   # implicit scope for the file
      jump to=L2
    L2:
      scope_enter scope=1   # scope delimited by the braces
      constant_integer value=1
      scope_leave scope=1
      jump to=L4
    L4:
      scope_leave scope=0
      end

Scope information contains the outer scope (or `-1` for a
subroutine/main scope), flags to indicate the scope type (subroutine,
eval, main) and the bytecode to be run when exiting the scope through
an exception.

In the DLR runtime, wrapping subroutines/evals with a try/catch block
containing the scope exit code for inner scopes should be (almost) all
is needed for stack unwinding.

The implementation for the Toy runtime (just pushed to GitHub) is
straightforward: when an exception is thrown, search the scope list
for the scope containing the current program counter and walk up the
scope list, running scope exit bytecode, until an eval scope is found.
