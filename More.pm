package Carp::Assert::More;

use warnings;
use strict;
use Exporter;
use Carp::Assert;

use vars qw( $VERSION @ISA @EXPORT );

*_fail_msg = *Carp::Assert::_fail_msg;


=head1 NAME

Carp::Assert::More - convenience wrappers around Carp::Assert

=head1 VERSION

Version 1.02

    $Header: /home/cvs/carp-assert-more/More.pm,v 1.18 2004/01/18 04:15:36 andy Exp $

=cut

BEGIN {
    $VERSION = '1.02';
    @ISA = qw(Exporter);
    @EXPORT = qw(
        assert_defined
        assert_exists
        assert_fail
        assert_hashref
        assert_in
        assert_integer
        assert_isa
        assert_like
        assert_listref
        assert_negative
        assert_negative_integer
        assert_nonblank
        assert_nonempty
        assert_nonref
        assert_nonzero
        assert_nonzero_integer
        assert_positive
        assert_positive_integer
    );
}

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
        &Carp::confess( _fail_msg($name) );
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

=head2 assert_positive( $this [, $name ] )

Asserts that the numeric value of I<$this> is greater than zero.

    assert_positive( 0 );    # FAIL
    assert_positive( -14 );  # FAIL
    assert_positive( '14.' );  # pass

=cut

sub assert_positive($;$) {
    my $this = shift;
    my $name = shift;

    no warnings;
    if ( $this+0 <= 0 ) {
        require Carp;
        &Carp::confess( _fail_msg($name) );
    }
}

=head2 assert_negative( $this [, $name ] )

Asserts that the numeric value of I<$this> is less than zero.

    assert_negative( 0 );    # FAIL
    assert_negative( -14 );  # FAIL
    assert_negative( '14.' );  # pass

=cut

sub assert_negative($;$) {
    my $this = shift;
    my $name = shift;

    no warnings;
    if ( $this+0 >= 0 ) {
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

=head2 assert_positive_integer( $this [, $name ] )

Asserts that the numeric value of I<$this> is greater than zero, and
that I<$this> is an integer.

    assert_positive_integer( 0 );    # FAIL
    assert_positive_integer( -14 );  # FAIL
    assert_positive_integer( '14.' );  # pass

=cut

sub assert_positive_integer($;$) {
    my $this = shift;
    my $name = shift;

    assert_positive( $this, $name );
    assert_integer( $this, $name );
}

=head2 assert_negative_integer( $this [, $name ] )

Asserts that the numeric value of I<$this> is less than zero, and that
I<$this> is an integer.

    assert_negative_integer( 0 );    # FAIL
    assert_negative_integer( -14 );  # pass
    assert_negative_integer( '14.' );  # FAIL

=cut

sub assert_negative_integer($;$) {
    my $this = shift;
    my $name = shift;

    assert_negative( $this, $name );
    assert_integer( $this, $name );
}

=head2 assert_nonempty( $this [, $name ] )

I<$this> must be a ref to either a hash or an array.  Asserts that that
collection contains at least 1 element.  Will assert (with its own message,
not I<$name>) unless given a hash or array ref.   It is OK if I<$this> has
been blessed into objecthood, but the semantics of checking an object to see
if it has keys (for a hashref) or returns >0 in scalar context (for an array
ref) may not be what you want.

    assert_nonempty( 0 );       # FAIL
    assert_nonempty( 'foo' );   # FAIL
    assert_nonempty( undef );   # FAIL
    assert_nonempty( {} );      # FAIL
    assert_nonempty( [] );      # FAIL
    assert_nonempty( {foo=>1} );# pass
    assert_nonempty( [1,2,3] ); # pass

=cut

sub assert_nonempty($;$) {
    my $ref = shift;
    my $name = shift;

    my $type = ref $ref;
    if ( $type eq "HASH" ) {
        assert_positive( scalar keys %$ref, $name );
    } elsif ( $type eq "ARRAY" ) {
        assert_positive( scalar @$ref, $name );
    } else {
        assert_fail( "Not an array or hash reference" );
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
}

=head2 assert_like( $string, qr/regex/ [,$name] )

Asserts that I<$string> matches I<qr/regex/>.

=cut

sub assert_like($$;$) {
    my $string = shift;
    my $regex = shift;
    my $name = shift;

    assert_nonref($string, $name);
    assert_isa( $regex, 'Regexp' );
    if (!($string =~ $regex)) {
        require Carp;
        &Carp::confess( _fail_msg($name) );
    }
}

=head2 assert_in( $string, \@inlist [,$name] );

Asserts that I<$string> is defined and matches one of the elements
of I<\@inlist>.

I<\@inlist> must be an array reference of defined strings.

=cut

sub assert_in($$;$) {
    my $string = shift;
    my $arrayref = shift;
    my $name = shift;

    assert_nonref($string);
    assert_isa( $arrayref, 'ARRAY' );
    foreach my $element (@{$arrayref}) {
        assert_nonref($element);
        return if $string eq $element;
    }
    require Carp;
    &Carp::confess( _fail_msg($name) );
}

=head2 assert_exists( \%hash, $key [,$name] )

=head2 assert_exists( \%hash, \@keylist [,$name] )

Asserts that I<$key> exists in I<%hash>, or that all of the keys in
I<@keylist> exist in I<%this>.

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


=head2 assert_hashref( $ref [,$name] )

Asserts that I<$ref> is defined, and is a reference to a (possibly empty) hash.

B<NB:> This method returns I<false> for objects, even those whose underlying
data is a hashref. This is as it should be, under the assumptions that:

=over 4

=item (a)

you shouldn't rely on the underlying data structure of a particular class, and

=item (b)

you should use C<assert_isa> instead.

=back

=cut

sub assert_hashref($;$) {
    my $ref = shift;
    my $name = shift;

    return assert_isa($ref, 'HASH');
}

=head2 assert_listref( $ref [,$name] )

Asserts that I<$ref> is defined, and is a reference to a (possibly empty) list.

B<NB:> The same caveat about objects whose underlying structure is a
hash (see C<assert_hashref>) applies here; this method returns false
even for objects whose underlying structure is an array.

=cut

sub assert_listref($;$) {
    my $ref = shift;
    my $name = shift;

    return assert_isa($ref, 'ARRAY');
}

=head1 AUTHOR

Andy Lester <andy@petdance.com>

=head1 ACKNOWLEDGEMENTS

Thanks to
Pete Krawczyk,
David Storrs
and
Dan Friedman
for assert_ functions.

=cut

return 1; # happiness
