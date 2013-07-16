package App::Services::Remote::Exec::Service;

use Moose;

with 'App::Services::Logger::Role';
with 'App::Services::Remote::Conn::Role';

has cmd => (
	is  => 'rw',
	isa => 'Maybe[Str]',

	#required => 1,
);

sub exec {
	my $s   = shift or confess;
	my $cmd = shift or $s->cmd;

	my $log       = $s->log;
	my $ssh       = $s->ssh;
	my $host_name = $s->ssh_svc->host_name;

	$ssh or $log->logconfess("$host_name: No ssh objects exists");

	$log->debug("$host_name: exec(): Executing '$cmd'");

	my ( @out, @err ) = $ssh->capture2($cmd);

	if ( @err or ( $ssh->error and $! ) ) {
		$log->error("$host_name: Problem executing '$cmd': $!");
		$log->error($_) for @err;
		return undef;    #-- the actual 'exec'
	}

	return @out;         #--- need a better way to handle errors. Prob need a callback function to interpret the output text.

}

sub exec_open{
	my $s   = shift or confess;
	my $cmd = shift or $s->cmd;

	open my $console_stdout, '>&STDOUT' or die;    #-- save stdout file descriptor
	close STDOUT;  

	my $log       = $s->log;
	my $host_name = $s->ssh_svc->host_name;
	my $user      = $s->ssh_svc->user;

	$cmd = "ssh -qtt -l $user $host_name '$cmd'";

	$log->debug("$host_name: Executing '$cmd'");

	my @out = `$cmd`;

	if ($!) {
		$log->error("$host_name: Problem executing '$cmd': $!");

		#$log->error($_) for @err;
		return undef;                                #-- the actual 'exec'
	}

	open STDOUT, ">&", \$console_stdout;

	return @out;                                     #--- need a better way to handle errors. Prob need a callback function to interpret the output text.

}

sub exec_tty {
	my $s   = shift or confess;
	my $cmd = shift or $s->cmd;

	my $log       = $s->log;
	my $host_name = $s->ssh_svc->host_name;
	my $user      = $s->ssh_svc->user;

	$cmd = "ssh -qtt -l $user $host_name '$cmd'";

	$log->debug("$host_name: Executing '$cmd'");

	my @out = `$cmd`;

	if ($!) {
		$log->error("$host_name: Problem executing '$cmd': $!");

		#$log->error($_) for @err;
		return undef;                                #-- the actual 'exec'
	}

	return @out;                                     #--- need a better way to handle errors. Prob need a callback function to interpret the output text.

}

sub read_file {
	my $s = shift or confess;

	my $log = $s->log;
	my $filename = shift or logconfess();

	my $host_name = $s->ssh_svc->host_name;
	my $user = $s->ssh_svc->user;

	my $rc = 0;
	my $cmd = "ssh $user\@$host_name cat '$filename'";

	my @out = `$cmd`;

	if ($? == -1) {
		$s->log->error("failed to execute: $!");
		$rc = 1;

	} elsif ($? & 127) {
		$s->log->error(printf("child died with signal %d, %s coredump", ($? & 127),  ($? & 128) ? 'with' : 'without'));
		$rc = 1;

	}

	return @out if @out;
	return undef if $rc;
	return 1;

}

sub write_file {
	my $s = shift or confess;

	my $log      = $s->log;
	my $filename = shift or $log->logconfess();
	my @content  = @_ or $log->logconfess("No file content specfied. Zero byte file would be created, but I failed instead.");

	my $ssh       = $s->ssh;
	my $host_name = $s->ssh_svc->host_name;

	my ( $in, $pid ) = $ssh->pipe_in("cat > $filename");

	my $content = join '', @content;
	$content .= "\n" unless $content =~ /\n$/;    #-- ensure there is a trailing carriage return

	print $in "$content";

	if ( $ssh->error and $! ) {
		$log->error("$host_name: Problem writing to '$filename': $!");
		return undef;
	}

	return 1;

}

sub put_file {
	my $s = shift or confess;

	my $log         = $s->log;
	my $local_file  = shift or logconfess();
	my $remote_name = shift or logconfess();

	my $ssh       = $s->ssh;
	my $host_name = $s->ssh_svc->host_name;

	my $rc = $ssh->scp_put( $local_file, $remote_name );

	if ( $ssh->error or not defined $rc ) {
		$log->error("$host_name: Problem sending '$local_file' to '$remote_name': $!");
		return undef;

	} else {
		$log->info("Copied '$local_file' to '${host_name}:$remote_name'");

	}

	return 1;

}

sub get_file {
	my $s = shift or confess;

	my $log         = $s->log;
	my $remote_name = shift or $s->log->logconfess();
	my $local_file  = shift or $s->log->logconfess();

	my $ssh       = $s->ssh;
	my $host_name = $s->ssh_svc->host_name;

	unless ($ssh) {
		$log->warn("$host_name: Exec_SSH->get_file: No SSH object exists");
		return undef;
	}

	my $rc = $ssh->scp_get( $remote_name, $local_file );

	if ( $ssh->error or not defined $rc ) {
		$log->error( "$host_name: SSH Error: " . $ssh->error );
		$log->error("$host_name: Problem getting '$remote_name' and/or writing to '$local_file': $!");
		return undef;
	}

	return 1;

}

sub read_dir {
	my $s = shift or confess;

	my $log = $s->log;
	my $dirname = shift or logconfess();

	my $pattern = shift // '*'; #/

	my $ssh       = $s->ssh;
	my $host_name = $s->ssh_svc->host_name;

	my $sftp = $s->ssh->sftp();
	my $dir  = $sftp->setcwd($dirname);

	if ( $sftp->error and $! ) {
		$log->error("$host_name: Problem changing directory to '$dirname': $!");
		return undef;
	}

	my @dir_entries = $sftp->glob( $pattern, names_only => 1 );

	if ( $sftp->error and $! ) {
		$log->error("$host_name: Problem reading '$dirname': $!");
		return undef;
	}

	return @dir_entries;

}

no Moose;

1;
