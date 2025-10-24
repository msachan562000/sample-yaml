CREATE DATABASE IF NOT EXISTS 'prd_directory_db';
USE `prd_directory_db`;

CREATE TYPE `directory_date_type_enum` AS ENUM (
    'OPEN_DATE',
    'REFRESH_DATE'
);

CREATE TYPE `party_type_enum` AS ENUM (
    'PERSON',
    'ORGANISATION'
);

CREATE TYPE `directory_status_enum` AS ENUM (
    'ACTIVE',
    'INACTIVE',
    'TERMINATED'
);

CREATE TYPE `address_type_enum` AS ENUM (
    'RESIDENTIAL',
    'CORPORATE',
    'MAILING'
);

CREATE TYPE `contact_type_enum` AS ENUM (
    'EMAIL',
    'CELL_PHONE',
    'SOCIAL_NETWORK',
    'OTHER'
);

CREATE TYPE `political_exposure_enum` AS ENUM (
    'FOREIGN',
    'DOMESTIC',
    'NONE'
);
-- Association types
CREATE TYPE `association_type_enum` AS ENUM (
    'PARENT_OF',
    'SUBSIDIARY_OF',
    'CERTIFIED_BY',
    'MARRIED_TO',
    'ACTS_ON_BEHALF_OF',
    'CONTACT_POINT_FOR',
    'TRUSTED_BY'
);
-- OBLIGATION ENUMS

CREATE TYPE `obligation_type_enum` AS ENUM (
    'SWEEP_ARRANGEMENT',
    'WITHDRAWAL_ARRANGEMENT', 
    'DEPOSIT_ARRANGEMENT',
    'INTEREST_ARRANGEMENT',
    'FEE_ARRANGEMENT',
    'LIEN_ARRANGEMENT',
    'INFORMATION_ARRANGEMENT',
    'PAYMENT_ARRANGEMENT',
    'ENTITLEMENT_ARRANGEMENT',
    'PERIOD_ARRANGEMENT',
    'COLLATERAL_ARRANGEMENT',
    'LIMIT_ARRANGEMENT',
    'ACCESS_ARRANGEMENT',
    'CARD_PAYMENT_ARRANGEMENT',
    'STANDING_ORDER_ARRANGEMENT',
    'OVERDRAFT_ARRANGEMENT',
    'REPAYMENT_ARRANGEMENT',
    'STATEMENT_ARRANGEMENT',
    'CREDIT_TRANSFER_ARRANGEMENT',
    'PRODUCT_SERVICE_ARRANGEMENT',
    'FACTORING_ARRANGEMENT',
    'ROLLOVER_ARRANGEMENT',
    'RESTRUCTURING_ARRANGEMENT',
    'INSURANCE_ARRANGEMENT',
    'COLLECTION_ARRANGEMENT',
    'UNDERWRITING_ARRANGEMENT',
    'TERMINATION_ARRANGEMENT',
    'MATURITY_ARRANGEMENT'
);

CREATE TYPE `obligation_modality_enum` AS ENUM (
    'ALLOCATION_MODALITY',
    'CALCULATION_MODALITY',
    'DERIVATION_MODALITY', 
    'PAYMENT_MODALITY',
    'PROCESSING_MODALITY',
    'APPLICATION_MODALITY',
    'DELIVERY_MODALITY'
);

--  document_type enum
CREATE TYPE `document_type_enum` AS ENUM (
    'WORK_DOCUMENT',
    'CERTIFICATION_DOCUMENT', 
    'PERSONAL_DOCUMENT'
);

CREATE TYPE `document_status_enum` AS ENUM (
    'DRAFT',
    'SUBMITTED',
    'VERIFIED',
    'APPROVED',
    'REJECTED',
    'EXPIRED',
    'REVOKED'
);

-- REFERENCE TABLES
-- Reference table for identification types
DROP TABLE IF EXISTS `identification_type`;
CREATE TABLE `identification_type` (
    `identification_type_id` SERIAL,
    `type_code` VARCHAR(50) UNIQUE NOT NULL,
    `type_name` VARCHAR(100) NOT NULL,
    `description` TEXT,
    `country_scope` VARCHAR(3),          -- NULL for global, or specific country code
    `is_active` BOOLEAN DEFAULT true,
    `validation_regex` VARCHAR(200),     -- Optional: regex pattern for validation
    `created_at` TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`identification_type_id`)
);


