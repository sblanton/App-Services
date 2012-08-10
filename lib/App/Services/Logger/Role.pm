package App::Services::Logger::Role;    #-- Log service interface

use Moose::Role;

sub BUILD {
	$_[0]->logger_svc->log_category( ref( $_[0] ) );

}

has logger_svc => (
	is       => 'rw',
	isa      => 'App::Services::Logger::Service',
	handles  => 'App::Services::Logger::Service',
	required => 1,
);

no Moose::Role;

1;

