package PLib::Services::Util_Container;

use Moose;
use Bread::Board;

extends 'Bread::Board::Container';

sub BUILD {
	$_[0]->build_container;
}

has log_conf_file => (
	is      => 'rw',
	isa     => 'Str',
	default => 'log4perl.conf',
);

has +name => (
	is      => 'rw',
	isa     => 'Str',
	default => 'plib_util_svc',
);

sub build_container {
	my $s = shift;

	return container $s => as {

		service 'log_conf_file' => $s->log_conf_file;

		service 'logger_svc' => (
			class         => 'PLib::Services::Logger',
			lifecycle     => 'Singleton',
			log_conf_file => 'log_conf_file'
		);

	}
}

no Moose;

1;