DROP TABLE IF EXISTS `party`;
CREATE TABLE `party` (
    `party_id` UUID DEFAULT gen_random_uuid(),
    `party_type` party_type_enum NOT NULL,  -- ENUM, 
    `party_legal_structure` VARCHAR(100),
    `party_full_legal_name` VARCHAR(500) NOT NULL,
    `party_name_salutation` VARCHAR(200),
    `date_of_birth` DATE,
    `nationality` VARCHAR(3),
    `residency_status` VARCHAR(50),
    `customer_since_date` DATE,
    `created_at` TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`party_id`)
);

-- Party identification information
DROP TABLE IF EXISTS `party_identification`;
CREATE TABLE `party_identification` (
    `identification_id` UUID DEFAULT gen_random_uuid(),
    `party_id` UUID NOT NULL REFERENCES party(party_id),
    `identification_type_id` INTEGER NOT NULL REFERENCES identification_type(identification_type_id),
    `identification_value` VARCHAR(500) NOT NULL,
    `issuing_authority` VARCHAR(200),
    `issuing_country` VARCHAR(3), -- Country that issued the ID
    `start_date` DATE,
    `end_date` DATE,
    `is_verified` BOOLEAN DEFAULT false,
    `verified_at` TIMESTAMPTZ,
    `created_at` TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`identification_id`)
);

DROP TABLE IF EXISTS `party_reference_data_directory_entry`;
CREATE TABLE `party_reference_data_directory_entry` (
    `party_reference_data_directory_id` UUID DEFAULT gen_random_uuid(),
    `party_reference` UUID NOT NULL REFERENCES party(party_id),
    `directory_entry_date_type` directory_date_type_enum NOT NULL,  -- ENUM
    `directory_entry_date` TIMESTAMPTZ NOT NULL,
    `party_type` party_type_enum NOT NULL,  -- ENUM
    `created_at` TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    `status` directory_status_enum DEFAULT 'ACTIVE',  -- ENUM
    PRIMARY KEY (`party_reference_data_directory_id`)
);

-- Address table
DROP TABLE IF EXISTS `party_address`;
CREATE TABLE `party_address` (
    `address_id` UUID DEFAULT gen_random_uuid(),
    `party_id` UUID NOT NULL REFERENCES party(party_id),
`address_type` address_type_enum NOT NULL, 
    `street_name` VARCHAR(100),
    `street_building_identification` VARCHAR(50),
    `building_name` VARCHAR(100),
    `floor` VARCHAR(20),
    `post_code_identification` VARCHAR(20),
    `town_name` VARCHAR(100),
    `country` VARCHAR(3) NOT NULL, -- ISO 3166-1 alpha-3
    `country_of_residence` VARCHAR(3),
    `validity_period_start` DATE,
    `validity_period_end` DATE,
    `is_primary` BOOLEAN DEFAULT false,
    `created_at` TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`address_id`)
);


-- Contact points table
DROP TABLE IF EXISTS `party_contact_point`;
CREATE TABLE `party_contact_point` (
    `contact_point_id` UUID DEFAULT gen_random_uuid(),
    `party_id` UUID NOT NULL REFERENCES party(party_id),
     `contact_type` contact_type_enum NOT NULL,
    `contact_value` VARCHAR(500) NOT NULL,
    `is_primary` BOOLEAN DEFAULT false,
    `is_temporary` BOOLEAN DEFAULT false,
    `validity_period_start` DATE,
    `validity_period_end` DATE,
    `created_at` TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`contact_point_id`)
);

