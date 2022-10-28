#!/usr/bin/perl
package Model::Evaluation;

use 5.010;
use strict;
use Services::DBHandle;

sub new
{
  my $class = shift;
  my $dbh = Services::DBHandle->new();

  bless { dbh => $dbh->connect_db() }, $class;
}

# Возвращаем список оценок из БД
sub get_evaluation_list
{
  my ($this, $params) = @_;
  my $group_id = $params->{group_id};
  my $evaluation_list;

  if ( $group_id == 0 || !defined $group_id)
  {
    my $sql = "SELECT homework_id, title, student_id, first_name, score
               FROM webprog4x27_evaluation AS e JOIN webprog4x27_homework AS h
               ON e.homework_id = h.id JOIN webprog4x27_student AS s
               ON e.student_id = s.id ORDER BY homework_id";
    $evaluation_list = $this->{dbh}->selectall_arrayref( $sql, { Slice => {} } );
  }
  else
  {
    my $sql = "SELECT homework_id, title, student_id, first_name, score
               FROM webprog4x27_evaluation AS e JOIN webprog4x27_homework AS h
               ON e.homework_id = h.id JOIN webprog4x27_student AS s
               ON e.student_id = s.id WHERE e.group_id=? ORDER BY homework_id";
    $evaluation_list = $this->{dbh}->selectall_arrayref( $sql, { Slice => {} }, $group_id );
  }


  return $evaluation_list;
}

1;
