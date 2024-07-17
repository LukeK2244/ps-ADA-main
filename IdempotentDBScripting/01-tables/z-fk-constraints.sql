-- FK Constraints for ADA application - see alphabetically

-- ADA_DOCUMENT
CALL IDEM_SP_DDL_UTIL_ADD_CONSTRAINT_IF_NOT_EXISTS('ADA_DOCUMENT', 'ADA_FK_DOCUMENT_REF_TYPE', 'FOREIGN KEY', 'FOREIGN KEY (`DOCUMENT_TYPE_ID`) REFERENCES `ADA_REFERENCE_DATA` (`ID`)');
CALL IDEM_SP_DDL_UTIL_ADD_CONSTRAINT_IF_NOT_EXISTS('ADA_DOCUMENT', 'ADA_FK_DOCUMENT_PROJECT', 'FOREIGN KEY', 'FOREIGN KEY (`PROJECT_ID`) REFERENCES `ADA_PROJECT` (`PROJECT_ID`)');

-- ADA_PROJECT
CALL IDEM_SP_DDL_UTIL_ADD_CONSTRAINT_IF_NOT_EXISTS('ADA_PROJECT', 'ADA_FK_PROJECT_REF_STATUS', 'FOREIGN KEY', 'FOREIGN KEY (`PROJECT_STATUS_ID`) REFERENCES `ADA_REFERENCE_DATA` (`ID`)');
CALL IDEM_SP_DDL_UTIL_ADD_CONSTRAINT_IF_NOT_EXISTS('ADA_PROJECT', 'ADA_FK_PROJECT_REF_PRIVACY_RATING', 'FOREIGN KEY', 'FOREIGN KEY (`PRIVACY_RATING_ID`) REFERENCES `ADA_REFERENCE_DATA` (`ID`)');
CALL IDEM_SP_DDL_UTIL_ADD_CONSTRAINT_IF_NOT_EXISTS('ADA_PROJECT', 'ADA_FK_PROJECT_CLIENT', 'FOREIGN KEY', 'FOREIGN KEY (`CLIENT_ID`) REFERENCES `ADA_CLIENT` (`CLIENT_ID`)');

-- ADA_TEAM_MEMBER
CALL IDEM_SP_DDL_UTIL_ADD_CONSTRAINT_IF_NOT_EXISTS('ADA_TEAM_MEMBER', 'ADA_FK_TEAM_MEMBER_PROJECT', 'FOREIGN KEY', 'FOREIGN KEY (`PROJECT_ID`) REFERENCES `ADA_PROJECT` (`PROJECT_ID`)');
CALL IDEM_SP_DDL_UTIL_ADD_CONSTRAINT_IF_NOT_EXISTS('ADA_TEAM_MEMBER', 'ADA_FK_TEAM_MEMBER_TYPE', 'FOREIGN KEY', 'FOREIGN KEY (`TEAM_MEMBER_TYPE_ID`) REFERENCES `ADA_REFERENCE_DATA` (`ID`)');

-- ADA_SECTION
CALL IDEM_SP_DDL_UTIL_ADD_CONSTRAINT_IF_NOT_EXISTS('ADA_SECTION', 'ADA_SECTION_PROJECT_ID_FK', 'FOREIGN KEY', 'FOREIGN KEY (`PROJECT_ID`) REFERENCES `ADA_PROJECT` (`PROJECT_ID`)');
CALL IDEM_SP_DDL_UTIL_ADD_CONSTRAINT_IF_NOT_EXISTS('ADA_SECTION', 'ADA_SECTION_TYPE_REF_ID_FK', 'FOREIGN KEY', 'FOREIGN KEY (`SECTION_TYPE_ID`) REFERENCES `ADA_REFERENCE_DATA` (`ID`)');

-- ADA_SECTION_CONTENT
CALL IDEM_SP_DDL_UTIL_ADD_CONSTRAINT_IF_NOT_EXISTS('ADA_SECTION_CONTENT', 'ADA_SECTION_CONTENT_ID_FK', 'FOREIGN KEY', 'FOREIGN KEY (`SECTION_ID`) REFERENCES `ADA_SECTION` (`SECTION_ID`)');


