#!/usr/bin/perl

use warnings;
use strict;

use Test::More tests=>7;

BEGIN { use_ok( 'Carp::Assert::More' ); }

my %foo = (
    name => "Andy Lester",
    phone => "578-3338",
    wango => undef,
);


eval {
    assert_exists( \%foo, 'name' );
};
is( $@, "" );


eval {
    assert_exists( \%foo, 'wango' );
};
is( $@, "" );


eval {
    assert_exists( \%foo, 'Nonexistent' );
};
like( $@, qr/Assert.+failed/ );


eval {
    assert_exists( \%foo, [qw( name )] );
};
is( $@, "" );

eval {
    assert_exists( \%foo, [qw( name phone )] );
};
is( $@, "" );


eval {
    assert_exists( \%foo, ['name','Nonexistent'] );
};
like( $@, qr/Assert.+failed/ );


