#!/usr/bin/perl -w

use strict;
use warnings;
use t::lib::XSP::Test tests => 11;

run_diff xsp_stdout => 'expected';

__DATA__

=== Basic class
--- xsp_stdout
%module{Foo};

class Foo
{
    int foo( int a, int b, int c );
};
--- expected
MODULE=Foo

MODULE=Foo PACKAGE=Foo

int
Foo::foo( a, b, c )
    int a
    int b
    int c
  CODE:
    try {
      RETVAL = THIS->foo( a, b, c );
    } catch (std::exception& e) {
      croak("Caught unhandled C++ exception: %s", e.what());
    } catch (...) {
      croak("Caught unhandled C++ exception of unknown type");
    }
  OUTPUT: RETVAL

=== Empty class
--- xsp_stdout
%module{Foo};

class Foo
{
};
--- expected
MODULE=Foo

MODULE=Foo PACKAGE=Foo

=== Basic function
--- xsp_stdout
%module{Foo};
%package{Foo::Bar};

int foo( int a );
--- expected
MODULE=Foo

MODULE=Foo PACKAGE=Foo::Bar

int
foo( a )
    int a
  CODE:
    try {
      RETVAL = foo( a );
    } catch (std::exception& e) {
      croak("Caught unhandled C++ exception: %s", e.what());
    } catch (...) {
      croak("Caught unhandled C++ exception of unknown type");
    }
  OUTPUT: RETVAL

=== Default arguments
--- xsp_stdout
%module{Foo};

class Foo
{
    int foo( int a = 1 );
};
--- expected
MODULE=Foo

MODULE=Foo PACKAGE=Foo

int
Foo::foo( a = 1 )
    int a
  CODE:
    try {
      RETVAL = THIS->foo( a );
    } catch (std::exception& e) {
      croak("Caught unhandled C++ exception: %s", e.what());
    } catch (...) {
      croak("Caught unhandled C++ exception of unknown type");
    }
  OUTPUT: RETVAL

=== Constructor
--- xsp_stdout
%module{Foo};

class Foo
{
    Foo( int a = 1 );
};
--- expected
MODULE=Foo

MODULE=Foo PACKAGE=Foo

Foo*
Foo::new( a = 1 )
    int a
  CODE:
    try {
      RETVAL = new Foo( a );
    } catch (std::exception& e) {
      croak("Caught unhandled C++ exception: %s", e.what());
    } catch (...) {
      croak("Caught unhandled C++ exception of unknown type");
    }
  OUTPUT: RETVAL

=== Destructor
--- xsp_stdout
%module{Foo};

class Foo
{
    ~Foo();
};
--- expected
MODULE=Foo

MODULE=Foo PACKAGE=Foo

void
Foo::DESTROY()
  CODE:
    try {
      delete THIS;
    } catch (std::exception& e) {
      croak("Caught unhandled C++ exception: %s", e.what());
    } catch (...) {
      croak("Caught unhandled C++ exception of unknown type");
    }

=== Void function
--- xsp_stdout
%module{Foo};

class Foo
{
    void foo( int a );
};
--- expected
MODULE=Foo

MODULE=Foo PACKAGE=Foo

void
Foo::foo( a )
    int a
  CODE:
    try {
      THIS->foo( a );
    } catch (std::exception& e) {
      croak("Caught unhandled C++ exception: %s", e.what());
    } catch (...) {
      croak("Caught unhandled C++ exception of unknown type");
    }

=== No parameters
--- xsp_stdout
%module{Foo};

class Foo
{
    void foo();
};
--- expected
MODULE=Foo

MODULE=Foo PACKAGE=Foo

void
Foo::foo()
  CODE:
    try {
      THIS->foo();
    } catch (std::exception& e) {
      croak("Caught unhandled C++ exception: %s", e.what());
    } catch (...) {
      croak("Caught unhandled C++ exception of unknown type");
    }

=== Comments and raw blocks
--- xsp_stdout
// comment before %module
## comment before %module

%module{Foo};

## comment after %module
// comment after %module

{%
  Passed through verbatim
  as written in sources
%}

# simple typemaps
%typemap{int}{simple};

# before class
class Foo
{
    ## before method
    int foo( int a, int b, int c );
    # after method
};
/* long comment
 * right after
 * class
 */
--- expected
## comment before %module


MODULE=Foo
## comment after %module




  Passed through verbatim
  as written in sources


# simple typemaps


# before class



MODULE=Foo PACKAGE=Foo

## before method


int
Foo::foo( a, b, c )
    int a
    int b
    int c
  CODE:
    try {
      RETVAL = THIS->foo( a, b, c );
    } catch (std::exception& e) {
      croak("Caught unhandled C++ exception: %s", e.what());
    } catch (...) {
      croak("Caught unhandled C++ exception of unknown type");
    }
  OUTPUT: RETVAL

# after method

=== %length and ANSI style
--- xsp_stdout
%module{Foo};

%package{Bar};

unsigned int
bar( char* line, unsigned long %length{line} );
--- expected
MODULE=Foo

MODULE=Foo PACKAGE=Bar

unsigned int
bar( char* line, unsigned long length(line) )
  CODE:
    try {
      RETVAL = bar( line, length(line) );
    } catch (std::exception& e) {
      croak("Caught unhandled C++ exception: %s", e.what());
    } catch (...) {
      croak("Caught unhandled C++ exception of unknown type");
    }
  OUTPUT: RETVAL
=== various integer types
--- xsp_stdout
%module{Foo};

%package{Bar};

short int
bar( short a, unsigned short int b, unsigned c, unsigned int d, int e, unsigned short f, long int g, unsigned long int h );
--- expected
MODULE=Foo

MODULE=Foo PACKAGE=Bar

short
bar( a, b, c, d, e, f, g, h )
    short a
    unsigned short b
    unsigned int c
    unsigned int d
    int e
    unsigned short f
    long g
    unsigned long h
  CODE:
    try {
      RETVAL = bar( a, b, c, d, e, f, g, h );
    } catch (std::exception& e) {
      croak("Caught unhandled C++ exception: %s", e.what());
    } catch (...) {
      croak("Caught unhandled C++ exception of unknown type");
    }
  OUTPUT: RETVAL
