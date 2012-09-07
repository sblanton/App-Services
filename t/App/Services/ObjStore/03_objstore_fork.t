#!/usr/bin/perl

use common::sense;

use Bread::Board;
use Test::More qw(no_plan);

use App::Services::ObjStore::Container;
use App::Services::Forker::Container;

use MyObj;

my $os_cntnr = App::Services::ObjStore::Container->new();
#my $frkr_cntnr = App::Services::Forker::Container->new();

#my $lsvc = $cntnr->resolve( service => 'log/logger_svc' );
#
#ok( $lsvc, "Create logger service" );

__END__

my $os_svc = $os_cntnr->resolve( service => 'obj_store_svc' );

ok( $svc, "Create object store service" );

$svc->delete_object_store;
sleep 1;
$svc->init_object_store;

ok( $svc->kdb, "initialized obj store" );

my $pid;
my @child_pids;

$svc->log->info("BEGIN");

foreach my $i ( 1 .. 10 ) {

	$pid = fork;

	unless ($pid) {
		my $obj = MyObj->new( foo => $i, bar => $i + $i );
		$svc->label("Child $i ($$)");

		my $oid = $svc->add_object($obj);

		ok( $oid, "Child $i ($$): inserted obj" );

		exit 0;
		
	} else {
		push @child_pids, $pid;
	}

}

use POSIX ":sys_wait_h";

my $kid;
$svc->log->info("$$: Waiting for children");

foreach my $pid (@child_pids) {
	waitpid( $pid, 0 );
}

$svc->log->info("Children all reaped");

my $i = 1;
my @obj_vals;

foreach my $obj ( $svc->all_objects ) {

	ok( ( ref($obj) eq 'MyObj' ), "$$: Got object ($i)" );

	push @obj_vals, $obj->foo;
	$svc->log->info("$$: Found obj with foo: " . $obj->foo);

	$i++;
}

