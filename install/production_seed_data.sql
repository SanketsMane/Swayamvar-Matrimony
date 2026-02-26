-- MySQL dump 10.13  Distrib 9.5.0, for macos26.1 (arm64)
--
-- Host: localhost    Database: matrimonial_local
-- ------------------------------------------------------
-- Server version	9.5.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- GTID state at the beginning of the backup 
--


--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `user_type` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'member',
  `role_id` int DEFAULT NULL,
  `code` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `membership` tinyint(1) DEFAULT '1' COMMENT '1-Free member,\r\n2-Premium member',
  `first_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `last_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `new_email_verificiation_code` text COLLATE utf8mb4_unicode_ci,
  `phone` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `verification_code` text COLLATE utf8mb4_unicode_ci,
  `password` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `provider_id` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `fcm_token` text COLLATE utf8mb4_unicode_ci,
  `photo` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `photo_approved` int NOT NULL DEFAULT '1',
  `remember_token` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `last_login_ip` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `last_login_at` timestamp NULL DEFAULT NULL,
  `blocked` tinyint(1) NOT NULL DEFAULT '0' COMMENT '1=blocked',
  `deactivated` tinyint(1) NOT NULL DEFAULT '0' COMMENT '0=active, 1=deactive',
  `permanently_delete` tinyint(1) NOT NULL DEFAULT '0',
  `approved` tinyint(1) DEFAULT '1' COMMENT '0=Pending\r\n1=Approved',
  `verification_info` longtext COLLATE utf8mb4_unicode_ci,
  `balance` double(20,0) NOT NULL DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `code` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=35 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'admin',NULL,NULL,1,'Admin','User',NULL,'admin@example.com','2026-02-17 05:36:45',NULL,NULL,NULL,'$2y$10$JYUi/xKpIJeOpXm9yds3G.ZAHOetS.2sj8IET2I/QMyj7SAQIZL3u',NULL,NULL,NULL,1,NULL,NULL,NULL,0,0,0,1,NULL,0,'2026-02-17 05:36:45','2026-02-17 05:36:45',NULL),(2,'admin',NULL,NULL,1,'Sanket','SuperAdmin',NULL,'contactsanket1@gmail.com','2026-02-17 06:45:58',NULL,NULL,NULL,'$2y$10$CTn01oSMJ4HocGm1O6SVD.W1TP8tHT4cVPS8ZR6HAxWiM9pEEtdZa',NULL,NULL,NULL,1,NULL,NULL,NULL,0,0,0,1,NULL,0,'2026-02-17 06:45:58','2026-02-17 06:45:58',NULL),(24,'member',NULL,'20260224',1,'Sanket','Mane',NULL,'contactsanket2@gmail.com','2026-02-17 11:32:13',NULL,NULL,'177989','$2y$10$MOv0PHhNKBl2kgh0RdtZl.QWlTSh9vH9I.odCTYF80qV5eR6eufGK',NULL,'d2dNn8A9Tsd9hwHN66tFt6:APA91bGzKfKhOKAMZRLv7LEiZofin1p5yVvLC1NbzrAEcZDVZJaDRln6Fce5-u2BpZyo9YiTAh8J5NFJte8tU0w3Obn5zfCm6fVbbm4sO64WTQZT4wmHVcM',NULL,1,NULL,NULL,NULL,0,0,0,0,NULL,0,'2026-02-17 12:15:08','2026-02-17 12:15:14',NULL),(25,'member',NULL,NULL,2,'Rahul','Deshmukh','Rahul Deshmukh','rahul@example.com','2026-02-17 12:35:13',NULL,NULL,NULL,'$2y$10$JwP2JZ75tpRZti6OZeR2rueuyX/4xacE6N0FR8HfZ239C3H8eOOry',NULL,NULL,'36',1,NULL,NULL,NULL,0,0,0,1,NULL,0,'2026-02-17 12:35:13','2026-02-17 12:37:36',NULL),(26,'member',NULL,NULL,1,'Snehal','Patil','Snehal Patil','snehal@example.com','2026-02-17 12:35:13',NULL,NULL,NULL,'$2y$10$gbHZYt1GXJUYEThhIq9wj.YnoemZknZR9yawKi08sdWvivoEd/DAi',NULL,NULL,'37',1,NULL,NULL,NULL,0,0,0,1,NULL,0,'2026-02-17 12:35:13','2026-02-17 12:35:13',NULL),(27,'member',NULL,NULL,1,'Prathamesh','Kulkarni','Prathamesh Kulkarni','prathamesh@example.com','2026-02-17 12:35:13',NULL,NULL,NULL,'$2y$10$tY9IQznO3tCud.1fhiHmmuqtDONA3e57PsKHCTVjHxxpbylMNl7k6',NULL,NULL,'38',1,NULL,NULL,NULL,0,0,0,1,NULL,0,'2026-02-17 12:35:13','2026-02-17 12:35:13',NULL),(28,'member',NULL,NULL,1,'Priyanka','More','Priyanka More','priyanka@example.com','2026-02-17 12:35:13',NULL,NULL,NULL,'$2y$10$hFxbb2q3o6SXcyyt12DR6OMxDthfjk1WLWfooOaBbXeMmzM0moR2m',NULL,NULL,'39',1,NULL,NULL,NULL,0,0,0,1,NULL,0,'2026-02-17 12:35:13','2026-02-17 12:35:13',NULL),(29,'member',NULL,NULL,1,'Sanket','Joshi','Sanket Joshi','sanket_m@example.com','2026-02-17 12:35:13',NULL,NULL,NULL,'$2y$10$B8mDYvXbl72SFYrLCJeOuOlvJHNmqZTRWWoa/c5Dlff9D/kUpiJj.',NULL,NULL,'40',1,NULL,NULL,NULL,0,0,0,1,NULL,0,'2026-02-17 12:35:13','2026-02-17 12:35:13',NULL),(30,'member',NULL,NULL,1,'Pratiksha','Shinde','Pratiksha Shinde','pratiksha@example.com','2026-02-17 12:35:13',NULL,NULL,NULL,'$2y$10$J6XBKdSS.XO39nSVNXYxWuQH/7hBh9sLz5n2g0M8ODIA6GPpD75k2',NULL,NULL,'41',1,NULL,NULL,NULL,0,0,0,1,NULL,0,'2026-02-17 12:35:13','2026-02-17 12:35:13',NULL),(31,'member',NULL,NULL,1,'Akshay','Gaware','Akshay Gaware','akshay@example.com','2026-02-17 12:35:13',NULL,NULL,NULL,'$2y$10$x1IH3H4qXUkirj..cfz0K.qL7l6kzaf1CeIS9w8jxDPb3iqOqGno2',NULL,NULL,'42',1,NULL,NULL,NULL,0,0,0,1,NULL,0,'2026-02-17 12:35:13','2026-02-17 12:35:13',NULL),(32,'member',NULL,NULL,1,'Rutuja','Jadhav','Rutuja Jadhav','rutuja@example.com','2026-02-17 12:35:13',NULL,NULL,NULL,'$2y$10$3LurpJ7GSw6kXNU83zqnM.9TDOJ3ES4ElJ.phPFPAGvL0L7jXAQ2O',NULL,NULL,'43',1,NULL,NULL,NULL,0,0,0,1,NULL,0,'2026-02-17 12:35:13','2026-02-17 12:35:13',NULL),(33,'member',NULL,NULL,1,'Vishal','Pawar','Vishal Pawar','vishal@example.com','2026-02-17 12:35:14',NULL,NULL,NULL,'$2y$10$nlf7XgUBLLBmMKSU4i4vXuwDr5ZbOscB7.nkDdQT7vnehz2b0mK4m',NULL,NULL,'44',1,NULL,NULL,NULL,0,0,0,1,NULL,0,'2026-02-17 12:35:14','2026-02-17 12:35:14',NULL),(34,'member',NULL,NULL,1,'Tanvi','Kadam','Tanvi Kadam','tanvi@example.com','2026-02-17 12:35:14',NULL,NULL,NULL,'$2y$10$Zt.DWvdSRaP1dG0sXw3bu.2ze8VeSEonxHg7LC9c0304.rxGQCVZO',NULL,NULL,'45',1,NULL,NULL,NULL,0,0,0,1,NULL,0,'2026-02-17 12:35:14','2026-02-17 12:35:14',NULL);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `members`
