#!/usr/bin/perl

use warnings;
use strict;

use FindBin qw($Bin);
use lib "$Bin/lib";

use Test::More;
use Test::Deep;

plan tests => 4;

use_ok("Nagios::Plugin::WWW::Mechanize");
my $np;

$np = Nagios::Plugin::WWW::Mechanize->new();
is( $np->total_time, 0, "Timer reset to 0" );
$np->timer_start;
sleep 4;
$np->timer_end;
cmp_ok( $np->total_time, ">=", 4, "Timer above 4 seconds" );
cmp_ok( $np->total_time, "<", 4.05, "Allow 0.05 seconds latency" );
