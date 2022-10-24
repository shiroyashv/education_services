#!/usr/bin/perl
package Model::Group;

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

my $group_id = $io_cgi->param('group_id');
my $title = $io_cgi->param('title');

# Возвращаем список групп из БД
sub get_group_list
{
  my $sth = $dbh->prepare("SELECT id, title FROM webprog4x27_group_id ORDER BY id");
  $sth->execute() or die $DBI::errstr;

  my $group_list = [];

  while ( my @row = $sth->fetchrow_array() )
  {
    my ($id, $title) = @row;
    push @{$group_list}, { ID => $id, TITLE => $title };
  }
  $sth->finish();
  return $group_list;
}

# Добовляет группу в БД
sub add_group
{
  my $message;

  if ( is_group_exist($group_id) )
  {
    $message = "Группа с таким id уже существует.";
  }
  elsif ( $group_id == 0 )
  {
    $message = "Нужно указать id группы.";
  }
  else
  {
    my $sth = $dbh->prepare("INSERT INTO webprog4x27_group_id SET id=?, title=?");
    $sth->execute($group_id, $title) or die $DBI::errstr;
    $sth->finish();
  }
  return $message;
}

# Удаляет группу из БД
sub delete_group
{
  my $message;

  if ( is_group_exist($group_id) )
  {
    my $sth = $dbh->prepare("DELETE FROM `webprog4x27_group_id` WHERE id=?");
    $sth->execute($group_id) or die $DBI::errstr;
    $sth->finish();
  }
  else
  {
    $message = "Группа уже удалена.";
  }
  return $message;
}

# Проверяет есть ли группа в БД
sub is_group_exist
{
  my $sth = $dbh->prepare("SELECT id FROM webprog4x27_group_id WHERE id=?");
  $sth->execute($group_id) or die $DBI::errstr;
  return 1 if $sth->fetchrow_array();
  return 0;
}

1;
