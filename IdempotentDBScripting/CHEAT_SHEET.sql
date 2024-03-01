
-- RE-RUNNABLE SQL CHEAT SHEET

/* *** INITIAL TABLE CREATION ***
 * NOTES:
 *  - don't include any indexes or constraints in here other than the PRIMARY KEY definition.
 * - other indexes should go after the initial creation but in the same file
 * - constraints should go in the separate global constraint file
 *
 */
CREATE TABLE IF NOT EXISTS `MY_TABLE` (
  `MY_TABLE_ID` int(11) NOT NULL AUTO_INCREMENT,
  `TITLE` varchar(255) DEFAULT NULL,
  `MESSAGE` varchar(1000) DEFAULT NULL,
  `DETAIL` varchar(1000) DEFAULT NULL,
  `CONTEXT` varchar(1000) DEFAULT NULL,
  `PROCESS_ID` int(11) DEFAULT NULL,
  `CREATED_ON` datetime NOT NULL,
  `CREATED_BY` varchar(255) NOT NULL,
  `UPDATED_ON` datetime NOT NULL,
  `UPDATED_BY` varchar(255) NOT NULL,
  `IS_ACTIVE` tinyint(1) NOT NULL,
  PRIMARY KEY (`MY_TABLE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/***********************************************/

/* *** ADD A FIELD ***
 * NOTES:
 *  - Always include AFTER_COLUMN_NAME even if the column is not being moved.
 */
CALL IDEM_SP_DDL_UTIL_ADD_FIELD_IF_NOT_EXISTS ('MY_TABLE_NAME', 'NEW_COLUMN_NAME', 'DATA TYPE', 'AFTER_COLUMN_NAME');
-- Example
CALL IDEM_SP_DDL_UTIL_ADD_FIELD_IF_NOT_EXISTS ('MY_TABLE', 'newField1', 'INT NOT NULL DEFAULT 0', 'PROCESS_ID');
/***********************************************/

/* *** RENAME A FIELD ***
 * NOTES:
 *  - Always include AFTER_COLUMN_NAME even if the column is not being moved.
 *  - In case the column is the first one in the table (or you want to move it to the first position), pass FIRST as the value for AFTER_COLUMN_NAME.
 *  - *** CAUTION: RENAME WILL ONLY RUN WHEN THE OLD COLUMN EXISTS BUT WILL CHANGE THE DATA TYPE WHEN IT DOES RUN - CAN POTENTIALLY LEAD TO DATA LOSS IF EXISTING DATA IS NOT OF A COMPATIBLE TYPE!***
 */
CALL IDEM_SP_DDL_UTIL_RENAME_FIELD_IF_EXISTS ('MY_TABLE_NAME', 'OLD_COLUMN_NAME', 'NEW_COLUMN_NAME', 'DATA TYPE', 'AFTER_COLUMN_NAME');
-- Example
CALL IDEM_SP_DDL_UTIL_RENAME_FIELD_IF_EXISTS ('MY_TABLE', 'ERROR_MESSAGE', 'NEW_ERROR_MESSAGE', 'varchar(1000)', 'ERROR_DETAIL');
/***********************************************/

/* *** MODIFY A FIELD ***
 * NOTES:
 *  - Always include AFTER_COLUMN_NAME even if the column is not being moved. 
 *  - In case the column is the first one in the table (or you want to move it to the first position), pass FIRST as the value for AFTER_COLUMN_NAME.
 *  - *** CAUTION: ONLY INCLUDE ONE MODIFY STATEMENT PER COLUMN IN THE SQL SCRIPT FOR A GIVEN TABLE***
 */
CALL IDEM_SP_DDL_UTIL_MODIFY_FIELD_IF_EXISTS ('MY_TABLE_NAME', 'COLUMN_NAME', 'NEW DATA TYPE', 'AFTER_COLUMN_NAME');
-- Example
CALL IDEM_SP_DDL_UTIL_MODIFY_FIELD_IF_EXISTS ('MY_TABLE', 'newField1', 'varchar(20)', 'ERROR_DETAIL');
/***********************************************/

/* *** DROP A FIELD ***
 * NOTES:
 *  - *** CAUTION: LIMIT DROP STATEMENTS AS MUCH AS POSSIBLE - if the column needs adding back again later on
 *        then the original drop will run again causing data loss.
          REMOVE ANY DROP STATEMENT when adding the column back in!!!***
 */
CALL IDEM_SP_DDL_UTIL_DROP_FIELD_IF_EXISTS ('MY_TABLE_NAME', 'COLUMN_NAME');
-- Example
CALL IDEM_SP_DDL_UTIL_DROP_FIELD_IF_EXISTS ('MY_TABLE', 'newField1');
/***********************************************/


/* *** ADD AN INDEX ***
 * NOTES:
 *  - Only add indexes added for performance reasons like this
 *  - PKs and FKs will automatically get indexes due to being PKs and from FK Constraints
 */
CALL IDEM_SP_DDL_UTIL_ADD_INDEX_IF_NOT_EXISTS('MY_TABLE_NAME', 'INDEX_NAME', 'INDEX_FIELDS_COMMA_SEPARATED');
-- Example:
CALL IDEM_SP_DDL_UTIL_ADD_INDEX_IF_NOT_EXISTS('MY_TABLE', 'IX_newField1', '`newField1`');
/***********************************************/

/* *** DROP AN INDEX ***
 * NOTES:
 */
CALL IDEM_SP_DDL_UTIL_DROP_INDEX_IF_EXISTS('MY_TABLE_NAME', 'INDEX_NAME');
-- Example:
CALL IDEM_SP_DDL_UTIL_DROP_INDEX_IF_EXISTS('MY_TABLE', 'IX_newField1');
/***********************************************/

/* *** ADD A CONSTRAINT ***
 * NOTES:
 *  - Constraints should be added to a separate global constraints file to be run after all table creations
 * - Currently only FOREIGN KEY is supported as Constraint Type.
 */
CALL IDEM_SP_DDL_UTIL_ADD_CONSTRAINT_IF_NOT_EXISTS('MY_TABLE_NAME', 'FK_CONSTRAINT_NAME', 'FOREIGN KEY', 'CONSTRAINT DEFINITION');
-- Example:
CALL IDEM_SP_DDL_UTIL_ADD_CONSTRAINT_IF_NOT_EXISTS('MY_TABLE', 'FK_PROCESS_ID', 'FOREIGN KEY', 'FOREIGN KEY (`PROCESS_ID`) REFERENCES `REF_PROCESS` (`PROCESS_ID`)');

/* *** ADD A UNIQUE CONSTRAINT ***
 * NOTES:
 * - UNIQUE constraint type needs to be added seperately from a FK contraint
 */

 CALL IDEM_SP_DDL_UTIL_ADD_CONSTRAINT_IF_NOT_EXISTS('MY_TABLE_NAME', 'UNQ_CONSTRAINT_NAME', 'UNIQUE', 'CONSTRAINT DEFINITION');
 -- Example:
CALL IDEM_SP_DDL_UTIL_ADD_CONSTRAINT_IF_NOT_EXISTS('MY_TABLE', 'UNQ_PROCESS_ID', 'UNIQUE', 'UNIQUE(`PROCESS_ID`)');


/***********************************************/

/* *** DROP A CONSTRAINT ***
 * NOTES:
 *  -
 */
CALL IDEM_SP_DDL_UTIL_DROP_CONSTRAINT_IF_EXISTS('MY_TABLE_NAME', 'FK_CONSTRAINT_NAME', 'FOREIGN KEY');
-- Example:
CALL IDEM_SP_DDL_UTIL_DROP_CONSTRAINT_IF_EXISTS('MY_TABLE', 'FK_PROCESS_ID', 'FOREIGN KEY');
/***********************************************/


/* *** DROP A UNIQUE CONSTRAINT ***
 * NOTES:
 *  -
 */
CALL IDEM_SP_DDL_UTIL_DROP_CONSTRAINT_IF_EXISTS('MY_TABLE_NAME', 'UNQ_CONSTRAINT_NAME', 'UNIQUE');
-- Example:
CALL IDEM_SP_DDL_UTIL_DROP_CONSTRAINT_IF_EXISTS('MY_TABLE', 'UNQ_PROCESS_ID', 'UNIQUE');
/***********************************************/
