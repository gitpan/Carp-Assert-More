package Carp::Assert::More;

use warnings;
use strict;
use Exporter;
use Carp::Assert;

use vars qw( $VERSION @ISA @EXPORT );

*_fail_msg = *Carp::Assert::_fail_msg;

BEGIN {
    $VERSION = '0.03';
    @ISA = qw(Exporter);
    @EXPORT = qw( 
	assert_defined
	assert_fail
	assert_isa
	assert_nonref
	assert_nonblank
    );
}

=head1 NAME

Carp::Assert::More - convenience wrappers around Carp::Assert

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
    return undef;
}

=head1 AUTHOR

Andy Lester <andy@petdance.com>

=cut

return 1; # happiness
