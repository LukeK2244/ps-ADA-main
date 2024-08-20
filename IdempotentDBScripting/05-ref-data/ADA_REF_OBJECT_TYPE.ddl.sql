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
