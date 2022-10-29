-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Хост: localhost:3306
-- Время создания: Окт 29 2022 г., 15:33
-- Версия сервера: 10.6.7-MariaDB-1:10.6.7+maria~bullseye
-- Версия PHP: 8.1.3

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- База данных: `webprog4x27_tgbot`
--

-- --------------------------------------------------------

--
-- Структура таблицы `webprog4x27_admin`
--

CREATE TABLE `webprog4x27_admin` (
  `id` int(11) NOT NULL COMMENT 'id пользователя в telegram',
  `first_name` varchar(32) NOT NULL COMMENT 'Имя',
  `last_name` varchar(32) NOT NULL COMMENT 'Фамилия',
  `username` varchar(32) NOT NULL COMMENT 'username пользователя в telegram',
  `group_id` int(11) NOT NULL COMMENT 'id telegram группы в которой состоит пользователь'
) ENGINE=InnoDB DEFAULT CHARSET=cp1251 COMMENT='Таблица администраторов';

--
-- Дамп данных таблицы `webprog4x27_admin`
--

INSERT INTO `webprog4x27_admin` (`id`, `first_name`, `last_name`, `username`, `group_id`) VALUES
(268398730, 'Сергей', '', '', -861114071);

-- --------------------------------------------------------

--
-- Структура таблицы `webprog4x27_evaluation`
--

CREATE TABLE `webprog4x27_evaluation` (
  `id` int(11) NOT NULL COMMENT 'id',
  `homework_id` int(11) NOT NULL COMMENT 'id задания',
  `student_id` int(11) NOT NULL COMMENT 'id студента выполнившего задание',
  `group_id` int(11) NOT NULL COMMENT 'id группы telegram',
  `score` int(2) NOT NULL COMMENT 'Оценка за задание'
) ENGINE=InnoDB DEFAULT CHARSET=cp1251 COMMENT='Таблица оценивания заданий';

--
-- Дамп данных таблицы `webprog4x27_evaluation`
--

INSERT INTO `webprog4x27_evaluation` (`id`, `homework_id`, `student_id`, `group_id`, `score`) VALUES
(3, 1, 2147483647, -861114071, 10),
(4, 1, 31474836, -861114071, 9),
(5, 2, 31474836, -861114071, 13),
(6, 1, 124214124, -861114071, 6),
(7, 2, 2147483647, -861114071, 15);

-- --------------------------------------------------------

--
-- Структура таблицы `webprog4x27_group_id`
--

CREATE TABLE `webprog4x27_group_id` (
  `id` int(11) NOT NULL COMMENT 'id telegram группы',
  `title` varchar(32) NOT NULL COMMENT 'название telegram группы'
) ENGINE=InnoDB DEFAULT CHARSET=cp1251 COMMENT='Таблица telegram групп';

--
-- Дамп данных таблицы `webprog4x27_group_id`
--

INSERT INTO `webprog4x27_group_id` (`id`, `title`) VALUES
(-861114071, 'test');

-- --------------------------------------------------------

--
-- Структура таблицы `webprog4x27_homework`
--

CREATE TABLE `webprog4x27_homework` (
  `id` int(11) NOT NULL COMMENT 'id',
  `title` varchar(64) NOT NULL COMMENT 'Название задания',
  `description` text NOT NULL COMMENT 'Описание задания',
  `number` int(3) NOT NULL COMMENT 'Номер задания',
  `max_score` int(2) NOT NULL COMMENT 'Максимальный балл',
  `deadline` datetime NOT NULL COMMENT 'Крайний срок сдачи '
) ENGINE=InnoDB DEFAULT CHARSET=cp1251 COMMENT='Таблица домашних заданий';

--
-- Дамп данных таблицы `webprog4x27_homework`
--

INSERT INTO `webprog4x27_homework` (`id`, `title`, `description`, `number`, `max_score`, `deadline`) VALUES
(1, 'Телеграм бот', 'Скрипт на сервере, который при запуске читает содержимое групп, где состоит. Если находит, что в группу написал кто-то новый, то отвечает ему “Привет, <User>!”. Если находит, что из группы кто-то вышел, то пишет в группу “Желаем удачи, <User>!”', 1, 10, '2022-10-07 10:00:00'),
(2, 'Создать и поработать с БД MySQL \r\n\r\n', 'Есть группы Telegram для обучения. В каждой группе есть администратор и участники. Участники группы делают домашние задания и присылают их в чат с хештегом #дз<номер домашнего задания>. Администратор группы проставляет баллы за выполнение каждого домашнего задания. Для каждого дз есть сроки сдачи и максимальный балл. Если учащийся сдает ДЗ в срок, он получает максимальный балл по нему. Администратор может скорректировать балл за ДЗ. Администратор должен видеть общий балл участников и просматривать всю историю сдачи дз и баллов по ним.\r\n', 2, 15, '2022-10-11 10:00:00');

-- --------------------------------------------------------

--
-- Структура таблицы `webprog4x27_student`
--

CREATE TABLE `webprog4x27_student` (
  `id` int(11) NOT NULL COMMENT 'id пользователя в telegram',
  `first_name` varchar(32) NOT NULL COMMENT 'Имя',
  `last_name` varchar(32) NOT NULL,
  `username` varchar(32) NOT NULL,
  `total_score` int(3) NOT NULL COMMENT 'Общий балл',
  `group_id` int(11) NOT NULL COMMENT 'id telegram группы в которой состоит пользователь'
) ENGINE=InnoDB DEFAULT CHARSET=cp1251 COMMENT='Таблица студентов';

--
-- Дамп данных таблицы `webprog4x27_student`
--

INSERT INTO `webprog4x27_student` (`id`, `first_name`, `last_name`, `username`, `total_score`, `group_id`) VALUES
(31474836, 'Мария', '', '', 22, -861114071),
(124214124, 'Анатолий', '', '', 6, -861114071),
(2147483647, 'Сергей', '', '', 25, -861114071);

--
-- Индексы сохранённых таблиц
--

--
-- Индексы таблицы `webprog4x27_admin`
--
ALTER TABLE `webprog4x27_admin`
  ADD PRIMARY KEY (`id`),
  ADD KEY `group_id` (`group_id`),
  ADD KEY `username` (`username`),
  ADD KEY `first_name` (`first_name`,`last_name`);

--
-- Индексы таблицы `webprog4x27_evaluation`
--
ALTER TABLE `webprog4x27_evaluation`
  ADD PRIMARY KEY (`id`),
  ADD KEY `homework_id` (`student_id`,`homework_id`) USING BTREE;

--
-- Индексы таблицы `webprog4x27_group_id`
--
ALTER TABLE `webprog4x27_group_id`
  ADD PRIMARY KEY (`id`),
  ADD KEY `title` (`title`);

--
-- Индексы таблицы `webprog4x27_homework`
--
ALTER TABLE `webprog4x27_homework`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `number` (`number`),
  ADD KEY `title` (`title`);

--
-- Индексы таблицы `webprog4x27_student`
--
ALTER TABLE `webprog4x27_student`
  ADD PRIMARY KEY (`id`),
  ADD KEY `webprog4x27_student_ibfk_1` (`group_id`),
  ADD KEY `first_name` (`first_name`,`last_name`),
  ADD KEY `username` (`username`);

--
-- AUTO_INCREMENT для сохранённых таблиц
--

--
-- AUTO_INCREMENT для таблицы `webprog4x27_evaluation`
--
ALTER TABLE `webprog4x27_evaluation`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id', AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT для таблицы `webprog4x27_homework`
--
ALTER TABLE `webprog4x27_homework`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id', AUTO_INCREMENT=6;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
