package Carp::Assert::More;

use warnings;
use strict;
use Exporter;
use Carp;
use Carp::Assert;

use vars qw( $VERSION @ISA @EXPORT );

*_fail_msg = *Carp::Assert::_fail_msg;

BEGIN {
    $VERSION = '0.01';
    @ISA = qw(Exporter);
    @EXPORT = qw( assert_defined assert_isa );
}

=head1 NAME

Carp::Assert::More - convenience wrappers around Carp::Assert

=head1 SYNOPSIS

    use Carp::Assert::More;

    my $parser = HTML::Parser->new();
    assert_isa( $parser, 'HTML::Parser', 'Got back a correct object' );

=head1 DESCRIPTION

Carp::Assert::More is a set of wrappers around the Carp::Assert functions
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

=head1 FUNCTIONS

=head2 assert_defined( $this [, $name] )

Asserts that I<$this> is defined.

=cut

sub assert_defined($;$) {
    if ( !defined($_[0]) ) {
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
