package App::Services::Logger::Role;    #-- Log service interface

use Moose::Role;

use common::sense;

has logger_svc => (
	is       => 'rw',
	isa      => 'App::Services::Logger::Service',
	handles  => [qw(log log_category log_conf)],
	required => 1,

);

no Moose::Role;

1;
