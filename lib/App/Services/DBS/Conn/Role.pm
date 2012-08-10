package App::Services::DBS::DB_Conn::Role;  #-- Log service interface

use Moose::Role;

has db_conn_svc => (
 is => 'rw',
 isa => 'App::Services::Service::DB_Conn',
 handles => ['dbh'],
 required => 1,
);

no Moose::Role;

1;