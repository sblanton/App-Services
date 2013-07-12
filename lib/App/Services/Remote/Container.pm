package App::Services::Remote::Container;

use Moose;
use Bread::Board;

extends 'Bread::Board::Container';

sub BUILD {
	$_[0]->build_container;
}

has user => (
	is => 'rw',

	#	isa     => 'Str',
	default => sub { 'please supply a user' },
);

has password => (
	is      => 'rw',
	default => sub { '' },
);

has host_name => (
	is => 'rw',

	#	isa     => 'Str',
	default => sub { 'please supply a host_name' },
);

has log_conf => (
	is      => 'rw',
	default => sub { 'log4perl.conf' },
);

has +name => (
	is      => 'rw',
	isa     => 'Str',
	default => 'ssh_svc',
);

sub build_container {
	my $s = shift;

	my $log_cntnr = App::Services::Logger::Container->new(
		log_conf => $s->log_conf,
		name     => 'log'
	);

	service 'host_name' => $s->host_name;
	service 'user'      => $s->user;
	service 'password'  => $s->password;

	container $s => as {

		service 'ssh_conn' => (
			class        => 'App::Services::Remote::Conn::Service',
			dependencies => {
				log_svc   => depends_on('log_svc'),
				host_name => 'host_name',
				user      => 'user',
				password  => 'password',

			}
		);

		service 'ssh_exec' => (
			class        => 'App::Services::Remote::Exec::Service',
			dependencies => {
				log_svc  => depends_on('log_svc'),
				ssh_conn => depends_on('ssh_conn'),
			}
		);

	};

	$s->add_sub_container($log_cntnr);

	return $s;

}

no Moose;

1;
