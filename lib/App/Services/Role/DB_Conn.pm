package App::Services::Role::DB_Conn;  #-- Log service interface

use Moose::Role;

has db_svc => (
 is => 'rw',
 isa => 'App::Services::Service::DB_Conn',
 handles => ['dbh'],
 required => 1,
);

no Moose::Role;

1;