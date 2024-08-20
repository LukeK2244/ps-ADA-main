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
