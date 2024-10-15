DROP DATABASE IF EXISTS addb CASCADE;
CREATE DATABASE addb;

USE addb;

CREATE TABLE IF NOT EXISTS dly (
    id UUID NOT NULL DEFAULT gen_random_uuid(), 
    created_dt TIMESTAMPTZ(0) NOT NULL DEFAULT current_timestamp():::TIMESTAMPTZ,
    created_by VARCHAR(32) NOT NULL DEFAULT 'eccr_intg_user':::STRING,
    updated_dt TIMESTAMPTZ(0) NOT NULL DEFAULT current_timestamp():::TIMESTAMPTZ,
    updated_by VARCHAR(32) NOT NULL DEFAULT 'eccr_intg_user':::STRING,
    agree_nbr VARCHAR(25)  NULL,
    usage_dt TIMESTAMPTZ(0)  NULL,
    product_feature_id INT4 NULL,
    service_cd VARCHAR(50) NULL,
    product_line_cd VARCHAR(50) NULL,
    user_login_id VARCHAR(256) NULL,
    license_server_nm VARCHAR(128) NULL,
    license_type_txt VARCHAR(10) NULL,
    machine_nm VARCHAR(128) NULL,
    txn_type_nm VARCHAR(30)  NULL,
    token_pool_cd VARCHAR(2)  NULL,
    end_customer_agreement_yr_ind INT4  NULL,
    duration_mns FLOAT8 NULL DEFAULT 0.0:::FLOAT8,
    txn_units_nbr FLOAT8 NULL DEFAULT 0.0:::FLOAT8,
    unique_usage_cnt INT4 NULL DEFAULT 0:::INT8,
    isdeleted INT4 NULL DEFAULT 0:::INT8,
    hashkey VARCHAR(64) NULL,
    CONSTRAINT t_all_usage_dly_pkey PRIMARY KEY (id ASC, end_customer_agreement_yr_ind ASC),
    UNIQUE INDEX uk_t_all_usage_dly (agree_nbr ASC, usage_dt ASC, product_feature_id ASC, service_cd ASC, product_line_cd ASC, user_login_id ASC, license_server_nm ASC, license_type_txt ASC, machine_nm ASC, txn_type_nm ASC, token_pool_cd ASC, end_customer_agreement_yr_ind ASC),
    INDEX ix_t_all_usage_dly_agree_nbr (agree_nbr ASC),
    INDEX ix_t_all_usage_dly_usagedt (agree_nbr ASC, usage_dt ASC),
    INDEX ix_t_all_usage_dly_plc (agree_nbr ASC, product_line_cd ASC, usage_dt ASC),
    INDEX ix_t_all_usage_dly_pf (agree_nbr ASC, product_feature_id ASC, usage_dt ASC),
    INDEX ix_t_all_usage_dly_sc (agree_nbr ASC, service_cd ASC, usage_dt ASC),
    INDEX ix_t_all_usage_dly_hk (hashkey ASC),
    INDEX ix_t_all_usage_dly_txntype (txn_type_nm ASC),
    INDEX ix_t_all_usage_dly_usagedt_txntype (usage_dt ASC, txn_type_nm ASC),
    INDEX ix_t_all_usage_dly_lic (agree_nbr ASC, license_server_nm ASC, usage_dt ASC)
);

