#!/usr/bin/perl
package Model::User;

use 5.010;
use strict;
use DBHandle;
use singleton_cgi;

# ����������� � ��
my $dbh = DBHandle->new();
$dbh = $dbh->connect_db();

# ������� ������ ������ � ������ ���������
my $io_cgi = singleton_cgi->new();
$io_cgi = $io_cgi->get_cgi_params();

my $user_id = $io_cgi->param('user_id');
my $group_id = $io_cgi->param('group_id');
my $first_name = $io_cgi->param('first_name');


# ���������� ������ ������������� �� ��
sub get_user_list
{
  my $sth;
  if ($group_id)
  {
    $sth = $dbh->prepare("SELECT id, first_name, total_score FROM webprog4x27_student
                          WHERE group_id=? ORDER BY first_name");
    $sth->execute($group_id) or die $DBI::errstr;
  }
  else
  {
    $sth = $dbh->prepare("SELECT id, first_name, total_score FROM webprog4x27_student
                          ORDER BY first_name");
    $sth->execute() or die $DBI::errstr;
  }
  my $user_list = [];

  while ( my @row = $sth->fetchrow_array() )
  {
    my ($id, $first_name, $total_score ) = @row;
    push @{$user_list}, { ID => $id, FIRST_NAME => $first_name, TOTAL_SCORE => $total_score };
  }
  $sth->finish();
  return $user_list;
}

# ��������� ������������ � ��
sub add_user
{
  my $message;

  if ( is_user_exist($user_id) )
  {
    $message = "������������ � ����� id ��� ����������.";
  }
  elsif ( $user_id == 0 )
  {
    $message = "����� ������� id ������������.";
  }
  else
  {
    my $sth = $dbh->prepare("INSERT INTO webprog4x27_student SET id=?, first_name=?, group_id=?");
    $sth->execute($user_id, $first_name, $group_id) or die $DBI::errstr;
    $sth->finish();
  }
  return $message;
}

# ������� ������������ �� ��
sub delete_user
{
  my $message;

  if ( is_user_exist($user_id) )
  {
    my $sth = $dbh->prepare("DELETE FROM webprog4x27_student WHERE id=?");
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
  my $sth = $dbh->prepare("SELECT id FROM webprog4x27_student WHERE id=?");
  $sth->execute($user_id) or die $DBI::errstr;
  return 1 if $sth->fetchrow_array();
  return 0;
}

1;
