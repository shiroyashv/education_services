#!/usr/bin/perl
package Services::DBHandle;

use 5.010;
use strict;
use DBI;

my $singleton;

sub new
{
  my $class = shift;

  $singleton ||= bless {}, $class;
}

# Подключение к БД
sub connect_db
{
  my $attr = {PrintError => 0, RaiseError => 0};
  my $data_source = $DATA_SOURCE;
  my $username = $USERNAME;
  my $password = $PASSWORD;

  $singleton->{dbh} ||= DBI->connect($data_source, $username, $password, $attr) or die $DBI::errstr;
  $singleton->{dbh}->do('SET NAMES cp1251');
  return $singleton->{dbh};
}

sub disconnect_db
{
  $singleton->{dbh}->disconnect();
}

1;
