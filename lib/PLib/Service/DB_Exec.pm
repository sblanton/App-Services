package PLib::Service::DB_Exec;

use Moose;

with 'PLib::Roles::Logger';

use DBI;

has sql => (
	is => 'rw',
);

has dbh => (
	is => 'rw',
	default => \&dbh_builder,
	lazy => 1,
);

sub exec {
	my $s = shift or confess;

	$s->dbh or confess;
	$s->sql or confess;

	$s->sth = $s->dbh->prepare($s->sql);
	$s->sth->execute or die $DBI::errstr;

	return sub { $s->sth->fetchrow_hashref() }

}

no Moose;

1;

