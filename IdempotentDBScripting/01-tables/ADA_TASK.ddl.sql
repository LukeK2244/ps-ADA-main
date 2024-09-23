CREATE TABLE IF NOT EXISTS `ADA_TASK` (
  `TASK_ID` int(11) NOT NULL AUTO_INCREMENT,
  `TASK_NAME` varchar(255) DEFAULT NULL,
  `TASK_TYPE_ID` int(11) DEFAULT NULL,
  `ASSIGNEE` varchar(255) DEFAULT NULL,
  `TASK_STATUS_ID` int(11) DEFAULT NULL,
  `TASK_OUTCOME_ID` int(11) DEFAULT NULL,
  `COMPLETED_ON` datetime DEFAULT NULL,
  `COMPLETED_BY` varchar(255) DEFAULT NULL,
  `CREATED_ON` datetime NOT NULL,
  `CREATED_BY` varchar(255) NOT NULL,
  `UPDATED_ON` datetime NOT NULL,
  `UPDATED_BY` varchar(255) NOT NULL,
  `IS_ACTIVE` tinyint(1) NOT NULL,
  PRIMARY KEY (`TASK_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;