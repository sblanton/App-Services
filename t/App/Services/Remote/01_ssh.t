#!/usr/bin/env perl

use common::sense;

use Test::More qw(no_plan);

use App::Services::Remote::Container;

my $log_conf = qq/ 
log4perl.rootLogger=INFO, main
log4perl.appender.main=Log::Log4perl::Appender::Screen
log4perl.appender.main.layout   = Log::Log4perl::Layout::SimpleLayout
/;

my $cntnr = App::Services::Remote::Container->new(
	log_conf => \$log_conf,
	rem_user => 'sblanton',
	host_name => 'localhost',
);

my $svc = $cntnr->resolve( service => 'rem_exec_svc' );

ok($svc, "Create rm_exec service");

my $log = $svc->log;

ok($log, "Got Log4perl logger");

