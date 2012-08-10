package App::Services::DBS::Container::SQLite;

use Moose;
use Bread::Board;

use App::Services::DBS::Container;

extends 'App::Services::DBS::Container';

sub BUILD {
	$_[0]->build_container;
}

has db_file => (
	is      => 'rw',
	isa     => 'Str',
	default => 'tmp.sqlite',
);

has log_conf => ( is => 'rw', );

has +name => (
	is      => 'rw',
	isa     => 'Str',
	default => 'svc',
);

sub build_container {
	my $s = shift;

	my $dsn = "dbi:SQLite:dbname=" . $s->db_file;

	my $db_cntnr = App::Services::DBS::Container->new(
		dsn         => $dsn,
		db_user     => '',
		db_password => '',
		log_conf    => $s->log_conf,
		name        => 'db'
	);

	container $s => as {

		service 'db_exec_svc' => (
			class        => 'App::Services::Services::DB_Exec',
			dependencies => {
				logger_svc => depends_on('log/logger_svc'),
				db_conn    => depends_on('db/db_conn_svc'),
			}
		);

	};

	$s->add_sub_container($db_cntnr);

	return $s;
}

no Moose;

1;

