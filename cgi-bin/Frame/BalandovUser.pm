#!/usr/bin/perl
package BalandovUser;

use 5.010;
use strict;
use HTML::Template;
use Model::User;
use Model::Group;
use Services::CGIParam;

sub new
{
  my $class = shift;
  my $cgi = Services::CGIParam->new();

  bless { cgi_params => $cgi->get_cgi_param() }, $class;
}

sub show_list
{
  my $this = shift;

  my $params = {
    group_id => $this->{cgi_params}->{group_id},
  };

  my $model_user = Model::User->new();
  my $model_group = Model::Group->new();
  my $user_list = $model_user->get_user_list($params);
  my $group_list = $model_group->get_group_list();

  my $template = HTML::Template->new( filename => 'templates/user_list.html' );

  $template->param( user_list => $user_list,
                    group_list => $group_list,
                    message => $this->{message} );
  print "Content-Type: text/html\n";
  print "Charset: windows-1251\n\n";
  print $template->output;
}

sub add
{
  my $this = shift;

  my $params = {
    user_id => $this->{cgi_params}->{user_id},
    first_name => $this->{cgi_params}->{first_name},
    group_id => $this->{cgi_params}->{group_id},
  };

  my $model_user = Model::User->new();

  $this->{message} = $model_user->add_user($params);
  $this->show_list();
}

sub del
{
  my $this = shift;

  my $params = {
    user_id => $this->{cgi_params}->{user_id},
  };

  my $model_user = Model::User->new();

  $this->{message} = $model_user->delete_user($params);
  $this->show_list();
}

1;
