package App::Services::Forker::Role;    #-- Log service interface

use Moo::Role;

use common::sense;

has forker_svc => (
	is       => 'rw',
	isa      => sub { ref($_[0]) eq 'App::Services::Forker::Service' },
	handles  => [qw(forker)],
	required => 1,

);

no Moo::Role;

1;
