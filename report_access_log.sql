CREATE DATABASE  IF NOT EXISTS `rest_db` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `rest_db`;

DROP TABLE IF EXISTS `report_access_log`;
CREATE TABLE `report_access_log` (
 `id` varchar(255) NOT NULL,
 `report_name` varchar (64),
 `parameters` varchar (256),
 `user_name` varchar (64),
 `generated_timestamp` date
 PRIMARY KEY (`id`)
);
