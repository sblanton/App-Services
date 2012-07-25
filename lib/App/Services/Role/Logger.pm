package App::Services::Role::Logger;  #-- Log service interface

use Moose::Role;

has log_svc => (
        is       => 'rw',
        isa      => 'App::Services::Service::Logger',
        required => 1,
);

has log_category => (
 is => 'rw',
 isa => 'Str',
 default => sub { ref($_[0]) },
 lazy => 1,
);

has log => ( #-- The actual Log::Log4perl logger. Type?
	is      => 'rw',
	default => sub {
		$_[0]->log_svc->log_category($_[0]->log_category);
		$_[0]->log_svc->get_logger();
	},
);

no Moose::Role;

1;

