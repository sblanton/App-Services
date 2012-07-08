package App::Services::Container::SSH;

use Moose;
use Bread::Board;

extends 'Bread::Board::Container';

sub BUILD {
	$_[0]->build_container;
}


has +name => (
	is      => 'rw',
	isa     => 'Str',
	default => 'plib_ssh_svc',
);

sub build_container {
	my $s = shift;

	return container $s => as {

		service 'ssh_conn' => (
			class        => 'App::Services::Services::SSH_Conn',
			dependencies => {
				log_svc   => depends_on('log_svc'),
				host_name => 'host_name',
			}
		);

		service 'ssh_exec' => (
			class        => 'App::Services::Services::SSH_Exec',
			dependencies => {
				log_svc  => depends_on('log_svc'),
				ssh_conn => depends_on('ssh_conn'),
			}
		);
	}
}

no Moose;

1;

