package App::Services::DB::Conn::Role;  #-- Log service interface

use Moo::Role;

has db_conn_svc => (
 is => 'rw',
 isa => sub { ref eq 'App::Services::Service::DB_Conn' },
 handles => ['dbh'],
 required => 1,
); #--- handles => didn't work here for some reason

no Moo::Role;

1;
