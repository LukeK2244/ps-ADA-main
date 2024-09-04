-- ADA Master SQL

SET FOREIGN_KEY_CHECKS = 0;

DROP FUNCTION IF EXISTS `IDEM_FN_DDL_UTIL_IS_FIELD_EXISTING`;

DELIMITER $$
CREATE FUNCTION `IDEM_FN_DDL_UTIL_IS_FIELD_EXISTING` (
  `in_tableName` VARCHAR(100),
  `in_fieldName` VARCHAR(100)
) RETURNS INT(11) RETURN (
    SELECT COUNT(COLUMN_NAME)
    FROM INFORMATION_SCHEMA.columns
    WHERE TABLE_SCHEMA = "Appian"
    AND TABLE_NAME = in_tableName
    AND COLUMN_NAME = in_fieldName
)$$
DELIMITER ;

DROP FUNCTION IF EXISTS `IDEM_FN_DDL_UTIL_IS_CONSTRAINT_EXISTING`;

DELIMITER $$
CREATE FUNCTION `IDEM_FN_DDL_UTIL_IS_CONSTRAINT_EXISTING` (
  `in_tableName` VARCHAR(100),
  `in_constraintName` VARCHAR(100),
  `in_constraintType` VARCHAR(100) -- eg 'FOREIGN KEY'
) RETURNS INT(11) RETURN (
    SELECT COUNT(CONSTRAINT_NAME)
    FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    WHERE TABLE_SCHEMA = "Appian"
    AND TABLE_NAME = in_tableName
    AND CONSTRAINT_NAME = in_constraintName
    AND CONSTRAINT_TYPE = in_constraintType

)$$
DELIMITER ;

DROP FUNCTION IF EXISTS `IDEM_FN_DDL_UTIL_IS_INDEX_EXISTING`;

DELIMITER $$
CREATE FUNCTION `IDEM_FN_DDL_UTIL_IS_INDEX_EXISTING` (
  `in_tableName` VARCHAR(100),
  `in_indexName` VARCHAR(100)
) RETURNS INT(11) RETURN (
    SELECT COUNT(INDEX_NAME)
    FROM INFORMATION_SCHEMA.STATISTICS
    WHERE TABLE_SCHEMA = "Appian"
    AND TABLE_NAME = in_tableName
    AND INDEX_NAME = in_indexName

)$$
DELIMITER ;

DROP PROCEDURE IF EXISTS `IDEM_SP_DDL_UTIL_ADD_FIELD_IF_NOT_EXISTS`;

DELIMITER $$
CREATE PROCEDURE `IDEM_SP_DDL_UTIL_ADD_FIELD_IF_NOT_EXISTS` (IN `in_tableName` VARCHAR(100), IN `in_fieldName` VARCHAR(100), IN `in_fieldDefinition` VARCHAR(500), IN `in_afterFieldName` VARCHAR(100))  BEGIN

    SET @isFieldThere = IDEM_FN_DDL_UTIL_IS_FIELD_EXISTING(in_tableName, in_fieldName);

    IF (@isFieldThere = 0) THEN
        SET @ddl = CONCAT('ALTER TABLE ', in_tableName);
        SET @ddl = CONCAT(@ddl, ' ', 'ADD COLUMN');
        SET @ddl = CONCAT(@ddl, ' ', in_fieldName);
        SET @ddl = CONCAT(@ddl, ' ', in_fieldDefinition);
        SET @ddl = CONCAT(@ddl, ' ', 'AFTER');
        SET @ddl = CONCAT(@ddl, ' ', in_afterFieldName);

        PREPARE stmt FROM @ddl;
        EXECUTE stmt;
        DEALLOCATE PREPARE stmt;
    ELSE
        SET @msg = LEFT(CONCAT("SELECT 'Column ", in_fieldName, " on table ", in_tableName, " already exists - skipping add'"), 128);
        SIGNAL SQLSTATE '01000'
          SET MESSAGE_TEXT = @msg;
    END IF;

END$$
DELIMITER ;

DROP PROCEDURE IF EXISTS `IDEM_SP_DDL_UTIL_DROP_FIELD_IF_EXISTS`;

DELIMITER $$
CREATE PROCEDURE `IDEM_SP_DDL_UTIL_DROP_FIELD_IF_EXISTS` (IN `in_tableName` VARCHAR(100), IN `in_fieldName` VARCHAR(100))  BEGIN

    SET @isFieldThere = IDEM_FN_DDL_UTIL_IS_FIELD_EXISTING(in_tableName, in_fieldName);

    IF (@isFieldThere = 1) THEN
        SET @ddl = CONCAT('ALTER TABLE ', in_tableName);
        SET @ddl = CONCAT(@ddl, ' ', 'DROP COLUMN');
        SET @ddl = CONCAT(@ddl, ' ', in_fieldName);

        PREPARE stmt FROM @ddl;
        EXECUTE stmt;
        DEALLOCATE PREPARE stmt;
    ELSE
        SET @msg = LEFT(CONCAT("SELECT 'Column ", in_fieldName, " on table ", in_tableName, " does not exist - skipping drop'"),128);
        SIGNAL SQLSTATE '01000'
          SET MESSAGE_TEXT = @msg;
    END IF;

END$$
DELIMITER ;

DROP PROCEDURE IF EXISTS `IDEM_SP_DDL_UTIL_MODIFY_FIELD_IF_EXISTS`;

DELIMITER $$
CREATE PROCEDURE `IDEM_SP_DDL_UTIL_MODIFY_FIELD_IF_EXISTS` (
  IN `in_tableName` VARCHAR(100),
  IN `in_fieldName` VARCHAR(100),
  IN `in_fieldDefinition` VARCHAR(500),
  IN `in_afterFieldName` VARCHAR(100)
)  BEGIN

    SET @isFieldThere = IDEM_FN_DDL_UTIL_IS_FIELD_EXISTING(in_tableName, in_fieldName);
	SET @afterFieldName = IFNULL(in_afterFieldName, '');
	
	IF (@afterFieldName = '') THEN 
	    SET @msg = LEFT(CONCAT("Modify Column ", in_fieldName, " on table ", in_tableName, " - missing AFTER_COLUMN_NAME parameter - skipping modify'"),128);
            SIGNAL SQLSTATE '01000'
            SET MESSAGE_TEXT = @msg;
    END IF;

    IF (@isFieldThere = 1) THEN
        SET @ddl = CONCAT('ALTER TABLE ', in_tableName);
        SET @ddl = CONCAT(@ddl, ' ', 'MODIFY COLUMN');
        SET @ddl = CONCAT(@ddl, ' ', in_fieldName);
        SET @ddl = CONCAT(@ddl, ' ', in_fieldDefinition);
		IF @afterFieldName = 'FIRST' THEN
		    SET @ddl = CONCAT(@ddl, ' ', 'FIRST');
		ELSE
			SET @ddl = CONCAT(@ddl, ' ', 'AFTER');
			SET @ddl = CONCAT(@ddl, ' ', in_afterFieldName);
		END IF;

        PREPARE stmt FROM @ddl;
        EXECUTE stmt;
        DEALLOCATE PREPARE stmt;
    ELSE
        SET @msg = LEFT(CONCAT("SELECT 'Column ", in_fieldName, " on table ", in_tableName, " does not exist - skipping modify'"),128);
        SIGNAL SQLSTATE '01000'
          SET MESSAGE_TEXT = @msg;
    END IF;

