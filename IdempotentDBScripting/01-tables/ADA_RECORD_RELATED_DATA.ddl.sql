CREATE TABLE IF NOT EXISTS `ADA_RECORD_RELATED_DATA` (
 `ID` int(11) NOT NULL AUTO_INCREMENT,
 `RECORD_TYPE_ID` int(11) DEFAULT NULL,
 `NAME` varchar(255) DEFAULT NULL,
 `TYPE` int(11) DEFAULT NULL,
 `DESCRIPTION` varchar(255) DEFAULT NULL,
 `UUID` varchar(255) DEFAULT NULL,
 `IS_ACTIVE` bit(1) DEFAULT 1,
 `CREATED_BY` varchar(255) DEFAULT NULL,
 `CREATED_ON` datetime(6) DEFAULT NULL,
 `MODIFIED_BY` varchar(255) DEFAULT NULL,
 `MODIFIED_ON` datetime(6) DEFAULT NULL,
 PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;