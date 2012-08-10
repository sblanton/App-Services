package App::Services::DB::DB_Conn::Role;  #-- Log service interface

use Moo::Role;

has db_conn_svc => (
 is => 'rw',
 isa => sub { ref eq 'App::Services::Service::DB_Conn' },
 handles => ['dbh'],
 required => 1,
);

no Moo::Role;

1;