END$$
DELIMITER ;

DROP PROCEDURE IF EXISTS `IDEM_SP_DDL_UTIL_RENAME_FIELD_IF_EXISTS`;

DELIMITER $$
CREATE PROCEDURE `IDEM_SP_DDL_UTIL_RENAME_FIELD_IF_EXISTS` (
  IN `in_tableName` VARCHAR(100),
  IN `in_oldFieldName` VARCHAR(100),
  IN `in_newFieldName` VARCHAR(100),
  IN `in_newFieldDefinition` VARCHAR(500),
  IN `in_afterFieldName` VARCHAR(100)
)  BEGIN

    SET @isFieldThere = IDEM_FN_DDL_UTIL_IS_FIELD_EXISTING(in_tableName, in_oldFieldName);
	SET @afterFieldName = IFNULL(in_afterFieldName, '');
	
	IF (@afterFieldName = '') THEN 
	    SET @msg = LEFT(CONCAT("Rename Column ", in_fieldName, " on table ", in_tableName, " - missing AFTER_COLUMN_NAME parameter - skipping rename'"),128);
            SIGNAL SQLSTATE '01000'
            SET MESSAGE_TEXT = @msg;
    END IF;

    IF (@isFieldThere = 1) THEN
        SET @ddl = CONCAT('ALTER TABLE ', in_tableName);
        SET @ddl = CONCAT(@ddl, ' ', 'CHANGE') ;
        SET @ddl = CONCAT(@ddl, ' ', in_oldFieldName);
        SET @ddl = CONCAT(@ddl, ' ', in_newFieldName);
        SET @ddl = CONCAT(@ddl, ' ', in_newFieldDefinition);
        IF @afterFieldName = 'FIRST' THEN
		    SET @ddl = CONCAT(@ddl, ' ', 'FIRST');
		ELSE
			SET @ddl = CONCAT(@ddl, ' ', 'AFTER');
			SET @ddl = CONCAT(@ddl, ' ', in_afterFieldName);
		END IF;

        PREPARE stmt FROM @ddl;
        EXECUTE stmt;
        DEALLOCATE PREPARE stmt;
    ELSE
        SET @msg = LEFT(CONCAT("SELECT 'Column ", in_oldFieldName, " on table ", in_tableName, " does not exist - skipping rename'"),128);
        SIGNAL SQLSTATE '01000'
          SET MESSAGE_TEXT = @msg;
    END IF;

END$$
DELIMITER ;

DROP PROCEDURE IF EXISTS `IDEM_SP_DDL_UTIL_ADD_CONSTRAINT_IF_NOT_EXISTS`;

DELIMITER $$
CREATE PROCEDURE `IDEM_SP_DDL_UTIL_ADD_CONSTRAINT_IF_NOT_EXISTS` (
  IN `in_tableName` VARCHAR(100),
  IN `in_constraintName` VARCHAR(100),
  IN `in_constraintType` VARCHAR(100),
  IN `in_constraintDefinition` VARCHAR(500)
)  BEGIN

    SET @isConstraintThere = IDEM_FN_DDL_UTIL_IS_CONSTRAINT_EXISTING(in_tableName, in_constraintName, in_constraintType);

    IF (@isConstraintThere = 0) THEN
        SET @ddl = CONCAT('ALTER TABLE ', in_tableName);
        SET @ddl = CONCAT(@ddl, ' ', 'ADD CONSTRAINT') ;
        SET @ddl = CONCAT(@ddl, ' ', in_constraintName);
        SET @ddl = CONCAT(@ddl, ' ', in_constraintDefinition);

        PREPARE stmt FROM @ddl;
        EXECUTE stmt;
        DEALLOCATE PREPARE stmt;
    ELSE
        SET @msg = LEFT(CONCAT("SELECT 'Constraint ", in_constraintName, " on table ", in_tableName, " exists - skipping add'"), 128);
        SIGNAL SQLSTATE '01000'
          SET MESSAGE_TEXT = @msg;
    END IF;

END$$
DELIMITER ;

DROP PROCEDURE IF EXISTS `IDEM_SP_DDL_UTIL_DROP_CONSTRAINT_IF_EXISTS`;

DELIMITER $$
CREATE PROCEDURE `IDEM_SP_DDL_UTIL_DROP_CONSTRAINT_IF_EXISTS` (
  IN `in_tableName` VARCHAR(100),
  IN `in_constraintName` VARCHAR(100),
  IN `in_constraintType` VARCHAR(100)
)  BEGIN

    SET @isConstraintThere = IDEM_FN_DDL_UTIL_IS_CONSTRAINT_EXISTING(in_tableName, in_constraintName, in_constraintType);

    IF (@isConstraintThere = 1) THEN

        SET @overrideConstraintType = CASE
          WHEN in_constraintType = 'UNIQUE' THEN 'INDEX'
          ELSE in_constraintType
        END;

        SET @ddl = CONCAT('ALTER TABLE ', in_tableName);
        SET @ddl = CONCAT(@ddl, ' ', 'DROP');
        SET @ddl = CONCAT(@ddl, ' ', @overrideConstraintType); -- use overridden constraint type!
        SET @ddl = CONCAT(@ddl, ' ', in_constraintName);

        PREPARE stmt FROM @ddl;
        EXECUTE stmt;
        DEALLOCATE PREPARE stmt;

        -- If FK, also drop the index that the FK constraint created
        IF (in_constraintType = 'FOREIGN KEY') THEN
          CALL IDEM_SP_DDL_UTIL_DROP_INDEX_IF_EXISTS(in_tableName, in_constraintName);
        END IF;

    ELSE
        SET @msg = LEFT(CONCAT("SELECT '", in_constraintName, " on table ", in_tableName, " does not exist - skipping drop'"), 128);
        SIGNAL SQLSTATE '01000'
          SET MESSAGE_TEXT = @msg;
    END IF;

END$$
DELIMITER ;

DROP PROCEDURE IF EXISTS `IDEM_SP_DDL_UTIL_ADD_INDEX_IF_NOT_EXISTS`;

DELIMITER $$
CREATE PROCEDURE `IDEM_SP_DDL_UTIL_ADD_INDEX_IF_NOT_EXISTS` (
  IN `in_tableName` VARCHAR(100),
  IN `in_indexName` VARCHAR(100),
  IN `in_indexColumns` VARCHAR(500)
)  BEGIN

    SET @isIndexThere = IDEM_FN_DDL_UTIL_IS_INDEX_EXISTING(in_tableName, in_indexName);

    IF (@isIndexThere = 0) THEN
        SET @ddl = CONCAT('CREATE INDEX ', in_indexName);
        SET @ddl = CONCAT(@ddl, ' ', 'ON') ;
        SET @ddl = CONCAT(@ddl, ' ', in_tableName);
        SET @ddl = CONCAT(@ddl, ' (', in_indexColumns, ')');

        PREPARE stmt FROM @ddl;
        EXECUTE stmt;
        DEALLOCATE PREPARE stmt;
    ELSE
        SET @msg = LEFT(CONCAT("SELECT 'Index ", in_indexName, " on table ", in_tableName, " exists - skipping add'"), 128);
        SIGNAL SQLSTATE '01000'
          SET MESSAGE_TEXT = @msg;
    END IF;

END$$
DELIMITER ;

DROP PROCEDURE IF EXISTS `IDEM_SP_DDL_UTIL_DROP_INDEX_IF_EXISTS`;

