package App::Services::Logger::Role;    #-- Log service interface

use Moo::Role;

use common::sense;

has logger_svc => (
	is       => 'rw',
	isa      => sub { ref eq 'App::Services::Logger::Service' },
	handles  => [qw(log log_category log_conf)],
	required => 1,

);

no Moo::Role;

1;
