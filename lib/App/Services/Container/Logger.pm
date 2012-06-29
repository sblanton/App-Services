package PLib::Container::Logger;

use Moose;
use Bread::Board;

extends 'Bread::Board::Container';

sub BUILD {
	$_[0]->build_container;
}

has log_conf => (
	is  => 'rw',
	isa => 'Str',
);

has +name => (
	is      => 'rw',
	isa     => 'Str',
	default => 'plib_util_svc',
);

sub build_container {
	my $s = shift;

	return container $s => as {

		service 'log_conf' => $s->log_conf;

		service 'logger_svc' => (
			class        => 'PLib::Service::Logger',
			lifecycle    => 'Singleton',
			dependencies => [ log_conf => 'log_conf' ]

		);

	}
}

no Moose;

1;

