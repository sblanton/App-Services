package PLib::Services::Logger;

use Moose;

use Log::Log4perl;

has log_category => (
 is => 'rw',
 default => '',
);
 
has log => ( #-- The actual Log::Log4perl logger. Type?
	is      => 'rw',
	default => sub { $_[0]->log_category(ref($_[0])); $_[0]->get_logger() },
);


has log_conf_file => (
 is => 'rw',
 isa => 'Str',
 default => "$ENV{Project_HOME}/ProjectConfig/etc/logs/Generic.conf",
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

