package App::Services::Remote::Container;

use Moose;
use Bread::Board;

use App::Services::Logger::Container;

extends 'Bread::Board::Container';

sub BUILD {
	$_[0]->build_container;
}

has user => (
	is => 'rw',
	isa     => 'Str',
	default => sub { 'please supply a user' },
);

has password => (
	is      => 'rw',
	isa     => 'Str',
	default => sub { 'nopassword' },
);

has host_name => (
	is => 'rw',
	isa     => 'Str',
	default => sub { 'please supply a host_name' },
);

has log_conf => (
	is      => 'rw',
	default => sub { 'log4perl.conf' },
);

has +name => (
	is      => 'rw',
	isa     => 'Str',
	default => 'ssh_cntnr',
);

sub build_container {
	my $s = shift;

	my $log_cntnr = App::Services::Logger::Container->new(
		log_conf => $s->log_conf,
		name     => 'log'
	);

	container $s => as {

		service 'rem_password'  => $s->password;
		service 'host_name' => $s->host_name;
		service 'rem_user'      => $s->user;

		service 'ssh_conn_svc' => (
			class        => 'App::Services::Remote::Conn::Service',
			dependencies => {
				logger_svc   => depends_on('log/logger_svc'),
				host_name => 'host_name',
				rem_user      => 'rem_user',
				rem_password  => 'rem_password',

			}
		);

		service 'ssh_exec_svc' => (
			class        => 'App::Services::Remote::Exec::Service',
			dependencies => {
				logger_svc  => depends_on('log/logger_svc'),
				ssh_conn_svc => depends_on('ssh_conn_svc'),
			}
		);

	};

	$s->add_sub_container($log_cntnr);

	return $s;

}

no Moose;

1;
