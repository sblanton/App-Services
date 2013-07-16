package App::Services::Remote::Exec::Role;  #-- interface

use Moose::Role;

has exec_ssh => (
	is       => 'rw',
	isa      => 'Chopper::Service::Exec_SSH',
	handles => qw(ssh),
	required => 1,
);

no Moose::Role;

1;
