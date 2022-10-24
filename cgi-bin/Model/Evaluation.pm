#!/usr/bin/perl
package Model::Evaluation;

use 5.010;
use strict;
use DBHandle;
use singleton_cgi;

# Подключение к БД
my $dbh = DBHandle->new();
$dbh = $dbh->connect_db();

# Создаем объект класса и парсим параметры
my $io_cgi = singleton_cgi->new();
$io_cgi = $io_cgi->get_cgi_params();

my $id = $io_cgi->param('id');

# Возвращаем список оценок из БД
sub get_evaluation_list
{
  my $sth;
  if ($id)
  {
    $sth = $dbh->prepare("SELECT homework_id, title, student_id, first_name, score
                             FROM webprog4x27_evaluation AS e JOIN webprog4x27_homework AS h
                             ON e.homework_id = h.id JOIN webprog4x27_student AS s
                             ON e.student_id = s.id WHERE e.group_id=? ORDER BY homework_id");
    $sth->execute($id) or die $DBI::errstr;
  }
  else
  {
    $sth = $dbh->prepare("SELECT homework_id, title, student_id, first_name, score
                             FROM webprog4x27_evaluation AS e JOIN webprog4x27_homework AS h
                             ON e.homework_id = h.id JOIN webprog4x27_student AS s
                             ON e.student_id = s.id ORDER BY homework_id");
    $sth->execute() or die $DBI::errstr;
  }
  my $evaluation_list = [];

  while ( my @row = $sth->fetchrow_array() )
  {
    my ($homework_id, $title, $student_id, $first_name, $score) = @row;
    my $evaluation_info = {
    HOMEWORK_ID => $homework_id,
    HOMEWORK_TITLE => $title,
    STUDENT_ID => $student_id,
    STUDENT_NAME => $first_name,
    SCORE => $score,
  };
    push @{$evaluation_list}, $evaluation_info;
  }
  $sth->finish();
  return $evaluation_list;
}

1;
