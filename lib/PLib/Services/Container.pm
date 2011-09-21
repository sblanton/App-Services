package PLib::Services::Container;

use Moose;
use Bread::Board;

extends 'Bread::Board::Container';

sub BUILD {
        $_[0]->build_container;
}

has host_name => (
	is => 'rw',
	isa => 'Str',
	default => '0.0.0.1',
);

has dsn => (
	is => 'rw',
	isa => 'Str',
	default => 'mydatabase',
);

has db_user => (
	is => 'rw',
	isa => 'Str',
	default => 'king',
);

has db_password => (
	is => 'rw',
	isa => 'Str',
	default => 'kong',
);

has +name => (
        is      => 'rw',
        isa     => 'Str',
        default => 'svc',
);

sub build_container {
        my $s = shift;

        return container $s => as {

                service 'dsn' => $s->host_name;
                service 'db_user' => $s->db_user;
                service 'db_password' => $s->db_password;

                service 'host_name' => $s->host_name;

                service 'logger_svc' => (
                        class     => 'PLib::Services::Logger',
                        lifecycle => 'Singleton',
                );

                service 'db_conn' => (    #-- raw DBI database handle
                        class        => 'PLib::Services::DB_Conn',
                        dependencies => {
				log_svc => depends_on('log_svc'),
				dsn => 'dsn',
				db_user => 'db_user',
				db_password=> 'db_password',
			}
                );

                service 'db_exec' => (
                        class        => 'PLib::Services::DB_Exec',
                        dependencies => {
				log_svc => depends_on('log_svc'),
				db_conn => depends_on('db_conn'),
			}
                );

                service 'ssh_conn' => (
                        class        => 'PLib::Services::SSH_Conn',
                        dependencies => {
				log_svc => depends_on('log_svc'),
				host_name => 'host_name',
			}
                );

                service 'ssh_exec' => (
                        class        => 'PLib::Services::SSH_Exec',
                        dependencies => {
				log_svc => depends_on('log_svc'),
				ssh_conn => depends_on('ssh_conn'),
			}
                );
	}
}

no Moose;

1;

