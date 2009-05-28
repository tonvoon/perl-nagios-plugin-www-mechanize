#!/usr/bin/perl

use warnings;
use strict;

use FindBin qw($Bin);
use lib "$Bin/lib";

use Test::More;
use Nagios::Plugin::WWW::Mechanize;

plan tests => 17;

my $np;
$np = Nagios::Plugin::WWW::Mechanize->new( mech => { options => "4", to_pass => "mech" } );
is_deeply( $np->mech->{options_hash}, { options => "4", to_pass => "mech" } );

my $fake_mech = WWW::Mechanize->new( faked => 1 );
$np = Nagios::Plugin::WWW::Mechanize->new( mech => $fake_mech );
is_deeply( $np->mech->{options_hash}, { faked => 1 } );
is( $np->mech, $fake_mech );

eval { $np = Nagios::Plugin::WWW::Mechanize->new( mech => [qw(invalid array ref)] ) };
like( $@, "/Can't call method \"isa\" on unblessed reference/", "Compile error if wrong type for mech option given" );

# Use Nagios::Plugin, only because already here
my $fake_non_mech_object = Nagios::Plugin->new();
eval { $np = Nagios::Plugin::WWW::Mechanize->new( mech => $fake_non_mech_object ) };
like( $@, "/Invalid object passed into mech option/", "Invalid object passed into mech option" );


$np = Nagios::Plugin::WWW::Mechanize->new();
is_deeply( $np->mech->{options_hash}, { autocheck => 0 }, "Default options as expected to mech");
is( $np->include_time, 1, "include_time set by default" );

$np = Nagios::Plugin::WWW::Mechanize->new( include_time => 0 );
is( $np->include_time, 0, "Set include_time off" );

$np = Nagios::Plugin::WWW::Mechanize->new( include_time => 1 );
is( $np->include_time, 1, "Set include_time on" );

TODO: {
	local $TODO = "Cannot export constants yet";
	eval '$np->nagios_exit( CRITICAL, "Need to export this constant" )';
	is( $@, "", "Should allow CRITICAL" );
}

$np->nagios_exit( 2, "Args here" );
is_deeply( $np->{nagios_exit}, { code => 2, message => "Args here" } );
is_deeply( $np->{perfdata}, [] );

$np->mech->set_success(1);
$np->include_time(0);
$np->nagios_exit( 1, "More stuff here" );
is_deeply( $np->{nagios_exit}, { code => 1, message => "More stuff here" } );
is_deeply( $np->{perfdata}, [] );

$np->mech->set_success(1);
$np->include_time(1);
$np->nagios_exit( 1, "More stuff here" );
is_deeply( $np->{nagios_exit}, { code => 1, message => "More stuff here" } );
is_deeply( $np->{perfdata}, [ { label => "time", uom => "s", value => "0.000" } ] );

is($np->content, "called_content_via_www_mechanize" );


