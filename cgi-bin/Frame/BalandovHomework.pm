#!/usr/bin/perl
package BalandovHomework;

use 5.010;
use strict;
use HTML::Template;
use Model::Homework;
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

  my $model_homework = Model::Homework->new();
  my $homework_list = $model_homework->get_homework_list();

  my $template = HTML::Template->new( filename => 'templates/homework_list.html' );

  $template->param( homework_list => $homework_list,
                    message => $this->{message} );
  print "Content-Type: text/html\n";
  print "Charset: windows-1251\n\n";
  print $template->output;
}

sub add
{
  my $this = shift;

  my $params = {
    number => $this->{cgi_params}->{number},
    title => $this->{cgi_params}->{title},
    description => $this->{cgi_params}->{description},
    max_score => $this->{cgi_params}->{max_score},
    deadline => $this->{cgi_params}->{deadline},
  };

  my $model_homework = Model::Homework->new();

  $this->{message} = $model_homework->add_homework($params);
  $this->show_list();
}

sub del
{
  my $this = shift;

  my $params = {
    number => $this->{cgi_params}->{number},
  };

  my $model_homework = Model::Homework->new();

  $this->{message} = $model_homework->delete_homework($params);
  $this->show_list();
}

1;
