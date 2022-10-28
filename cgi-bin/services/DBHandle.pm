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
  my $data_source = "DBI:mysql:webprog4x27_tgbot:localhost";
  my $username = "webprog4x27_tgbot";
  my $password = "bAaAsH7KNtUFJprE";

  $singleton->{dbh} ||= DBI->connect($data_source, $username, $password, $attr) or die $DBI::errstr;
  $singleton->{dbh}->do('SET NAMES cp1251');
  return $singleton->{dbh};
}

sub disconnect_db
{
  $singleton->{dbh}->disconnect();
}

1;
