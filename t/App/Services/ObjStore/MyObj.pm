package MyObj;

use Moo;

use common::sense;

has foo => ( is => 'rw' );
has bar => ( is => 'rw' );

no Moo;

1;