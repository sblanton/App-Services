package App::Services::Role::Logger;    #-- Log service interface

use Moose::Role;

sub BUILD {
	$_[0]->logger_svc->log_category( ref( $_[0] ) );
	
}

has logger_svc => (
	is       => 'rw',
	isa      => 'App::Services::Service::Logger',
	handles => [qw( log log_category)],
	required => 1,
);

no Moose::Role;

1;

