#!/usr/bin/env perl

use strict;
use warnings; no warnings 'once';

use Test::More tests => 3;

use lib grep { -d } qw(../lib ./lib);
use Hash::MostUtils qw(leach hashmap n_each n_map);
use Test::Easy qw(deep_ok);

subtest basic => sub {
	diag 'illustrate basic leach LIST';
	plan tests => 1;

	my @list = (1..10);
	my @got;
	while (my ($k, $v) = leach @list) {
		push @got, [$k, $v];
	}
	deep_ok( \@got, [hashmap { [$a, $b] } @list], 'list-each works' );
};

subtest n_ary => sub {
	diag 'show n-ary listwise each';
	plan tests => 1;

	my @list = (1..9);
	my @got = ();
	while (my ($k, $v1, $v2) = n_each 3, @list) {
		push @got, [$k, $v1, $v2];
	}
	deep_ok( \@got, [n_map 3, sub { [$::a, $::b, $::c] }, @list], 'n_each works' );
};

subtest mutable => sub {
	diag 'show that mutating @list affects the cache leach() maintains';
	plan tests => 2;

	my @list = (1..10);
	my @got = ();
	while (my ($k, $v) = leach @list) {
		@list = () if $k == 1;
		push @got, [$k, $v];
	}
	deep_ok( \@got, [[1, 2]], 'mutating @list updated $leach object' );
	deep_ok( \@list, [], 'we set @list to ()' );
};
