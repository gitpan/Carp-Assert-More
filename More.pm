package Carp::Assert::More;

use warnings;
use strict;
use Exporter;
use Carp::Assert;

use vars qw( $VERSION @ISA @EXPORT );

*_fail_msg = *Carp::Assert::_fail_msg;

BEGIN {
    $VERSION = '0.04';
    @ISA = qw(Exporter);
    @EXPORT = qw( 
	assert_defined
	assert_fail
	assert_isa
	assert_nonref
	assert_nonblank
	assert_integer
	assert_nonzero
	assert_nonzero_integer
	assert_exists
    );
}

=head1 NAME

Carp::Assert::More - convenience wrappers around Carp::Assert

=head1 VERSION

Version 0.03

    $Header: /home/cvs/carp-assert-more/More.pm,v 1.16 2002/08/21 22:53:34 andy Exp $

=head1 SYNOPSIS

    use Carp::Assert::More;

    my $parser = HTML::Parser->new();
    assert_isa( $parser, 'HTML::Parser', 'Got back a correct object' );

=head1 DESCRIPTION

Carp::Assert::More is a set of wrappers around the L<Carp::Assert> functions
to make the habit of writing assertions even easier.

Everything in here is effectively syntactic sugar.  There's no technical
reason to use

    assert_isa( $foo, 'HTML::Lint' );

instead of

    assert( defined $foo );
    assert( ref($foo) eq 'HTML::Lint' );

other than readability and simplicity of the code.

My intent here is to make common assertions easy so that we as programmers
have no excuse to not use them.

=head1 TODO

Many more functions.  This is just the first proof of concept.

=head1 CAVEATS

I haven't specifically done anything to make Carp::Assert::More be
backwards compatible with anything besides Perl 5.6.1, much less back
to 5.004.  Perhaps someone with better testing resources in that area
can help me out here.

=head1 FUNCTIONS

Please note that there is no C<assert_string> function.  A string is
just a non-reference, for which we have C<assert_nonref>.

=head2 assert_fail( [$name] )

Assertion that always fails.  C<assert_fail($msg)> is exactly the same
as calling C<assert(0,$msg)>, but it eliminates that case where you
accidentally use C<assert($msg)>, which of course never fires.

=cut

sub assert_fail(;$) {
    require Carp;
    &Carp::confess( _fail_msg($_[0]) );
}

=head2 assert_defined( $this [, $name] )

Asserts that I<$this> is defined.

=cut

sub assert_defined($;$) {
    if ( !defined($_[0]) ) {
	require Carp;
	&Carp::confess( _fail_msg($_[1]) );
    }
}

=head2 assert_nonref( $this [, $name ] )

Asserts that I<$this> is not undef and not a reference.

=cut

sub assert_nonref($;$) {
    my $this = shift;
    my $name = shift;

    assert_defined( $this, $name );
    if ( ref($this) ) {
	require Carp;
	&Carp::confess( _fail_msg($_[1]) );
    }
}

=head2 assert_nonblank( $this [, $name] )

Asserts that I<$this> is not blank and not a reference.

=cut

sub assert_nonblank($;$) {
    my $this = shift;
    my $name = shift;

    assert_nonref( $this, $name );
    if ( $this eq "" ) {
	require Carp;
	&Carp::confess( _fail_msg($_[1]) );
    }
}

=head2 assert_integer( $this [, $name ] )

Asserts that I<$this> is an integer, which may be zero or negative.

    assert_integer( 0 );    # pass
    assert_integer( -14 );  # pass
    assert_integer( '14.' );  # FAIL

=cut

sub assert_integer($;$) {
    my $this = shift;
    my $name = shift;

    assert_nonref( $this, $name );
    if ( $this !~ /^-?\d+$/ ) {
	require Carp;
	&Carp::confess( _fail_msg($name) );
    }
}

=head2 assert_nonzero( $this [, $name ] )

Asserts that the numeric value of I<$this> is not zero.

    assert_nonzero( 0 );    # FAIL
    assert_nonzero( -14 );  # pass
    assert_nonzero( '14.' );  # pass

Asserts that the numeric value of I<$this> is not zero.

=cut

sub assert_nonzero($;$) {
    my $this = shift;
    my $name = shift;

    no warnings;
    if ( $this+0 == 0 ) {
	require Carp;
	&Carp::confess( _fail_msg($name) );
    }
}

=head2 assert_nonzero_integer( $this [, $name ] )

Asserts that the numeric value of I<$this> is not zero, and that I<$this>
is an integer.

    assert_nonzero_integer( 0 );    # FAIL
    assert_nonzero_integer( -14 );  # pass
    assert_nonzero_integer( '14.' );  # FAIL

=cut

sub assert_nonzero_integer($;$) {
    my $this = shift;
    my $name = shift;

    assert_nonzero( $this, $name );
    assert_integer( $this, $name );
}

=head2 assert_isa( $this, $type [, $name ] ) 

Asserts that I<$this> is an object of type I<$type>.

=cut

sub assert_isa($$;$) {
    my $this = shift;
    my $type = shift;
    my $name = shift;

    assert_defined( $this, $name );

    if ( ref($this) ne $type ) {
	require Carp;
	&Carp::confess( _fail_msg($name) );
    }
}

=head2 assert_exists( \%hash, $key [,$name] )

=head2 assert_exists( \%hash, \@keylist [,$name] )

Asserts that I<$key> exists in I<%hash>, or that all of the keys in I<@keylist> exist in I<%this>.

    assert_exists( \%custinfo, 'name', 'Customer has a name field' );

    assert_exists( \%custinfo, [qw( name addr phone )],
			    'Customer has name, address and phone' );

=cut

sub assert_exists($$;$) {
    my $hash = shift;
    my $key = shift;
    my $name = shift;

    assert_isa( $hash, 'HASH' );     
    my @list = ref($key) ? @$key : ($key);

    for ( @list ) {
	if ( !exists( $hash->{$_} ) ) {
	    require Carp;
	    &Carp::confess( _fail_msg($name) );
	}
    }
}

=head1 AUTHOR

Andy Lester <andy@petdance.com>

=cut

return 1; # happiness
