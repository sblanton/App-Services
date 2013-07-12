package App::Services::Remote::Conn::Service;

use Moose;

use Net::OpenSSH;

#$Net::OpenSSH::debug |= 16;

with 'App::Services::Logger::Role';

has ssh => (
	is      => 'rw',
	isa     => 'Maybe[Net::OpenSSH]',
	default => \&ssh_builder,
	lazy    => 1,
);

has host_name => (
	is  => 'rw',
	isa => 'Maybe[Str]',
);

has host_ip => (
	is  => 'rw',
	isa => 'Maybe[Str]',
);

has rem_user => (
	is      => 'rw',
	isa     => 'Str',
	default => 'king'
);

has rem_password => (
	is      => 'rw',
	isa     => 'Str',
	default => 'kong'
);

sub trace {
	my $s         = shift;
	my $trace_val = shift;

	$s->ssh->trace($trace_val);
}

sub debug {
	my $s         = shift;
	my $trace_val = shift;

	$s->ssh->trace($trace_val);
}

has rem_host => (
	is      => 'rw',
	default => sub {
		my $s = shift;
		my $rem_host;

		if ( exists $s->{host_ip} ) {
			$rem_host = $s->host_ip ? $s->host_ip : $s->host_name;

		} elsif ( $s->host_name ) {
			$rem_host = $s->host_name;

		} else {
			$s->log->fatal("No host name defined for SSH");
			return undef;

		}

		chomp($rem_host);    #-- cleanup if needed
		$rem_host =~ s/\s//g;

		return undef unless $rem_host;

		return $rem_host;
	},
	lazy => 1,
);

sub ssh_builder {

	#-- Tries to return an authenticated, connected ssh obj
	#-- or a connected one, or just an ssh obj according to how much info is available

	my $s = shift or confess;

	my $log = $s->log;

	my %env_vars = ( PATH => '/sbin:/usr/bin', );

	my $ssh = Net::OpenSSH->new(
		$s->rem_host,
		user  => $s->user,
		vars  => \%env_vars,
		async => 1,
	);

	my $host_name = $s->host_name;

	if ( $ssh->error ) {
		$s->log->warn("$host_name: Failed to create Net::OpenSSH object: $!");
		return undef;
	}

	return $ssh;
}

sub reconnect {
	my $s = shift or confess;
	$s->ssh( $s->ssh_builder );
}

no Moose;

1;
