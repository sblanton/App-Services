package App::Services::Role::DB_Conn;  #-- Log service interface

use Moose::Role;

has db_svc => (
 is => 'rw',
 isa => 'App::Services::Service::DB_Conn',
 required => 1,
);

has dbh => (
	is      => 'rw',
	default => sub { $_[0]->db_svc->dbh },
	lazy => 1,
);

no Moose::Role;

1;