--

DROP TABLE IF EXISTS `members`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `members` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL,
  `gender` varchar(10) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `birthday` datetime DEFAULT NULL,
  `introduction` longtext COLLATE utf8mb3_unicode_ci,
  `marital_status_id` bigint DEFAULT NULL,
  `children` int DEFAULT NULL,
  `on_behalves_id` bigint DEFAULT NULL,
  `mothere_tongue` bigint DEFAULT NULL,
  `known_languages` text COLLATE utf8mb3_unicode_ci,
  `current_package_id` varchar(255) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `remaining_interest` int NOT NULL DEFAULT '0',
  `remaining_contact_view` int NOT NULL DEFAULT '0',
  `remaining_profile_image_view` int NOT NULL DEFAULT '0',
  `remaining_gallery_image_view` int NOT NULL DEFAULT '0',
  `remaining_photo_gallery` int DEFAULT '0',
  `auto_profile_match` tinyint(1) NOT NULL DEFAULT '0' COMMENT '0-inactve, 1-active	',
  `package_validity` varchar(100) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `ignored_users` longtext COLLATE utf8mb3_unicode_ci,
  `ignored_by` longtext COLLATE utf8mb3_unicode_ci,
  `reported_user` longtext COLLATE utf8mb3_unicode_ci,
  `reported_by` longtext COLLATE utf8mb3_unicode_ci,
  `blocked_reason` longtext COLLATE utf8mb3_unicode_ci,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=33 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `members`
