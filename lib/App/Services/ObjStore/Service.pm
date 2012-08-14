package App::Services::ObjStore::Service;

use Moo;
with 'App::Services::Logger::Role';

use common::sense;

use KiokuDB;

has kdb => ( is => 'rwp');

our $kdb;

sub BUILD {
	$_[0]->init_object_store;
}

sub init_object_store {
	my $s = shift or die;
	$s->_set_kdb( KiokuDB->connect( "dbi:SQLite:dbname=$ENV{TEMP}/.app-services-obj-store-$$.db", create => 1 ) );
	
	$s->kdb or $s->log->logconfess();

}

sub add_object {

	my $s   = shift or die;
	my $obj = shift or $s->log->fatal("No object passed");
	my $id  = shift;

	my $kdb = $s->kdb;
	
	unless ( $kdb ) {
		$s->log->logconfess("Must call 'init_object_store' first");
	}

	my $new_id;

	do {
		eval {
			($new_id) = $kdb->txn_do(
				scope => 1,
				body  => sub {
					if ($id) {
						$kdb->insert( $id => Simple->new );
						
					} else {
						$kdb->insert( Simple->new );
						
					}
				}
			);
		};

		if ($@) {
			warn "$$ failed to commit, sleeping for random interval and retrying";
			my $i = rand(0.1);
			sleep $i;
			redo;
			
		} else {
			warn "$$ successfully comitted";
		}

	} while ( !$@ );
	
	return $new_id;

}

sub get_object {
	my $s  = shift or die;
	my $id = shift or $s->log->fatal("No object id passed");

	my $kdb = $s->kdb;

	unless ( $kdb ) {
		$s->log->logconfess("Must call 'init_object_store' first");
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

	unless ( $kdb ) {
		$s->log->logconfess("Must call 'init_object_store' first");
	}
	
	return $kdb->all_objects;

}

no Moo;

1;
