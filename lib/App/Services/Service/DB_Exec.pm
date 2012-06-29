package App::Services::Service::DB_Exec;

use Moose;

with 'PLib::Role::Logger';
with 'PLib::Role::DB_Conn';

use DBI;

has sql => ( is => 'rw', );

sub exec_sql {
	my $s = shift or confess;

	my $sql = shift or $s->log->logconfess("No SQL supplied to exec_sql");
	$s->log->info($sql);
	$s->sql($sql);
	return $s->exec;

}

has return_code => (
	is      => 'rw',
	default => 1,
);

has error_message => (
	is      => 'rw',
	default => '',
);

has array_ref => (
	is      => 'rw',
	default => undef,
);

sub validate {
	my $s = shift or confess;

	$s->dbh or confess("dbh handle required for &write_run");

	unless ( $s->dbh ) {
		$s->error_message("ERROR: NO DATABASE CONNECTION DEFINED");
		$s->return_code(undef);
		return undef;
	}

	unless ( $s->sql ) {
		$s->error_message("ERROR: NO SQL DEFINED TO EXECUTE");
		$s->return_code(undef);
		return undef;
	}
}

sub exec {
	my $s = shift or confess;

	return unless $s->validate;

	my $sql_text = $s->sql;

	my $sth = $s->dbh->prepare($sql_text);

	unless ($sth) {
		$s->error_message( $s->dbh->errstr );
		$s->return_code(undef);
		return undef;
	}

	my $rc = $sth->execute();

	unless ($rc) {
		$s->error_message( $s->dbh->errstr );
		$s->return_code(undef);
		return undef;
	}

	my $ra = $sth->fetchall_arrayref( {} );

	unless ($ra) {
		$s->error_message( $s->dbh->errstr );
		$s->return_code(undef);
		return undef;
	}

	$s->array_ref($ra);

	return $ra;
}

sub exec_scalar {
	my $s = shift or confess;

	return unless $s->validate;

	$s->log->debug( $s->sql );

	return $s->dbh->selectrow_array( $s->sql );

}

sub conn_refresh {
	my $s = shift or confess;

	$s->dbh_refresh;

}


no Moose;

1;

