#!/usr/bin/perl
use 5.010;
use strict;
BEGIN{unshift @INC, ("./", "./services", "./Frame")};
use DBHandle;
use singleton_cgi;
use HTML::Template;

eval
{
  # ����������� � ��
  my $dbh = DBHandle->new();
  $dbh = $dbh->connect_db();

  # ������� ������ ������ � ������ ���������
  my $io_cgi = singleton_cgi->new();
  $io_cgi = $io_cgi->get_cgi_params();

  my $cl = $io_cgi->param('cl');
  my $event = $io_cgi->param('event');

  # ������� ������ ������ � �������� �����
  require $cl.'.pm';
  my $object = $cl->new();
  $object->$event();

  # ���������� �� ��
  $dbh->disconnect();
};
if ($@)
{
  warn "���-�� ����� �� ���! " . $@;
}

