#!/usr/bin/perl
package BalandovGroup;

use 5.010;
use strict;
use HTML::Template;
use Model::Group;
use Services::CGIParam;

sub new
{
  my $class = shift;
  my $cgi = Services::CGIParam->new();

  bless { _cgi_params => $cgi->get_cgi_param() }, $class;
}

sub show_list
{
  my $this = shift;

  my $model_group = Model::Group->new();
  my $group_list = $model_group->get_group_list();

  my $template = HTML::Template->new( filename => 'templates/group_list.html' );

  $template->param( group_list => $group_list,
                    message => $this->{message} );
  print "Content-Type: text/html\n";
  print "Charset: windows-1251\n\n";
  print $template->output;
}

sub add
{
  my $this = shift;

  my $params = {
    group_id => $this->{_cgi_params}->{group_id},
    title => $this->{_cgi_params}->{title},
  };

  my $model_group = Model::Group->new();

  $this->{message} = $model_group->add_group($params);
  $this->show_list();
}

sub del
{
  my $this = shift;

  my $params = {
    group_id => $this->{_cgi_params}->{group_id},
  };

  my $model_group = Model::Group->new();

  $this->{message} = $model_group->delete_group($params);
  $this->show_list();
}

1;
