package PLib::Container::DB;

use Moose;
use Bread::Board;

extends 'Bread::Board::Container';

sub BUILD {
	$_[0]->build_container;
}

has dsn => (
	is      => 'rw',
	isa     => 'Str',
	default => 'mydatabase',
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

has log_conf_file => (
	is      => 'rw',
	isa     => 'Str',
	default => 'log4perl.conf',
);

has +name => (
	is      => 'rw',
	isa     => 'Str',
	default => 'svc',
);

sub build_container {
	my $s = shift;
	
	my $util_cntnr = PLib::Container::Logger->new(
		log_conf => $s->log_conf,
		name => 'util'
	);


	container $s => as {

		service 'dsn'         => $s->host_name;
		service 'db_user'     => $s->db_user;
		service 'db_password' => $s->db_password;

		service 'db_conn' => (    #-- raw DBI database handle
			class        => 'PLib::Services::DB_Conn',
			dependencies => {
				log_svc     => depends_on('util/log_svc'),
				dsn         => 'dsn',
				db_user     => 'db_user',
				db_password => 'db_password',
			}
		);

		service 'db_exec' => (
			class        => 'PLib::Services::DB_Exec',
			dependencies => {
				log_svc => depends_on('util/log_svc'),
				db_conn => depends_on('db_conn'),
			}
		);

	};
	
	$s->add_sub_container($util_cntnr);
	
	return $s;
}

no Moose;

1;

