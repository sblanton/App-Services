package App::Services::ObjStore::Service;

use Moo;

use common::sense;

with 'App::Services::Logger::Role';

use KiokuDB;

has kdb => ( is => 'rw' );

has kdb_file => (
	is      => 'rw',
	default => sub { "dbi:SQLite:dbname=/tmp/.app-services-obj-store-$$.db" }
);

has label => (
	is => 'rw',
	default => sub { $$ },
);

sub init_object_store {
	my $s = shift or die;

	$s->kdb( KiokuDB->connect( $s->kdb_file, create => 1 ) );

	$s->kdb or $s->log->logconfess();

}

sub delete_object_store {
	my $s = shift or die;

	unlink $s->kdb_file if -d $s->kdb_file;

	$s->log->warn("Couldn't delete object store") if -d $s->kdb_file;

	$s->kdb(undef);

	return $s->kdb;

}

sub add_object {

	my $s   = shift or die;
	my $obj = shift or $s->log->fatal($s->label . ": No object passed");
	my $id  = shift;

	my $kdb = $s->kdb;
	my $log = $s->log;

	$log->debug($s->label . " Entering add_object");

	unless ($kdb) {
		$s->log->logconfess($s->label . ": Must call 'init_object_store' first");
	}

	my $new_id;

	my $rc;

	do {
		$log->info($s->label . ": Inserting obj");

		eval {
			($new_id) = $kdb->txn_do(
				scope => 1,
				body  => sub {
					if ($id) {
						$kdb->insert( $id => $obj );

					} else {
						$kdb->insert($obj);

					}
				}
			);
		};

		if ($@) {
			$s->log->warn( $s->label . ": failed to commit to (" . $s->kdb . "): [ $@ ], sleeping for random interval and retrying" );
			my $i = rand(0.1);
			sleep $i;

		} else {
			$log->info($s->label . ": successfully comitted");
			$rc = 1;
		}

	} until ($rc);

	return $new_id;

}

sub get_object {
	my $s  = shift or die;
	my $id = shift or $s->log->fatal($s->label . ": No object id passed");

	my $kdb = $s->kdb;

	unless ($kdb) {
		$s->log->logconfess($s->label . ":Must call 'init_object_store' first");
	}

	my $obj;

	$kdb->txn_do(
		scope => 1,
		body  => sub {
			$obj = $kdb->lookup($id);
		}
	);

	return $obj;
}

sub all_objects {
	my $s = shift or die;

	my $kdb = $s->kdb;

	unless ($kdb) {
		$s->log->logconfess($s->label . ":Must call 'init_object_store' first");
	}

	return $kdb->all_objects->items;

}

no Moo;

1;
