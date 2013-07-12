package App::Services::Remote::Conn::Role;  #-- Log service interface

use Moose::Role;

has ssh_svc => (
	is       => 'rw',
	isa      => 'Chopper::Service::SSH',
	handles  => [qw(ssh host_name rem_user rem_password)],
	
	required => 1,
);

no Moose::Role;

1;
