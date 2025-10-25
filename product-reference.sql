CREATE DATABASE IF NOT EXISTS `prd_reference_product_db`;
USE `prd_reference_product_db`;

-- ENUM types for product classification
CREATE TYPE `product_category_enum` AS ENUM (
    'ELECTRONICS',
    'CLOTHING',
    'FOOD',
    'PHARMACEUTICAL',
    'AUTOMOTIVE',
    'FURNITURE',
    'TOYS',
    'OTHER'
);

CREATE TYPE `product_status_enum` AS ENUM (
    'ACTIVE',
    'INACTIVE',
    'DISCONTINUED',
    'OUT_OF_STOCK',
    'DELISTED'
);

CREATE TYPE `supplier_type_enum` AS ENUM (
    'MANUFACTURER',
    'DISTRIBUTOR',
    'RETAILER'
);

CREATE TYPE `currency_enum` AS ENUM (
    'USD',
    'EUR',
    'INR',
    'GBP',
    'JPY'
);

CREATE TYPE `certification_type_enum` AS ENUM (
    'SAFETY',
    'QUALITY',
    'ENVIRONMENT',
    'LEGAL',
    'CUSTOM'
);

CREATE TYPE `logistics_channel_enum` AS ENUM (
    'AIR',
    'SEA',
    'ROAD',
    'RAIL'
);

-- SUPPLIER TABLE
DROP TABLE IF EXISTS `supplier`;
CREATE TABLE `supplier` (
    `supplier_id` UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    `supplier_type` supplier_type_enum NOT NULL, -- enum
    `supplier_name` VARCHAR(300) NOT NULL,
    `registration_number` VARCHAR(100) UNIQUE,
    `country` VARCHAR(3) NOT NULL,
    `contact_email` VARCHAR(200),
    `contact_phone` VARCHAR(50),
    `onboarded_at` TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- Supplier address
DROP TABLE IF EXISTS `supplier_address`;
CREATE TABLE `supplier_address` (
    `supplier_address_id` UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    `supplier_id` UUID NOT NULL REFERENCES supplier(supplier_id),
    `street_line` VARCHAR(300),
    `city` VARCHAR(100),
    `postal_code` VARCHAR(20),
    `country` VARCHAR(3) NOT NULL,
    `created_at` TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- PRODUCT CATALOG TABLE
DROP TABLE IF EXISTS `product`;
CREATE TABLE `product` (
    `product_id` UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    `product_name` VARCHAR(500) NOT NULL,
    `product_category` product_category_enum NOT NULL,
    `product_description` TEXT,
    `status` product_status_enum DEFAULT 'ACTIVE',
    `launch_date` DATE,
    `expiration_date` DATE,
    `created_at` TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT `chk_product_dates` CHECK (
        launch_date <= expiration_date OR expiration_date IS NULL
    )
);

-- Product supply mapping
DROP TABLE IF EXISTS `product_supplier`;
CREATE TABLE `product_supplier` (
    `product_supplier_id` UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    `product_id` UUID NOT NULL REFERENCES product(product_id),
    `supplier_id` UUID NOT NULL REFERENCES supplier(supplier_id),
    `supplier_sku` VARCHAR(200),
    `is_primary_supplier` BOOLEAN DEFAULT false,
    `active_from` DATE,
    `active_to` DATE,
    CONSTRAINT `chk_supplier_active_dates` CHECK (
        active_from <= active_to OR active_to IS NULL
    )
);

-- Product Certifications
DROP TABLE IF EXISTS `product_certification`;
CREATE TABLE `product_certification` (
    `certification_id` UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    `product_id` UUID NOT NULL REFERENCES product(product_id),
    `certification_type` certification_type_enum NOT NULL,
    `certification_authority` VARCHAR(200),
    `certificate_identifier` VARCHAR(200),
    `issued_date` DATE,
    `expiry_date` DATE,
    `document_reference` TEXT,
    CONSTRAINT `chk_cert_dates` CHECK (
        issued_date <= expiry_date OR expiry_date IS NULL
    )
);

-- Logistics options for each product
DROP TABLE IF EXISTS `product_logistics`;
CREATE TABLE `product_logistics` (
    `logistics_id` UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    `product_id` UUID NOT NULL REFERENCES product(product_id),
    `channel` logistics_channel_enum NOT NULL,
    `preferred_partner` VARCHAR(200),
    `delivery_time_days` INTEGER,
    `is_hazardous` BOOLEAN DEFAULT false,
    `created_at` TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- Pricing information
DROP TABLE IF EXISTS `product_pricing`;
CREATE TABLE `product_pricing` (
    `pricing_id` UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    `product_id` UUID NOT NULL REFERENCES product(product_id),
    `currency` currency_enum NOT NULL,
    `list_price` DECIMAL(15,2) NOT NULL,
    `discount_price` DECIMAL(15,2),
    `effective_from` DATE NOT NULL,
    `effective_to` DATE,
    `created_at` TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT `chk_price_duration` CHECK (
        effective_from <= effective_to OR effective_to IS NULL
    ),
    CONSTRAINT `chk_discount_less_than_list` CHECK (
        discount_price <= list_price OR discount_price IS NULL
    )
);

-- Inventory repository
DROP TABLE IF EXISTS `product_inventory`;
CREATE TABLE `product_inventory` (
    `inventory_id` UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    `product_id` UUID NOT NULL REFERENCES product(product_id),
    `warehouse_location` VARCHAR(200),
    `stock_quantity` INTEGER DEFAULT 0,
    `reorder_threshold` INTEGER DEFAULT 10,
    `last_restocked_at` TIMESTAMPTZ
);

-- Product ordering lifecycle logs
DROP TABLE IF EXISTS `product_order_lifecycle`;
CREATE TABLE `product_order_lifecycle` (
    `order_lifecycle_id` UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    `product_id` UUID NOT NULL REFERENCES product(product_id),
    `order_reference` VARCHAR(200),
    `status_before` product_status_enum,
    `status_after` product_status_enum NOT NULL,
    `changed_at` TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    `approver_id` UUID, -- Could reference a user table if added later
    `change_reason` TEXT
);
