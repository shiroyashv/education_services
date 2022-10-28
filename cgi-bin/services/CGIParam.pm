#!/usr/bin/perl
package Services::CGIParam;

use 5.010;
use strict;
require "./Services/io_cgi.pl";

my $singleton;

sub new
{
  my $class = shift;

  $singleton ||= bless { io_cgi => 'io_cgi'->new() }, $class;
}

sub get_cgi_param
{
  unless ( defined $singleton->{io_cgi}->{param} )
  {
    $singleton->{io_cgi}->get_params();
  }
  return $singleton->{io_cgi}->{param};
}

1;
