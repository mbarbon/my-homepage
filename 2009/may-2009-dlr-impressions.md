Title: Playing with DLR
Date-Rfc822: Fri, 01 May 2009 12:29:20 +0200
Description: First impressions from playing with DLR
Tags: dlr perl

Setup
-----

I used Mono 2.4 and MonoDevelop 2.0 (the binary download under Mac OS X,
built from sources for Debian Lenny x86-64) and the DLR from Subversion
(revision 23071).

For the DLR to build I had to make some changes to the project files:

    find . -name '*.csproj' | xargs perl -i -pe 's/\Q;$(SignedSym)\E//' -- 
    find . -name '*.csproj' | xargs perl -i -ne '/<TreatWarningsAsErrors>/ || print' -- 

naturally the same changes can be performed from the project settings
dialog inside MonoDevelop, but the above one-liners are way quicker.

The DLR compiles just fine from inside MonoDevelop, just open
`Src/Codeplex-DLR.sln`, expand "Runtme" and build
`Microsoft.Scripting.ExtensionAttribute`, `Microsoft.Scripting.Core` and
`Microsoft.Scripting`.  I have not tried to build the rest of the projects
(examples, IronPyton and IronRuby).

Hello world
-----------

    using System;
    using Microsoft.Linq.Expressions;
    
    namespace HelloWorld
    {
        class MainClass
        {
            public static void Main(string[] args)
            {
                // get the MethodInfo for the method System.Console.WriteLine(string)
                var write_line = typeof(System.Console).GetMethod("WriteLine", new Type[] { typeof(string) });
                // construct the expression tree for System.Console.WriteLine("Hello, world!")
                var exp = Expression.Lambda(
                            Expression.Call(write_line,
                                            Expression.Constant("Hello, world!")));
                // compile the expression and call the generated code
                exp.Compile().DynamicInvoke();
            }
        }
    }
    
While the program output is nothing impressive, I find the ability to
dynamically compile expression trees pretty impressive.  Even more
impressive is that expression trees can work both for translating ASTs
(they have blocks, conditional expressions, loops) and for compiling
basic blocks (using goto).
