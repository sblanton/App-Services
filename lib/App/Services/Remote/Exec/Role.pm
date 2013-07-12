package App::Services::Remote::Exec::Role;  #-- interface

use Moose::Role;

has exec_ssh => (
	is       => 'rw',
	isa      => 'Chopper::Service::Exec_SSH',
	required => 1,
);

has ssh => (
	is      => 'rw',
	isa     => 'Maybe[Net::OpenSSH]',
	default => sub {
		$_[0]->exec_ssh->ssh;
	},
	lazy => 1,
);

no Moose::Role;

1;
