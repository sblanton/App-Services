package App::Services::Email::Service;

use Moo;
use MooX::Types::MooseLike::Base qw/:all/;

use common::sense;
use Carp qw(confess);

with 'App::Services::Logger::Role';

use Net::SMTP;

has msg => (
	is       => 'rw',
	isa      => Str,
	required => 1,

);

has recipients => (
	is       => 'rw',
	isa      => ArrayRef [Str],
	required => 1,
);

has timeout => (
	is      => 'rw',
	isa     => Int,
	default => sub { 60 },
);

has mailhost => (
	is       => 'rw',
	isa      => Str,
	required => 1,
);

has from => (
	is      => 'rw',
	isa     => Str,
	required => 1,
);

has subject => (
	is      => 'rw',
	isa     => Str,
	required => 1,
);

sub send {
	my $s = shift or confess;
	
	my $smtp = Net::SMTP->new(
		Host => $s->mailhost,
		Debug => 1
	);

	$smtp->mail( $s->from );
	$smtp->to(join( ',', @{ $s->recipients } ));

	$smtp->data();
	$smtp->datasend( "To: " . join( ',', @{ $s->recipients } ) . "\n" );
	$smtp->datasend( "Subject: " . $s->subject . "\n");
	$smtp->datasend("\n");
	$smtp->datasend( $s->msg );

	$smtp->dataend();

	$smtp->quit;

}

no Moo;

1;
