package App::Services::DBS::Exec::Role;  #-- Log service interface

use Moose::Role;

has db_exec_svc => (
 is => 'ro',
 isa => 'App::Services::DBS::Exec::Service',
 handles => 'App::Services::DBS::Exec::Service',
 required => 1,
);

no Moose::Role;

1;