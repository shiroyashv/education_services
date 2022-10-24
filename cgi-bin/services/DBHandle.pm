#!/usr/bin/perl
package DBHandle;

use 5.010;
use strict;
use DBI;

my $singleton;

sub new
{
  my $class = shift;

  $singleton ||= bless {}, $class;
}

# Информация о БД
sub get_db_info
{
  my $db_info = {
    attr => {PrintError => 0, RaiseError => 0},
    data_source => "DBI:mysql:webprog4x27_tgbot:localhost",
    username => "webprog4x27_tgbot",
    password => "bAaAsH7KNtUFJprE",
  };

  return $db_info;
}

# Подключение к БД
sub connect_db
{
  my $this = shift;
  my $db_info = $this->get_db_info();
  my $attr = $db_info->{attr};
  my $data_source = $db_info->{data_source};
  my $username = $db_info->{username};
  my $password = $db_info->{password};

  $this->{dbh} ||= DBI->connect($data_source, $username, $password, $attr) or die $DBI::errstr;
  $this->{dbh}->do('SET NAMES cp1251');

  return $this->{dbh};
}

# Отключение от БД
sub disconnect_db
{
  my $this=shift;

  $this->{dbh}->disconnect();
}

1;
