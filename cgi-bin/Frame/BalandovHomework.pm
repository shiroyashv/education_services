#!/usr/bin/perl
package BalandovHomework;

use 5.010;
use strict;
use HTML::Template;
use Model::Homework;

sub new
{
  my $class = shift;

  bless {}, $class;
}

sub show_list
{
  my $this = shift;
  my $template = HTML::Template->new(filename => 'templates/homework_list.html');
  my $homework_list = Model::Homework->get_homework_list();

  # $template->param( MESSAGE => $this->{MESSAGE} );
  $template->param( HOMEWORK_LIST => $homework_list );
  print "Content-Type: text/html\n";
  print "Charset: windows-1251\n\n";
  print $template->output;
}

sub add
{
  my $this = shift;

  $this->{MESSAGE} = Model::Homework->add_homework();
  $this->show_list();
}

sub del
{
  my $this = shift;

  $this->{MESSAGE} = Model::Homework->delete_homework();
  $this->show_list();
}

1;
