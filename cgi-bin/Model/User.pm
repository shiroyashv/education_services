#!/usr/bin/perl
package Model::User;

use 5.010;
use strict;
use Services::DBHandle;

sub new
{
  my $class = shift;
  my $dbh = Services::DBHandle->new();

  bless { dbh => $dbh->connect_db() }, $class;
}

# ���������� ������ ������������� �� ��
sub get_user_list
{
  my ($this, $params) = @_;
  my $group_id = $params->{group_id};
  my $user_list;

  if ( $group_id == 0 || !defined $group_id)
  {
    my $sql = "SELECT id, first_name, total_score FROM webprog4x27_student
               ORDER BY first_name";
    $user_list = $this->{dbh}->selectall_arrayref( $sql, { Slice => {} } );
  }
  else
  {
    my $sql = "SELECT id, first_name, total_score FROM webprog4x27_student
               WHERE group_id=? ORDER BY first_name";
    $user_list = $this->{dbh}->selectall_arrayref( $sql, { Slice => {} }, $group_id );
  }

  return $user_list;
}

# ��������� ������������ � ��
sub add_user
{
  my ($this, $params) = @_;
  my $user_id = $params->{user_id};
  my $first_name = $params->{first_name};
  my $group_id = $params->{group_id};
  my $message;

  if ( is_user_exist( { this => $this, user_id => $user_id } ) )
  {
    $message = "������������ � ����� id ��� ����������.";
  }
  elsif ( $user_id == 0 )
  {
    $message = "����� ������� id ������������.";
  }
  else
  {
    my $sth = $this->{dbh}->prepare("INSERT INTO webprog4x27_student SET id=?, first_name=?, group_id=?");
    $sth->execute( $user_id, $first_name, $group_id ) or die $DBI::errstr;
    $sth->finish();
  }

  return $message;
}

# ������� ������������ �� ��
sub delete_user
{
  my ($this, $params) = @_;
  my $user_id = $params->{user_id};
  my $message;

  if ( is_user_exist( { this => $this, user_id => $user_id } ) )
  {
    my $sth = $this->{dbh}->prepare("DELETE FROM webprog4x27_student WHERE id=?");
    $sth->execute($user_id) or die $DBI::errstr;
    $sth->finish();
  }
  else
  {
    $message = "������������ ��� ������.";
  }

  return $message;
}

# ��������� ���� �� ������������ � ��
sub is_user_exist
{
  my ($params) = @_;
  my $this = $params->{this};
  my $user_id = $params->{user_id};

  my $sth = $this->{dbh}->prepare("SELECT id FROM webprog4x27_student WHERE id=?");
  $sth->execute($user_id) or die $DBI::errstr;

  return 1 if $sth->fetchrow_array();
  return 0;
}

1;