DELIMITER $$
CREATE PROCEDURE `IDEM_SP_DDL_UTIL_DROP_INDEX_IF_EXISTS` (
  IN `in_tableName` VARCHAR(100),
  IN `in_indexName` VARCHAR(100)
)  BEGIN

    SET @isIndexThere = IDEM_FN_DDL_UTIL_IS_INDEX_EXISTING(in_tableName, in_indexName);

    IF (@isIndexThere = 1) THEN

        SET @ddl = CONCAT('DROP INDEX ', in_indexName);
        SET @ddl = CONCAT(@ddl, ' ', 'ON');
        SET @ddl = CONCAT(@ddl, ' ', in_tableName);

        PREPARE stmt FROM @ddl;
        EXECUTE stmt;
        DEALLOCATE PREPARE stmt;
    ELSE
        SET @msg = LEFT(CONCAT("SELECT '", in_indexName, " on table ", in_tableName, " does not exist - skipping drop'"), 128);
        SIGNAL SQLSTATE '01000'
          SET MESSAGE_TEXT = @msg;
    END IF;

END$$
DELIMITER ;
-- Table structure for table `ADA_CUSTOM_SECTION`
--

CREATE TABLE IF NOT EXISTS `ADA_CUSTOM_SECTION` (
  `SECTION_ID` int(11) NOT NULL AUTO_INCREMENT,
  `TITLE` varchar(255) DEFAULT NULL,
  `PROJECT_ID` int(11) DEFAULT NULL,
  `CREATED_ON` datetime NOT NULL,
  `CREATED_BY` varchar(255) NOT NULL,
  `UPDATED_ON` datetime NOT NULL,
  `UPDATED_BY` varchar(255) NOT NULL,
  `IS_ACTIVE` tinyint(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`SECTION_ID`),
  KEY `ADA_SECTION_PROJECT_ID_FK` (`PROJECT_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
--
-- Constraints for dumped tables
--

--
-- Constraints for table `ADA_CUSTOM_SECTION`
--
CALL IDEM_SP_DDL_UTIL_ADD_CONSTRAINT_IF_NOT_EXISTS('ADA_CUSTOM_SECTION', 'ADA_SECTION_PROJECT_ID_FK', 'FOREIGN KEY', 'FOREIGN KEY (`PROJECT_ID`) REFERENCES `ADA_PROJECT` (`PROJECT_ID`)');

-- /*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
-- /*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
-- /*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
CREATE TABLE IF NOT EXISTS `ADA_CUSTOM_SECTION_CONTENT` (
 `SECTION_CONTENT_ID` int(11) NOT NULL AUTO_INCREMENT,
 `VALUE` varchar(4000),
 `SECTION_ID` int(11),
 `ORDER` int(11),
 `CREATED_ON` datetime NOT NULL,
 `CREATED_BY` varchar(255) NOT NULL,
 `UPDATED_ON` datetime NOT NULL,
 `UPDATED_BY` varchar(255) NOT NULL,
 `IS_ACTIVE` tinyint(1) NOT NULL DEFAULT 1,
 PRIMARY KEY (`SECTION_CONTENT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
CREATE TABLE IF NOT EXISTS `ADA_DOCUMENT` (
  `DOCUMENT_ID` int(11) NOT NULL AUTO_INCREMENT,
  `APPIAN_DOCUMENT_ID` int(11),
  `DOCUMENT_TYPE_ID` int(11),
  `RELATED_RECORD_TYPE_ID` int(11),
  `RELATED_RECORD_ID` int(11),
  `FOLDER_ID` int(11),
  `PROJECT_ID` int(11),
  `CREATED_ON` datetime NOT NULL,
  `CREATED_BY` varchar(255) NOT NULL,
  `UPDATED_ON` datetime NOT NULL,
  `UPDATED_BY` varchar(255) NOT NULL,
  `IS_ACTIVE` tinyint(1) NOT NULL,
  PRIMARY KEY (`DOCUMENT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CALL IDEM_SP_DDL_UTIL_ADD_CONSTRAINT_IF_NOT_EXISTS('ADA_DOCUMENT', 'UNQ_DOCUMENT_APPIAN_DOCUMENT', 'UNIQUE', 'UNIQUE(`APPIAN_DOCUMENT_ID`)');
CALL IDEM_SP_DDL_UTIL_MODIFY_FIELD_IF_EXISTS ('ADA_DOCUMENT', 'IS_ACTIVE', 'tinyint(1) DEFAULT 1', 'UPDATED_BY');

CALL IDEM_SP_DDL_UTIL_ADD_FIELD_IF_NOT_EXISTS ('ADA_DOCUMENT', 'NAME', 'varchar(255)', 'APPIAN_DOCUMENT_ID');
CREATE TABLE IF NOT EXISTS `ADA_EVENT_HISTORY` (
 `EVENT_ID` int(11) NOT NULL AUTO_INCREMENT,
 `RELATED_RECORD_ID` int(11),
 `RELATED_RECORD_TYPE_ID` int(11),
 `EVENT_TYPE_ID` int(11),
 `PROJECT_ID` int(11),
 `AUTOMATION_TYPE_ID` int(11) DEFAULT NULL,
 `DESCRIPTION` varchar(255) DEFAULT NULL,
 `CREATED_ON` datetime NOT NULL,
 `CREATED_BY` varchar(255) NOT NULL,
 `IS_ACTIVE` tinyint(1) NOT NULL DEFAULT 1,
 PRIMARY KEY (`EVENT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
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

ALTER TABLE `ADA_OBJECT` ADD COLUMN IF NOT EXISTS `INCLUDED_IN_EXPORT` bit(1) NULL DEFAULT NULL AFTER `UUID`;
CREATE TABLE IF NOT EXISTS `ADA_OBJECT_ATTRIBUTE` (
 `OBJECT_ATTRIBUTE_ID` int(11) NOT NULL AUTO_INCREMENT,
 `OBJECT_ID` int(11) DEFAULT NULL,
 `ATTRIBUTE_TYPE_ID` int(11) DEFAULT NULL,
 `VALUE` varchar(255) DEFAULT NULL,
 `IS_ACTIVE` bit(1) DEFAULT 1,
 `CREATED_BY` varchar(255) DEFAULT NULL,
 `CREATED_ON` datetime(6) DEFAULT NULL,
 `MODIFIED_BY` varchar(255) DEFAULT NULL,
 `MODIFIED_ON` datetime(6) DEFAULT NULL,
 PRIMARY KEY (`OBJECT_ATTRIBUTE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CALL IDEM_SP_DDL_UTIL_MODIFY_FIELD_IF_EXISTS ('ADA_OBJECT_ATTRIBUTE', 'VALUE', 'varchar(1000) DEFAULT NULL', 'ATTRIBUTE_TYPE_ID');
CREATE TABLE IF NOT EXISTS `ADA_PROJECT` (
  `PROJECT_ID` int(11) NOT NULL AUTO_INCREMENT,
  `TITLE` varchar(255) DEFAULT NULL,
  `CLIENT_NAME` varchar(255) DEFAULT NULL,
  `PRIVACY_RATING_ID` int(11) DEFAULT NULL,
  `PROJECT_STATUS_ID` int(11) DEFAULT NULL,
  `CURRENT_VERSION_ID` int(11) DEFAULT 0,
  `APPLICATION_PREFIX` varchar(255) DEFAULT NULL,
  `DESCRIPTION` varchar(4000) DEFAULT NULL,
  `START_DATE` date DEFAULT NULL,
  `END_DATE` date DEFAULT NULL,
  `LOGO_IMG_ID` int(11) DEFAULT NULL,
  `ENVIRONMENT_IMG_ID` int(11) DEFAULT NULL,
  `PARENT_FOLDER_ID` int(11) DEFAULT NULL,
  `DOCUMENT_FOLDER_ID` int(11) DEFAULT NULL,
  `IMAGE_FOLDER_ID` int(11) DEFAULT NULL,
  `CREATED_ON` datetime NOT NULL,
  `CREATED_BY` varchar(255) NOT NULL,
  `UPDATED_ON` datetime NOT NULL,
  `UPDATED_BY` varchar(255) NOT NULL,
  `IS_ACTIVE` tinyint(1) DEFAULT 1,
  PRIMARY KEY (`PROJECT_ID`),
  KEY `ADA_FK_PROJECT_REF_STATUS` (`PROJECT_STATUS_ID`),
  KEY `ADA_FK_PROJECT_REF_PRIVACY_RATING` (`PRIVACY_RATING_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

CALL IDEM_SP_DDL_UTIL_ADD_FIELD_IF_NOT_EXISTS ('ADA_PROJECT', 'PRIMARY_LOCALE', 'VARCHAR(255) DEFAULT NULL', 'DESCRIPTION`');
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
CREATE TABLE IF NOT EXISTS `ADA_REF_OBJECT_TYPE` (
 `OBJECT_TYPE_ID` int(11) NOT NULL AUTO_INCREMENT,
 `PARENT_OBJECT_TYPE_ID` int(11) DEFAULT NULL,
 `VALUE` varchar(255) DEFAULT NULL,
 `XPATH` varchar(255) DEFAULT NULL,
 `IS_ACTIVE` bit(1) DEFAULT 1,
 `CREATED_BY` varchar(255) DEFAULT NULL,
 `CREATED_ON` datetime(6) DEFAULT NULL,
 `MODIFIED_BY` varchar(255) DEFAULT NULL,
 `MODIFIED_ON` datetime(6) DEFAULT NULL,
 PRIMARY KEY (`OBJECT_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
CREATE TABLE IF NOT EXISTS `ADA_REFERENCE_DATA` (
 `ID` int(11) NOT NULL AUTO_INCREMENT,
 `TYPE` varchar(255),
 `VALUE` varchar(255),
 `SORT_ORDER` int(11),
 `IS_ACTIVE` tinyint(1),
 `CREATED_BY` varchar(255),
 `CREATED_ON` datetime,
 `MODIFIED_BY` varchar(255),
 `MODIFIED_ON` datetime,
 PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CALL IDEM_SP_DDL_UTIL_MODIFY_FIELD_IF_EXISTS ('ADA_REFERENCE_DATA', 'VALUE', 'varchar(255)', 'ID');
-- Create the ADA_SECTION table
CREATE TABLE IF NOT EXISTS `ADA_SECTION` (
  `SECTION_ID` INT(11) NOT NULL AUTO_INCREMENT,
  `PROJECT_ID` INT(11) DEFAULT NULL,
  `SECTION_TYPE_ID` INT(11) DEFAULT NULL,
  `HEALTH_STATUS_ID` INT(11) DEFAULT NULL,
  `IS_NOT_APPLICABLE` TINYINT(1) NOT NULL DEFAULT 0,
  `CREATED_ON` DATETIME NOT NULL,
  `CREATED_BY` VARCHAR(255) NOT NULL,
  `UPDATED_ON` DATETIME NOT NULL,
  `UPDATED_BY` VARCHAR(255) NOT NULL,
  `IS_ACTIVE` TINYINT(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`SECTION_ID`),
  KEY `ADA_SECTION_PROJECT_ID_FK` (`PROJECT_ID`),
  KEY `ADA_SECTION_TYPE_ID_FK` (`SECTION_TYPE_ID`),
  KEY `ADA_HEALTH_STATUS_ID_FK` (`HEALTH_STATUS_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Add foreign key constraints
CALL IDEM_SP_DDL_UTIL_ADD_CONSTRAINT_IF_NOT_EXISTS('ADA_SECTION', 'ADA_PROJECT_ID_FK', 'FOREIGN KEY', 'FOREIGN KEY (`PROJECT_ID`) REFERENCES `ADA_PROJECT` (`PROJECT_ID`)');

CALL IDEM_SP_DDL_UTIL_ADD_CONSTRAINT_IF_NOT_EXISTS('ADA_SECTION', 'ADA_SECTION_TYPE_ID_FK', 'FOREIGN KEY', 'FOREIGN KEY (`SECTION_TYPE_ID`) REFERENCES `ADA_REFERENCE_DATA` (`ID`)');

CALL IDEM_SP_DDL_UTIL_ADD_CONSTRAINT_IF_NOT_EXISTS('ADA_SECTION', 'ADA_HEALTH_STATUS_ID_FK', 'FOREIGN KEY', 'FOREIGN KEY (`HEALTH_STATUS_ID`) REFERENCES `ADA_REFERENCE_DATA` (`ID`)');
CREATE TABLE IF NOT EXISTS `ADA_TASK` (
  `TASK_ID` int(11) NOT NULL AUTO_INCREMENT,
  `TASK_NAME` varchar(255) DEFAULT NULL,
  `TASK_TYPE_ID` int(11) DEFAULT NULL,
  `REQUESTOR` varchar(255) DEFAULT NULL,
  `ASSIGNEE` varchar(255) DEFAULT NULL,
  `REQUESTED_DATE` datetime DEFAULT NULL,
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

CREATE TABLE IF NOT EXISTS `ADA_TASK_ENTITY` (
  `TASK_ENTITY_ID` int(11) NOT NULL AUTO_INCREMENT,
  `TASK_ID` int(11) DEFAULT NULL,
  `PROJECT_ID` int(11) DEFAULT NULL,
  `ENTITY_TYPE_ID` int(11) DEFAULT NULL,
  `ENTITY_ID` int(11) DEFAULT NULL,
  `CREATED_ON` datetime NOT NULL,
  `CREATED_BY` varchar(255) NOT NULL,
  `UPDATED_ON` datetime NOT NULL,
  `UPDATED_BY` varchar(255) NOT NULL,
  `IS_ACTIVE` tinyint(1) NOT NULL,
  PRIMARY KEY (`TASK_ENTITY_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
CREATE TABLE IF NOT EXISTS `ADA_TEAM_MEMBER` (
 `TEAM_MEMBER_ID` int(11) NOT NULL AUTO_INCREMENT,
 `USER` varchar(255),
 `TEAM_MEMBER_TYPE_ID` int(11),
 `PROJECT_ID` int(11),
 `START_DATE` datetime,
 `END_DATE` datetime,
 `CREATED_ON` datetime NOT NULL,
 `CREATED_BY` varchar(255) NOT NULL,
 `UPDATED_ON` datetime NOT NULL,
 `UPDATED_BY` varchar(255) NOT NULL,
 `IS_ACTIVE` tinyint(1) NOT NULL,
 PRIMARY KEY (`TEAM_MEMBER_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CALL IDEM_SP_DDL_UTIL_MODIFY_FIELD_IF_EXISTS ('ADA_TEAM_MEMBER', 'IS_ACTIVE', 'tinyint(1) DEFAULT 1', 'UPDATED_BY');
CALL IDEM_SP_DDL_UTIL_MODIFY_FIELD_IF_EXISTS ('ADA_TEAM_MEMBER', 'START_DATE', 'date', 'PROJECT_ID');
CALL IDEM_SP_DDL_UTIL_MODIFY_FIELD_IF_EXISTS ('ADA_TEAM_MEMBER', 'END_DATE', 'date', 'START_DATE');

-- CREATE TABLE IF NOT EXISTS `AAA_MY_TABLE_1` (
--  `AAA_MY_TABLE_1_ID` int(11) NOT NULL AUTO_INCREMENT,
--  `NAME` varchar(255) NOT NULL,
--  `CREATED_ON` datetime NOT NULL,
--  `CREATED_BY` varchar(255) NOT NULL,
--  `UPDATED_ON` datetime NOT NULL,
--  `UPDATED_BY` varchar(255) NOT NULL,
--  `IS_ACTIVE` tinyint(1) NOT NULL,
--  PRIMARY KEY (`AAA_MY_TABLE_1_ID`)
-- ) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- CALL IDEM_SP_DDL_UTIL_ADD_FIELD_IF_NOT_EXISTS ('AAA_MY_TABLE_1', 'NAME2', 'VARCHAR(255) DEFAULT NULL', 'NAME');
-- FK Constraints for ADA application - see alphabetically

-- ADA_DOCUMENT
CALL IDEM_SP_DDL_UTIL_ADD_CONSTRAINT_IF_NOT_EXISTS('ADA_DOCUMENT', 'ADA_FK_DOCUMENT_REF_TYPE', 'FOREIGN KEY', 'FOREIGN KEY (`DOCUMENT_TYPE_ID`) REFERENCES `ADA_REFERENCE_DATA` (`ID`)');
CALL IDEM_SP_DDL_UTIL_ADD_CONSTRAINT_IF_NOT_EXISTS('ADA_DOCUMENT', 'ADA_FK_DOCUMENT_PROJECT', 'FOREIGN KEY', 'FOREIGN KEY (`PROJECT_ID`) REFERENCES `ADA_PROJECT` (`PROJECT_ID`)');

-- ADA_PROJECT
CALL IDEM_SP_DDL_UTIL_ADD_CONSTRAINT_IF_NOT_EXISTS('ADA_PROJECT', 'ADA_FK_PROJECT_REF_STATUS', 'FOREIGN KEY', 'FOREIGN KEY (`PROJECT_STATUS_ID`) REFERENCES `ADA_REFERENCE_DATA` (`ID`)');
CALL IDEM_SP_DDL_UTIL_ADD_CONSTRAINT_IF_NOT_EXISTS('ADA_PROJECT', 'ADA_FK_PROJECT_REF_PRIVACY_RATING', 'FOREIGN KEY', 'FOREIGN KEY (`PRIVACY_RATING_ID`) REFERENCES `ADA_REFERENCE_DATA` (`ID`)');


-- ADA_TEAM_MEMBER
CALL IDEM_SP_DDL_UTIL_ADD_CONSTRAINT_IF_NOT_EXISTS('ADA_TEAM_MEMBER', 'ADA_FK_TEAM_MEMBER_PROJECT', 'FOREIGN KEY', 'FOREIGN KEY (`PROJECT_ID`) REFERENCES `ADA_PROJECT` (`PROJECT_ID`)');
CALL IDEM_SP_DDL_UTIL_ADD_CONSTRAINT_IF_NOT_EXISTS('ADA_TEAM_MEMBER', 'ADA_FK_TEAM_MEMBER_TYPE', 'FOREIGN KEY', 'FOREIGN KEY (`TEAM_MEMBER_TYPE_ID`) REFERENCES `ADA_REFERENCE_DATA` (`ID`)');

-- ADA_SECTION_CONTENT
-- CALL IDEM_SP_DDL_UTIL_ADD_CONSTRAINT_IF_NOT_EXISTS('ADA_SECTION_CONTENT', 'ADA_SECTION_CONTENT_ID_FK', 'FOREIGN KEY', 'FOREIGN KEY (`SECTION_ID`) REFERENCES `ADA_SECTION` (`SECTION_ID`)');


TRUNCATE TABLE `ADA_REF_ATTRIBUTE_TYPE`;

INSERT INTO `ADA_REF_ATTRIBUTE_TYPE` (`ATTRIBUTE_TYPE_ID`, `OBJECT_TYPE_ID`, `ATTRIBUTE_NAME`, `XPATH`, `IS_ACTIVE`, `CREATED_BY`, `CREATED_ON`, `MODIFIED_BY`, `MODIFIED_ON`) VALUES
-- 1-20 for connected system
(1, 1, 'Name', '/connectedSystemHaul/connectedSystem/name/text()', 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
(2, 1, 'UUID', '/connectedSystemHaul/connectedSystem/uuid/text()', 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
(3, 1, 'Description', '/connectedSystemHaul/connectedSystem/description/text()', 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
-- 21-40 for constant
(21, 2, 'Name', '/contentHaul/constant/name/text()', 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
(22, 2, 'UUID', '/contentHaul/constant/uuid/text()', 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
(23, 2, 'Description', '/contentHaul/constant/description/text()', 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
(24, 2, 'Type', '/contentHaul/constant/typedValue/type/name/text()', 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
(25, 2, 'Value', '/contentHaul/constant/typedValue/value/text()', 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
-- 41-60 for data store
(41, 3, 'Name', '/dataStoreHaul/dataStore/name/text()', 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
(42, 3, 'UUID', '/dataStoreHaul/dataStore/uuid/text()', 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
(43, 3, 'Description', '/dataStoreHaul/dataStore/description/text()', 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
-- 61-80 for data type TODO
(61, 4, 'Name', '/xsd:schema/xsd:complexType/@name', 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
(62, 4, 'UUID', '/xsd:schema/xsd:complexType/@name', 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
(63, 4, 'Namespace', '/xsd:schema/@targetNamespace', 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
-- 81-100 for decision
(81, 5, 'Name', '/contentHaul/decision/name/text()', 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
(82, 5, 'UUID', '/contentHaul/decision/uuid/text()', 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
(83, 5, 'Description', '/contentHaul/decision/description/text()', 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
-- 101-120 for Document
(101, 6, 'Name', '/contentHaul/document/name/text()', 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
(102, 6, 'Description', '/contentHaul/document/description/text()', 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
(103, 6, 'UUID', '/contentHaul/document/uuid/text()', 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
-- 121-140 for Expression Rule
(121, 7, 'Name', '/contentHaul/rule/name/text()', 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
(122, 7, 'UUID', '/contentHaul/rule/uuid/text()', 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
(123, 7, 'Description', '/contentHaul/rule/description/text()', 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
-- 141-160 for feed
(141, 8, 'Name', '/tempoFeedHaul/tempoFeed/name/text()', 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
(142, 8, 'Description', '/tempoFeedHaul/tempoFeed/description/text()', 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
(143, 8, 'UUID', '/tempoFeedHaul/tempoFeed/uuid/text()', 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
-- 161-180 for folder TODO
(161, 9, 'Name', '/contentHaul\']/rulesFolder\' or name()=\'communityKnowledgeCenter\' or name()=\'folder\']/name\']/text()', 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
(162, 9, 'Description', '/contentHaul\']/rulesFolder\' or name()=\'communityKnowledgeCenter\' or name()=\'folder\']/description\']/text()', 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
(163, 9, 'UUID', '/contentHaul\']/rulesFolder\' or name()=\'communityKnowledgeCenter\' or name()=\'folder\']/uuid\']/text()', 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
-- 181-200 for group
(181, 10, 'Name', '/groupHaul/group/name/text()', 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
(182, 10, 'Description', '/groupHaul/group/description/text()', 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
(183, 10, 'UUID', '/groupHaul/group/uuid/text()', 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
(184, 10, 'Parent Group', '/groupHaul/group/parentUuid/text()', 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
(185, 10, 'Membership', '/groupHaul/group/memberPolicy/text()', 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
(186, 10, 'Privacy Policy', '/groupHaul/group/viewingPolicy/text()', 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
(187, 10, 'Visibility', '/groupHaul/group/securityMap/text()', 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
(188, 10, 'Administrator Group', '/groupHaul/admins/groups/groupUuid/text()', 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
(189, 10, 'Group Type UUID', '/groupHaul/group/groupTypeUuid/text()', 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
-- 201-220 for integration
(201, 11, 'Name', '/contentHaul/outboundIntegration/name/text()', 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
(202, 11, 'UUID', '/contentHaul/outboundIntegration/uuid/text()', 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
(203, 11, 'Description', '/contentHaul/outboundIntegration/description/text()', 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
(204, 11, 'Uses Connected System', '/contentHaul/outboundIntegration/isConnectedSystemConnectionOptionSelected/text()', 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
(205, 11, 'Type', '/contentHaul/outboundIntegration/integrationType/text()', 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
-- 221-240 for interface
(221, 12, 'Name', '/contentHaul/interface/name/text()', 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
(222, 12, 'UUID', '/contentHaul/interface/uuid/text()', 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
(223, 12, 'Description', '/contentHaul/interface/description/text()', 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
-- 241-260 for process model TODO
(241, 13, 'Name', "/processModelHaul/*[name()='process_model_port']/*[name()='pm']/*[name()='meta']/*[name()='name']/*[name()='string-map']/*[name()='pair']/*[name()='value'][1]/text()", 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
(242, 13, 'UUID', "/*[name()='processModelHaul']/*[name()='process_model_port']/*[name()='pm']/*[name()='meta']/*[name()='uuid']/text()", 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
(243, 13, 'Data Management (Clean Up Action)', "/*[name()='processModelHaul']/*[name()='process_model_port']/*[name()='pm']/*[name()='meta']/*[name()='cleanup-action']/text()", 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
(244, 13, 'Data Management (Archive Delay)', "/*[name()='processModelHaul']/*[name()='process_model_port']/*[name()='pm']/*[name()='meta']/*[name()='auto-archive-delay']/text()", 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
(245, 13, 'Data Management (Delete Delay)', "/*[name()='processModelHaul']/*[name()='process_model_port']/*[name()='pm']/*[name()='meta']/*[name()='auto-delete-delay']/text()", 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
(250, 13, 'Alert - Custom Settings', "/*[name()='processModelHaul']/*[name()='process_model_port']/*[name()='pm']/*[name()='meta']/*[name()='pm-notification-settings']/*[name()='custom-settings']/text()", 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
(251, 13, 'Alert - Notify Initiator', "/*[name()='processModelHaul']/*[name()='process_model_port']/*[name()='pm']/*[name()='meta']/*[name()='pm-notification-settings']/*[name()='notify-initiator']/text()", 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
(252, 13, 'Alert - Notify Owner', "/*[name()='processModelHaul']/*[name()='process_model_port']/*[name()='pm']/*[name()='meta']/*[name()='pm-notification-settings']/*[name()='notify-owner']/text()", 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
(253, 13, 'Alert - Recipients Expression', "/*[name()='processModelHaul']/*[name()='process_model_port']/*[name()='pm']/*[name()='meta']/*[name()='pm-notification-settings']/*[name()='recipients-exp']/text()", 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
(254, 13, 'Alert - Notify users and groups', "/*[name()='processModelHaul']/*[name()='process_model_port']/*[name()='pm']/*[name()='meta']/*[name()='pm-notification-settings']/*[name()='usersandgroups']/text()", 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
-- 261-280 for process report
(261, 14, 'Name', '/contentHaul/report/name/text()', 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
(262, 14, 'Description', '/contentHaul/report/description/text()', 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
(263, 14, 'UUID', '/contentHaul/report/uuid/text()', 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
-- 281-300 for record type
(281, 15, 'Name', '/recordTypeHaul/recordType/@name', 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
(282, 15, 'Description', '/recordTypeHaul/recordType/a:description/text()', 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
(283, 15, 'UUID', '/recordTypeHaul/recordType/@a:uuid', 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
(284, 15, 'Table Name', '/recordTypeHaul/recordType/a:sourceConfiguration/friendlyName/text()', 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
(285, 15, 'Data Source', '/recordTypeHaul/recordType/a:source/@xsi:type', 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
-- 301-320 for report
(301, 16, 'Name', '/tempoReportHaul/tempoReport/@name', 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
(302, 16, 'Description', '/tempoReportHaul/tempoReport/description/text()', 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
(303, 16, 'UUID', '/tempoReportHaul/tempoReport/@uuid', 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
-- 321-340 for site
(321, 17, 'Name', '/siteHaul/site/@name', 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
(322, 17, 'Description', '/siteHaul/site/description/text()', 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
(323, 17, 'UUID', '/siteHaul/site/@uuid', 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
-- 341-360 for web API
(341, 18, 'Name', '/webApiHaul/webApi/@name', 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
(342, 18, 'Description', '/webApiHaul/webApi/description/text()', 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
(343, 18, 'UUID', '/webApiHaul/webApi/@uuid', 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
-- 361-380 for knowledge center
(361, 19, 'Name', '/contentHaul/communityKnowledgeCenter/name/text()', 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
(362, 19, 'Description', '/contentHaul/communityKnowledgeCenter/description/text()', 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
(363, 19, 'UUID', '/contentHaul/communityKnowledgeCenter/uuid/text()', 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
-- 381-400 for group type
(381, 20, 'Name', '/groupTypeHaul/groupType/name/text()', 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
(382, 20, 'Description', '/groupTypeHaul/groupType/description/text()', 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
(383, 20, 'UUID', '/groupTypeHaul/groupType/uuid/text()', 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
-- 401-420 for process model folder
(401, 21, 'Name', '/processModelFolderHaul/processModelFolder/name/text()', 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
(402, 21, 'UUID', '/processModelFolderHaul/processModelFolder/uuid/text()', 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
(403, 21, 'Description', '/processModelFolderHaul/processModelFolder/description/text()', 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
-- 421-440 for application
(421, 22, 'Name', '/applicationHaul/application/name/text()', 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
(422, 22, 'UUID', '/applicationHaul/application/uuid/text()', 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
(423, 22, 'Description', '/applicationHaul/application/description/text()', 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
-- 441-460 for task report
(441, 23, 'Name', '/taskReportHaul/taskReport/@name', 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
(442, 23, 'Description', '/taskReportHaul/taskReport/description/text()', 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
(443, 23, 'UUID', '/taskReportHaul/taskReport/@uuid', 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
-- 461-480 for database table

-- 481-500 for database table column

-- 501-520 for query rule
(501, 26, 'Name', '/contentHaul/queryRule/name/text()', 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
(502, 26, 'UUID', '/contentHaul/queryRule/uuid/text()', 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
-- 521-540 for record type views
(521, 101, 'Name', '/a:detailViewCfg/a:nameExpr/text()', 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
(522, 101, 'URL stub', '/a:detailViewCfg/a:urlStub/text()', 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
-- 541-560 for related actions
(541, 102, 'Name', '/a:relatedActionCfg/a:staticTitleString/text()', 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
(542, 102, 'uuid', '/a:relatedActionCfg/a:uuid/text()', 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
(543, 102, 'description', '/a:relatedActionCfg/a:staticDescriptionString/text()', 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
-- 561-580 for record actions
(561, 103, 'Name', '/a:recordListActionCfg/a:staticTitle/text()', 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
(562, 103, 'uuid', '/a:recordListActionCfg/a:uuid/text()', 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
(563, 103, 'description', '/a:recordListActionCfg/a:staticDescription/text()', 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
-- 581-600 for user filters
(581, 104, 'Name', '/a:fieldCfg/a:facetLabelExpr/text()', 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
(582, 104, 'UUID', '/a:fieldCfg/a:uuid/text()', 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
(583, 104, 'description', '/a:fieldCfg/a:description/text()', 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
-- 601-620 for source filters
(601, 105, 'description', '/a:sourceConfiguration/sourceFilterExpr/text()', 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
-- 621-640 for Process Model Locales
(621, 106, 'Country', "/processModelHaul/*[name()='process_model_port']/*[name()='pm']/*[name()='meta']/*[name()='name']/*[name()='string-map']/*[name()='pair']/*[name()='locale']/@country", 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
(622, 106, 'Language', "/processModelHaul/*[name()='process_model_port']/*[name()='pm']/*[name()='meta']/*[name()='name']/*[name()='string-map']/*[name()='pair']/*[name()='locale']/@lang", 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
(623, 106, 'Name', "/processModelHaul/*[name()='process_model_port']/*[name()='pm']/*[name()='meta']/*[name()='name']/*[name()='string-map']/*[name()='pair']", 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
(624, 106, 'Description', "/processModelHaul/*[name()='process_model_port']/*[name()='pm']/*[name()='meta']/*[name()='desc']/*[name()='string-map']/*[name()='pair']", 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
(625, 106, 'Display Name', "/processModelHaul/*[name()='process_model_port']/*[name()='pm']/*[name()='meta']/*[name()='process-name']/*[name()='string-map']/*[name()='pair']", 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
-- 641-660 for Data Type Fields
(641, 107, 'Name', '/xsd:element/@name', 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP)
;
TRUNCATE TABLE `ADA_REF_OBJECT_TYPE`;

INSERT INTO `ADA_REF_OBJECT_TYPE` (`OBJECT_TYPE_ID`, `PARENT_OBJECT_TYPE_ID`, `VALUE`, `XPATH`, `IS_ACTIVE`, `CREATED_BY`, `CREATED_ON`, `MODIFIED_BY`, `MODIFIED_ON`) VALUES
(1, NULL, 'Connected System', '/connectedSystemHaul', 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
(2, NULL, 'Constant', '/contentHaul/constant', 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
(3, NULL, 'Data Store', '/dataStoreHaul', 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
(4, NULL, 'Data Type', '/xsd:schema', 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
(5, NULL, 'Decision', '/contentHaul/decision', 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
(6, NULL, 'Document', '/contentHaul/document', 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
(7, NULL, 'Expression Rule', '/contentHaul/rule', 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
(8, NULL, 'Feed', '/tempoFeedHaul', 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
(9, NULL, 'Rules Folder', '/contentHaul/rulesFolder', 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
(10, NULL, 'Group', '/groupHaul', 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
(11, NULL, 'Integration', '/contentHaul/outboundIntegration', 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
(12, NULL, 'Interface', '/contentHaul/interface', 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
(13, NULL, 'Process Model', '/processModelHaul', 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
(14, NULL, 'Process Report', '/contentHaul/report', 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
(15, NULL, 'Record Type', '/recordTypeHaul', 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
(16, NULL, 'Report', '/tempoReportHaul', 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
(17, NULL, 'Site', '/siteHaul', 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
(18, NULL, 'Web API', '/webApiHaul', 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
(19, NULL, 'Knowledge Center', '/contentHaul/communityKnowledgeCenter', 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
(20, NULL, 'Group Type', '/groupTypeHaul', 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
(21, NULL, 'Process Model Folder', '/processModelFolderHaul', 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
(22, NULL, 'Application', '/applicationHaul', 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
(23, NULL, 'Task Report', '/taskReportHaul', 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
(24, NULL, 'Database Table', NULL, 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
(25, NULL, 'Database Table Column', NULL, 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
(26, NULL, 'Query Rule', '/contentHaul/queryRule', 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
(27, NULL, 'Folder', '/contentHaul/folder', 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),


-- id > 100 for object types that will be child objects
(101, 15, 'View', '/recordTypeHaul/recordType/a:detailViewCfg', 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
(102, 15, 'Related Action', '/recordTypeHaul/recordType/a:relatedActionCfg', 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
(103, 15, 'Record Action', '/recordTypeHaul/recordType/a:recordListActionCfg', 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
(104, 15, 'User Filter', '/recordTypeHaul/recordType/a:fieldCfg', 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
(105, 15, 'Source Filter', '/recordTypeHaul/recordType/a:sourceConfiguration', 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
(106, 13, 'Locale', "/processModelHaul/*[name()='process_model_port']/*[name()='pm']/*[name()='meta']/*[name()='name']/*[name()='string-map']/*[name()='pair']/*[name()='locale']/@lang", 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
(107, 4, 'Field', "/xsd:schema/xsd:complexType/xsd:sequence/xsd:element", 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP)
;
TRUNCATE TABLE `ADA_REFERENCE_DATA`;

INSERT INTO `ADA_REFERENCE_DATA` (`ID`, `TYPE`, `VALUE`, `SORT_ORDER`, `IS_ACTIVE`, `CREATED_BY`, `CREATED_ON`, `MODIFIED_BY`, `MODIFIED_ON`) VALUES
-- Ids 1 - 4 for PROJECT_STATUS
(1, 'PROJECT_STATUS', 'To Be started', 1, 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
(2, 'PROJECT_STATUS', 'In Progress', 2, 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
(3, 'PROJECT_STATUS', 'Completed', 3, 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
(4, 'PROJECT_STATUS', 'Cancelled', 4, 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),

-- Ids 51 - 53 for PRIVACY_RATING
(51, 'PRIVACY_RATING', 'Public', 1, 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
(52, 'PRIVACY_RATING', 'Restricted', 2, 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
(53, 'PRIVACY_RATING', 'Private', 3, 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),

-- Ids 101 - 104 for TEAM_MEMBER_TYPE
(101, 'TEAM_MEMBER_TYPE', 'Architect', 1, 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
(102, 'TEAM_MEMBER_TYPE', 'TDM', 2, 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
(103, 'TEAM_MEMBER_TYPE', 'Lead Developer', 3, 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
(104, 'TEAM_MEMBER_TYPE', 'Developer', 4, 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),

-- Ids 151 - 154 for RECORD_TYPE
(151, 'RECORD_TYPE', 'Reference Table', 3, b'1', 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
(152, 'RECORD_TYPE', 'Mapping Table', 2, b'1', 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
(153, 'RECORD_TYPE', 'Data Table', 1, b'1', 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
(154, 'RECORD_TYPE', 'Other', 4, b'1', 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),

-- Ids 201 - 214 for EVENT_HISTORY_TYPE
(201, 'EVENT_HISTORY_TYPE', 'Created Project', 1, 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
(202, 'EVENT_HISTORY_TYPE', 'Status Change', 2, 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
(203, 'EVENT_HISTORY_TYPE', 'Updated Project Details', 3, 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
(204, 'EVENT_HISTORY_TYPE', 'Updated Team Member', 4, 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
(205, 'EVENT_HISTORY_TYPE', 'Added Team Member', 5, 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
(206, 'EVENT_HISTORY_TYPE', 'Added Section', 7, 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
(207, 'EVENT_HISTORY_TYPE', 'Updated Section', 8, 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
(210, 'EVENT_HISTORY_TYPE', 'Removed Team Member', 6, 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
(211, 'EVENT_HISTORY_TYPE', 'Removed Section', 9, 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
(213, 'EVENT_HISTORY_TYPE', 'Uploaded Document', 13, 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
(214, 'EVENT_HISTORY_TYPE', 'Exported Document', 14, 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
(215, 'EVENT_HISTORY_TYPE', 'Updated Prefixes', 15, 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
(216, 'EVENT_HISTORY_TYPE', 'Updated Introduction', 16, 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),

-- Ids 251 - 256 for RELATED_RECORD_TYPE
(251, 'RELATED_RECORD_TYPE', 'Project', 1, 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
(252, 'RELATED_RECORD_TYPE', 'Client', 2, 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
(254, 'RELATED_RECORD_TYPE', 'Team Member', 4, 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
(255, 'RELATED_RECORD_TYPE', 'Section', 5, 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
(256, 'RELATED_RECORD_TYPE', 'Document', 6, 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
(257, 'RELATED_RECORD_TYPE', 'Prefixes', 7, 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
(258, 'RELATED_RECORD_TYPE', 'Introduction', 8, 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),


-- Ids 301 - 312 for SECTION_TYPE
(301, 'SECTION_TYPE', 'Custom', 1, 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
(302, 'SECTION_TYPE', 'Document Management', 2, 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
(303, 'SECTION_TYPE', 'Reports', 3, 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
(304, 'SECTION_TYPE', 'Appendix', 4, 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
(305, 'SECTION_TYPE', 'Process Architecture', 5, 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
(306, 'SECTION_TYPE', 'Introduction', 6, 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
(307, 'SECTION_TYPE', 'Architecture Overview', 7, 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
(308, 'SECTION_TYPE', 'Platform Overview', 8, 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
(309, 'SECTION_TYPE', 'Groups', 9, 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
(310, 'SECTION_TYPE', 'Record Types', 10, 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
(311, 'SECTION_TYPE', 'Integrations', 11, 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
(312, 'SECTION_TYPE', 'Connected Systems', 12, 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
(313, 'SECTION_TYPE', 'Prefixes', 13, 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),

-- Ids 351 - 355 for RECORD_RELATED_DATA_TYPE
(351, 'RECORD_RELATED_DATA_TYPE', 'View', 1, b'1', 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
(352, 'RECORD_RELATED_DATA_TYPE', 'Related Action', 2, b'1', 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
(353, 'RECORD_RELATED_DATA_TYPE', 'Record Action', 3, b'1', 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
(354, 'RECORD_RELATED_DATA_TYPE', 'User Filter', 2, b'1', 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
(355, 'RECORD_RELATED_DATA_TYPE', 'Default Filter', 2, b'1', 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),

-- Ids 401 - 403 for DOCUMENT_TYPE
(401, 'DOCUMENT_TYPE', 'Exported DOCX', 1, 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
(402, 'DOCUMENT_TYPE', 'Uploaded ZIP', 3, 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
(403, 'DOCUMENT_TYPE', 'Exported PDF', 2, 1, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),

-- Ids 501 - 516 for MANDATORY_PREFIX
(501, 'MANDATORY_PREFIX', 'Constant', '1', b'1', 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
(502, 'MANDATORY_PREFIX', 'Data Store', '2', b'1', 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
(503, 'MANDATORY_PREFIX', 'Data Type', '3', b'1', 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
(504, 'MANDATORY_PREFIX', 'Decision Rule', '4', b'1', 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
(505, 'MANDATORY_PREFIX', 'Document', '5', b'1', 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
(506, 'MANDATORY_PREFIX', 'Expression Rule', '6', b'1', 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
(507, 'MANDATORY_PREFIX', 'Folder', '7', b'1', 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
(508, 'MANDATORY_PREFIX', 'Group', '8', b'1', 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
(509, 'MANDATORY_PREFIX', 'Integration', '9', b'1', 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
(510, 'MANDATORY_PREFIX', 'Interface', '10', b'1', 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
(511, 'MANDATORY_PREFIX', 'Process Model', '11', b'1', 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
(512, 'MANDATORY_PREFIX', 'Query Entity', '12', b'1', 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
(513, 'MANDATORY_PREFIX', 'Query Record Type', '13', b'1', 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
(514, 'MANDATORY_PREFIX', 'Record Type', '14', b'1', 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
(515, 'MANDATORY_PREFIX', 'Site', '15', b'1', 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
(516, 'MANDATORY_PREFIX', 'Web API', '16', b'1', 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),

-- Id 551 for OPTIONAL_PREFIX
(551, 'OPTIONAL_PREFIX', 'Feed', '1', b'1', 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),

-- Id 601-605 for SECTION_HEALTH_STATUS_ID
(601, 'SECTION_HEALTH_STATUS_ID', 'Well Maintained', '1', '1', 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
(602, 'SECTION_HEALTH_STATUS_ID', 'Recommend Revisit', '2', '1', 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
(603, 'SECTION_HEALTH_STATUS_ID', 'Overdue', '2', '1', 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),

-- Id 651 - 654 for TASK_STATUS_ID
(651, 'TASK_STATUS_ID', 'Unassigned', '1', '1', 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
(652, 'TASK_STATUS_ID', 'In Progress', '2', '1', 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
(653, 'TASK_STATUS_ID', 'Completed', '3', '1', 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
(654, 'TASK_STATUS_ID', 'Cancelled', '4', '1', 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),

-- Id 701 - 703 for TASK_OUTCOME_ID
(701, 'TASK_OUTCOME_ID', 'Completed', '1', '1', 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
(702, 'TASK_OUTCOME_ID', 'Approved', '2', '1', 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),
(703, 'TASK_OUTCOME_ID', 'Rejected', '3', '1', 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP),

-- Id 751 for TASK_TYPE_ID
(751, 'TASK_TYPE_ID', 'Review Section', '1', '1', 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP);
-- TRUNCATE TABLE `AAA_MY_TABLE_1`;

-- INSERT INTO `AAA_MY_TABLE_1` (`AAA_MY_TABLE_1_ID`, `NAME`, `CREATED_ON`, `CREATED_BY`, `UPDATED_ON`, `UPDATED_BY`, `IS_ACTIVE`) VALUES
-- ('1', 'AAA', '2020-11-16 00:00:00', 'SYSTEM', '2020-11-16 00:00:00', 'SYSTEM', 1),
-- ('2', 'BBB', '2020-11-16 00:00:00', 'SYSTEM', '2020-11-16 00:00:00', 'SYSTEM', 1),
-- ('3', 'CCC', '2020-11-16 00:00:00', 'SYSTEM', '2020-11-16 00:00:00', 'SYSTEM', 1);
SET FOREIGN_KEY_CHECKS = 1;
-- ADA Master SQL Build Complete

