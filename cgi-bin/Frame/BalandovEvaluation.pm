#!/usr/bin/perl
package BalandovEvaluation;

use 5.010;
use strict;
use HTML::Template;
use Model::Evaluation;
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

  my $model_evaluation = Model::Evaluation->new();
  my $evaluation_list = $model_evaluation->get_evaluation_list($params);

  my $template = HTML::Template->new( filename => 'templates/evaluation_list.html' );

  $template->param( evaluation_list => $evaluation_list );
  print "Content-Type: text/html\n";
  print "Charset: windows-1251\n\n";
  print $template->output;
}

1;
