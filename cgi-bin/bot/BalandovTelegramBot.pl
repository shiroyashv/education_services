use 5.010;

use strict;
use utf8;

require './WebProgTelegramClient.pm';

my $token = $TOKEN;

my $tg = WebProgTelegramClient->new(token => $token);

say "Бот запущен";

my @greeting = ('Приветствую', 'Здравствуй', 'Добро пожалвать');
my @goodbye = ('Желаем удачи', 'Пока', 'Еще увидимся', 'Береги себя');

my $text;
my $offset;
my $update_id;

while (1)
{
  # Получаем все обновления
  my $updates = $tg->call('getUpdates', { offset => $offset });

  # Если обновлений нет, начинаем сначала
  unless ( scalar @{ $updates->{result} } ) { sleep 5; next; }

  # Если обновления есть, обрабатываем полученный массив
  for my $update ( @{ $updates->{result} } )
  {
    my $chat_id = $update->{message}->{chat}->{id};

    # Если к чату присоеденился новый пользователь, шлем приветственное сообщение
    if ( my $user = $update->{message}->{new_chat_member} )
    {
      $user = $user->{first_name};
      $text = $greeting[rand @greeting] . ", " . $user . "!";
      $tg->call('sendMessage', { chat_id => $chat_id, text => $text });
    }
    # Если пользователь вышел из чата, шлем прощальное сообщение
    elsif ( my $user = $update->{message}->{left_chat_member} )
    {
      $user = $user->{first_name};
      $text = $goodbye[rand @goodbye] . ", " . $user . "!";
      $tg->call('sendMessage', { chat_id => $chat_id, text => $text });
    }

    $update_id = $update->{update_id};
    sleep 5;
  }

  $offset = $update_id + 1;
}
