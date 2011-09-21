package PLib::Roles::Logger;  #-- Log service interface

use Moose::Role;

has log_svc => (
        is       => 'rw',
        isa      => 'Project::Services::Log',
        required => 1,
);

has log => (
        is      => 'rw',
        default => sub {
                $_[0]->log_svc->log_category( ref( $_[0] ) );
                $_[0]->log_svc->get_logger();
        },

);

no Moose::Role;

1;

