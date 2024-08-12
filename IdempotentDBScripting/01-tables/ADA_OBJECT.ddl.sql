CREATE TABLE IF NOT EXISTS `ADA_OBJECT` (
 `OBJECT_ID` int(11) NOT NULL AUTO_INCREMENT,
 `PROJECT_ID` int(11) DEFAULT NULL,
 `VERSION_ID` int(11) DEFAULT NULL,
 `OBJECT_TYPE_ID` int(11) DEFAULT NULL,
 `PARENT_OBJECT_ID` int(11) DEFAULT NULL,
 `NAME` varchar(255) DEFAULT NULL,
 `UUID` varchar(255) DEFAULT NULL,
 `IS_ACTIVE` bit(1) DEFAULT 1,
 `CREATED_BY` varchar(255) DEFAULT NULL,
 `CREATED_ON` datetime(6) DEFAULT NULL,
 `MODIFIED_BY` varchar(255) DEFAULT NULL,
 `MODIFIED_ON` datetime(6) DEFAULT NULL,
 PRIMARY KEY (`OBJECT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;