-- phpMyAdmin SQL Dump
-- version 4.8.3
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: May 10, 2020 at 07:59 PM
-- Server version: 10.1.37-MariaDB
-- PHP Version: 7.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `laravel`
--

-- --------------------------------------------------------

--
-- Table structure for table `fixtures`
--

CREATE TABLE `fixtures` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `team1_id` int(11) NOT NULL,
  `team2_id` int(11) NOT NULL,
  `date_time` datetime NOT NULL,
  `venue_location` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `completed` int(11) NOT NULL,
  `winning_team_id` int(11) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `fixtures`
--

INSERT INTO `fixtures` (`id`, `team1_id`, `team2_id`, `date_time`, `venue_location`, `completed`, `winning_team_id`, `created_at`, `updated_at`) VALUES
(1, 1, 2, '2020-05-11 05:00:00', 'Chennai', 1, 1, NULL, '2020-05-10 07:53:01'),
(2, 2, 1, '2020-05-20 00:00:00', 'Pune', 1, 1, '2020-05-10 04:54:17', '2020-05-10 07:53:11');

-- --------------------------------------------------------

--
-- Table structure for table `players`
--

CREATE TABLE `players` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `team_id` int(11) NOT NULL,
  `firstName` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `lastName` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `imageUri` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `Playerjerseynumber` varchar(11) COLLATE utf8mb4_unicode_ci NOT NULL,
  `country` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `matches` varchar(11) COLLATE utf8mb4_unicode_ci NOT NULL,
  `run` varchar(11) COLLATE utf8mb4_unicode_ci NOT NULL,
  `highestscores` varchar(11) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fifties` varchar(11) COLLATE utf8mb4_unicode_ci NOT NULL,
  `hundreds` varchar(11) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `players`
--

INSERT INTO `players` (`id`, `team_id`, `firstName`, `lastName`, `imageUri`, `Playerjerseynumber`, `country`, `matches`, `run`, `highestscores`, `fifties`, `hundreds`, `created_at`, `updated_at`) VALUES
(1, 2, 'Rohit', 'Sharma', 'player/Oo20h4Cy4bNZWlYGaa.jpeg', '10', 'IN', '200', '10000', '252', '25', '25', '2020-05-09 19:12:13', '2020-05-10 02:50:46'),
(3, 2, 'Virat', 'Kohli', 'player/BDaJeVuWQl1oUmNfsg.jpeg', '1', 'IN', '200', '12000', '186', '45', '37', '2020-05-09 19:53:02', '2020-05-09 20:10:02'),
(5, 1, 'David', 'Warner', 'player/bTjFqAzBGH8Dkzl0qe.jpeg', '12', 'AUS', '200', '12000', '186', '50', '12', '2020-05-09 20:08:31', '2020-05-10 03:36:12');

-- --------------------------------------------------------

--
-- Table structure for table `points`
--

CREATE TABLE `points` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `team_id` int(11) NOT NULL,
  `matches_win` int(11) NOT NULL,
  `matches_lost` int(11) NOT NULL,
  `points` int(11) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `points`
--

INSERT INTO `points` (`id`, `team_id`, `matches_win`, `matches_lost`, `points`, `created_at`, `updated_at`) VALUES
(1, 1, 1, 0, 2, '2020-05-10 07:53:01', '2020-05-10 07:53:01'),
(2, 2, 0, 1, 0, '2020-05-10 07:53:01', '2020-05-10 07:53:01'),
(3, 2, 0, 1, 0, '2020-05-10 07:53:11', '2020-05-10 07:53:11'),
(4, 1, 1, 0, 2, '2020-05-10 07:53:12', '2020-05-10 07:53:12');

-- --------------------------------------------------------

--
-- Table structure for table `teams`
--

CREATE TABLE `teams` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `logoUri` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `clubstate` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `teams`
--

INSERT INTO `teams` (`id`, `name`, `logoUri`, `clubstate`, `created_at`, `updated_at`) VALUES
(1, 'Delhi Capitals', 'images/qaXFCmvOhVNcCL1qbx.jpeg', 'Delhi', '2020-05-09 08:47:20', '2020-05-09 09:12:13'),
(2, 'Chennai Super King', 'images/0uzVADCGVVpSDC1yRk.jpeg', 'Chennai', '2020-05-09 09:13:22', '2020-05-09 09:13:22');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `api_token` varchar(80) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `password` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `remember_token` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `name`, `email`, `email_verified_at`, `api_token`, `password`, `remember_token`, `created_at`, `updated_at`) VALUES
(1, 'ramesh', 'admin@admin.com', NULL, '$2y$10$BRyNQIz.hKYZgZRUTaM32OIY3HjnDfwlTFaZ.MeC6a96tUt5zCM7i', 'e10adc3949ba59abbe56e057f20f883e', NULL, NULL, '2020-05-08 23:37:46');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `fixtures`
--
ALTER TABLE `fixtures`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `players`
--
ALTER TABLE `players`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `points`
--
ALTER TABLE `points`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `teams`
--
ALTER TABLE `teams`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `teams_name_unique` (`name`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `users_email_unique` (`email`),
  ADD UNIQUE KEY `users_api_token_unique` (`api_token`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `fixtures`
--
ALTER TABLE `fixtures`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `players`
--
ALTER TABLE `players`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `points`
--
ALTER TABLE `points`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `teams`
--
ALTER TABLE `teams`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
