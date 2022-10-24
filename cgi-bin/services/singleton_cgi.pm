#!/usr/bin/perl
package singleton_cgi;

use 5.010;
use strict;
require "./services/io_cgi.pl";

my $singleton;

sub new
{
  my $class = shift;

  $singleton ||= bless {}, $class;
}

sub get_cgi_params
{
  my $this = shift;

  if ($this->{io_cgi})
  {
    $this->{io_cgi}
  }
  else
  {
    $this->{io_cgi} = 'io_cgi'->new;
    $this->{io_cgi}->get_params();
    return $this->{io_cgi};
  }

}

1;
