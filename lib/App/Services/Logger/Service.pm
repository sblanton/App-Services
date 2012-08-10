package App::Services::Logger::Service;

use Moose;

use Log::Log4perl;

has log_conf => (
	is  => 'rw',
	required => 1

);

has log_category => (
	is      => 'rw',
	isa     => 'Str',
	default => sub { ref( $_[0] ) },
	lazy    => 1,

);

has log => ( #-- The actual Log::Log4perl logger. Type?
	is      => 'rw',
	default => sub {
		$_[0]->log_category($_[0]->log_category);
		$_[0]->get_logger();
	},
);

sub BUILD {
	$_[0]->get_logger;
}

sub get_logger {

	my $s = shift or confess;
	my $category = shift;
	$category = $s->log_category unless $category;

	my $log_conf = $s->log_conf;

	unless ( $log_conf ) {
		confess("Log4perl conf is empty!");
	}

	unless ( Log::Log4perl->initialized() ) {
		Log::Log4perl->init( $log_conf );
	}

	my $log = Log::Log4perl->get_logger($category);
	$log->debug("Created logger for category '$category'");

	return $log;
}

no Moose;

1;

