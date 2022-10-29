use 5.010;

use DBI;
use strict;
use Encode qw(decode encode);
use Services::DBHandle;

require './WebProgTelegramClient.pm';

my $dbh = Services::DBHandle->new();

my $token = $TOKEN;
my $tg = WebProgTelegramClient->new(token => $token);

# Получаем список всех групп из БД
my $groups = $dbh->selectall_arrayref("SELECT * FROM webprog4x27_group");

my $group_updates = [];
my $offset = 0;

# Получаем обновления для всех групп
for my $group ( @{$groups} )
{
  my $chat_id = $group->[0];
  my $admin_id = $group->[1];
  my $updates = $tg->read_chat(chat_id => $chat_id);
  my $group_info = {
    chat_id => $chat_id,
    updates => $updates,
    admin_id => $admin_id,
  };
  push @{$group_updates}, $group_info;
}

# Обрабатываем полученные обновления
for my $group ( @{$group_updates} )
{
  my $updates = $group->{updates};
  my $group_id = $group->{chat_id};

  for my $update ( @{$updates} )
  {
    $offset = $update->{update_id} + 1 if $update->{update_id} >= $offset;

    # Добавляем новых участников в БД
    if ( my $user = $update->{message}->{new_chat_member} )
    {
      my $id = $user->{id};
      my $name = encode('cp1251', $user->{first_name});
      my $sth = $dbh->prepare("INSERT INTO webprog4x27_student (id, name, group_id) VALUES (?, ?, ?)");
      $sth->execute($id, $name, $group_id) or die $DBI::errstr;
    }

    # Удаляем участников из БД
    if ( my $user = $update->{message}->{left_chat_member} )
    {
      my $id = $user->{id};
      my $sth = $dbh->prepare("DELETE FROM webprog4x27_student WHERE id=?");
      $sth->execute($id) or die $DBI::errstr;
    }
  }
}

$tg->call('getUpdates', { offset => $offset });

$dbh->disconnect();
