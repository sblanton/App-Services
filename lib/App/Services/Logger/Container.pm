package App::Services::Logger::Container;

use Moo;
use Bread::Board;

extends 'Bread::Board::Container';

sub BUILD {
	$_[0]->build_container;
}

has log_conf => (
	is      => 'rw',
	default => sub { " 
log4perl.rootLogger=INFO, main
log4perl.appender.main=Log::Log4perl::Appender::Screen
log4perl.appender.main.layout   = Log::Log4perl::Layout::SimpleLayout
" },
);

has +name => (
	is      => 'rw',
	default => sub { 'logger' },
);

sub build_container {
	my $s = shift;

	return container $s => as {

		service 'log_conf' => $s->log_conf;

		service 'logger_svc' => (
			class        => 'App::Services::Logger::Service',
			lifecycle    => 'Singleton',
			dependencies => { log_conf => 'log_conf' },

		);

	};

}

no Moo;

1;

