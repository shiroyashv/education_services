#!/usr/bin/perl
use 5.010;
use strict;
BEGIN{unshift @INC, "./"};
use HTML::Template;
use Services::DBHandle;
use Services::CGIParam;

eval
{
  # Подключение к БД
  my $dbh = Services::DBHandle->new();
  $dbh->connect_db();

  # Создаем объект класса и парсим параметры
  my $cgi = Services::CGIParam->new();
  my $cl = $cgi->get_cgi_param()->{cl};
  my $event = $cgi->get_cgi_param()->{event};

  # Создаем объект класса и вызываем метод
  require './Frame/' . $cl . '.pm';
  my $object = $cl->new();
  $object->$event();

  # Отключение от БД
  $dbh->disconnect_db();
};
if ($@)
{
  print "Content-Type: text/html\n";
  print "Charset: windows-1251\n\n";
  print "Что-то пошло не так... " . $@;
}
