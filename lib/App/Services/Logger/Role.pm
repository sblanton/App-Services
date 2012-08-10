package App::Services::Logger::Role;    #-- Log service interface

use Moo::Role;

use common::sense;

sub _build_logger {
	$_[0]->logger_svc->log_category( ref( $_[0] ) );
	$_[0]->logger_svc->get_logger();

}

has logger_svc => (
	is       => 'rw',
	isa      => sub { ref eq 'App::Services::Logger::Service' },
	handles  => [qw(log log_category log_conf)],
	builder  => 1,
	required => 1,
);

no Moo::Role;

1;
