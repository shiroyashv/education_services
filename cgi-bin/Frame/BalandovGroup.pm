#!/usr/bin/perl
package BalandovGroup;

use 5.010;
use strict;
use HTML::Template;
use Model::Group;

sub new
{
  my $class = shift;

  bless {}, $class;
}

sub show_list
{
  my $this = shift;
  my $template = HTML::Template->new(filename => 'templates/group_list.html');
  my $group_list = Model::Group->get_group_list();

  $template->param( MESSAGE => $this->{MESSAGE} );
  $template->param( GROUP_LIST => $group_list );
  print "Content-Type: text/html\n";
  print "Charset: windows-1251\n\n";
  print $template->output;
}

sub add
{
  my $this = shift;

  $this->{MESSAGE} = Model::Group->add_group();
  $this->show_list();
}

sub del
{
  my $this = shift;

  $this->{MESSAGE} = Model::Group->delete_group();
  $this->show_list();
}

1;
