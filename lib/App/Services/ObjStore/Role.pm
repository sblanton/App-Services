package App::Services::ObjStore::Role;    #-- Log service interface

use Moose::Role;

use common::sense;

has obj_store_svc => (
	is       => 'rw',
	isa      => 'App::Services::ObjStore::Service',
	handles  => [qw(all_objects)],
	required => 1,

);

no Moose::Role;

1;
