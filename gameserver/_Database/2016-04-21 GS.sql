CREATE DATABASE  IF NOT EXISTS `ug` /*!40100 DEFAULT CHARACTER SET latin1 */;
USE `ug`;
-- MySQL dump 10.13  Distrib 5.7.9, for Win64 (x86_64)
--
-- Host: localhost    Database: ug
-- ------------------------------------------------------
-- Server version	5.7.11-log

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `accounts`
--

DROP TABLE IF EXISTS `accounts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `accounts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` text,
  `registerdate` datetime DEFAULT CURRENT_TIMESTAMP,
  `lastlogin` datetime DEFAULT NULL,
  `ip` text,
  `admin` float DEFAULT '0',
  `warn_style` int(1) NOT NULL DEFAULT '1',
  `hiddenadmin` tinyint(3) unsigned DEFAULT '0',
  `adminduty` tinyint(3) unsigned DEFAULT '0',
  `adminjail` tinyint(3) unsigned DEFAULT '0',
  `adminjail_time` int(11) DEFAULT NULL,
  `adminjail_by` text,
  `adminjail_reason` text,
  `banned` tinyint(3) unsigned DEFAULT '0',
  `banned_by` text,
  `banned_reason` text,
  `muted` tinyint(3) unsigned DEFAULT '0',
  `globalooc` tinyint(3) unsigned DEFAULT '1',
  `friendsmessage` varchar(255) NOT NULL DEFAULT 'Hi!',
  `adminjail_permanent` tinyint(3) unsigned DEFAULT '0',
  `adminreports` int(11) DEFAULT '0',
  `warns` tinyint(3) unsigned DEFAULT '0',
  `chatbubbles` tinyint(3) unsigned NOT NULL DEFAULT '1',
  `adminnote` text,
  `appstate` tinyint(1) DEFAULT '0',
  `appdatetime` datetime DEFAULT NULL,
  `appreason` longtext,
  `email` text,
  `help` int(1) NOT NULL DEFAULT '1',
  `adblocked` int(1) NOT NULL DEFAULT '0',
  `newsblocked` int(1) DEFAULT '0',
  `mtaserial` text,
  `d_addiction` text,
  `loginhash` varchar(64) DEFAULT NULL,
  `credits` int(11) NOT NULL DEFAULT '0',
  `transfers` int(11) DEFAULT '0',
  `monitored` varchar(255) NOT NULL DEFAULT 'New Player',
  `autopark` int(1) NOT NULL DEFAULT '1',
  `forceUpdate` int(1) NOT NULL DEFAULT '0',
  `anotes` text,
  `oldAdminRank` int(11) DEFAULT NULL,
  `suspensionTime` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `accounts`
--

LOCK TABLES `accounts` WRITE;
/*!40000 ALTER TABLE `accounts` DISABLE KEYS */;
INSERT INTO `accounts` VALUES (1,'TamFire',NULL,'2016-04-03 15:18:03','25.110.55.104',4,0,0,1,0,0,'Tyrone Lawrence','Test',0,NULL,NULL,0,1,'I Lick Dick',1,2,0,1,'Likes Dick\n',3,NULL,NULL,'tamfire1996@gmail.com',1,0,0,'B4A343FE94C2B4D3BAC5F4B58A35EEB2',NULL,'gXapdVvZoL9h4qWKoxwEtyEMplMbb7duLNiUkQVk7xZzENTqQqTqT9hLl57MeRMZ',0,0,'',1,0,NULL,0,NULL),(2,'FuckMe',NULL,'2015-07-05 01:33:56','99.242.144.152',6,1,0,0,0,NULL,NULL,NULL,0,NULL,NULL,0,1,'Hi!',0,0,0,1,NULL,3,NULL,NULL,NULL,1,0,0,'073E5231A2C51D4084184B7B1B3EBE12',NULL,'5oHWJxfj6lxsSsra56Te02f5fXirdMlqw1sPzAV0YdgLWZM4fUUR3ctE6b4izyCH',0,0,'New Player',1,0,NULL,0,NULL),(3,'FrolicBeast',NULL,'2015-08-17 20:48:14','104.247.244.183',3,1,0,1,0,NULL,NULL,NULL,0,NULL,NULL,0,1,'Hi!',0,1,0,1,NULL,3,NULL,NULL,'frolicbeast@hotmail.com',1,0,0,'5FCC9ED01F116C323042D65D90821D62',NULL,'3ax7kdgXg543RUxoK4l2ZHoLhwZK8V9NbMUwXLROcGLewMqfRcNq2KjfAfxxgq6v',0,0,'New Player',1,0,NULL,0,NULL),(4,'Bean',NULL,'2016-03-01 14:29:56','25.155.128.251',3,0,0,1,0,NULL,NULL,NULL,0,NULL,NULL,0,1,'Hi!',0,0,0,1,NULL,3,NULL,NULL,'bean.calvin1@gmail.com',1,0,0,'7EE99333B49065EA198BA5CF9CA196B3',NULL,'1VVJrQUyzTw4LckqWKGOVNSTMQ7j4abCk4BX3NrKW1sy6dvEPIfmCx0n06wO7HMy',999,0,'New Player',1,0,NULL,0,NULL),(5,'Grif',NULL,'2016-02-28 16:09:43','25.12.206.224',4,1,0,0,0,NULL,NULL,NULL,0,NULL,NULL,0,1,'Hi!',0,0,0,1,NULL,3,NULL,NULL,'grifparker@gmail.com',1,0,0,'7EB82E0436ADD261CE8F2707A63F37A2',NULL,'kBMSbpYehUevOAxs6bQOzXjPRrywBeSpQOnPIGhynLfHCxJQqEDdICUWBkC8uWXN',0,0,'New Player',1,0,NULL,0,NULL),(6,'simon',NULL,'2015-08-17 21:27:21','174.91.65.239',4,1,0,0,0,NULL,NULL,NULL,0,NULL,NULL,0,1,'Hi!',0,0,0,1,NULL,3,NULL,NULL,'simon_o@live.ca',1,0,0,'222E1613A9E68A454CF9D075557305F2',NULL,'o9TjuTEEZWn8mAKSN0aZ6UEvvdtsY1uRa7Eun6aoK5NiSEYaqu4DGGBzt4A0ThUc',0,0,'New Player',1,0,NULL,0,NULL),(7,'Tenrakk',NULL,'2015-08-17 20:52:51','64.228.241.63',4,1,0,0,0,NULL,NULL,NULL,0,NULL,NULL,0,1,'Hi!',0,0,0,1,NULL,3,NULL,NULL,'c.hitzroth@gmail.com',1,0,0,'F495F40475646081CDFC3615D0BA5E42',NULL,'i1PAX0zB4l0LrtJCsl5hci1FZjMIEMwuDPSVsjkpHZJGHvNtsKqjOCvKjgoC24PF',0,0,'New Player',1,0,NULL,0,NULL);
/*!40000 ALTER TABLE `accounts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `adminhistory`
--

DROP TABLE IF EXISTS `adminhistory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `adminhistory` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user` int(10) unsigned NOT NULL,
  `user_char` text NOT NULL,
  `admin` int(10) unsigned NOT NULL,
  `admin_char` text NOT NULL,
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `action` tinyint(3) unsigned NOT NULL,
  `duration` int(10) unsigned NOT NULL,
  `reason` text NOT NULL,
  `hiddenadmin` tinyint(3) unsigned NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `adminhistory`
--

