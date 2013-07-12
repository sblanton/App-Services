package App::Services::Logger::Role;    #-- Log service interface

use Moo::Role;

use common::sense;
use Carp qw(confess);

has logger_svc => (
	is       => 'rw',
	isa      => 'App::Services::Logger::Service',
	handles  => [qw(log log_category log_conf)],
	required => 1,

);

has log_label => (
	is => 'rw',
	default => sub{ '' },
);

sub log_prefix { $_[0]->log_label ? '' : $_[0]->log_label . ' ' }

sub li {
	my $s = shift or confess;
	my $msg = shift or $s->log->logwarn();
	
	$s->log->info($s->log_prefix . $msg);
}
 
sub le {
	my $s = shift or confess;
	my $msg = shift or $s->log->logwarn();
	
	$s->log->error($s->log_prefix . $msg);
}
 
sub lw {
	my $s = shift or confess;
	my $msg = shift or $s->log->logwarn();
	
	$s->log->warn($s->log_prefix . $msg);
}
 
sub ld {
	my $s = shift or confess;
	my $msg = shift or $s->log->logwarn();
	
	$s->log->debug($s->log_prefix .  $msg);
}

no Moo::Role;

1;
