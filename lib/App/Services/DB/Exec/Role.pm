package App::Services::DB::Exec::Role;  #-- Log service interface

use Moo::Role;

has db_exec_svc => (
 is => 'ro',
 isa => sub { ref($_[0]) eq 'App::Services::DB::Exec::Service' },
 handles => ['App::Services::DB::Exec::Service'],
 required => 1,
);

no Moo::Role;

1;