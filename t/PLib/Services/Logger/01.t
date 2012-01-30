#!/usr/bin/perl

use common::sense;

use File::Basename;
use PLib::Services::Container;

my $sc = PLib::Services::Container->new();

my $log = $sc->resolve( service => 'logger_svc' )->log;
