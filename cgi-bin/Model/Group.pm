#!/usr/bin/perl
package Model::Group;

use 5.010;
use strict;
use Services::DBHandle;

sub new
{
  my $class = shift;
  my $dbh = Services::DBHandle->new();

  bless { dbh => $dbh->connect_db() }, $class;
}

# Возвращаем список групп из БД
sub get_group_list
{
  my $this = shift;

  my $sql = "SELECT id, title FROM webprog4x27_group_id ORDER BY id";
  my $group_list = $this->{dbh}->selectall_arrayref( $sql, { Slice => {} } );

  return $group_list;
}

# Добовляет группу в БД
sub add_group
{
  my ($this, $params) = @_;
  my $group_id = $params->{group_id};
  my $title = $params->{title};
  my $message;

  if ( is_group_exist( { this => $this, group_id => $group_id } ) )
  {
    $message = "Группа с таким id уже существует.";
  }
  elsif ( $group_id == 0 )
  {
    $message = "Нужно указать id группы.";
  }
  else
  {
    my $sth = $this->{dbh}->prepare("INSERT INTO webprog4x27_group_id SET id=?, title=?");
    $sth->execute($group_id, $title) or die $DBI::errstr;
    $sth->finish();
  }

  return $message;
}

# Удаляет группу из БД
sub delete_group
{
  my ($this, $params) = @_;
  my $group_id = $params->{group_id};
  my $message;

  if ( is_group_exist( { this => $this, group_id => $group_id } ) )
  {
    my $sth = $this->{dbh}->prepare("DELETE FROM `webprog4x27_group_id` WHERE id=?");
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
  my ($params) = @_;
  my $this = $params->{this};
  my $group_id = $params->{group_id};

  my $sth = $this->{dbh}->prepare("SELECT id FROM webprog4x27_group_id WHERE id=?");
  $sth->execute($group_id) or die $DBI::errstr;

  return 1 if $sth->fetchrow_array();
  return 0;
}

1;
