#!/usr/bin/perl
package BalandovUser;

use 5.010;
use strict;
use HTML::Template;
use Model::User;
use Model::Group;

sub new
{
  my $class = shift;

  bless {}, $class;
}

sub show_list
{
  my $this = shift;
  my $template = HTML::Template->new(filename => 'templates/user_list.html');
  my $user_list = Model::User->get_user_list();
  my $group_list = Model::Group->get_group_list();

  $template->param( MESSAGE => $this->{MESSAGE} );
  $template->param( GROUP_LIST => $group_list );
  $template->param( USER_LIST => $user_list );
  print "Content-Type: text/html\n";
  print "Charset: windows-1251\n\n";
  print $template->output;
}

sub add
{
  my $this = shift;

  $this->{MESSAGE} = Model::User->add_user();
  $this->show_list();
}

sub del
{
  my $this = shift;

  $this->{MESSAGE} = Model::User->delete_user();
  $this->show_list();
}

1;
