#!/usr/bin/perl
package Model::Homework;

use 5.010;
use strict;
use DBHandle;
use singleton_cgi;

# ����������� � ��
my $dbh = DBHandle->new();
$dbh = $dbh->connect_db();

# ������� ������ ������ � ������ ��� ���������
my $io_cgi = singleton_cgi->new();
$io_cgi = $io_cgi->get_cgi_params();

my $number = $io_cgi->param('number');
my $title = $io_cgi->param('title');
my $description = $io_cgi->param('description');
my $max_score = $io_cgi->param('max_score');
my $deadline = $io_cgi->param('deadline');

# ���������� ������ ������� �� ��
sub get_homework_list
{
  my $sth = $dbh->prepare("SELECT number, title, description, max_score, deadline
                           FROM webprog4x27_homework ORDER BY number");
  $sth->execute() or die $DBI::errstr;

  my $homework_list = [];

  while ( my @row = $sth->fetchrow_array() )
  {
    my ($number, $title, $description, $max_score, $deadline) = @row;
    my $homewok_info = {
      NUMBER => $number,
      TITLE => $title,
      DESCRIPTION => $description,
      MAX_SCORE => $max_score,
      DEADLINE => $deadline,
    };
    push @{$homework_list}, $homewok_info;
  }
  $sth->finish();
  return $homework_list;
}

# ��������� ������� � ��
sub add_homework
{
  my $message;

  if ( is_homework_exist($number) )
  {
    $message = "������� � ����� ������� ��� ����������.";
  }
  elsif ( $number == 0 )
  {
    $message = "����� ������� ����� �������.";
  }
  else
  {
    my $sth = $dbh->prepare("INSERT INTO webprog4x27_homework
                             SET number=?, title=?, description=?, max_score=?, deadline=?");
    $sth->execute($number, $title, $description, $max_score, $deadline) or die $DBI::errstr;
    $sth->finish();
  }
  return $message;
}

# ������� ������� �� ��
sub delete_homework
{
  my $message;

  if ( is_homework_exist($number) )
  {
    my $sth = $dbh->prepare("DELETE FROM `webprog4x27_homework` WHERE number=?");
    $sth->execute($number) or die $DBI::errstr;
    $sth->finish();
  }
  else
  {
    $message = "������ ��� �������.";
  }
  return $message;
}

# ��������� ���� �� ������� � ��
sub is_homework_exist
{
  my $sth = $dbh->prepare("SELECT id FROM webprog4x27_homework WHERE number=?");
  $sth->execute($number) or die $DBI::errstr;
  return 1 if $sth->fetchrow_array();
  return 0;
}

1;

