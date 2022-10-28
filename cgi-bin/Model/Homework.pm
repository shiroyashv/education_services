#!/usr/bin/perl
package Model::Homework;

use 5.010;
use strict;
use Services::DBHandle;

sub new
{
  my $class = shift;
  my $dbh = Services::DBHandle->new();

  bless { dbh => $dbh->connect_db() }, $class;
}

# Возвращаем список заданий из БД
sub get_homework_list
{
  my $this = shift;

  my $sql = "SELECT number, title, description, max_score, deadline
             FROM webprog4x27_homework ORDER BY number";
  my $homework_list = $this->{dbh}->selectall_arrayref( $sql, { Slice => {} } );

  return $homework_list;
}

# Добовляет задание в БД
sub add_homework
{
  my ($this, $params) = @_;
  my $number = $params->{number};
  my $title = $params->{title};
  my $description = $params->{description};
  my $max_score = $params->{max_score};
  my $deadline = $params->{deadline};
  my $message;

  if ( is_homework_exist( { this => $this, number => $number } ) )
  {
    $message = "Задание с таким номером уже существует.";
  }
  elsif ( $number == 0 )
  {
    $message = "Нужно указать номер задания.";
  }
  else
  {
    my $sth = $this->{dbh}->prepare("INSERT INTO webprog4x27_homework
                                     SET number=?, title=?, description=?, max_score=?, deadline=?");
    $sth->execute( $number, $title, $description, $max_score, $deadline ) or die $DBI::errstr;
    $sth->finish();
  }

  return $message;
}

# Удаляет задание из БД
sub delete_homework
{
  my ($this, $params) = @_;
  my $number = $params->{number};
  my $message;

  if ( is_homework_exist( { this => $this, number => $number } ) )
  {
    my $sth = $this->{dbh}->prepare("DELETE FROM `webprog4x27_homework` WHERE number=?");
    $sth->execute($number) or die $DBI::errstr;
    $sth->finish();
  }
  else
  {
    $message = "Группа уже удалена.";
  }

  return $message;
}

# Проверяет есть ли задание в БД
sub is_homework_exist
{
  my ($params) = @_;
  my $this = $params->{this};
  my $number = $params->{number};

  my $sth = $this->{dbh}->prepare("SELECT id FROM webprog4x27_homework WHERE number=?");
  $sth->execute($number) or die $DBI::errstr;

  return 1 if $sth->fetchrow_array();
  return 0;
}

1;

