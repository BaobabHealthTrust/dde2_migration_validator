-- MySQL dump 10.13  Distrib 5.5.37, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: dde_integration
-- ------------------------------------------------------
-- Server version	5.5.37-0ubuntu0.12.04.1

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
-- Table structure for table `sites`
--

DROP TABLE IF EXISTS `sites`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sites` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `annotations` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `code` varchar(255) DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=34 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sites`
--

LOCK TABLES `sites` WRITE;
/*!40000 ALTER TABLE `sites` DISABLE KEYS */;
INSERT INTO `sites` VALUES (1,'My Local Site','My Local Site ','2012-08-02 04:00:01','2013-11-01 11:42:40','MLS'),(2,'Lumbadzi Health Center','Lumbadzi Health Center','2012-08-02 04:22:57','2012-08-02 04:22:57','312'),(3,'Chileka Health Center (Lilongwe)','Chileka Health Center (Lilongwe)','2012-08-04 20:25:11','2012-11-20 09:16:02','XXL'),(4,'Kamuzu Central Hospital','Kamuzu Central Hospital','2012-08-10 00:15:00','2012-08-10 00:15:00','696'),(5,'Martin Preuss Centre','Martin Preuss Centre','2012-08-10 08:45:13','2013-11-01 11:43:53','MPC'),(6,'Nathenje Health Center','Nathenje Health Center','2012-08-12 19:50:55','2012-08-12 19:50:55','526'),(7,'Chalasa Village','Chalasa Village at Ngoni','2013-03-25 17:36:42','2013-03-25 17:36:42','CHA'),(8,'Mtema 1','Mtema 1 Villages at Ngoni','2013-03-25 17:37:40','2013-03-25 17:37:40','MTA'),(9,'Kawale Health Center','Kawale Health Center','2013-04-03 08:57:15','2013-04-03 08:57:15','KHC'),(10,'Mitundu Community Hospital','Mitundu Community Hospital','2013-07-22 16:19:01','2013-07-23 16:21:32','MTU'),(11,'AREA 18 Health Center','AREA 18 Health Center','2013-07-22 19:10:49','2013-07-22 19:10:49','A18'),(12,'MITUNDU Health Center','MITUNDU Health Center','2013-07-22 19:11:39','2013-07-22 19:11:39','MIT'),(13,'Mzuzu Health Center','Mzuzu Health Center','2013-07-22 19:12:56','2013-07-22 19:12:56','MZC'),(14,'Nkhotakota District Hospital','Nkhotakota District Hospital','2013-07-22 19:14:23','2013-07-22 19:14:23','NAH'),(15,'Queen Elizabeth Central Hospital','Queen Elizabeth Central Hospital','2013-07-22 19:18:36','2013-07-25 17:35:57','QCH'),(16,'Malamulo Health Centre','Malamulo Health Centre','2013-08-02 13:39:39','2013-08-02 13:39:39','MAL'),(17,'Area 25 Health Center','Area 25 Health Center','2013-08-04 17:07:04','2013-08-04 22:35:26','KAN'),(18,'Mbangombe Health Center','Mbangombe Health Center','2013-08-20 08:16:56','2013-08-20 08:16:56','MHC'),(19,'Likuni Mission Hospital','Likuni Mission Hospital','2013-08-21 16:30:02','2013-08-21 16:30:02','LIK'),(20,'Ngoni Health Centre','Ngoni Health Centre ','2013-09-06 15:47:26','2013-11-01 11:44:42','NHC'),(21,'Daeyang Luke Hospital',' Daeyang Luke Hospital ','2013-10-31 16:34:48','2013-11-01 11:41:40','DLH'),(22,'Dowa District Hospital','Dowa  District Hospital','2013-11-22 18:22:56','2013-11-27 16:52:37','DOW'),(23,'Ntcheu District Hospital','Ntcheu District Hospital','2013-11-22 18:27:10','2013-11-22 18:27:10','NCH'),(24,'St Gabriels Mission Hospital','St Gabriels  Mission Hospital','2013-12-11 15:29:48','2013-12-11 15:29:48','STG'),(25,'Mlambe Mission Hospital','Mlambe Mission Hospital','2013-12-15 11:53:20','2013-12-15 11:53:20','MLB'),(26,'Phalombe Mission Hospital','Phalombe Mission Hospital','2013-12-16 15:09:14','2013-12-16 15:09:14','PMH'),(27,'Mphonde Villages','Mphonde Villages','2014-01-06 11:09:08','2014-01-06 11:09:08','CVR'),(28,'Mulanje District Hospital','Mulanje District Hospital','2014-02-09 19:57:01','2014-02-09 19:57:01','MJD'),(29,'Bangwe Health Centre','Bangwe Health Centre','2014-02-23 08:51:42','2014-02-23 08:51:42','BHC'),(30,'Ndirande Health Centre','Ndirande Health Centre','2014-02-23 08:53:04','2014-02-23 08:53:04','NDC'),(31,'HIV Exposed Child Mastercard','HIV Exposed Child Mastercard','2014-03-05 09:25:04','2014-03-06 12:55:31','EXC'),(32,'Dedza District Hospital','Dedza District Hospital','2014-03-06 12:56:19','2014-03-06 12:56:19','DZA'),(33,'Kasungu District Hospital','Kasungu District Hospital','2014-03-10 16:06:05','2014-03-10 16:06:05','KAS');
/*!40000 ALTER TABLE `sites` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2014-08-26 11:33:37
