CREATE DATABASE 'savings_account_db';
USE `savings_account_db`;

-- Table for Deposits schema
DROP TABLE IF EXISTS `deposits`;
CREATE TABLE `deposits` (
  `savings_account_number` int NOT NULL,
  `product_instance_reference` varchar(255),
  `customer_reference` varchar(255),
  `bank_branch_location_reference` varchar(255),
  `account_type` enum('Savings Account', 'Checking Account', 'Deposit Account', 'Current Account'),
  `account_currency` varchar(10),
  `entitlement_option_setting` varchar(255),
  `restriction_option_setting` varchar(255),
  `position_limit_type` varchar(255),
  `transaction_date_type` varchar(255),
  `transaction_type` varchar(50),
  `transaction_amount` decimal(15, 2),
  `transaction_description` varchar(255),
  `account_limit_breach_response` varchar(255),
  PRIMARY KEY (`savings_account_number`)
);

-- Table for Withdrawals schema
DROP TABLE IF EXISTS `withdrawal`;
CREATE TABLE `withdrawal` (
  `savings_account_number` int NOT NULL,
  `product_instance_reference` varchar(255),
  `customer_reference` varchar(255),
  `bank_branch_location_reference` varchar(255),
  `account_type` enum('Savings Account', 'Checking Account', 'Deposit Account', 'Current Account'),
  `account_currency` varchar(10),
  `entitlement_option_setting` varchar(255),
  `restriction_option_setting` varchar(255),
  `position_limit_type` varchar(255),
  `transaction_date_type` varchar(255),
  `transaction_type` varchar(50),
  `transaction_amount` decimal(15, 2),
  `transaction_description` varchar(255),
  `account_limit_breach_response` varchar(255),
  PRIMARY KEY (`savings_account_number`)
);

-- Table for Transactions schema
DROP TABLE IF EXISTS `transactions`;
CREATE TABLE `transactions` (
  `savings_account_number` int NOT NULL,
  `transaction_reference` varchar(255) NOT NULL,
  `transaction_type` varchar(50),
  `account_limit_breach_response` varchar(255),
  `transaction_description` varchar(255),
  `transaction_amount` varchar(255),
  `transaction_date` varchar(255),
  PRIMARY KEY (`savings_account_number`)
);
