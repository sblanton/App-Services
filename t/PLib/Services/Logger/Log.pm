package Log;

use DateTime;

sub get_log_conf {

my $log_file_name = get_log_file_name();
	
my $log_conf = q/ 
log4j.rootLogger=INFO, stdout, Logfile

log4j.appender.stdout=org.apache.log4j.ConsoleAppender
log4j.appender.stdout.layout=org.apache.log4j.PatternLayout
log4j.appender.stdout.layout.ConversionPattern=%-6p| %m%n

log4j.appender.main=org.apache.log4j.RollingFileAppender
log4j.appender.main.File=$log_file_name
log4j.appender.main.layout=org.apache.log4j.PatternLayout
log4j.appender.main.layout.ConversionPattern=%d (%08r) | %-5p - %-40m{chomp}  (%c:%L)%n
/;

}


sub get_log_file_name {
	return "t_" . DateTime->now->strftime('%Y_%m_d') . ".log"
}

1;