#!/usr/bin/perl -w

# $Id: 01.load.t,v 1.1.1.1 2002/08/08 04:19:04 andy Exp $

BEGIN { $| = 1; print "1..1\n"; }
END   { print "not ok 1\n" unless $loaded; }

use Carp::Assert;
$loaded = 1;
print "ok\n";

