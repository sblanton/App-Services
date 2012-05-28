#!/usr/bin/perl

use common::sense;

use Bread::Board;

use Test::More qw(no_plan);

my $log_filename = 't_01.log';

my $log_conf = qq/ 
log4perl.rootLogger=INFO, main

log4perl.appender.main=Log::Log4perl::Appender::File
log4perl.appender.main.filename=$log_filename
log4perl.appender.main.layout   = Log::Log4perl::Layout::SimpleLayout
/;

my $cntnr = container 't_log_01' => as {

	service log_conf => \$log_conf;

	service 'logger_svc' => (
		class        => 'PLib::Service::Logger',
		lifecycle    => 'Singleton',
		dependencies => [ log_conf => 'log_conf']
	);

};

my $svc = $cntnr->resolve( service => 'logger_svc' );

ok($svc, "Create logger service");

my $log = $svc->log;

ok($log, "Got Log4perl logger");

$log->info("Log success!!");

ok( -f $log_filename, "Log file created");

unlink( -f $log_filename);
