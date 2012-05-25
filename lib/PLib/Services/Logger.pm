package PLib::Services::Logger;

use Moose;

use Log::Log4perl;

has log_conf => (
 is => 'rw',
 isa => 'Str',
 default => "log4perl.conf",
);

has log_category => (
 is => 'rw',
 isa => 'Str',
 default => sub { ref($_[0]) },
 lazy => 1,
);

sub BUILD {
	$_[0]->get_logger;
}

sub get_logger {
	
	my $s = shift or confess;
	my $category = shift;
	$category = $s->log_category unless $category;

	Log::Log4perl::init_once($s->log_conf_file);

	my $log = Log::Log4perl->get_logger($category);
	$log->debug("Created logger for category '$category'");

	return $log;
}

sub get_log_filename {
	require POSIX;
	my $date = POSIX::strftime( "%Y%m%d", localtime );
	return "app_${date}.log"

}

no Moose;

1;