LOCK TABLES `adminhistory` WRITE;
/*!40000 ALTER TABLE `adminhistory` DISABLE KEYS */;
INSERT INTO `adminhistory` VALUES (1,1,'Tyrone Lawrence',1,'Tyrone Lawrence','2015-07-05 00:46:03',0,1,'Being a big fat nigger',0),(2,1,'Tyrone Lawrence',1,'Tyrone Lawrence','2015-07-05 00:48:10',0,1,'Being a big fat nigger',0),(3,4,'Dopehouse Niggler',1,'Tyrone Lawrence','2015-08-03 21:50:30',6,999,'999 donPoints for: IOU DON',0),(4,1,'Tyrone Lawrence',1,'Tyrone Lawrence','2015-09-10 14:11:34',0,9999999,'Jail',0),(5,1,'Tyrone Lawrence',1,'Tyrone Lawrence','2015-09-13 23:45:46',0,9999999,'Test',0);
/*!40000 ALTER TABLE `adminhistory` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `apb`
--

DROP TABLE IF EXISTS `apb`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `apb` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `description` text NOT NULL,
  `doneby` int(11) NOT NULL,
  `time` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `apb`
--

LOCK TABLES `apb` WRITE;
/*!40000 ALTER TABLE `apb` DISABLE KEYS */;
/*!40000 ALTER TABLE `apb` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `applications`
--

DROP TABLE IF EXISTS `applications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `applications` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `accountID` int(11) NOT NULL,
  `dateposted` datetime NOT NULL,
  `content` text NOT NULL,
  `datereviewed` datetime DEFAULT NULL,
  `adminID` int(11) DEFAULT NULL,
  `adminNote` text,
  `adminAction` int(11) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `applications`
--

LOCK TABLES `applications` WRITE;
/*!40000 ALTER TABLE `applications` DISABLE KEYS */;
/*!40000 ALTER TABLE `applications` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `atms`
--

DROP TABLE IF EXISTS `atms`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `atms` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `x` decimal(10,6) DEFAULT '0.000000',
  `y` decimal(10,6) DEFAULT '0.000000',
  `z` decimal(10,6) DEFAULT '0.000000',
  `rotation` decimal(10,6) DEFAULT '0.000000',
  `dimension` int(5) DEFAULT '0',
  `interior` int(5) DEFAULT '0',
  `deposit` tinyint(3) unsigned DEFAULT '0',
  `limit` int(10) unsigned DEFAULT '5000',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `atms`
--

LOCK TABLES `atms` WRITE;
/*!40000 ALTER TABLE `atms` DISABLE KEYS */;
/*!40000 ALTER TABLE `atms` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `bannedips`
--

DROP TABLE IF EXISTS `bannedips`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `bannedips` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `ip` varchar(16) NOT NULL DEFAULT '0.0.0.0',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bannedips`
--

LOCK TABLES `bannedips` WRITE;
/*!40000 ALTER TABLE `bannedips` DISABLE KEYS */;
/*!40000 ALTER TABLE `bannedips` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `bannedserials`
--

DROP TABLE IF EXISTS `bannedserials`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `bannedserials` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `serial` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bannedserials`
--

LOCK TABLES `bannedserials` WRITE;
/*!40000 ALTER TABLE `bannedserials` DISABLE KEYS */;
/*!40000 ALTER TABLE `bannedserials` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `blocked`
--

DROP TABLE IF EXISTS `blocked`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `blocked` (
  `userid` int(10) DEFAULT NULL,
  `blockedid` int(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `blocked`
--

LOCK TABLES `blocked` WRITE;
/*!40000 ALTER TABLE `blocked` DISABLE KEYS */;
/*!40000 ALTER TABLE `blocked` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `characters`
--

DROP TABLE IF EXISTS `characters`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `characters` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `charactername` text,
  `account` int(11) DEFAULT '0',
  `x` float DEFAULT '1770.02',
  `y` float DEFAULT '-1860.91',
  `z` float DEFAULT '13.5782',
  `rotation` float DEFAULT '359.388',
  `interior_id` int(5) DEFAULT '0',
  `dimension_id` int(5) DEFAULT '0',
  `health` float DEFAULT '100',
  `armor` float DEFAULT '0',
  `skin` int(3) DEFAULT '264',
  `money` bigint(20) DEFAULT '250',
  `gender` int(1) DEFAULT '0',
  `cuffed` int(11) DEFAULT '0',
  `duty` int(3) DEFAULT '0',
  `fightstyle` int(2) DEFAULT '4',
  `pdjail` int(1) DEFAULT '0',
  `pdjail_time` int(11) DEFAULT '0',
  `cked` int(1) DEFAULT '0',
  `lastarea` text,
  `age` int(3) DEFAULT '18',
  `faction_id` int(11) DEFAULT '-1',
  `faction_rank` int(2) DEFAULT '1',
  `faction_perks` text,
  `skincolor` int(1) DEFAULT '0',
  `weight` int(3) DEFAULT '180',
  `height` int(3) DEFAULT '180',
  `description` text,
  `deaths` int(11) DEFAULT '0',
  `faction_leader` int(1) DEFAULT '0',
  `fingerprint` text,
  `casualskin` int(3) DEFAULT '0',
  `bankmoney` bigint(20) DEFAULT '15000',
  `car_license` int(1) DEFAULT '0',
  `gun_license` int(1) DEFAULT '0',
  `tag` int(3) DEFAULT '1',
  `hoursplayed` int(11) DEFAULT '0',
  `pdjail_station` int(1) DEFAULT '0',
  `timeinserver` int(2) DEFAULT '0',
  `restrainedobj` int(11) DEFAULT '0',
  `restrainedby` int(11) DEFAULT '0',
  `dutyskin` int(3) DEFAULT '-1',
  `fish` int(10) unsigned NOT NULL DEFAULT '0',
  `truckingruns` int(10) unsigned NOT NULL DEFAULT '0',
  `truckingwage` int(10) unsigned NOT NULL DEFAULT '0',
  `blindfold` tinyint(4) NOT NULL DEFAULT '0',
  `lang1` tinyint(2) DEFAULT '1',
  `lang1skill` tinyint(3) DEFAULT '100',
  `lang2` tinyint(2) DEFAULT '0',
  `lang2skill` tinyint(3) DEFAULT '0',
  `lang3` tinyint(2) DEFAULT '0',
  `lang3skill` tinyint(3) DEFAULT '0',
  `currlang` tinyint(1) DEFAULT '1',
  `lastlogin` datetime DEFAULT NULL,
  `creationdate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `election_candidate` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `election_canvote` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `election_votedfor` int(10) unsigned NOT NULL DEFAULT '0',
  `marriedto` int(10) unsigned NOT NULL DEFAULT '0',
  `photos` int(10) unsigned NOT NULL DEFAULT '0',
  `maxvehicles` int(4) unsigned NOT NULL DEFAULT '5',
  `ck_info` text,
  `alcohollevel` float NOT NULL DEFAULT '0',
  `active` tinyint(1) unsigned NOT NULL DEFAULT '1',
  `wounded` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `recovery` int(1) DEFAULT '0',
  `recoverytime` bigint(20) DEFAULT NULL,
  `walkingstyle` int(3) NOT NULL DEFAULT '0',
  `job` int(11) unsigned zerofill DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `characters`
--

LOCK TABLES `characters` WRITE;
/*!40000 ALTER TABLE `characters` DISABLE KEYS */;
INSERT INTO `characters` VALUES (1,'Tyrone_Lawrence',1,1829.08,-1173.71,23.8281,68.3662,0,0,60,0,7,2956,0,0,0,4,0,0,0,'Glen Park',16,1,1,'{}',0,50,150,'',23,1,'1B59789EF07DBA55AA989509AF26E099',0,21532,0,0,1,21,0,253,0,0,-1,0,0,0,0,1,100,0,0,0,0,1,'2016-04-03 15:18:03','2015-07-02 21:06:27',0,0,0,0,0,5,NULL,0,1,0,0,NULL,128,00000000000),(2,'Carlos_Ramirez',2,1189.42,-1292.4,13.5493,99.0295,0,0,76,0,116,250,0,0,0,4,0,0,0,'Market',27,-1,1,'[ \"\" ]',1,100,173,'',2,0,'B4AF2071A0B73546E4C89DC831DA9B55',0,15300,0,0,1,1,0,33,0,0,-1,0,0,0,0,1,100,0,0,0,0,1,'2015-07-05 01:33:56','2015-07-04 23:58:40',0,0,0,0,0,5,NULL,0,1,0,0,NULL,128,00000000000),(3,'Nicholas_Fletcher',3,1208.26,-1285.6,13.3806,345.001,0,0,25,0,101,250,0,0,0,4,0,0,0,'Market',31,-1,1,'[ \"\" ]',1,50,150,'',1,0,'6394B27B929E23363F95602A06B3AF5F',0,15000,0,0,1,0,0,82,0,0,0,0,0,0,0,1,100,0,0,0,0,1,'2015-08-17 20:48:14','2015-08-02 14:25:02',0,0,0,0,0,5,NULL,0,1,0,0,NULL,128,00000000000),(4,'Markus_Robinson',4,1748.7,-1731.67,13.3923,88.2628,0,0,100,0,269,0,0,0,0,4,0,0,0,'Little Mexico',23,1,1,'[ \"\" ]',0,90,182,'',9,1,'1F46ED0B6B7AC9224B23F5CF95C6BAD4',18,16238,0,0,1,4,0,35,0,0,-1,0,0,0,0,1,100,0,0,0,0,1,'2016-03-01 14:29:56','2015-08-03 20:56:32',0,0,0,0,0,5,NULL,0,1,0,0,NULL,118,00000000000),(5,'Moon_Man',5,277.581,-2059.21,3084.75,26.2825,0,0,62,0,280,250,0,0,0,4,0,0,0,'Unknown',32,1,20,'[ \"\" ]',1,110,195,'',9,1,'766B636C9F1FD177265F86FCE5571220',0,15606,0,0,1,2,0,57,0,0,-1,0,0,0,0,1,100,0,0,0,0,1,'2016-02-28 16:09:43','2015-08-03 21:08:41',0,0,0,0,0,5,NULL,0,1,0,0,NULL,128,00000000000),(6,'Kaleefa_Williams',6,2650.14,-1052.58,69.1979,39.6044,0,0,89,0,249,200,0,0,0,4,0,0,0,'Las Colinas',32,-1,1,'[ \"\" ]',0,97,179,'',0,0,'E3CF71FDFF472FDAB67A6857F25FAE85',0,15000,0,0,1,0,0,70,0,0,-1,0,0,0,0,1,100,0,0,0,0,1,'2015-08-17 21:27:21','2015-08-17 19:33:55',0,0,0,0,0,5,NULL,0,1,0,0,NULL,128,00000000000),(7,'Xavier_Morgan',7,1389.22,-1829.59,13.3828,354.207,0,0,4,0,107,250,0,0,0,4,0,0,0,'Commerce',22,-1,1,'[ \"\" ]',0,96,200,'',3,0,'4549D5EF0834E5F5F3667FD7DA9AFBF1',0,15000,0,0,1,0,0,22,0,0,-1,0,0,0,0,1,100,0,0,0,0,1,'2015-08-17 20:52:51','2015-08-17 20:29:54',0,0,0,0,0,5,NULL,0,1,0,0,NULL,128,00000000000),(8,'Charles_Davidson',1,1770.02,-1860.91,13.5782,0.00274658,0,0,100,0,7,250,0,0,0,4,0,0,0,'El Corona',16,-1,1,'[ \"\" ]',0,50,150,'',0,0,'D309F7ECFB2E227756BBD90BEF8CA268',0,15000,0,0,1,0,0,0,0,0,-1,0,0,0,0,1,100,0,0,0,0,1,'2015-09-13 23:57:27','2015-09-13 23:57:22',0,0,0,0,0,5,NULL,0,1,0,0,NULL,128,00000000000);
/*!40000 ALTER TABLE `characters` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `computers`
--

DROP TABLE IF EXISTS `computers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `computers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `posX` float(10,5) NOT NULL,
  `posY` float(10,5) NOT NULL,
  `posZ` float(10,5) NOT NULL,
  `rotX` float(10,5) NOT NULL,
  `rotY` float(10,5) NOT NULL,
  `rotZ` float(10,5) NOT NULL,
  `interior` int(8) NOT NULL,
  `dimension` int(8) NOT NULL,
  `model` int(8) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `computers`
--

LOCK TABLES `computers` WRITE;
/*!40000 ALTER TABLE `computers` DISABLE KEYS */;
/*!40000 ALTER TABLE `computers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dancers`
--

DROP TABLE IF EXISTS `dancers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `dancers` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `x` float NOT NULL,
  `y` float NOT NULL,
  `z` float NOT NULL,
  `rotation` float NOT NULL,
  `skin` smallint(5) unsigned NOT NULL,
  `type` tinyint(3) unsigned NOT NULL,
  `interior` int(10) unsigned NOT NULL,
  `dimension` int(10) unsigned NOT NULL,
  `offset` tinyint(3) unsigned NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dancers`
--

LOCK TABLES `dancers` WRITE;
/*!40000 ALTER TABLE `dancers` DISABLE KEYS */;
/*!40000 ALTER TABLE `dancers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `don_prices`
--

DROP TABLE IF EXISTS `don_prices`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `don_prices` (
  `ProductID` int(10) DEFAULT NULL,
  `ProductPrice` double DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `don_prices`
--

LOCK TABLES `don_prices` WRITE;
/*!40000 ALTER TABLE `don_prices` DISABLE KEYS */;
/*!40000 ALTER TABLE `don_prices` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `don_transaction_failed`
--

DROP TABLE IF EXISTS `don_transaction_failed`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `don_transaction_failed` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `output` text NOT NULL,
  `ip` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `don_transaction_failed`
--

LOCK TABLES `don_transaction_failed` WRITE;
/*!40000 ALTER TABLE `don_transaction_failed` DISABLE KEYS */;
/*!40000 ALTER TABLE `don_transaction_failed` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `don_transactions`
--

DROP TABLE IF EXISTS `don_transactions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `don_transactions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `transaction_id` varchar(64) NOT NULL,
  `donator_email` varchar(255) NOT NULL,
  `amount` double NOT NULL,
  `original_request` text,
  `dt` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' ON UPDATE CURRENT_TIMESTAMP,
  `handled` smallint(1) DEFAULT '0',
  `username` varchar(50) NOT NULL,
  `realamount` double NOT NULL DEFAULT '0',
  `item_number` int(11) NOT NULL DEFAULT '0',
  `validated` smallint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `don_transactions`
--

LOCK TABLES `don_transactions` WRITE;
/*!40000 ALTER TABLE `don_transactions` DISABLE KEYS */;
/*!40000 ALTER TABLE `don_transactions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `donators`
--

DROP TABLE IF EXISTS `donators`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `donators` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `accountID` int(11) NOT NULL,
  `charID` int(11) NOT NULL DEFAULT '-1',
  `perkID` int(4) NOT NULL,
  `perkValue` varchar(10) NOT NULL DEFAULT '1',
  `expirationDate` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `donators`
--

LOCK TABLES `donators` WRITE;
/*!40000 ALTER TABLE `donators` DISABLE KEYS */;
/*!40000 ALTER TABLE `donators` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `elevators`
--

DROP TABLE IF EXISTS `elevators`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `elevators` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `x` decimal(10,6) DEFAULT '0.000000',
  `y` decimal(10,6) DEFAULT '0.000000',
  `z` decimal(10,6) DEFAULT '0.000000',
  `tpx` decimal(10,6) DEFAULT '0.000000',
  `tpy` decimal(10,6) DEFAULT '0.000000',
  `tpz` decimal(10,6) DEFAULT '0.000000',
  `dimensionwithin` int(5) DEFAULT '0',
  `interiorwithin` int(5) DEFAULT '0',
  `dimension` int(5) DEFAULT '0',
  `interior` int(5) DEFAULT '0',
  `car` tinyint(3) unsigned DEFAULT '0',
  `disabled` tinyint(3) unsigned DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `elevators`
--

LOCK TABLES `elevators` WRITE;
/*!40000 ALTER TABLE `elevators` DISABLE KEYS */;
/*!40000 ALTER TABLE `elevators` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `emailaccounts`
--

DROP TABLE IF EXISTS `emailaccounts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `emailaccounts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` text,
  `password` text,
  `creator` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `emailaccounts`
--

LOCK TABLES `emailaccounts` WRITE;
/*!40000 ALTER TABLE `emailaccounts` DISABLE KEYS */;
/*!40000 ALTER TABLE `emailaccounts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `emails`
--

DROP TABLE IF EXISTS `emails`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `emails` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `date` datetime NOT NULL,
  `sender` text,
  `receiver` text,
  `subject` text,
  `message` text,
  `inbox` int(1) NOT NULL DEFAULT '0',
  `outbox` int(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `emails`
--

LOCK TABLES `emails` WRITE;
/*!40000 ALTER TABLE `emails` DISABLE KEYS */;
/*!40000 ALTER TABLE `emails` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `factions`
--

DROP TABLE IF EXISTS `factions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `factions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` text,
  `bankbalance` bigint(20) DEFAULT NULL,
  `type` int(11) DEFAULT NULL,
  `rank_1` text,
  `rank_2` text,
  `rank_3` text,
  `rank_4` text,
  `rank_5` text,
  `rank_6` text,
  `rank_7` text,
  `rank_8` text,
  `rank_9` text,
  `rank_10` text,
  `rank_11` text,
  `rank_12` text,
  `rank_13` text,
  `rank_14` text,
  `rank_15` text,
  `rank_16` text,
  `rank_17` text,
  `rank_18` text,
  `rank_19` text,
  `rank_20` text,
  `wage_1` int(11) DEFAULT '100',
  `wage_2` int(11) DEFAULT '100',
  `wage_3` int(11) DEFAULT '100',
  `wage_4` int(11) DEFAULT '100',
  `wage_5` int(11) DEFAULT '100',
  `wage_6` int(11) DEFAULT '100',
  `wage_7` int(11) DEFAULT '100',
  `wage_8` int(11) DEFAULT '100',
  `wage_9` int(11) DEFAULT '100',
  `wage_10` int(11) DEFAULT '100',
  `wage_11` int(11) DEFAULT '100',
  `wage_12` int(11) DEFAULT '100',
  `wage_13` int(11) DEFAULT '100',
  `wage_14` int(11) DEFAULT '100',
  `wage_15` int(11) DEFAULT '100',
  `wage_16` int(11) DEFAULT '100',
  `wage_17` int(11) DEFAULT '100',
  `wage_18` int(11) DEFAULT '100',
  `wage_19` int(11) DEFAULT '100',
  `wage_20` int(11) DEFAULT '100',
  `motd` text,
  `note` text,
  `fnote` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `factions`
--

LOCK TABLES `factions` WRITE;
/*!40000 ALTER TABLE `factions` DISABLE KEYS */;
INSERT INTO `factions` VALUES (1,'Los Santos Police Department',0,2,'Police Officer I','Police Officer II','Police Officer III','Police Officer III SLO','Detective I','Detective II','Sergeant I','Detective III','Sergeant II','','','','Lieutenant I','Lieutenant II','Captain I','Captain II','Commander','Deputy Chief of Police','Assistant Chief of Police','Chief of Police',1,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,'Welcome to the faction.','',NULL),(2,'Los Santos Fire Department',0,4,'Dynamic Rank #1','Dynamic Rank #2','Dynamic Rank #3','Dynamic Rank #4','Dynamic Rank #5','Dynamic Rank #6','Dynamic Rank #7','Dynamic Rank #8','Dynamic Rank #9','Dynamic Rank #10','Dynamic Rank #11','Dynamic Rank #12','Dynamic Rank #13','Dynamic Rank #14','Dynamic Rank #15','Dynamic Rank #16','Dynamic Rank #17','Dynamic Rank #18','Dynamic Rank #19','Dynamic Rank #20',100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,'Welcome to the faction.','',NULL),(3,'Los Santos Government',0,3,'Dynamic Rank #1','Dynamic Rank #2','Dynamic Rank #3','Dynamic Rank #4','Dynamic Rank #5','Dynamic Rank #6','Dynamic Rank #7','Dynamic Rank #8','Dynamic Rank #9','Dynamic Rank #10','Dynamic Rank #11','Dynamic Rank #12','Dynamic Rank #13','Dynamic Rank #14','Dynamic Rank #15','Dynamic Rank #16','Dynamic Rank #17','Dynamic Rank #18','Dynamic Rank #19','Dynamic Rank #20',100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,'Welcome to the faction.','',NULL);
/*!40000 ALTER TABLE `factions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `factories`
--

DROP TABLE IF EXISTS `factories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `factories` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `INT_ID` int(11) DEFAULT NULL,
  `Type` int(1) DEFAULT NULL,
  `Max_Supplies` int(11) NOT NULL DEFAULT '50',
  `Curr_Supplies` int(11) NOT NULL DEFAULT '0',
  `Ordered_Supplies` int(11) NOT NULL DEFAULT '0',
  `Date_Of_Arrival` datetime DEFAULT NULL,
  `Order_Claimed` int(1) NOT NULL DEFAULT '0',
  `Authorized_Faction` int(11) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `factories`
--

LOCK TABLES `factories` WRITE;
/*!40000 ALTER TABLE `factories` DISABLE KEYS */;
INSERT INTO `factories` VALUES (5,1,1,55,55,0,NULL,0,1);
/*!40000 ALTER TABLE `factories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `forgotdetails`
--

DROP TABLE IF EXISTS `forgotdetails`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `forgotdetails` (
  `uniquekey` varchar(32) NOT NULL,
  `account` int(11) DEFAULT '0',
  `keytimestamp` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `forgotdetails`
--

LOCK TABLES `forgotdetails` WRITE;
/*!40000 ALTER TABLE `forgotdetails` DISABLE KEYS */;
/*!40000 ALTER TABLE `forgotdetails` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `friends`
--

DROP TABLE IF EXISTS `friends`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `friends` (
  `id` int(10) unsigned NOT NULL,
  `friend` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`,`friend`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `friends`
--

LOCK TABLES `friends` WRITE;
/*!40000 ALTER TABLE `friends` DISABLE KEYS */;
INSERT INTO `friends` VALUES (1,4),(4,1),(4,5),(5,4);
/*!40000 ALTER TABLE `friends` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fuelpeds`
--

DROP TABLE IF EXISTS `fuelpeds`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `fuelpeds` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `posX` float NOT NULL,
  `posY` float NOT NULL,
  `posZ` float NOT NULL,
  `rotZ` float NOT NULL,
  `skin` int(3) NOT NULL,
  `priceratio` int(3) NOT NULL,
  `name` varchar(50) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fuelpeds`
--

LOCK TABLES `fuelpeds` WRITE;
/*!40000 ALTER TABLE `fuelpeds` DISABLE KEYS */;
/*!40000 ALTER TABLE `fuelpeds` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fuelstations`
--

DROP TABLE IF EXISTS `fuelstations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `fuelstations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `x` decimal(10,6) DEFAULT '0.000000',
  `y` decimal(10,6) DEFAULT '0.000000',
  `z` decimal(10,6) DEFAULT '0.000000',
  `interior` int(5) DEFAULT '0',
  `dimension` int(5) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fuelstations`
--

LOCK TABLES `fuelstations` WRITE;
/*!40000 ALTER TABLE `fuelstations` DISABLE KEYS */;
/*!40000 ALTER TABLE `fuelstations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `gates`
--

DROP TABLE IF EXISTS `gates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `gates` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `objectID` int(11) NOT NULL,
  `startX` float NOT NULL,
  `startY` float NOT NULL,
  `startZ` float NOT NULL,
  `startRX` float NOT NULL,
  `startRY` float NOT NULL,
  `startRZ` float NOT NULL,
  `endX` float NOT NULL,
  `endY` float NOT NULL,
  `endZ` float NOT NULL,
  `endRX` float NOT NULL,
  `endRY` float NOT NULL,
  `endRZ` float NOT NULL,
  `gateType` tinyint(3) unsigned NOT NULL,
  `autocloseTime` int(4) NOT NULL,
  `movementTime` int(4) NOT NULL,
  `objectDimension` int(11) NOT NULL,
  `objectInterior` int(11) NOT NULL,
  `gateSecurityParameters` text,
  `creator` varchar(50) NOT NULL DEFAULT '',
  `createdDate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `adminNote` varchar(300) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `gates`
--

LOCK TABLES `gates` WRITE;
/*!40000 ALTER TABLE `gates` DISABLE KEYS */;
/*!40000 ALTER TABLE `gates` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `informationicons`
--

DROP TABLE IF EXISTS `informationicons`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `informationicons` (
  `id` int(10) DEFAULT NULL,
  `createdby` text,
  `x` float DEFAULT NULL,
  `y` float DEFAULT NULL,
  `z` float DEFAULT NULL,
  `rx` float DEFAULT NULL,
  `ry` float DEFAULT NULL,
  `rz` float DEFAULT NULL,
  `interior` float DEFAULT NULL,
  `dimension` float DEFAULT NULL,
  `information` text
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `informationicons`
--

LOCK TABLES `informationicons` WRITE;
/*!40000 ALTER TABLE `informationicons` DISABLE KEYS */;
/*!40000 ALTER TABLE `informationicons` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `interior_business`
--

DROP TABLE IF EXISTS `interior_business`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `interior_business` (
  `intID` int(11) NOT NULL,
  `businessNote` varchar(101) NOT NULL DEFAULT 'Welcome to our business!',
  PRIMARY KEY (`intID`),
  UNIQUE KEY `intID_UNIQUE` (`intID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Saves info about businesses - Maxime';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `interior_business`
--

LOCK TABLES `interior_business` WRITE;
/*!40000 ALTER TABLE `interior_business` DISABLE KEYS */;
INSERT INTO `interior_business` VALUES (3,'Welcome to our business!');
/*!40000 ALTER TABLE `interior_business` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `interior_logs`
--

DROP TABLE IF EXISTS `interior_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `interior_logs` (
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `intID` int(11) DEFAULT NULL,
  `action` text,
  `actor` int(11) DEFAULT NULL,
  `log_id` int(11) NOT NULL AUTO_INCREMENT,
  UNIQUE KEY `log_id_UNIQUE` (`log_id`)
) ENGINE=InnoDB AUTO_INCREMENT=36 DEFAULT CHARSET=utf8 COMMENT='Stores all admin actions on interiors - Monitored by Interior Manager - Maxime';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `interior_logs`
--

LOCK TABLES `interior_logs` WRITE;
/*!40000 ALTER TABLE `interior_logs` DISABLE KEYS */;
INSERT INTO `interior_logs` VALUES ('2015-07-05 00:48:18',1,'addinterior - id 35 - price $0 - name Nigger Shack',2,1),('2015-07-05 00:48:49',1,'setinteriorid 78',2,2),('2015-07-05 00:49:03',1,'setinteriorid 67',2,3),('2015-07-05 00:49:18',1,'setinteriorid 54',2,4),('2015-07-05 00:49:37',1,'setinteriorid 100',2,5),('2015-07-05 00:50:01',1,'setinteriorid 101',2,6),('2015-07-05 00:50:22',1,'setinteriorid 102',2,7),('2015-07-05 00:50:42',1,'setinteriorid 103',2,8),('2015-07-05 00:51:18',1,'setinteriorid 23',2,9),('2015-07-05 00:51:31',1,'setinteriorid 13',2,10),('2015-07-05 00:51:41',1,'setinteriorid 84',2,11),('2015-07-05 00:52:01',1,'setinteriorid 78',2,12),('2015-07-05 00:52:32',1,'setinteriorid 11',2,13),('2015-07-05 00:54:06',1,'setinteriorid 45',2,14),('2015-07-05 00:54:14',1,'setinteriorid 123',2,15),('2015-07-05 00:56:40',1,'unlock without key',1,16),('2015-08-03 21:36:27',1,'gotoint',5,17),('2015-08-03 21:38:04',1,'gotoint',5,18),('2015-08-03 21:39:50',1,'gotoint',5,19),('2015-08-03 21:44:49',2,'addinterior - id 1 - price $0 - name omfg',4,20),('2015-08-03 21:44:55',2,'delint',4,21),('2015-08-03 21:45:01',1,'gotoint',4,22),('2015-08-17 20:14:37',3,'addinterior - id 28 - price $0 - name Pig Pen',3,23),('2015-08-17 20:30:45',4,'addinterior - id 101 - price $0 - name Los Santos Police Department',3,24),('2015-09-10 20:59:33',1,'gotohouse',1,25),('2015-09-13 23:43:40',5,'addint - id 1 - price $0 - name House',1,26),('2015-09-15 16:02:11',3,'gotohouse',1,27),('2015-09-15 16:02:17',1,'gotohouse',1,28),('2015-09-15 16:33:24',1,'gotohouse',1,29),('2015-09-17 21:15:21',1,'gotohouse',1,30),('2015-09-24 14:00:02',1,'gotohouse',1,31),('2015-09-30 00:16:34',1,'gotohouse',1,32),('2015-09-30 00:18:13',4,'lock without key',1,33),('2015-11-18 18:21:46',1,'gotohouse',1,34),('2015-12-07 16:35:48',1,'gotohouse',1,35);
/*!40000 ALTER TABLE `interior_logs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `interiors`
--

DROP TABLE IF EXISTS `interiors`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `interiors` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `x` float DEFAULT '0',
  `y` float DEFAULT '0',
  `z` float DEFAULT '0',
  `type` int(1) DEFAULT '0',
  `owner` int(11) DEFAULT '-1',
  `locked` int(1) DEFAULT '0',
  `cost` int(11) DEFAULT '0',
  `name` text,
  `interior` int(5) DEFAULT '0',
  `interiorx` float DEFAULT '0',
  `interiory` float DEFAULT '0',
  `interiorz` float DEFAULT '0',
  `dimensionwithin` int(5) DEFAULT '0',
  `interiorwithin` int(5) DEFAULT '0',
  `angle` float DEFAULT '0',
  `angleexit` float DEFAULT '0',
  `supplies` int(11) DEFAULT '100',
  `safepositionX` float DEFAULT NULL,
  `safepositionY` float DEFAULT NULL,
  `safepositionZ` float DEFAULT NULL,
  `safepositionRZ` float DEFAULT NULL,
  `disabled` tinyint(3) unsigned DEFAULT '0',
  `lastused` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `deleted` varchar(45) NOT NULL DEFAULT '0',
  `adminnote` text,
  `createdDate` datetime DEFAULT NULL,
  `creator` varchar(45) DEFAULT NULL,
  `isLightOn` tinyint(4) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `interiors`
--

LOCK TABLES `interiors` WRITE;
/*!40000 ALTER TABLE `interiors` DISABLE KEYS */;
INSERT INTO `interiors` VALUES (1,2868.38,-2124.91,5.40358,0,2,0,0,'Nigger Shack',25,1920.57,-2327.92,13.75,0,0,0,275.577,100,NULL,NULL,NULL,NULL,0,'2016-02-28 14:40:39','0',NULL,'2015-07-05 00:48:18','FuckMe',0),(2,2681.7,2434.7,6.70312,0,-1,1,0,'omfg',3,975.26,-8.64,1001.14,0,0,90,285.849,100,NULL,NULL,NULL,NULL,0,'0000-00-00 00:00:00','Bean',NULL,'2015-08-03 21:44:49','Bean',0),(3,2421.56,-1219.25,25.5614,1,3,0,0,'Pig Pen',2,1204.81,-13.6,1000.92,0,0,0,1.20578,100,NULL,NULL,NULL,NULL,0,'2015-08-17 20:21:48','0',NULL,'2015-08-17 20:14:37','FrolicBeast',0),(4,1555.19,-1675.7,16.1953,2,0,1,0,'Los Santos Police Department',10,246.37,107.51,1003.21,0,0,0,273.577,100,NULL,NULL,NULL,NULL,0,'2015-09-30 00:17:22','0',NULL,'2015-08-17 20:30:45','FrolicBeast',0),(5,1194.59,-1316.97,13.3984,0,1,0,0,'House',3,975.26,-8.64,1001.14,0,0,90,244.925,100,NULL,NULL,NULL,NULL,0,'2015-09-13 23:45:20','0',NULL,'2015-09-13 23:43:40','TamFire',0);
/*!40000 ALTER TABLE `interiors` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `items`
--

DROP TABLE IF EXISTS `items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `items` (
  `index` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `type` tinyint(3) unsigned NOT NULL,
  `owner` int(10) unsigned NOT NULL,
  `itemID` int(10) NOT NULL,
  `itemValue` text NOT NULL,
  PRIMARY KEY (`index`)
) ENGINE=InnoDB AUTO_INCREMENT=461 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `items`
--

LOCK TABLES `items` WRITE;
/*!40000 ALTER TABLE `items` DISABLE KEYS */;
INSERT INTO `items` VALUES (1,1,1,16,'7'),(7,1,2,16,'116'),(8,1,2,17,'1'),(20,1,2,134,'250'),(52,1,2,4,'1'),(90,1,2,115,'24:mp9tN8brOv18Ov0t0ugZ:Deagle'),(91,1,2,116,'24:335:Ammo for Deagle'),(96,2,1,61,'1'),(97,2,1,85,'1'),(118,1,3,16,'101'),(119,1,3,17,'1'),(129,1,4,16,'18'),(130,1,4,17,'1'),(131,1,4,18,'1'),(133,1,5,16,'29'),(134,1,5,17,'1'),(135,1,5,18,'1'),(137,1,5,111,'1'),(141,2,1,3,'1'),(146,1,5,112,'Colonel - #100'),(159,1,4,115,'24:mp9BN8brm8gw0ugY08gZ:Deagle'),(160,1,4,116,'24:184:Ammo for Deagle'),(161,1,5,115,'24:mp9BN8br0vgq0ugY08gZ:Deagle'),(162,1,5,116,'24:414:Ammo for Deagle'),(167,2,2,3,'2'),(169,1,6,16,'249'),(170,1,6,17,'1'),(171,1,6,18,'1'),(178,1,3,5,'3'),(179,1,3,115,'24:mp98N8br08DV0HgVmugZ:Deagle'),(180,1,3,116,'24:0:Ammo for Deagle'),(181,1,7,16,'107'),(182,1,7,17,'1'),(185,1,7,134,'250'),(226,1,7,18,'1'),(234,1,3,116,'24:7:Ammo for Deagle'),(279,1,3,115,'8:mp98N8brOuDw08gVmugZ:Katana'),(280,1,3,116,'8:1:Ammo for Katana'),(286,1,7,115,'31:mp9qN8br08cY08gVmugZ:M4'),(287,1,7,116,'31:0:Ammo for M4'),(288,1,7,116,'31:0:Ammo for M4'),(290,1,7,116,'31:0:Ammo for M4'),(291,1,7,116,'31:0:Ammo for M4'),(295,1,7,116,'31:0:Ammo for M4'),(296,1,7,116,'31:0:Ammo for M4'),(298,1,7,116,'31:0:Ammo for M4'),(299,1,7,116,'31:0:Ammo for M4'),(301,1,7,116,'31:22:Ammo for M4'),(302,1,7,116,'31:50:Ammo for M4'),(303,1,7,116,'31:50:Ammo for M4'),(304,1,7,116,'31:50:Ammo for M4'),(305,1,7,116,'31:50:Ammo for M4'),(306,1,7,116,'31:50:Ammo for M4'),(307,1,7,116,'31:50:Ammo for M4'),(308,1,7,116,'31:7:Ammo for M4'),(309,1,7,116,'31:3:Ammo for M4'),(310,1,7,116,'31:50:Ammo for M4'),(311,1,7,116,'31:50:Ammo for M4'),(312,1,7,115,'35:mp9qN8br0v0R08gVmugZ:Rocket Launcher'),(313,1,7,116,'35:4:Ammo for Rocket Launcher'),(314,1,7,116,'35:5:Ammo for Rocket Launcher'),(315,1,7,116,'35:5:Ammo for Rocket Launcher'),(316,1,7,116,'35:5:Ammo for Rocket Launcher'),(317,1,7,116,'35:5:Ammo for Rocket Launcher'),(318,1,7,116,'35:5:Ammo for Rocket Launcher'),(319,1,7,116,'35:5:Ammo for Rocket Launcher'),(320,1,7,116,'35:5:Ammo for Rocket Launcher'),(321,1,7,116,'35:5:Ammo for Rocket Launcher'),(322,1,7,116,'35:5:Ammo for Rocket Launcher'),(323,1,7,116,'35:5:Ammo for Rocket Launcher'),(324,1,7,116,'35:5:Ammo for Rocket Launcher'),(325,1,7,116,'35:5:Ammo for Rocket Launcher'),(326,1,7,116,'35:5:Ammo for Rocket Launcher'),(327,1,7,116,'35:5:Ammo for Rocket Launcher'),(328,1,7,116,'35:5:Ammo for Rocket Launcher'),(329,1,7,116,'35:5:Ammo for Rocket Launcher'),(330,1,7,116,'35:5:Ammo for Rocket Launcher'),(331,1,7,116,'35:5:Ammo for Rocket Launcher'),(332,1,7,116,'35:5:Ammo for Rocket Launcher'),(333,1,7,116,'35:5:Ammo for Rocket Launcher'),(334,1,7,116,'35:5:Ammo for Rocket Launcher'),(335,1,7,116,'35:5:Ammo for Rocket Launcher'),(336,1,7,116,'35:5:Ammo for Rocket Launcher'),(337,1,6,134,'200'),(352,1,1,4,'5'),(353,1,8,16,'7'),(354,1,8,17,'1'),(355,1,8,18,'1'),(356,1,8,134,'250'),(371,1,3,134,'250'),(389,1,5,134,'250'),(395,1,4,6,'1337'),(396,1,4,2,'1337'),(397,1,5,2,'777'),(398,1,4,111,'1'),(402,1,4,71,'92'),(440,1,1,115,'22:mt9ZN8br0HQwmuhV0HhZ:Colt 45'),(444,1,1,116,'22:17:Ammo for Colt 45'),(445,1,1,116,'22:17:Ammo for Colt 45'),(446,1,1,116,'22:12:Ammo for Colt 45'),(447,1,1,116,'22:15:Ammo for Colt 45'),(448,1,1,116,'22:13:Ammo for Colt 45'),(449,2,7,85,'1'),(450,2,7,61,'1'),(452,2,7,3,'7'),(453,1,1,37,'1 gram(s)'),(460,1,1,134,'2956');
/*!40000 ALTER TABLE `items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `jobs`
--

DROP TABLE IF EXISTS `jobs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `jobs` (
  `jobID` int(11) DEFAULT '0',
  `jobCharID` int(11) DEFAULT '-1',
  `jobLevel` int(11) DEFAULT '1',
  `jobProgress` int(11) DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Saves job info, skill level and progress - Maxime';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `jobs`
--

LOCK TABLES `jobs` WRITE;
/*!40000 ALTER TABLE `jobs` DISABLE KEYS */;
/*!40000 ALTER TABLE `jobs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `logtable`
--

DROP TABLE IF EXISTS `logtable`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `logtable` (
  `time` datetime NOT NULL,
  `action` int(2) NOT NULL,
  `source` varchar(12) NOT NULL,
  `affected` text NOT NULL,
  `content` text
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `logtable`
--

LOCK TABLES `logtable` WRITE;
/*!40000 ALTER TABLE `logtable` DISABLE KEYS */;
/*!40000 ALTER TABLE `logtable` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lottery`
--

DROP TABLE IF EXISTS `lottery`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `lottery` (
  `characterid` int(255) NOT NULL,
  `ticketnumber` int(3) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `lottery`
--

LOCK TABLES `lottery` WRITE;
/*!40000 ALTER TABLE `lottery` DISABLE KEYS */;
/*!40000 ALTER TABLE `lottery` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `marijuanaplants`
--

DROP TABLE IF EXISTS `marijuanaplants`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `marijuanaplants` (
  `id` int(11) DEFAULT NULL,
  `timer` int(2) DEFAULT '24',
  `day` int(2) DEFAULT '1',
  `grams` float DEFAULT '0',
  `createdby` text,
  `x` float DEFAULT NULL,
  `y` float DEFAULT NULL,
  `z` float DEFAULT NULL,
  `rx` float DEFAULT NULL,
  `ry` float DEFAULT NULL,
  `rz` float DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `marijuanaplants`
--

LOCK TABLES `marijuanaplants` WRITE;
/*!40000 ALTER TABLE `marijuanaplants` DISABLE KEYS */;
/*!40000 ALTER TABLE `marijuanaplants` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mdcusers`
--

DROP TABLE IF EXISTS `mdcusers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `mdcusers` (
  `user_name` varchar(20) NOT NULL,
  `password` varchar(20) NOT NULL DEFAULT '123',
  `high_command` int(1) DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mdcusers`
--

LOCK TABLES `mdcusers` WRITE;
/*!40000 ALTER TABLE `mdcusers` DISABLE KEYS */;
INSERT INTO `mdcusers` VALUES ('tam','password',1);
/*!40000 ALTER TABLE `mdcusers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `objects`
--

DROP TABLE IF EXISTS `objects`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `objects` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `model` int(6) NOT NULL DEFAULT '0',
  `posX` float(12,7) NOT NULL DEFAULT '0.0000000',
  `posY` float(12,7) NOT NULL DEFAULT '0.0000000',
  `posZ` float(12,7) NOT NULL DEFAULT '0.0000000',
  `rotX` float(12,7) NOT NULL DEFAULT '0.0000000',
  `rotY` float(12,7) NOT NULL DEFAULT '0.0000000',
  `rotZ` float(12,7) NOT NULL DEFAULT '0.0000000',
  `interior` int(5) NOT NULL,
  `dimension` int(5) NOT NULL,
  `comment` varchar(50) DEFAULT NULL,
  `solid` int(1) NOT NULL DEFAULT '1',
  `doublesided` int(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `objects`
--

LOCK TABLES `objects` WRITE;
/*!40000 ALTER TABLE `objects` DISABLE KEYS */;
/*!40000 ALTER TABLE `objects` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `paynspray`
--

DROP TABLE IF EXISTS `paynspray`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `paynspray` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `x` decimal(10,6) DEFAULT '0.000000',
  `y` decimal(10,6) DEFAULT '0.000000',
  `z` decimal(10,6) DEFAULT '0.000000',
  `dimension` int(5) DEFAULT '0',
  `interior` int(5) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `paynspray`
--

LOCK TABLES `paynspray` WRITE;
/*!40000 ALTER TABLE `paynspray` DISABLE KEYS */;
INSERT INTO `paynspray` VALUES (1,2065.025391,-1831.480469,13.546875,0,0),(2,263.181641,-2053.112305,3084.600586,0,0);
/*!40000 ALTER TABLE `paynspray` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pd_tickets`
--

DROP TABLE IF EXISTS `pd_tickets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pd_tickets` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `vehid` int(11) NOT NULL,
  `reason` text NOT NULL,
  `amount` int(11) NOT NULL,
  `issuer` int(11) DEFAULT NULL,
  `time` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`id`,`time`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pd_tickets`
--

LOCK TABLES `pd_tickets` WRITE;
/*!40000 ALTER TABLE `pd_tickets` DISABLE KEYS */;
/*!40000 ALTER TABLE `pd_tickets` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `phone_contacts`
--

DROP TABLE IF EXISTS `phone_contacts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `phone_contacts` (
  `phone` bigint(20) NOT NULL,
  `entryName` varchar(50) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
  `entryNumber` bigint(20) NOT NULL,
  `entryEmail` varchar(60) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
  `entryAddress` varchar(100) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
  `entryFavorited` tinyint(4) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `phone_contacts`
--

LOCK TABLES `phone_contacts` WRITE;
/*!40000 ALTER TABLE `phone_contacts` DISABLE KEYS */;
/*!40000 ALTER TABLE `phone_contacts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `phone_history`
--

DROP TABLE IF EXISTS `phone_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `phone_history` (
  `targetNumber` bigint(20) NOT NULL,
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `duration` int(11) NOT NULL DEFAULT '0',
  `cost` float NOT NULL DEFAULT '0',
  `date2` varchar(20) COLLATE utf8_unicode_ci NOT NULL,
  `ownNumber` bigint(20) NOT NULL,
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `flow` tinyint(4) NOT NULL DEFAULT '1',
  UNIQUE KEY `ID_UNIQUE` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `phone_history`
--

LOCK TABLES `phone_history` WRITE;
/*!40000 ALTER TABLE `phone_history` DISABLE KEYS */;
/*!40000 ALTER TABLE `phone_history` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `phone_settings`
--

DROP TABLE IF EXISTS `phone_settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `phone_settings` (
  `phonenumber` int(1) NOT NULL,
  `turnedon` smallint(1) unsigned NOT NULL DEFAULT '1',
  `secretnumber` smallint(1) unsigned NOT NULL DEFAULT '0',
  `ringtone` smallint(1) NOT NULL DEFAULT '1',
  `phonebook` varchar(40) DEFAULT NULL,
  `boughtby` int(11) NOT NULL DEFAULT '-1',
  PRIMARY KEY (`phonenumber`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `phone_settings`
--

LOCK TABLES `phone_settings` WRITE;
/*!40000 ALTER TABLE `phone_settings` DISABLE KEYS */;
INSERT INTO `phone_settings` VALUES (777,1,0,1,NULL,-1),(1337,1,0,1,NULL,-1);
/*!40000 ALTER TABLE `phone_settings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `phone_sms`
--

DROP TABLE IF EXISTS `phone_sms`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `phone_sms` (
  `targetNumber` bigint(20) NOT NULL,
  `content` varchar(201) COLLATE utf8_unicode_ci NOT NULL,
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `opened` tinyint(4) NOT NULL DEFAULT '0',
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `myNumber` bigint(20) NOT NULL,
  `flow` int(11) NOT NULL DEFAULT '1',
  UNIQUE KEY `ID_UNIQUE` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `phone_sms`
--

LOCK TABLES `phone_sms` WRITE;
/*!40000 ALTER TABLE `phone_sms` DISABLE KEYS */;
/*!40000 ALTER TABLE `phone_sms` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `publicphones`
--

DROP TABLE IF EXISTS `publicphones`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `publicphones` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `x` float NOT NULL,
  `y` float NOT NULL,
  `z` float NOT NULL,
  `dimension` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `publicphones`
--

LOCK TABLES `publicphones` WRITE;
/*!40000 ALTER TABLE `publicphones` DISABLE KEYS */;
/*!40000 ALTER TABLE `publicphones` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `settings`
--

DROP TABLE IF EXISTS `settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `settings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` text,
  `value` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `settings`
--

LOCK TABLES `settings` WRITE;
/*!40000 ALTER TABLE `settings` DISABLE KEYS */;
INSERT INTO `settings` VALUES (1,'tax','15'),(2,'incometax','10'),(3,'motd','Welcome to UnitedGaming!'),(4,'amotd','Don\'t be fuckin\' retarted'),(5,'releasePos','1'),(6,'lottery','1000'),(7,'globalsupplies','10000');
/*!40000 ALTER TABLE `settings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `shop_contacts_info`
--

DROP TABLE IF EXISTS `shop_contacts_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `shop_contacts_info` (
  `npcID` int(11) NOT NULL,
  `sOwner` text,
  `sPhone` text,
  `sEmail` text,
  `sForum` text,
  PRIMARY KEY (`npcID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Saves data about business''s owners in shop system - MAXIME';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `shop_contacts_info`
--

LOCK TABLES `shop_contacts_info` WRITE;
/*!40000 ALTER TABLE `shop_contacts_info` DISABLE KEYS */;
/*!40000 ALTER TABLE `shop_contacts_info` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `shop_products`
--

DROP TABLE IF EXISTS `shop_products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `shop_products` (
  `npcID` int(11) DEFAULT NULL,
  `pItemID` int(11) DEFAULT NULL,
  `pItemValue` text,
  `pDesc` text,
  `pPrice` text,
  `pDate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `pID` int(11) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`pID`),
  UNIQUE KEY `pID_UNIQUE` (`pID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Saves on-sale products from players, business system by Maxime ';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `shop_products`
--

LOCK TABLES `shop_products` WRITE;
/*!40000 ALTER TABLE `shop_products` DISABLE KEYS */;
/*!40000 ALTER TABLE `shop_products` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `shops`
--

DROP TABLE IF EXISTS `shops`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `shops` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `x` float DEFAULT '0',
  `y` float DEFAULT '0',
  `z` float DEFAULT '0',
  `dimension` int(5) DEFAULT '0',
  `interior` int(5) DEFAULT '0',
  `shoptype` tinyint(4) DEFAULT '0',
  `rotation` float NOT NULL DEFAULT '0',
  `skin` int(11) DEFAULT '-1',
  `sPendingWage` int(11) NOT NULL DEFAULT '0',
  `sIncome` bigint(20) NOT NULL DEFAULT '0',
  `sCapacity` int(11) NOT NULL DEFAULT '10',
  `sSales` varchar(5000) NOT NULL DEFAULT '',
  `pedName` text,
  `deletedBy` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `shops`
--

LOCK TABLES `shops` WRITE;
/*!40000 ALTER TABLE `shops` DISABLE KEYS */;
INSERT INTO `shops` VALUES (1,1216.67,-15.2617,1000.92,3,2,9,30,-1,0,0,10,'',NULL,3),(2,1216.63,-15.2607,1000.92,3,2,9,360,-1,0,0,10,'',NULL,0),(3,1946.95,-1741.47,13.5469,0,0,16,60,217,0,0,10,'',NULL,6),(4,1216.72,-6.36719,1001.33,3,2,14,240,217,0,0,10,'',NULL,6),(5,2813.91,-2113.93,11.0064,0,0,16,180,-1,0,0,10,'',NULL,0),(7,2813.15,-2109.91,11.0938,0,0,1,180,-1,0,0,10,'',NULL,0);
/*!40000 ALTER TABLE `shops` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `speedcams`
--

DROP TABLE IF EXISTS `speedcams`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `speedcams` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `x` float(11,7) NOT NULL DEFAULT '0.0000000',
  `y` float(11,7) NOT NULL DEFAULT '0.0000000',
  `z` float(11,7) NOT NULL DEFAULT '0.0000000',
  `interior` int(3) NOT NULL DEFAULT '0' COMMENT 'Stores the location of the pernament speedcams',
  `dimension` int(5) NOT NULL DEFAULT '0',
  `maxspeed` int(4) NOT NULL DEFAULT '120',
  `radius` int(4) NOT NULL DEFAULT '2',
  `enabled` smallint(1) DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `speedcams`
--

LOCK TABLES `speedcams` WRITE;
/*!40000 ALTER TABLE `speedcams` DISABLE KEYS */;
/*!40000 ALTER TABLE `speedcams` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `speedingviolations`
--

DROP TABLE IF EXISTS `speedingviolations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `speedingviolations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `carID` int(11) NOT NULL,
  `time` datetime NOT NULL,
  `speed` int(5) NOT NULL,
  `area` varchar(50) NOT NULL,
  `personVisible` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `speedingviolations`
--

LOCK TABLES `speedingviolations` WRITE;
/*!40000 ALTER TABLE `speedingviolations` DISABLE KEYS */;
/*!40000 ALTER TABLE `speedingviolations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `stats`
--

DROP TABLE IF EXISTS `stats`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `stats` (
  `district` varchar(45) NOT NULL,
  `deaths` double DEFAULT '0',
  PRIMARY KEY (`district`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `stats`
--

LOCK TABLES `stats` WRITE;
/*!40000 ALTER TABLE `stats` DISABLE KEYS */;
/*!40000 ALTER TABLE `stats` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `suspectcrime`
--

DROP TABLE IF EXISTS `suspectcrime`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `suspectcrime` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `suspect_name` text,
  `time` text,
  `date` text,
  `officers` text,
  `ticket` int(11) DEFAULT NULL,
  `arrest` int(11) DEFAULT NULL,
  `fine` int(11) DEFAULT NULL,
  `ticket_price` text,
  `arrest_price` text,
  `fine_price` text,
  `illegal_items` text,
  `details` text,
  `done_by` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `suspectcrime`
--

LOCK TABLES `suspectcrime` WRITE;
/*!40000 ALTER TABLE `suspectcrime` DISABLE KEYS */;
/*!40000 ALTER TABLE `suspectcrime` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `suspectdetails`
--

DROP TABLE IF EXISTS `suspectdetails`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `suspectdetails` (
  `suspect_name` text,
  `birth` text,
  `gender` text,
  `ethnicy` text,
  `cell` int(5) DEFAULT '0',
  `occupation` text,
  `address` text,
  `other` text,
  `is_wanted` int(1) DEFAULT '0',
  `wanted_reason` text,
  `wanted_punishment` text,
  `wanted_by` text,
  `photo` text,
  `done_by` text
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `suspectdetails`
--

LOCK TABLES `suspectdetails` WRITE;
/*!40000 ALTER TABLE `suspectdetails` DISABLE KEYS */;
INSERT INTO `suspectdetails` VALUES ('Tyrone_Lawrence','','Male','',0,'','\n','Clothes, facial features, etc.\n',0,'None','None','None','007','tam');
/*!40000 ALTER TABLE `suspectdetails` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tags`
--

DROP TABLE IF EXISTS `tags`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tags` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `x` decimal(10,6) DEFAULT NULL,
  `y` decimal(10,6) DEFAULT NULL,
  `z` decimal(10,6) DEFAULT NULL,
  `interior` int(5) DEFAULT NULL,
  `dimension` int(5) DEFAULT NULL,
  `rx` decimal(10,6) DEFAULT NULL,
  `ry` decimal(10,6) DEFAULT NULL,
  `rz` decimal(10,6) DEFAULT NULL,
  `modelid` int(5) DEFAULT NULL,
  `creationdate` datetime DEFAULT NULL,
  `creator` int(11) NOT NULL DEFAULT '-1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tags`
--

LOCK TABLES `tags` WRITE;
/*!40000 ALTER TABLE `tags` DISABLE KEYS */;
/*!40000 ALTER TABLE `tags` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tc_comments`
--

DROP TABLE IF EXISTS `tc_comments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tc_comments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `poster` int(11) NOT NULL,
  `ip` varchar(50) NOT NULL,
  `message` text NOT NULL,
  `posted` int(25) NOT NULL,
  `type` int(1) NOT NULL,
  `ticket` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tc_comments`
--

LOCK TABLES `tc_comments` WRITE;
/*!40000 ALTER TABLE `tc_comments` DISABLE KEYS */;
/*!40000 ALTER TABLE `tc_comments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tc_tickets`
--

DROP TABLE IF EXISTS `tc_tickets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tc_tickets` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `creator` int(11) NOT NULL,
  `posted` int(25) NOT NULL,
  `subject` varchar(100) NOT NULL,
  `message` text NOT NULL,
  `status` int(1) NOT NULL,
  `lastpost` int(25) NOT NULL,
  `assigned` int(11) NOT NULL,
  `IP` varchar(50) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tc_tickets`
--

LOCK TABLES `tc_tickets` WRITE;
/*!40000 ALTER TABLE `tc_tickets` DISABLE KEYS */;
/*!40000 ALTER TABLE `tc_tickets` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tempinteriors`
--

DROP TABLE IF EXISTS `tempinteriors`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tempinteriors` (
  `id` int(11) NOT NULL,
  `posX` float NOT NULL,
  `posY` float DEFAULT NULL,
  `posZ` float DEFAULT NULL,
  `interior` int(5) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tempinteriors`
--

LOCK TABLES `tempinteriors` WRITE;
/*!40000 ALTER TABLE `tempinteriors` DISABLE KEYS */;
/*!40000 ALTER TABLE `tempinteriors` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tempobjects`
--

DROP TABLE IF EXISTS `tempobjects`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tempobjects` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `model` int(6) NOT NULL DEFAULT '0',
  `posX` float(12,7) NOT NULL DEFAULT '0.0000000',
  `posY` float(12,7) NOT NULL DEFAULT '0.0000000',
  `posZ` float(12,7) NOT NULL DEFAULT '0.0000000',
  `rotX` float(12,7) NOT NULL DEFAULT '0.0000000',
  `rotY` float(12,7) NOT NULL DEFAULT '0.0000000',
  `rotZ` float(12,7) NOT NULL DEFAULT '0.0000000',
  `interior` int(5) NOT NULL,
  `dimension` int(5) NOT NULL,
  `comment` varchar(50) DEFAULT NULL,
  `solid` int(1) NOT NULL DEFAULT '1',
  `doublesided` int(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tempobjects`
--

LOCK TABLES `tempobjects` WRITE;
/*!40000 ALTER TABLE `tempobjects` DISABLE KEYS */;
/*!40000 ALTER TABLE `tempobjects` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ticketreplies`
--

DROP TABLE IF EXISTS `ticketreplies`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ticketreplies` (
  `rid` int(11) NOT NULL AUTO_INCREMENT,
  `tid` int(11) NOT NULL,
  `text` text NOT NULL,
  `by` text NOT NULL,
  `rank` int(11) NOT NULL,
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`rid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ticketreplies`
--

LOCK TABLES `ticketreplies` WRITE;
/*!40000 ALTER TABLE `ticketreplies` DISABLE KEYS */;
/*!40000 ALTER TABLE `ticketreplies` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tickets`
--

DROP TABLE IF EXISTS `tickets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tickets` (
  `tid` int(11) NOT NULL AUTO_INCREMENT,
  `uid` int(11) NOT NULL,
  `name` text NOT NULL,
  `status` text NOT NULL,
  `subject` text NOT NULL,
  `assigned` text NOT NULL,
  `priority` text NOT NULL,
  `username` text NOT NULL,
  `gamename` text NOT NULL,
  `text` text NOT NULL,
  PRIMARY KEY (`tid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tickets`
--

LOCK TABLES `tickets` WRITE;
/*!40000 ALTER TABLE `tickets` DISABLE KEYS */;
/*!40000 ALTER TABLE `tickets` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `vehicle_logs`
--

DROP TABLE IF EXISTS `vehicle_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `vehicle_logs` (
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `vehID` int(11) DEFAULT NULL,
  `action` text,
  `actor` int(11) DEFAULT NULL,
  `log_id` int(11) NOT NULL AUTO_INCREMENT,
  UNIQUE KEY `log_id_UNIQUE` (`log_id`)
) ENGINE=InnoDB AUTO_INCREMENT=374 DEFAULT CHARSET=utf8 COMMENT='Stores all admin actions on vehicles - Monitored by Vehicle Manager - Maxime';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vehicle_logs`
--

LOCK TABLES `vehicle_logs` WRITE;
/*!40000 ALTER TABLE `vehicle_logs` DISABLE KEYS */;
INSERT INTO `vehicle_logs` VALUES ('2015-07-02 21:10:17',-1,'fixveh',1,1),('2015-07-02 21:11:03',-1,'unflip',1,2),('2015-07-02 21:11:04',-1,'fixveh',1,3),('2015-07-02 21:11:04',-1,'fixveh',1,4),('2015-07-02 21:13:07',-1,'fixveh',1,5),('2015-07-05 00:09:24',-1,'fixveh',1,6),('2015-07-05 00:09:26',-1,'fixveh',1,7),('2015-07-05 00:12:24',-3,'fixveh',1,8),('2015-07-05 00:12:56',-3,'fixveh',1,9),('2015-07-05 00:13:30',-3,'fixveh',1,10),('2015-07-05 00:13:50',-2,'fixveh',2,11),('2015-07-05 00:15:21',-3,'fixveh',1,12),('2015-07-05 00:15:45',-3,'fixveh',1,13),('2015-07-05 00:15:53',-3,'fixveh',1,14),('2015-07-05 00:15:59',-3,'fixveh',1,15),('2015-07-05 00:16:27',-2,'fixveh',2,16),('2015-07-05 00:17:03',-3,'fixveh',1,17),('2015-07-05 00:17:07',-3,'fixveh',1,18),('2015-07-05 00:17:17',-3,'fixveh',1,19),('2015-07-05 00:17:19',-3,'fixveh',1,20),('2015-07-05 00:17:53',-2,'fixveh',2,21),('2015-07-05 00:18:25',-3,'fixveh',1,22),('2015-07-05 00:18:25',-3,'fixveh',1,23),('2015-07-05 00:18:25',-3,'fixveh',1,24),('2015-07-05 00:18:29',-3,'fixveh',1,25),('2015-07-05 00:19:11',-3,'fixveh',1,26),('2015-07-05 00:19:13',-3,'fixveh',1,27),('2015-07-05 00:19:18',-3,'fixveh',1,28),('2015-07-05 00:19:21',-3,'fixveh',1,29),('2015-07-05 00:19:49',-3,'fixveh',1,30),('2015-07-05 00:19:54',-3,'fixveh',1,31),('2015-07-05 00:20:17',-3,'fixveh',1,32),('2015-07-05 00:20:32',-3,'fixveh',1,33),('2015-07-05 00:20:32',-3,'fixveh',1,34),('2015-07-05 00:21:23',-3,'fixveh',1,35),('2015-07-05 00:21:50',-3,'unflip',1,36),('2015-07-05 00:21:51',-3,'fixveh',1,37),('2015-07-05 00:21:59',-3,'fixveh',1,38),('2015-07-05 00:22:16',-3,'fixveh',1,39),('2015-07-05 00:22:17',-3,'fixveh',1,40),('2015-07-05 00:22:25',-3,'sell to Tyrone_Lawrence',1,41),('2015-07-05 00:22:35',-3,'fixveh',1,42),('2015-07-05 00:22:46',-3,'fixveh',1,43),('2015-07-05 00:23:10',-3,'fixveh',1,44),('2015-07-05 00:23:38',-3,'fixveh',1,45),('2015-07-05 00:23:52',-3,'fixveh',1,46),('2015-07-05 00:23:52',-2,'fixveh',2,47),('2015-07-05 00:24:01',-3,'fixveh',1,48),('2015-07-05 00:26:08',-3,'fixveh',1,49),('2015-07-05 00:26:51',-3,'fixveh',1,50),('2015-07-05 00:34:36',-4,'fixveh',1,51),('2015-07-05 00:34:36',-4,'fixveh',1,52),('2015-07-05 00:34:36',-4,'fixveh',1,53),('2015-07-05 00:34:36',-4,'fixveh',1,54),('2015-07-05 00:38:11',-6,'fixveh',1,55),('2015-07-05 00:39:21',-6,'fixveh',1,56),('2015-07-05 00:39:46',-6,'fixveh',1,57),('2015-07-05 00:41:14',-6,'fixveh',1,58),('2015-07-05 00:41:14',-6,'fixveh',1,59),('2015-07-05 01:12:15',-9,'fixveh',1,60),('2015-07-05 01:12:25',-9,'fixveh',1,61),('2015-07-05 01:12:57',-9,'fixveh',1,62),('2015-07-05 01:12:57',-9,'fixveh',1,63),('2015-07-05 01:14:56',-10,'fixveh',1,64),('2015-07-05 01:14:58',-10,'fixveh',1,65),('2015-07-05 01:15:01',-10,'fixveh',1,66),('2015-07-05 01:16:10',-10,'fixveh',1,67),('2015-07-05 01:17:25',-10,'entercar Tyrone Lawrence',1,68),('2015-07-05 15:27:23',1,'makeveh Police LS ($0 - to Tyrone_Lawrence)',1,69),('2015-07-05 15:28:44',1,'fixveh',1,70),('2015-07-05 15:30:52',1,'fixveh',1,71),('2015-07-05 15:31:36',1,'fixveh',1,72),('2015-07-05 15:31:36',1,'fixveh',1,73),('2015-07-05 15:32:14',1,'fixveh',1,74),('2015-07-05 15:32:23',1,'fixveh',1,75),('2015-07-05 15:32:57',1,'fixveh',1,76),('2015-07-05 15:33:16',1,'fixveh',1,77),('2015-07-05 15:33:18',1,'fixveh',1,78),('2015-07-05 15:33:24',1,'fixveh',1,79),('2015-07-05 15:33:32',1,'fixveh',1,80),('2015-07-05 15:33:49',1,'fixveh',1,81),('2015-07-05 15:33:53',1,'fixveh',1,82),('2015-07-05 15:34:01',1,'fixveh',1,83),('2015-07-05 15:34:24',1,'fixveh',1,84),('2015-07-05 15:34:32',1,'fixveh',1,85),('2015-07-05 15:34:48',1,'fixveh',1,86),('2015-07-05 15:37:10',1,'fixveh',1,87),('2015-07-05 15:37:19',1,'fixveh',1,88),('2015-07-05 15:37:21',1,'unflip',1,89),('2015-07-05 15:37:25',1,'fixveh',1,90),('2015-07-05 15:47:37',1,'fixveh',1,91),('2015-07-05 15:47:48',1,'fixveh',1,92),('2015-07-05 15:48:09',1,'fixveh',1,93),('2015-07-05 15:48:29',1,'fixveh',1,94),('2015-07-05 15:49:54',1,'fixveh',1,95),('2015-07-05 15:50:53',1,'fixveh',1,96),('2015-07-05 15:50:54',1,'fixveh',1,97),('2015-07-05 15:51:11',1,'fixveh',1,98),('2015-07-05 15:51:14',1,'fixveh',1,99),('2015-07-05 15:51:18',1,'fixveh',1,100),('2015-07-05 15:51:50',1,'fixveh',1,101),('2015-07-05 15:53:01',1,'fixveh',1,102),('2015-07-05 15:53:03',1,'fixveh',1,103),('2015-07-05 15:53:04',1,'fixveh',1,104),('2015-07-05 15:53:04',1,'fixveh',1,105),('2015-07-05 15:54:02',1,'fixveh',1,106),('2015-07-05 15:54:06',1,'fixveh',1,107),('2015-07-05 15:55:50',1,'fixveh',1,108),('2015-07-05 15:56:21',1,'fixveh',1,109),('2015-07-05 15:56:21',1,'fixveh',1,110),('2015-07-05 15:56:34',1,'gotocar',1,111),('2015-07-05 15:56:42',1,'fixveh',1,112),('2015-07-05 15:57:35',1,'unflip',1,113),('2015-07-05 15:57:36',1,'fixveh',1,114),('2015-07-05 15:57:41',1,'unflip',1,115),('2015-07-05 15:57:42',1,'fixveh',1,116),('2015-07-05 15:57:42',1,'fixveh',1,117),('2015-07-05 15:57:48',1,'fixveh',1,118),('2015-07-05 15:58:13',1,'fixveh',1,119),('2015-07-05 15:58:21',1,'fixveh',1,120),('2015-07-05 15:58:25',1,'fixveh',1,121),('2015-07-05 15:58:40',1,'fixveh',1,122),('2015-07-05 15:58:44',1,'fixveh',1,123),('2015-07-05 15:58:48',1,'fixveh',1,124),('2015-07-05 15:58:53',1,'fixveh',1,125),('2015-07-05 15:58:53',1,'fixveh',1,126),('2015-07-05 15:58:59',1,'fixveh',1,127),('2015-07-05 15:59:04',1,'fixveh',1,128),('2015-07-05 15:59:06',1,'unflip',1,129),('2015-07-05 15:59:06',1,'fixveh',1,130),('2015-07-05 15:59:25',1,'gotocar',1,131),('2015-07-05 15:59:31',1,'unflip',1,132),('2015-07-05 15:59:32',1,'fixveh',1,133),('2015-07-05 15:59:35',1,'fixveh',1,134),('2015-07-05 15:59:46',1,'fixveh',1,135),('2015-07-05 16:00:11',1,'getcar',1,136),('2015-07-05 16:00:17',1,'fixveh',1,137),('2015-07-05 16:00:22',1,'fixveh',1,138),('2015-07-05 16:00:31',1,'fixveh',1,139),('2015-07-05 16:00:48',1,'park',1,140),('2015-07-05 16:00:59',1,'fixveh',1,141),('2015-07-05 16:01:17',1,'fixveh',1,142),('2015-07-05 16:01:28',1,'fixveh',1,143),('2015-07-05 16:01:51',1,'fixveh',1,144),('2015-07-05 16:02:06',1,'fixveh',1,145),('2015-07-05 16:02:18',1,'fixveh',1,146),('2015-07-05 16:02:30',1,'fixveh',1,147),('2015-07-05 16:02:48',1,'unflip',1,148),('2015-07-05 16:02:49',1,'fixveh',1,149),('2015-07-05 16:03:03',1,'fixveh',1,150),('2015-07-05 16:03:10',1,'fixveh',1,151),('2015-07-05 16:03:14',1,'fixveh',1,152),('2015-07-05 16:03:19',1,'fixveh',1,153),('2015-07-05 16:03:43',1,'getcar',1,154),('2015-07-05 16:03:48',1,'fixveh',1,155),('2015-07-05 16:04:11',1,'unflip',1,156),('2015-07-05 16:04:11',1,'fixveh',1,157),('2015-07-08 19:37:27',1,'fixveh',1,158),('2015-07-08 19:38:06',1,'fixveh',1,159),('2015-07-08 19:38:57',1,'fixveh',1,160),('2015-07-08 19:39:12',1,'unflip',1,161),('2015-07-08 19:39:13',1,'fixveh',1,162),('2015-07-08 19:39:42',1,'fixveh',1,163),('2015-07-08 19:40:16',1,'fixveh',1,164),('2015-07-08 19:41:30',1,'fixveh',1,165),('2015-07-29 21:17:45',-1,'fixveh',1,166),('2015-07-29 21:18:14',-1,'fixveh',1,167),('2015-07-29 21:18:56',-1,'unflip',1,168),('2015-07-29 21:18:57',-1,'fixveh',1,169),('2015-07-29 21:35:01',-2,'fixveh',1,170),('2015-07-29 21:35:18',-2,'fixveh',1,171),('2015-07-29 21:35:34',-2,'fixveh',1,172),('2015-07-29 21:35:52',-2,'fixveh',1,173),('2015-07-29 21:36:12',-2,'fixveh',1,174),('2015-07-29 21:37:19',-2,'fixveh',1,175),('2015-07-29 21:37:35',-2,'fixveh',1,176),('2015-07-29 21:38:17',-2,'fixveh',1,177),('2015-07-29 21:38:20',-2,'fixveh',1,178),('2015-07-29 21:41:10',-2,'fixveh',1,179),('2015-07-29 21:41:24',-2,'fixveh',1,180),('2015-07-29 21:41:28',-2,'fixveh',1,181),('2015-07-29 21:42:06',-2,'fixveh',1,182),('2015-07-29 21:42:31',-2,'fixveh',1,183),('2015-07-29 21:43:00',-2,'fixveh',1,184),('2015-08-02 14:22:30',-1,'fixveh',1,185),('2015-08-02 14:22:49',-1,'fixveh',1,186),('2015-08-02 14:23:43',-1,'fixveh',1,187),('2015-08-02 14:51:12',2,'makeveh Sultan ($0 - to Nicholas_Fletcher)',3,188),('2015-08-02 14:51:29',2,'gotocar',1,189),('2015-08-03 21:36:30',-4,'unflip',4,190),('2015-08-03 21:38:18',1,'fixveh',1,191),('2015-08-03 21:38:28',-8,'getcar',5,192),('2015-08-03 21:38:29',-8,'getcar',5,193),('2015-08-03 21:39:59',1,'entercar Moon Man',5,194),('2015-08-03 21:40:00',1,'entercar Moon Man',5,195),('2015-08-03 21:40:01',1,'entercar Moon Man',5,196),('2015-08-03 21:40:02',1,'entercar Moon Man',4,197),('2015-08-03 21:40:10',1,'fixveh',1,198),('2015-08-03 21:40:43',1,'fixveh',1,199),('2015-08-03 21:41:30',1,'fixveh',1,200),('2015-08-03 21:41:56',1,'fixveh',1,201),('2015-08-03 21:42:22',1,'fixveh',1,202),('2015-08-03 21:42:48',1,'fixveh',1,203),('2015-08-03 21:43:00',1,'fixveh',1,204),('2015-08-03 21:43:13',1,'fixveh',1,205),('2015-08-03 21:43:31',1,'fixveh',1,206),('2015-08-03 21:43:32',1,'fixveh',1,207),('2015-08-03 21:45:07',1,'fixveh',1,208),('2015-08-03 21:45:11',-10,'gotocar',4,209),('2015-08-03 21:45:25',-11,'entercar Dopehouse Niggler',4,210),('2015-08-03 21:47:15',1,'getcar',1,211),('2015-08-03 21:47:46',1,'fixveh',1,212),('2015-08-03 21:49:52',1,'fixveh',1,213),('2015-08-03 21:50:04',1,'fixveh',1,214),('2015-08-03 21:50:43',1,'fixveh',1,215),('2015-08-03 21:54:07',1,'gotocar',1,216),('2015-08-03 21:54:10',1,'fixveh',1,217),('2015-08-03 21:54:15',1,'fixveh',1,218),('2015-08-03 21:54:54',1,'fixveh',1,219),('2015-08-03 21:55:01',1,'fixveh',1,220),('2015-08-03 21:55:19',1,'fixveh',1,221),('2015-08-03 21:55:28',1,'fixveh',1,222),('2015-08-03 21:56:37',1,'fixveh',1,223),('2015-08-03 21:56:52',1,'fixveh',1,224),('2015-08-03 21:56:53',1,'fixveh',1,225),('2015-08-03 21:56:58',1,'fixveh',1,226),('2015-08-03 21:57:28',1,'fixveh',1,227),('2015-08-03 21:58:39',1,'gotocar',1,228),('2015-08-03 21:58:45',1,'fixveh',1,229),('2015-08-03 21:58:49',-14,'setcolor0 1',5,230),('2015-08-03 21:58:50',-14,'setcolor3 1',5,231),('2015-08-03 21:58:51',-14,'setcolor0 1',5,232),('2015-08-03 21:58:53',-14,'setcolor16 1',5,233),('2015-08-03 21:58:55',-14,'setcolor11 1',5,234),('2015-08-03 21:58:57',1,'fixveh',1,235),('2015-08-03 21:59:00',1,'fixveh',1,236),('2015-08-03 21:59:22',-14,'fixveh',5,237),('2015-08-03 21:59:26',1,'fixveh',1,238),('2015-08-03 21:59:44',1,'fixveh',1,239),('2015-08-03 21:59:51',1,'fixveh',1,240),('2015-08-03 21:59:57',1,'fixveh',1,241),('2015-08-03 22:00:03',1,'fixveh',1,242),('2015-08-03 22:00:15',1,'fixveh',1,243),('2015-08-03 22:00:30',1,'unflip',1,244),('2015-08-03 22:00:31',1,'fixveh',1,245),('2015-08-03 22:01:08',1,'gotocar',1,246),('2015-08-03 22:01:20',1,'fixveh',5,247),('2015-08-03 22:02:03',1,'fixveh',5,248),('2015-08-03 22:03:17',1,'fixveh',5,249),('2015-08-03 22:04:44',1,'unflip',5,250),('2015-08-03 22:04:45',1,'fixveh',5,251),('2015-08-03 22:05:56',1,'fixveh',5,252),('2015-08-03 22:05:59',1,'unflip',5,253),('2015-08-03 22:06:00',1,'fixveh',5,254),('2015-08-03 22:08:47',1,'fixveh',5,255),('2015-08-03 22:11:22',1,'fixveh',5,256),('2015-08-03 22:12:45',1,'unflip',5,257),('2015-08-03 22:12:49',1,'fixveh',5,258),('2015-08-03 22:14:06',1,'fixveh',5,259),('2015-08-03 22:14:31',1,'unflip',5,260),('2015-08-03 22:14:32',1,'fixveh',5,261),('2015-08-03 22:15:14',1,'fixveh',5,262),('2015-08-03 22:15:42',1,'fixveh',5,263),('2015-08-03 22:15:43',1,'unflip',5,264),('2015-08-03 22:15:44',1,'fixveh',5,265),('2015-08-03 22:16:15',1,'fixveh',5,266),('2015-08-03 22:17:10',1,'fixveh',5,267),('2015-08-03 22:17:35',1,'fixveh',5,268),('2015-08-03 22:18:57',-52,'fixveh',1,269),('2015-08-03 22:19:15',-55,'fixveh',1,270),('2015-08-03 22:19:20',-55,'fixveh',1,271),('2015-08-03 22:19:38',-57,'setcolor0 4',5,272),('2015-08-03 22:19:39',-57,'setcolor0 5',5,273),('2015-08-03 22:19:40',-57,'setcolor5',5,274),('2015-08-03 22:22:20',-55,'unflip',1,275),('2015-08-03 22:22:22',-55,'unflip',1,276),('2015-08-03 22:22:23',-55,'fixveh',1,277),('2015-08-03 22:22:27',-55,'unflip',1,278),('2015-08-03 22:22:41',-55,'unflip',1,279),('2015-08-03 22:24:27',-55,'unflip',1,280),('2015-08-03 22:24:27',-55,'fixveh',1,281),('2015-08-03 22:28:30',-58,'fixveh',4,282),('2015-08-03 22:28:32',-71,'fixveh',1,283),('2015-08-03 22:28:47',-71,'fixveh',1,284),('2015-08-03 22:29:38',-71,'fixveh',1,285),('2015-08-03 22:29:49',-80,'fixveh',5,286),('2015-08-03 22:30:11',-71,'fixveh',1,287),('2015-08-03 22:30:53',-71,'fixveh',1,288),('2015-08-03 22:31:13',-71,'fixveh',1,289),('2015-08-03 22:31:13',-58,'fixveh',5,290),('2015-08-03 22:31:45',-71,'fixveh',1,291),('2015-08-03 22:31:58',-71,'fixveh',1,292),('2015-08-03 22:33:00',-71,'fixveh',1,293),('2015-08-03 22:33:10',-90,'setcolor0 1',5,294),('2015-08-03 22:33:12',-90,'setcolor1 0',5,295),('2015-08-03 22:33:31',-86,'setcolor0',5,296),('2015-08-03 22:33:33',-71,'fixveh',1,297),('2015-08-03 22:35:53',-94,'setcolor3',5,298),('2015-08-03 22:36:42',-92,'fixveh',1,299),('2015-08-03 22:36:44',-92,'unflip',1,300),('2015-08-03 22:36:45',-92,'fixveh',1,301),('2015-08-03 22:37:06',-92,'fixveh',1,302),('2015-08-03 22:37:09',-92,'fixveh',1,303),('2015-08-03 22:44:12',-103,'setcolor30',4,304),('2015-08-14 20:42:17',2,'fixveh',1,305),('2015-08-14 20:45:39',2,'fixveh',1,306),('2015-08-14 20:46:08',2,'fixveh',1,307),('2015-08-14 20:46:38',2,'fixveh',1,308),('2015-08-14 20:46:56',2,'fixveh',1,309),('2015-08-14 20:48:34',2,'fixveh',1,310),('2015-08-14 20:48:36',2,'fixveh',1,311),('2015-08-14 20:48:46',2,'fixveh',1,312),('2015-08-14 20:48:54',2,'fixveh',1,313),('2015-08-14 20:49:03',2,'fixveh',1,314),('2015-08-14 20:49:39',2,'unflip',1,315),('2015-08-14 20:49:40',2,'fixveh',1,316),('2015-08-14 20:50:16',2,'fixveh',1,317),('2015-08-14 20:51:21',2,'fixveh',1,318),('2015-08-14 20:51:25',2,'fixveh',1,319),('2015-08-14 20:52:33',2,'fixveh',1,320),('2015-08-14 20:52:40',2,'fixveh',1,321),('2015-08-14 20:53:13',2,'unflip',1,322),('2015-08-14 20:53:14',2,'fixveh',1,323),('2015-08-14 20:56:46',2,'fixveh',1,324),('2015-08-14 20:57:56',2,'fixveh',1,325),('2015-08-14 21:00:08',2,'fixveh',1,326),('2015-08-14 21:00:48',2,'fixveh',1,327),('2015-08-14 21:01:01',2,'fixveh',1,328),('2015-08-14 21:04:28',2,'fixveh',1,329),('2015-08-14 21:06:40',2,'fixveh',1,330),('2015-08-14 21:08:41',2,'fixveh',1,331),('2015-08-14 21:09:00',2,'fixveh',1,332),('2015-08-14 21:09:01',2,'fixveh',1,333),('2015-08-14 21:10:02',2,'fixveh',1,334),('2015-08-14 21:10:18',2,'fixveh',1,335),('2015-08-17 20:27:17',3,'makeveh Police LS ($0 - to Faction #1)',3,336),('2015-08-17 20:27:43',3,'park',3,337),('2015-08-17 20:27:50',3,'park',3,338),('2015-08-17 20:40:21',4,'makeveh S.W.A.T. ($0 - to Faction #1)',3,339),('2015-08-17 20:40:44',4,'park',3,340),('2015-08-17 20:40:46',4,'park',3,341),('2015-08-17 20:40:49',4,'park',3,342),('2015-08-17 20:40:55',-5,'fixveh',6,343),('2015-08-17 20:41:08',5,'makeveh Securicar ($0 - to Faction #1)',3,344),('2015-08-17 20:41:14',5,'delveh',3,345),('2015-08-17 20:41:57',-5,'fixveh',6,346),('2015-08-17 20:42:31',3,'delveh',3,347),('2015-08-17 20:47:31',1,'getcar',1,348),('2015-08-17 20:47:52',1,'fixveh',1,349),('2015-08-17 21:24:35',-7,'fixveh',6,350),('2015-09-08 14:07:20',-2,'fixveh',1,351),('2015-09-30 00:01:18',6,'makeveh Police LS ($0 - to Faction #1)',1,352),('2015-09-30 01:08:07',-2,'entercar Tyrone Lawrence',1,353),('2015-09-30 01:12:29',-2,'fixveh',1,354),('2015-09-30 01:13:07',-2,'unflip',1,355),('2016-02-28 19:58:50',-1,'fixveh',1,356),('2016-02-28 20:20:54',1,'gotocar',4,357),('2016-02-28 20:29:45',-3,'setcarhp 251',4,358),('2016-02-28 20:29:56',-3,'setcarhp 1000',4,359),('2016-02-28 20:29:59',-3,'fixveh',4,360),('2016-02-28 20:44:55',-1,'restoreveh',4,361),('2016-02-28 20:54:55',4,'getcar',4,362),('2016-02-28 20:55:00',6,'getcar',4,363),('2016-03-02 01:10:18',7,'makeveh Police LS ($0 - to Tyrone_Lawrence)',1,364),('2016-03-31 19:52:04',-1,'unflip',1,365),('2016-03-31 20:33:26',1,'gotocar',1,366),('2016-04-01 19:03:58',-2,'unflip',1,367),('2016-04-03 17:15:13',-2,'fixveh',1,368),('2016-04-03 17:15:55',-2,'fixveh',1,369),('2016-04-03 17:17:06',-2,'fixveh',1,370),('2016-04-03 17:17:35',-2,'fixveh',1,371),('2016-04-03 17:18:03',-2,'fixveh',1,372),('2016-04-03 18:36:35',-2,'fixveh',1,373);
/*!40000 ALTER TABLE `vehicle_logs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `vehicles`
--

DROP TABLE IF EXISTS `vehicles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `vehicles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `model` int(3) DEFAULT '0',
  `x` decimal(10,6) DEFAULT '0.000000',
  `y` decimal(10,6) DEFAULT '0.000000',
  `z` decimal(10,6) DEFAULT '0.000000',
  `rotx` decimal(10,6) DEFAULT '0.000000',
  `roty` decimal(10,6) DEFAULT '0.000000',
  `rotz` decimal(10,6) DEFAULT '0.000000',
  `currx` decimal(10,6) DEFAULT '0.000000',
  `curry` decimal(10,6) DEFAULT '0.000000',
  `currz` decimal(10,6) DEFAULT '0.000000',
  `currrx` decimal(10,6) DEFAULT '0.000000',
  `currry` decimal(10,6) DEFAULT '0.000000',
  `currrz` decimal(10,6) NOT NULL DEFAULT '0.000000',
  `fuel` int(3) DEFAULT '100',
  `engine` int(1) DEFAULT '0',
  `locked` int(1) DEFAULT '0',
  `lights` int(1) DEFAULT '0',
  `sirens` int(1) DEFAULT '0',
  `paintjob` int(11) DEFAULT '0',
  `hp` float DEFAULT '1000',
  `color1` varchar(50) DEFAULT '0',
  `color2` varchar(50) DEFAULT '0',
  `color3` varchar(50) DEFAULT NULL,
  `color4` varchar(50) DEFAULT NULL,
  `plate` text,
  `faction` int(11) DEFAULT '-1',
  `owner` int(11) DEFAULT '-1',
  `job` int(11) DEFAULT '-1',
  `tintedwindows` int(1) DEFAULT '0',
  `dimension` int(5) DEFAULT '0',
  `interior` int(5) DEFAULT '0',
  `currdimension` int(5) DEFAULT '0',
  `currinterior` int(5) DEFAULT '0',
  `enginebroke` int(1) DEFAULT '0',
  `items` text,
  `itemvalues` text,
  `Impounded` int(3) DEFAULT '0',
  `handbrake` int(1) DEFAULT '0',
  `safepositionX` float DEFAULT NULL,
  `safepositionY` float DEFAULT NULL,
  `safepositionZ` float DEFAULT NULL,
  `safepositionRZ` float DEFAULT NULL,
  `handling` text,
  `upgrades` varchar(150) DEFAULT '[ [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ]',
  `wheelStates` varchar(30) DEFAULT '[ [ 0, 0, 0, 0 ] ]',
  `panelStates` varchar(40) DEFAULT '[ [ 0, 0, 0, 0, 0, 0, 0 ] ]',
  `doorStates` varchar(30) DEFAULT '[ [ 0, 0, 0, 0, 0, 0 ] ]',
  `odometer` int(15) DEFAULT '0',
  `headlights` varchar(30) DEFAULT '[ [ 255, 255, 255 ] ]',
  `variant1` int(3) DEFAULT NULL,
  `variant2` int(3) DEFAULT NULL,
  `description1` varchar(300) NOT NULL DEFAULT '',
  `description2` varchar(300) NOT NULL DEFAULT '',
  `description3` varchar(300) NOT NULL DEFAULT '',
  `description4` varchar(300) NOT NULL DEFAULT '',
  `description5` varchar(300) NOT NULL DEFAULT '',
  `note` text,
  `deleted` int(11) NOT NULL DEFAULT '0',
  `chopped` tinyint(4) NOT NULL DEFAULT '0',
  `stolen` tinyint(4) NOT NULL DEFAULT '0',
  `lastUsed` datetime DEFAULT NULL,
  `creationDate` datetime DEFAULT NULL,
  `createdBy` int(11) DEFAULT NULL,
  `trackingdevice` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vehicles`
--

LOCK TABLES `vehicles` WRITE;
/*!40000 ALTER TABLE `vehicles` DISABLE KEYS */;
INSERT INTO `vehicles` VALUES (1,596,266.810547,-2045.293945,3084.475098,0.104370,359.989014,260.271606,2045.060547,918.676758,8.522429,356.506348,359.901123,178.335571,46,1,0,2,1,0,1000,'[ [ 0, 0, 0 ] ]','[ [ 0, 0, 0 ]]','[ [ 0, 0, 0 ] ] ','[ [ 0, 0, 0 ] ]','SE2 4310',-1,1,-1,0,0,0,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'[ { \"suspensionLowerLimit\": -0.119999997317791, \"engineInertia\": 10, \"suspensionHighSpeedDamping\": 0, \"collisionDamageMultiplier\": 0.239999994635582, \"suspensionDamping\": 0.119999997317791, \"seatOffsetDistance\": 0.2000000029802322, \"headLight\": \"long\", \"dragCoeff\": 2, \"centerOfMass\": [ 0, 0.300000011920929, -0.1000000014901161 ], \"steeringLock\": 35, \"suspensionUpperLimit\": 0.2800000011920929, \"suspensionAntiDiveMultiplier\": 0, \"turnMass\": 4500, \"brakeBias\": 0.5299999713897705, \"tractionLoss\": 0.8500000238418579, \"monetary\": 25000, \"ABS\": false, \"suspensionFrontRearBias\": 0.550000011920929, \"percentSubmerged\": 75, \"tractionBias\": 0.5, \"numberOfGears\": 5, \"suspensionForceLevel\": 1, \"animGroup\": 0, \"engineAcceleration\": 10, \"maxVelocity\": 200, \"mass\": 1600, \"driveType\": \"rwd\", \"modelFlags\": 1073741824, \"brakeDeceleration\": 10, \"handlingFlags\": 270532616, \"tractionMultiplier\": 0.75, \"engineType\": \"petrol\", \"tailLight\": \"small\" } ]','[ [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ]','[ [ 0, 0, 0, 0 ] ]','[ [ 0, 0, 0, 0, 0, 0, 0 ] ]','[ [ 0, 0, 1, 0, 0, 0 ] ]',54029,'[ [ 255, 255, 255 ] ]',255,255,'','','','','',NULL,0,0,0,NULL,'2015-07-05 15:27:22',1,NULL),(2,560,2127.106746,-1111.851883,25.156784,0.000000,0.000000,28.622559,1447.494141,-1304.255859,13.270586,359.994507,359.890137,90.241699,19,0,0,2,0,0,300,'[ [ 0, 0, 0 ] ]','[ [ 0, 0, 0 ]]','[ [ 0, 0, 0 ] ] ','[ [ 0, 0, 0 ] ]','PJ7 7522',-1,3,-1,0,0,0,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'[ { \"suspensionLowerLimit\": -0.2000000029802322, \"engineInertia\": 5, \"suspensionHighSpeedDamping\": 0, \"collisionDamageMultiplier\": 0.6000000238418579, \"suspensionDamping\": 0.1500000059604645, \"seatOffsetDistance\": 0.25, \"headLight\": \"small\", \"dragCoeff\": 2.400000095367432, \"centerOfMass\": [ 0, 0.1000000014901161, -0.1000000014901161 ], \"steeringLock\": 30, \"suspensionUpperLimit\": 0.2800000011920929, \"suspensionAntiDiveMultiplier\": 0.300000011920929, \"turnMass\": 3400, \"brakeBias\": 0.5, \"tractionLoss\": 0.800000011920929, \"monetary\": 35000, \"ABS\": false, \"suspensionFrontRearBias\": 0.5, \"percentSubmerged\": 75, \"tractionBias\": 0.5, \"numberOfGears\": 5, \"suspensionForceLevel\": 1.200000047683716, \"animGroup\": 0, \"engineAcceleration\": 11.19999980926514, \"maxVelocity\": 200, \"mass\": 1400, \"driveType\": \"awd\", \"modelFlags\": 10240, \"brakeDeceleration\": 10, \"handlingFlags\": 67108866, \"tractionMultiplier\": 0.800000011920929, \"engineType\": \"petrol\", \"tailLight\": \"small\" } ]','[ [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ]','[ [ 0, 0, 0, 0 ] ]','[ [ 0, 0, 0, 0, 0, 0, 0 ] ]','[ [ 4, 0, 1, 0, 0, 0 ] ]',37672,'[ [ 255, 255, 255 ] ]',255,255,'','','','','',NULL,0,0,0,NULL,'2015-08-02 14:51:12',3,NULL),(4,601,1530.480469,-1643.915039,5.649436,0.010986,0.000000,180.280151,269.605469,-2044.245117,3084.513672,0.126343,0.010986,135.054932,100,1,0,1,0,0,1000,'[ [ 0, 0, 0 ] ]','[ [ 0, 0, 0 ]]','[ [ 0, 0, 0 ] ] ','[ [ 0, 0, 0 ] ]','NI3 2273',1,-1,-1,0,0,0,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'[ { \"suspensionLowerLimit\": -0.1800000071525574, \"engineInertia\": 25, \"suspensionHighSpeedDamping\": 1, \"collisionDamageMultiplier\": 0.05999999865889549, \"suspensionDamping\": 0.07999999821186066, \"seatOffsetDistance\": 0.3199999928474426, \"headLight\": \"long\", \"dragCoeff\": 2.5, \"centerOfMass\": [ 0, 0, -0.1000000014901161 ], \"steeringLock\": 27, \"suspensionUpperLimit\": 0.300000011920929, \"suspensionAntiDiveMultiplier\": 0, \"turnMass\": 10000, \"brakeBias\": 0.449999988079071, \"tractionLoss\": 0.699999988079071, \"monetary\": 40000, \"ABS\": false, \"suspensionFrontRearBias\": 0.5, \"percentSubmerged\": 85, \"tractionBias\": 0.4600000083446503, \"numberOfGears\": 5, \"suspensionForceLevel\": 0.699999988079071, \"animGroup\": 13, \"engineAcceleration\": 9.600000381469727, \"maxVelocity\": 110, \"mass\": 5000, \"driveType\": \"awd\", \"modelFlags\": 8912912, \"brakeDeceleration\": 6.400000095367432, \"handlingFlags\": 16777216, \"tractionMultiplier\": 0.6499999761581421, \"engineType\": \"diesel\", \"tailLight\": \"small\" } ]','[ [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ]','[ [ 0, 0, 0, 0 ] ]','[ [ 0, 0, 0, 0, 0, 0, 0 ] ]','[ [ 0, 0, 0, 0, 0, 0 ] ]',69,'[ [ 255, 255, 255 ] ]',0,255,'','','','','',NULL,0,0,0,NULL,'2015-08-17 20:40:21',3,NULL),(6,596,1524.888885,-1712.960566,13.382813,0.000000,0.000000,236.300293,270.047852,-2051.201172,3084.480225,359.708862,1.576538,184.696655,79,1,0,1,0,0,1000,'[ [ 0, 0, 0 ] ]','[ [ 0, 0, 0 ]]','[ [ 0, 0, 0 ] ] ','[ [ 0, 0, 0 ] ]','BB9 3809',1,-1,-1,1,0,0,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'[ { \"suspensionLowerLimit\": -0.119999997317791, \"engineInertia\": 10, \"suspensionHighSpeedDamping\": 0, \"collisionDamageMultiplier\": 0.239999994635582, \"suspensionDamping\": 0.119999997317791, \"seatOffsetDistance\": 0.2000000029802322, \"headLight\": \"long\", \"dragCoeff\": 2, \"centerOfMass\": [ 0, 0.300000011920929, -0.1000000014901161 ], \"steeringLock\": 35, \"suspensionUpperLimit\": 0.2800000011920929, \"suspensionAntiDiveMultiplier\": 0, \"turnMass\": 4500, \"brakeBias\": 0.5299999713897705, \"tractionLoss\": 0.8500000238418579, \"monetary\": 25000, \"ABS\": false, \"suspensionFrontRearBias\": 0.550000011920929, \"percentSubmerged\": 75, \"tractionBias\": 0.5, \"numberOfGears\": 5, \"suspensionForceLevel\": 1, \"animGroup\": 0, \"engineAcceleration\": 10, \"maxVelocity\": 200, \"mass\": 1600, \"driveType\": \"rwd\", \"modelFlags\": 1073741824, \"brakeDeceleration\": 10, \"handlingFlags\": 270532616, \"tractionMultiplier\": 0.75, \"engineType\": \"petrol\", \"tailLight\": \"small\" } ]','[ [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ]','[ [ 0, 0, 0, 0 ] ]','[ [ 0, 0, 0, 0, 0, 0, 0 ] ]','[ [ 0, 0, 0, 0, 0, 0 ] ]',50,'[ [ 255, 255, 255 ] ]',255,255,'','','','','',NULL,0,0,0,NULL,'2015-09-30 00:01:18',1,NULL),(7,596,2070.092305,-1749.221260,13.393370,0.000000,0.000000,95.261139,1125.695313,-1721.291016,13.263533,359.681396,359.895630,271.384277,98,1,0,2,0,0,1000,'[ [ 0, 0, 0 ] ]','[ [ 0, 0, 0 ]]','[ [ 0, 0, 0 ] ] ','[ [ 0, 0, 0 ] ]','ZS0 6535',-1,1,-1,1,0,0,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'[ { \"suspensionLowerLimit\": -0.119999997317791, \"engineInertia\": 10, \"suspensionHighSpeedDamping\": 0, \"collisionDamageMultiplier\": 0.239999994635582, \"suspensionDamping\": 0.119999997317791, \"seatOffsetDistance\": 0.2000000029802322, \"headLight\": \"long\", \"dragCoeff\": 2, \"centerOfMass\": [ 0, 0.300000011920929, -0.1000000014901161 ], \"steeringLock\": 35, \"suspensionUpperLimit\": 0.2800000011920929, \"suspensionAntiDiveMultiplier\": 0, \"turnMass\": 4500, \"brakeBias\": 0.5299999713897705, \"tractionLoss\": 0.8500000238418579, \"monetary\": 25000, \"ABS\": false, \"suspensionFrontRearBias\": 0.550000011920929, \"percentSubmerged\": 75, \"tractionBias\": 0.5, \"numberOfGears\": 5, \"suspensionForceLevel\": 1, \"animGroup\": 0, \"engineAcceleration\": 10, \"maxVelocity\": 200, \"mass\": 1600, \"driveType\": \"rwd\", \"modelFlags\": 1073741824, \"brakeDeceleration\": 10, \"handlingFlags\": 270532616, \"tractionMultiplier\": 0.75, \"engineType\": \"petrol\", \"tailLight\": \"small\" } ]','[ [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ]','[ [ 0, 0, 0, 0 ] ]','[ [ 0, 0, 0, 0, 0, 0, 0 ] ]','[ [ 0, 0, 1, 0, 0, 0 ] ]',713,'[ [ 255, 255, 255 ] ]',255,255,'','','','','',NULL,0,0,0,NULL,'2016-03-01 20:10:18',1,NULL);
/*!40000 ALTER TABLE `vehicles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wiretransfers`
--

DROP TABLE IF EXISTS `wiretransfers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `wiretransfers` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `from` int(11) NOT NULL,
  `to` int(11) NOT NULL,
  `amount` int(11) NOT NULL,
  `reason` text NOT NULL,
  `time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `type` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wiretransfers`
--

LOCK TABLES `wiretransfers` WRITE;
/*!40000 ALTER TABLE `wiretransfers` DISABLE KEYS */;
INSERT INTO `wiretransfers` VALUES (12,-57,1,431,'BANKINTEREST','2016-03-31 20:00:15',6),(13,1,-3,100,'VEHICLETAX','2016-03-31 20:00:15',6),(14,-57,1,431,'BANKINTEREST','2016-04-01 19:00:46',6),(15,1,-3,100,'VEHICLETAX','2016-04-01 19:00:46',6),(16,-57,1,431,'BANKINTEREST','2016-04-03 17:01:03',6),(17,1,-3,100,'VEHICLETAX','2016-04-03 17:01:03',6);
/*!40000 ALTER TABLE `wiretransfers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `worlditems`
--

DROP TABLE IF EXISTS `worlditems`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `worlditems` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `itemid` int(11) DEFAULT '0',
  `itemvalue` text,
  `x` float DEFAULT '0',
  `y` float DEFAULT '0',
  `z` float DEFAULT '0',
  `dimension` int(5) DEFAULT '0',
  `interior` int(5) DEFAULT '0',
  `creationdate` datetime DEFAULT NULL,
  `rz` float DEFAULT '0',
  `creator` int(10) unsigned DEFAULT '0',
  `protected` int(100) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `worlditems`
--

LOCK TABLES `worlditems` WRITE;
/*!40000 ALTER TABLE `worlditems` DISABLE KEYS */;
INSERT INTO `worlditems` VALUES (1,115,'9:mp9tN8brOvQqmH0t0ugZ:Chainsaw',1926.39,-2370.4,21.798,1,25,'2015-07-05 00:54:42',357.553,2,0),(2,115,'30:mt9tN8brmuctm80t0ugZ:AK-47',1937.65,-2352.27,13.679,1,25,'2015-07-05 01:00:17',269.826,2,0),(4,116,'24:3:Ammo for Deagle',1966.06,-1297.15,52.1797,0,0,'2015-08-17 20:35:31',322.852,7,0),(5,115,'24:mp9qN8br0HhY0HgVmugZ:Deagle',1965.37,-1297.1,52.1797,0,0,'2015-08-17 20:35:32',322.852,7,0),(6,115,'30:mt9tN8br0vgYm80t0ugZ:AK-47',1939.1,-2352.12,13.679,1,25,'2015-07-05 01:10:58',267.42,2,0),(7,115,'30:mp9tN8brOubYm80t0ugZ:AK-47',1939.88,-2352.09,13.679,1,25,'2015-07-05 01:11:03',267.42,2,0),(9,116,'30:0:Ammo for AK-47',1967.26,-1296.65,52.1797,0,0,'2015-08-17 20:35:40',322.852,7,0),(10,116,'30:0:Ammo for AK-47',1967.37,-1296.36,52.1797,0,0,'2015-08-17 20:35:41',322.852,7,0),(11,116,'30:0:Ammo for AK-47',1967.7,-1297.07,52.1797,0,0,'2015-08-17 20:35:42',322.852,7,0),(13,116,'30:7:Ammo for AK-47',1967.43,-1296.4,52.1797,0,0,'2015-08-17 20:35:46',322.852,7,0),(23,116,'30:0:Ammo for AK-47',1960.16,-1272.89,52.1797,0,0,'2015-08-17 20:37:02',114.52,7,0),(25,116,'30:0:Ammo for AK-47',1957.26,-1273.81,52.1797,0,0,'2015-08-17 20:37:06',114.52,7,0);
/*!40000 ALTER TABLE `worlditems` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2016-04-21 21:03:26
