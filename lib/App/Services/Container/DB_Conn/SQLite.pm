package App::Services::Container::DB_Conn::SQLite;

use Moose;
use Bread::Board;

extends 'Bread::Board::Container';

use App::Services::Container::DB;

sub BUILD {
	$_[0]->build_container;
}

has db_file => (
	is      => 'rw',
	isa     => 'Str',
	default => 'tmp.sqlite',
);

has log_conf => (
	is      => 'rw',
);

has +name => (
	is      => 'rw',
	isa     => 'Str',
	default => 'svc',
);

sub build_container {
	my $s = shift;
	
	my $dsn = "dbi:SQLite:dbname=" . $s->db_file;

	return App::Services::Container::DB->new(
		dsn => $dsn,
		db_user => '',
		db_password => '',
		log_conf => $s->log_conf,
	);
	
}

no Moose;

1;

