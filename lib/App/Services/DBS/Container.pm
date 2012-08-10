package App::Services::DBS::Container;

use Moose;
use Bread::Board;

extends 'Bread::Board::Container';

use App::Services::Logger::Container;

sub BUILD {
	$_[0]->build_container;
}

has dsn => (
	is      => 'rw',
	isa     => 'Str',
	default => 'dbi:SQLite:dbname=tmp.sqlite',
);

has db_user => (
	is      => 'rw',
	isa     => 'Str',
	default => 'king',
);

has db_password => (
	is      => 'rw',
	isa     => 'Str',
	default => 'kong',
);

has log_conf => (
	is      => 'rw',
	default => 'log4perl.conf',
);

has +name => (
	is      => 'rw',
	isa     => 'Str',
	default => 'db',
);

sub build_container {
	my $s = shift;
	
	my $util_cntnr = App::Services::Logger::Container->new(
		log_conf => $s->log_conf,
		name => 'log'
	);

	container $s => as {

		service 'dsn'         => $s->dsn;
		service 'db_user'     => $s->db_user;
		service 'db_password' => $s->db_password;

		service 'db_conn_svc' => (    #-- raw DBI database handle
			class        => 'App::Services::DBS::Conn::Service',
			dependencies => {
				logger_svc     => depends_on('log/logger_svc'),
				dsn         => 'dsn',
				db_user     => 'db_user',
				db_password => 'db_password',
			}
		);

		service 'db_exec_svc' => (
			class        => 'App::Services::DBS::Exec::Service',
			dependencies => {
				logger_svc => depends_on('log/logger_svc'),
				db_conn => depends_on('db_conn_svc'),
			}
		);

	};
	
	$s->add_sub_container($util_cntnr);
	
	return $s;
}

no Moose;

1;

