
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