-- Demographics table
DROP TABLE IF EXISTS `party_demographics`;
CREATE TABLE `party_demographics` (
    `demographics_id` UUID DEFAULT gen_random_uuid(),
    `party_reference_data_directory_id` UUID NOT NULL REFERENCES party_reference_data_directory_entry(party_reference_data_directory_id),
    `socio_economic_classification` TEXT,
    `ethnicity_religion` TEXT,
    `employment_party_id` UUID REFERENCES party(party_id),  -- Clearer naming
    `employment_history` TEXT,
    `education_history` TEXT,
    `servicing_constraints` TEXT,
    `political_exposure_type` political_exposure_enum NOT NULL DEFAULT 'NONE',  -- ENUM type
    `political_exposure_description` TEXT,
    `created_at` TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`demographics_id`)
);


-- Associations table
DROP TABLE IF EXISTS `party_association`;
CREATE TABLE `party_association` (
    `association_id` UUID DEFAULT gen_random_uuid(),
    `directory_id` UUID NOT NULL REFERENCES party_reference_data_directory_entry(party_reference_data_directory_id),
    `employee_party_id` UUID REFERENCES party(party_id),
    `associate_party_id` UUID NOT NULL REFERENCES party(party_id),
    `association_type` association_type_enum NOT NULL,
    `association_valid_from` DATE,
    `association_valid_to` DATE,
    `product_agreement_reference` UUID, 
    `is_preferred_beneficiary` BOOLEAN DEFAULT false,
    `description` TEXT, 
    `created_at` TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`association_id`),
    
    -- Additional constraints
    CONSTRAINT `chk_association_dates_valid` CHECK (
        association_valid_from <= association_valid_to OR association_valid_to IS NULL
    ),
    CONSTRAINT `chk_association_not_self` CHECK (
        employee_party_id != associate_party_id OR employee_party_id IS NULL
    )
);


-- Association obligations/entitlements
DROP TABLE IF EXISTS `association_obligation_entitlement`;
CREATE TABLE `association_obligation_entitlement` (
    `obligation_id` UUID DEFAULT gen_random_uuid(),
     `association_id` UUID NOT NULL REFERENCES party_association(association_id), 
    `obligation_subject` TEXT,
  `obligation_type` obligation_type_enum NOT NULL,  -- ENUM type
    `obligation_modality` obligation_modality_enum NOT NULL,  -- ENUM type
    `obligation_definition` TEXT,
    `created_at` TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`obligation_id`)
);

-- Bank relations table
DROP TABLE IF EXISTS `party_bank_relations`;
CREATE TABLE `party_bank_relations` (
    `bank_relations_id` UUID DEFAULT gen_random_uuid(),
    `party_reference_data_directory_id` UUID NOT NULL REFERENCES party_reference_data_directory_entry(party_reference_data_directory_id),
    `bank_relation_type` VARCHAR(100) NOT NULL,
    `business_unit_employee_reference` UUID, -- Reference to bank employee
    `relationship_start_date` DATE,
    `relationship_end_date` DATE,
    `relationship_lifecycle_status` VARCHAR(50),
    `relationship_identification` VARCHAR(100),
    `created_at` TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`bank_relations_id`)
);
-- Document references table
DROP TABLE IF EXISTS `party_document_reference`;
CREATE TABLE `party_document_reference` (
    `document_id` UUID DEFAULT gen_random_uuid(),
    `party_id` UUID NOT NULL REFERENCES party(party_id),
    `document_type` document_type_enum NOT NULL,  -- ENUM type
    `document_identification` VARCHAR(200) NOT NULL,
    `document_version` VARCHAR(50) DEFAULT '1.0',
    `document_status` document_status_enum NOT NULL DEFAULT 'DRAFT',  -- ENUM type
    `document_date_time` TIMESTAMPTZ NOT NULL,
    `document_name` VARCHAR(500) NOT NULL,
    `document_purpose` TEXT,
    `document_format` VARCHAR(100),
    `document_subject` TEXT,
    `document_description` TEXT,
    `validity_period_start` DATE,
    `validity_period_end` DATE,
    `created_at` TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`document_id`)
    
    -- Additional constraints
    CONSTRAINT `chk_document_dates_valid` CHECK (
        validity_period_start <= validity_period_end OR validity_period_end IS NULL
    ),
    CONSTRAINT `chk_document_date_consistent` CHECK (
        document_date_time >= created_at OR document_date_time IS NULL
    )
);
