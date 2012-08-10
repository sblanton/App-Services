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

my $cntnr = container '01_basic_t' => as {

	service log_conf => \$log_conf;

	service 'logger_svc' => (
		class        => 'App::Services::Service::Logger',
		lifecycle    => 'Singleton',
		dependencies => [ log_conf => 'log_conf' ]
	);

	service 'obj_store_svc' => (
		class      => 'App::Services::Service::ObjStore',
		depends_on => { logger_svc => depends_on('logger_svc') },
	);

};

my $lsvc = $cntnr->resolve( service => 'logger_svc' );

ok( $lsvc, "Create logger service" );

my $svc = $cntnr->resolve( service => 'obj_store_svc' );

ok( $svc, "Create object store service" );

