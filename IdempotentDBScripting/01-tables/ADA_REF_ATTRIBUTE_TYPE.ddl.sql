CREATE TABLE IF NOT EXISTS `ADA_REF_ATTRIBUTE_TYPE` (
 `ATTRIBUTE_TYPE_ID` int(11) NOT NULL AUTO_INCREMENT,
 `OBJECT_TYPE_ID` int(11) DEFAULT NULL,
 `ATTRIBUTE_NAME` varchar(255) DEFAULT NULL,
 `XPATH` varchar(255) DEFAULT NULL,
 `IS_ACTIVE` bit(1) DEFAULT 1,
 `CREATED_BY` varchar(255) DEFAULT 'SYSTEM',
 `CREATED_ON` datetime(6) DEFAULT CURRENT_TIMESTAMP,
 `MODIFIED_BY` varchar(255) DEFAULT 'SYSTEM',
 `MODIFIED_ON` datetime(6) DEFAULT CURRENT_TIMESTAMP,
 PRIMARY KEY (`ATTRIBUTE_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;