#!/usr/bin/perl
package BalandovEvaluation;

use 5.010;
use strict;
use HTML::Template;
use Model::Evaluation;

sub new
{
  my $class = shift;

  bless {}, $class;
}

sub show_list
{
  my $this = shift;
  my $template = HTML::Template->new(filename => 'templates/evaluation_list.html');
  my $evaluation_list = Model::Evaluation->get_evaluation_list();

  $template->param( EVALUATION_LIST => $evaluation_list );
  print "Content-Type: text/html\n";
  print "Charset: windows-1251\n\n";
  print $template->output;
}

1;
