package App::Services::Logger::Service;

use Moo;

use common::sense;

use Log::Log4perl;

#-- If log_conf is a reference, Log::Log4perl interprets the reference as a string containing conf info
#-- if it contains a scalar, Log::Log4perl interprets the scalar as a file name

has log_conf => (
	is => 'rw',

);

has log_category => (
	is      => 'rw',
	default => sub { ref( $_[0] ) },
	lazy    => 1,

);

has log => (    #-- The actual Log::Log4perl logger. Type?
	is      => 'rw',
	default => sub {
		$_[0]->log_category( ref($_[0]) );
		$_[0]->get_logger();
	},
	lazy => 1,
);

sub get_logger {

	my $s = shift or die;
	my $category = shift;

	$category = $s->log_category unless $category;

	my $log_conf = $s->log_conf;

	unless ($log_conf) {
		die("Log4perl conf is empty!");
	}

	unless ( Log::Log4perl->initialized() ) {
		Log::Log4perl->init($log_conf);
	}

	my $log = Log::Log4perl->get_logger($category);
	$log->debug("Created logger for category '$category'");

	return $log;
}

no Moo;

1;

