#!/usr/bin/perl
use 5.010;
use strict;
BEGIN{unshift @INC, ("./", "./services", "./Frame")};
use DBHandle;
use singleton_cgi;
use HTML::Template;

eval
{
  # Подключение к БД
  my $dbh = DBHandle->new();
  $dbh = $dbh->connect_db();

  # Создаем объект класса и парсим параметры
  my $io_cgi = singleton_cgi->new();
  $io_cgi = $io_cgi->get_cgi_params();

  my $cl = $io_cgi->param('cl');
  my $event = $io_cgi->param('event');

  # Создаем объект класса и вызываем метод
  require $cl.'.pm';
  my $object = $cl->new();
  $object->$event();

  # Отключение от БД
  $dbh->disconnect();
};
if ($@)
{
  warn "Что-то пошло не так! " . $@;
}

