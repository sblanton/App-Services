#!/usr/bin/perl

use common::sense;

use File::Basename;
use PLib::Services::Util_Container;

my $sc = PLib::Services::Util_Container->new();

my $log = $sc->resolve( service => 'logger_svc' )->log;

$log->info("Log success!!")
