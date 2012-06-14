#!/usr/bin/perl

use common::sense;

use Test::More qw(no_plan);

use PLib::Container::DB_Conn::SQLite;

my $log_filename = 't_01.log';

my $log_conf = qq/ 
log4perl.rootLogger=INFO, main

log4perl.appender.main=Log::Log4perl::Appender::File
log4perl.appender.main.filename=$log_filename
log4perl.appender.main.layout   = Log::Log4perl::Layout::SimpleLayout
/;

my $cntnr = PLib::Container::DB_Conn::SQLite->new(
	db_file => 't_01.sqlite',
	log_conf => $log_conf,
);

my $svc = $cntnr->resolve( service => 'db_exec_svc' );

ok($svc, "Create db exec service");

my $log = $svc->log;

ok($log, "Got Log4perl logger");

$log->info("Log success!!");

ok( -f $log_filename, "Log file created");

unlink( -f $log_filename);