--

LOCK TABLES `members` WRITE;
/*!40000 ALTER TABLE `members` DISABLE KEYS */;
INSERT INTO `members` VALUES (1,3,'male','1995-01-01 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,'1',10,10,0,0,10,0,NULL,NULL,NULL,NULL,NULL,NULL,'2026-02-17 11:21:46','2026-02-17 11:21:46',NULL),(22,24,'1','2002-05-04 00:00:00',NULL,NULL,NULL,1,NULL,NULL,'1',5,0,0,0,2,0,'2026-02-27',NULL,NULL,NULL,NULL,NULL,'2026-02-17 12:15:08','2026-02-17 12:15:08',NULL),(23,25,'male','1995-01-01 00:00:00',NULL,NULL,NULL,NULL,1,NULL,'8',10,10,0,0,10,0,NULL,NULL,NULL,NULL,NULL,NULL,'2026-02-17 12:35:13','2026-02-17 12:37:36',NULL),(24,26,'female','1995-01-01 00:00:00',NULL,NULL,NULL,NULL,1,NULL,'1',10,10,0,0,10,0,NULL,NULL,NULL,NULL,NULL,NULL,'2026-02-17 12:35:13','2026-02-17 12:35:13',NULL),(25,27,'male','1995-01-01 00:00:00',NULL,NULL,NULL,NULL,1,NULL,'1',10,10,0,0,10,0,NULL,NULL,NULL,NULL,NULL,NULL,'2026-02-17 12:35:13','2026-02-17 12:35:13',NULL),(26,28,'female','1995-01-01 00:00:00',NULL,NULL,NULL,NULL,1,NULL,'1',10,10,0,0,10,0,NULL,NULL,NULL,NULL,NULL,NULL,'2026-02-17 12:35:13','2026-02-17 12:35:13',NULL),(27,29,'male','1995-01-01 00:00:00',NULL,NULL,NULL,NULL,1,NULL,'1',10,10,0,0,10,0,NULL,NULL,NULL,NULL,NULL,NULL,'2026-02-17 12:35:13','2026-02-17 12:35:13',NULL),(28,30,'female','1995-01-01 00:00:00',NULL,NULL,NULL,NULL,1,NULL,'1',10,10,0,0,10,0,NULL,NULL,NULL,NULL,NULL,NULL,'2026-02-17 12:35:13','2026-02-17 12:35:13',NULL),(29,31,'male','1995-01-01 00:00:00',NULL,NULL,NULL,NULL,1,NULL,'1',10,10,0,0,10,0,NULL,NULL,NULL,NULL,NULL,NULL,'2026-02-17 12:35:13','2026-02-17 12:35:13',NULL),(30,32,'female','1995-01-01 00:00:00',NULL,NULL,NULL,NULL,1,NULL,'1',10,10,0,0,10,0,NULL,NULL,NULL,NULL,NULL,NULL,'2026-02-17 12:35:13','2026-02-17 12:35:13',NULL),(31,33,'male','1995-01-01 00:00:00',NULL,NULL,NULL,NULL,1,NULL,'1',10,10,0,0,10,0,NULL,NULL,NULL,NULL,NULL,NULL,'2026-02-17 12:35:14','2026-02-17 12:35:14',NULL),(32,34,'female','1995-01-01 00:00:00',NULL,NULL,NULL,NULL,1,NULL,'1',10,10,0,0,10,0,NULL,NULL,NULL,NULL,NULL,NULL,'2026-02-17 12:35:14','2026-02-17 12:35:14',NULL);
/*!40000 ALTER TABLE `members` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `uploads`
--

DROP TABLE IF EXISTS `uploads`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `uploads` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `file_original_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `file_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `user_id` int DEFAULT NULL,
  `file_size` int DEFAULT NULL,
  `extension` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `type` varchar(15) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=46 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `uploads`
--

LOCK TABLES `uploads` WRITE;
/*!40000 ALTER TABLE `uploads` DISABLE KEYS */;
INSERT INTO `uploads` VALUES (1,'kfLiYSgqrdD5t8KYrg9HJNZyERclSnbpyZXxJjb5','uploads/all/SKcOcvi3a3um1568ZOs13sykK82VVLJuydNtEARk.jpg',1,322091,'jpg','image','2021-08-24 02:15:49','2021-08-24 02:15:49',NULL),(2,'UgoHnTw7QRHMYhzI9MaeSRNvcIP8FxR1FaGNyY32','uploads/all/fR9eDKJYgKcMOighYhxoIZIHBCH8eK1QElv00ipf.png',1,185759,'png','image','2021-08-24 02:18:19','2021-08-24 02:18:19',NULL),(3,'SHlh3Cwc7RaNiiSyvNGmexFDLSYoHkRXlMQqvYwo','uploads/all/MUXVUsD8logxXRk1jq3wDkbB4YZFJ5LaZmolWtHN.png',1,147186,'png','image','2021-08-24 02:18:19','2021-08-24 02:18:19',NULL),(4,'MKeWioNRNyyZSPAJoi6Cy99Jk7kJn8gJabqjEBQW','uploads/all/lfhFfROa6D80ppbRoewuAvzFGgXezfQacqPkUY0x.png',1,189025,'png','image','2021-08-24 02:21:09','2021-08-24 02:21:09',NULL),(5,'D8IvIuVZ1XgBEbW8WNygx6JM0G6AVPKohVaHyj7X','uploads/all/Dz7iRoKk4NVftWS2NUBCJYb9hyGShKfciMfhW34m.png',1,3109,'png','image','2021-08-24 02:22:58','2021-08-24 02:22:58',NULL),(6,'zxhwmcnXiCd5WUb8V4GBLb7VkvXuEl2DHFUUD2sk','uploads/all/q7oLZIUsbv2sCeGydBzDZB400XkPnvCmd7dxN8jX.png',1,5733,'png','image','2021-08-24 02:22:58','2021-08-24 02:22:58',NULL),(7,'bB4GZnLSrquYOKA3lbH0JI5WKWEwznwXNvjbAEEU','uploads/all/eX4kuKyomyBHsBhGTYvJCRZprXA7osr37SWf9WgY.png',1,3444,'png','image','2021-08-24 02:22:58','2021-08-24 02:22:58',NULL),(8,'Zo4yekKwhDtasX6uEl3cKZFei63iYAAvi2550jOr','uploads/all/6H4OQJDt5cb8cLqO94MVYgsaJrrauLHAggxsJyfn.png',1,979778,'png','image','2021-08-24 02:26:57','2021-08-24 02:26:57',NULL),(9,'Zk2lj7FFjeGGYOhch3vtEAkxnnom4zPcWq1bV0tr','uploads/all/boI6HxbU3FzRAcBWyXkfOKIfRHHjIRlhEmR5gqhK.png',1,401,'png','image','2021-08-24 02:27:57','2021-08-24 02:27:57',NULL),(10,'54adYPz3OC2PKzpgZF0rpnvR3qKeDMTikwOqNsMW','uploads/all/m9mpkXk4dRHbI2jeg17ANOVNYvgZpNaIooTU9q0h.png',1,516,'png','image','2021-08-24 02:27:57','2021-08-24 02:27:57',NULL),(11,'5HxbGcXOowGkctJOQHm5CYETk4wIPutWs5eb3dlL','uploads/all/2Po5M6E64qMwkTXcchIC1f3ppisaD1aGh8zKvBm5.png',1,250,'png','image','2021-08-24 02:27:57','2021-08-24 02:27:57',NULL),(12,'LH0T5CcaRM0dYSiFx1sSrNHQWKje7QtvFrngtGHL','uploads/all/6U0M0KfzN2pH2MvEYJ1sRtoJttMLvxWQhiBwbeZA.jpg',1,136057,'jpg','image','2021-08-24 02:32:51','2021-08-24 02:32:51',NULL),(13,'LXbZN69RAoSGbxwxt5gk9IyItmqzHlklA03hsPYO','uploads/all/FiADRk4LeCkwdG6RgpJvtGB5vS5p5OreWwaUpsyu.png',1,426742,'png','image','2021-08-24 03:08:28','2021-08-24 03:08:28',NULL),(14,'logo','uploads/all/VLzKP5yQnLkojP6Qo5tw3Hqmq66xmzclDD5ccqt3.png',1,19381,'png','image','2021-08-24 03:12:54','2021-08-24 03:12:54',NULL),(15,'marathi_male_1.png','marathi_male_1.png',3,102400,'png','image','2026-02-17 11:21:46','2026-02-17 11:21:46',NULL),(36,'marathi_male_1.png','all/marathi_male_1.png',25,102400,'png','image','2026-02-17 12:35:13','2026-02-17 12:35:13',NULL),(37,'marathi_female_1.png','all/marathi_female_1.png',26,102400,'png','image','2026-02-17 12:35:13','2026-02-17 12:35:13',NULL),(38,'marathi_male_2.png','all/marathi_male_2.png',27,102400,'png','image','2026-02-17 12:35:13','2026-02-17 12:35:13',NULL),(39,'marathi_female_2.png','all/marathi_female_2.png',28,102400,'png','image','2026-02-17 12:35:13','2026-02-17 12:35:13',NULL),(40,'marathi_male_3.png','all/marathi_male_3.png',29,102400,'png','image','2026-02-17 12:35:13','2026-02-17 12:35:13',NULL),(41,'marathi_female_3.png','all/marathi_female_3.png',30,102400,'png','image','2026-02-17 12:35:13','2026-02-17 12:35:13',NULL),(42,'marathi_male_4.png','all/marathi_male_4.png',31,102400,'png','image','2026-02-17 12:35:13','2026-02-17 12:35:13',NULL),(43,'marathi_female_2.png','all/marathi_female_2.png',32,102400,'png','image','2026-02-17 12:35:13','2026-02-17 12:35:13',NULL),(44,'marathi_male_5.png','all/marathi_male_5.png',33,102400,'png','image','2026-02-17 12:35:14','2026-02-17 12:35:14',NULL),(45,'marathi_female_5.png','all/marathi_female_5.png',34,102400,'png','image','2026-02-17 12:35:14','2026-02-17 12:35:14',NULL);
/*!40000 ALTER TABLE `uploads` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `addresses`
--

DROP TABLE IF EXISTS `addresses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `addresses` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint unsigned NOT NULL,
  `type` varchar(50) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `city_id` bigint DEFAULT NULL,
  `state_id` bigint DEFAULT NULL,
  `country_id` bigint DEFAULT NULL,
  `postal_code` varchar(20) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `addresses_user_id_foreign` (`user_id`),
  CONSTRAINT `addresses_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `addresses`
--

LOCK TABLES `addresses` WRITE;
/*!40000 ALTER TABLE `addresses` DISABLE KEYS */;
INSERT INTO `addresses` VALUES (21,25,'present',2474,22,101,NULL,'2026-02-17 12:35:13','2026-02-17 12:35:13',NULL),(22,26,'present',2478,22,101,NULL,'2026-02-17 12:35:13','2026-02-17 12:35:13',NULL),(23,27,'present',2482,22,101,NULL,'2026-02-17 12:35:13','2026-02-17 12:35:13',NULL),(24,28,'present',2478,22,101,NULL,'2026-02-17 12:35:13','2026-02-17 12:35:13',NULL),(25,29,'present',2480,22,101,NULL,'2026-02-17 12:35:13','2026-02-17 12:35:13',NULL),(26,30,'present',2474,22,101,NULL,'2026-02-17 12:35:13','2026-02-17 12:35:13',NULL),(27,31,'present',2478,22,101,NULL,'2026-02-17 12:35:13','2026-02-17 12:35:13',NULL),(28,32,'present',2482,22,101,NULL,'2026-02-17 12:35:13','2026-02-17 12:35:13',NULL),(29,33,'present',2478,22,101,NULL,'2026-02-17 12:35:14','2026-02-17 12:35:14',NULL),(30,34,'present',2480,22,101,NULL,'2026-02-17 12:35:14','2026-02-17 12:35:14',NULL);
/*!40000 ALTER TABLE `addresses` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-02-17 23:41:28
