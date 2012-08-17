package App::Services::Forker::Container;

use Moo;

use common::sense;

use Bread::Board;

extends 'Bread::Board::Container';

use App::Services::Logger::Container;

sub BUILD {
	$_[0]->build_container;
}

has log_conf => (
	is      => 'rw',
	default => sub { 'log4perl.conf' },
);

has child_objects => (
	is     => 'rw',
	isa    => sub { ref($_[0]) eq 'ARRAY' },
	required => 1,

);

has child_actions => (
	is       => 'rw',
	isa      => sub { ref( $_[0] ) eq 'CODE' },
	required => 1,
);

has +name => (
	is  => 'rw',
	default => sub { 'forker' },
);

sub build_container {
	my $s = shift;

	my $log_cntnr = App::Services::Logger::Container->new(
		log_conf => $s->log_conf,
		name     => 'log'
	);

	container $s => as {

		service child_objects => $s->child_objects;
		service child_actions => $s->child_actions;

		service 'forker_svc' => (
			class        => 'App::Services::Forker::Service',
			dependencies => {
				logger_svc    => depends_on('log/logger_svc'),
				child_objects => 'child_objects',
				child_actions => 'child_actions'
			},
		);

	};

	$s->add_sub_container($log_cntnr);

	return $s;
}

no Moo;

1;

