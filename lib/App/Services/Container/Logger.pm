package App::Services::Container::Logger;

use Moose;
use Bread::Board;

extends 'Bread::Board::Container';

sub BUILD {
	$_[0]->build_container;
}

has log_conf => (
	is      => 'rw',
	isa     => 'Str',
	default => qq/ 
log4perl.rootLogger=INFO, main

log4perl.appender.main=Log::Log4perl::Appender::File
log4perl.appender.main.filename=app_services.log
log4perl.appender.main.layout   = Log::Log4perl::Layout::SimpleLayout
/,
);

has +name => (
	is      => 'rw',
	isa     => 'Str',
	default => 'logger_svc',
);

sub build_container {
	my $s = shift;

	return container $s => as {

		service 'log_conf' => $s->log_conf;

		service 'logger_svc' => (
			class        => 'App::Services::Service::Logger',
			lifecycle    => 'Singleton',
			dependencies => [ log_conf => 'log_conf' ]

		);

	}
}

no Moose;

1;

