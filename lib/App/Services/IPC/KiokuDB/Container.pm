package App::Services::ObjStore::Container;

use Moose;

use common::sense;

#use MooX::Types::MooseLike::Base;

use Bread::Board;

extends 'Bread::Board::Container';

use App::Services::Logger::Container;

sub BUILD {
	$_[0]->build_container;
}

has log_conf => (
	is      => 'rw',
	default => sub {
		\qq/ 
log4perl.rootLogger=INFO, main
log4perl.appender.main=Log::Log4perl::Appender::Screen
log4perl.appender.main.layout   = Log::Log4perl::Layout::SimpleLayout
/;
	},
);

has obj_store_file => (
	is      => 'rw',
	default => "/tmp/.app-services-obj-store-$$.db",

);

has +name => (
	is => 'rw',

	#	isa     => 'Str',
	default => sub { 'obj_store' },
);

sub build_container {
	my $s = shift;

	my $log_cntnr = App::Services::Logger::Container->new(
		log_conf => $s->log_conf,
		name     => 'log'
	);

	container $s => as {

		service 'obj_store_file' => $s->obj_store_file;

		service 'obj_store_svc' => (
			class        => 'App::Services::ObjStore::Service',
			dependencies => {
				logger_svc     => depends_on('log/logger_svc'),
				obj_store_file => 'obj_store_file',
			}
		);

	};

	$s->add_sub_container($log_cntnr);

	return $s;
}

no Moose;

1;

