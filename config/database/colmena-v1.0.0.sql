-- MySQL Script generated by MySQL Workbench
-- Sat Jul  4 12:04:26 2020
-- Model: CampusVirtual    Version: 1.0
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema colmena
-- -----------------------------------------------------
-- Compatible con:
-- - pdns v4.2.1
-- - colmena v1.0.0
DROP SCHEMA IF EXISTS `colmena` ;

-- -----------------------------------------------------
-- Schema colmena
--
-- Compatible con:
-- - pdns v4.2.1
-- - colmena v1.0.0
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `colmena` DEFAULT CHARACTER SET utf8 ;
USE `colmena` ;

-- -----------------------------------------------------
-- Table `colmena`.`provider`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `colmena`.`provider` ;

CREATE TABLE IF NOT EXISTS `colmena`.`provider` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  `url` VARCHAR(255) NULL,
  `suportUrl` VARCHAR(255) NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `colmena`.`owner`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `colmena`.`owner` ;

CREATE TABLE IF NOT EXISTS `colmena`.`owner` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  `client_fk` INT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `colmena`.`server`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `colmena`.`server` ;

CREATE TABLE IF NOT EXISTS `colmena`.`server` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `hostname` VARCHAR(15) NULL,
  `fqdn` VARCHAR(255) NULL,
  `ip4` VARCHAR(15) NOT NULL,
  `ip6` VARCHAR(39) NOT NULL,
  `vpn4` VARCHAR(15) NULL,
  `vpn6` VARCHAR(39) NULL,
  `cpus` TINYINT(1) NULL,
  `memory_mb` INT(11) NULL,
  `swap_mb` INT(11) NULL,
  `hdd1_mb` INT(11) NULL,
  `hdd2_mb` INT(11) NULL,
  `transfer_mb` INT(11) NULL,
  `location` VARCHAR(45) NULL,
  `provider` INT NOT NULL,
  `owner` INT NOT NULL,
  `active` TINYINT(1) NULL,
  `hive_hierarchy` ENUM('R', 'Q', 'B', 'L') NULL COMMENT 'R=Royal, Q=Queen, B=Bee, L=Larva',
  `cert` TEXT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_server_provider_idx` (`provider` ASC),
  INDEX `fk_server_owner1_idx` (`owner` ASC),
  UNIQUE INDEX `hostname_idx` (`hostname` ASC),
  UNIQUE INDEX `fqdn_idx` (`fqdn` ASC),
  UNIQUE INDEX `ip4_idx` (`ip4` ASC),
  UNIQUE INDEX `ip6_idx` (`ip6` ASC),
  UNIQUE INDEX `vpn4_idx` (`vpn4` ASC),
  UNIQUE INDEX `vpn6_idx` (`vpn6` ASC),
  CONSTRAINT `fk_server_provider`
    FOREIGN KEY (`provider`)
    REFERENCES `colmena`.`provider` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_server_owner1`
    FOREIGN KEY (`owner`)
    REFERENCES `colmena`.`owner` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `colmena`.`domain_class`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `colmena`.`domain_class` ;

CREATE TABLE IF NOT EXISTS `colmena`.`domain_class` (
  `id` INT NOT NULL AUTO_INCREMENT COMMENT 'nicadmin',
  `class` VARCHAR(5) NULL,
  `name` VARCHAR(45) NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `colmena`.`domain`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `colmena`.`domain` ;

CREATE TABLE IF NOT EXISTS `colmena`.`domain` (
  `id` INT NOT NULL AUTO_INCREMENT COMMENT 'nicadmin, pdns v4.2.1',
  `name` VARCHAR(255) NOT NULL COMMENT 'pdns v4.2.1',
  `sld` VARCHAR(63) NULL,
  `tld` VARCHAR(63) NULL,
  `cctld` VARCHAR(63) NULL,
  `class` INT NOT NULL,
  `default_url` VARCHAR(255) NULL,
  `provider` INT NOT NULL,
  `owner` INT NOT NULL,
  `active` TINYINT(1) NULL,
  `master` VARCHAR(128) NULL COMMENT 'pdns v4.2.1',
  `last_check` INT(11) NULL COMMENT 'pdns v4.2.1',
  `type` VARCHAR(6) NOT NULL COMMENT 'pdns v4.2.1',
  `notified_serial` INT(11) UNSIGNED NULL COMMENT 'pdns v4.2.1',
  `account` VARCHAR(40) CHARACTER SET 'utf8' NULL COMMENT 'pdns v4.2.1',
  PRIMARY KEY (`id`, `class`, `provider`, `owner`),
  INDEX `fk_domain_domain_type1_idx` (`class` ASC),
  INDEX `fk_domain_provider1_idx` (`provider` ASC),
  INDEX `fk_domain_owner1_idx` (`owner` ASC),
  UNIQUE INDEX `name_index` (`name` ASC),
  CONSTRAINT `fk_domain_class1`
    FOREIGN KEY (`class`)
    REFERENCES `colmena`.`domain_class` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_domain_provider1`
    FOREIGN KEY (`provider`)
    REFERENCES `colmena`.`provider` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_domain_owner1`
    FOREIGN KEY (`owner`)
    REFERENCES `colmena`.`owner` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `colmena`.`vhost`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `colmena`.`vhost` ;

CREATE TABLE IF NOT EXISTS `colmena`.`vhost` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `domain` INT NOT NULL,
  `fqdn` VARCHAR(255) NOT NULL,
  `active` TINYINT(1) NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_vhost_domain1_idx` (`domain` ASC),
  INDEX `domain_id` (`domain` ASC),
  UNIQUE INDEX `fqdn_id` (`fqdn` ASC),
  CONSTRAINT `fk_vhost_domain1`
    FOREIGN KEY (`domain`)
    REFERENCES `colmena`.`domain` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `colmena`.`nameserver`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `colmena`.`nameserver` ;

CREATE TABLE IF NOT EXISTS `colmena`.`nameserver` (
  `id` INT NOT NULL AUTO_INCREMENT COMMENT 'nicadmin, External name servers',
  `domain` INT NOT NULL,
  `name` VARCHAR(255) NOT NULL,
  `ip4` VARCHAR(15) NULL,
  `ip6` VARCHAR(39) NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_nameserver_domain1_idx` (`domain` ASC),
  INDEX `domain_id` (`domain` ASC),
  CONSTRAINT `fk_nameserver_domain1`
    FOREIGN KEY (`domain`)
    REFERENCES `colmena`.`domain` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `colmena`.`service`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `colmena`.`service` ;

CREATE TABLE IF NOT EXISTS `colmena`.`service` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL COMMENT 'web,ftp, db,...',
  `api` VARCHAR(36) NOT NULL,
  `active` TINYINT(1) NOT NULL DEFAULT 0,
  `reqActivation` TINYINT(1) NOT NULL DEFAULT 0,
  `useACL` TINYINT(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `colmena`.`hosting`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `colmena`.`hosting` ;

CREATE TABLE IF NOT EXISTS `colmena`.`hosting` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `server` INT NOT NULL,
  `vhost` INT NOT NULL,
  `service` INT NOT NULL,
  `params_json` TEXT NULL COMMENT 'Parametros exclusivos del vhost en general, el config de cada servicio de cada instancia esta en su propia base de datos',
  `active` TINYINT(1) NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_hosted_server1_idx` (`server` ASC),
  INDEX `fk_hosted_vhost1_idx` (`vhost` ASC),
  INDEX `fk_hosted_hosting_type1_idx` (`service` ASC),
  INDEX `server_idx` (`server` ASC),
  INDEX `vhost_idx` (`vhost` ASC),
  INDEX `service_idx` (`service` ASC),
  CONSTRAINT `fk_hosted_server1`
    FOREIGN KEY (`server`)
    REFERENCES `colmena`.`server` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_hosted_vhost1`
    FOREIGN KEY (`vhost`)
    REFERENCES `colmena`.`vhost` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_hosted_hosting_type1`
    FOREIGN KEY (`service`)
    REFERENCES `colmena`.`service` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `colmena`.`performance`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `colmena`.`performance` ;

CREATE TABLE IF NOT EXISTS `colmena`.`performance` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `server` INT NOT NULL,
  `la01` DECIMAL(4,2) NULL COMMENT 'Load Average last minute',
  `la05` DECIMAL(4,2) NULL COMMENT 'Load Average last 5 minutes',
  `la15` DECIMAL(4,2) NULL COMMENT 'Load Average last 15 minutes',
  `dupercent` TINYINT(1) NULL COMMENT '0-100',
  PRIMARY KEY (`id`),
  INDEX `fk_snapshot_server1_idx` (`server` ASC),
  INDEX `server_id` (`server` ASC),
  CONSTRAINT `fk_snapshot_server1`
    FOREIGN KEY (`server`)
    REFERENCES `colmena`.`server` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `colmena`.`ip_fw_list`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `colmena`.`ip_fw_list` ;

CREATE TABLE IF NOT EXISTS `colmena`.`ip_fw_list` (
  `ip` VARCHAR(39) NOT NULL,
  `cidr` VARCHAR(5) NULL,
  `list` ENUM('BL', 'GL', 'WL', 'UK', 'EB', 'EG', 'EW') NOT NULL DEFAULT 'UK' COMMENT 'Black, Gray, White, Unknown, ExBlack, ExGrey, ExWhite',
  `last` ENUM('BL', 'GL', 'WL', 'UK', 'EB', 'EG', 'EW') NULL DEFAULT 'UK',
  `events` INT NOT NULL DEFAULT 1,
  `firstActivityDate` INT(11) NULL,
  `lastActivityDate` INT(11) NULL,
  `hostname` TEXT NULL,
  `blockDays` SMALLINT(6) UNSIGNED NULL,
  `propagated` TINYINT(1) NOT NULL DEFAULT 0,
  `src_ip6` VARCHAR(39) NOT NULL,
  PRIMARY KEY (`ip`),
  INDEX `ip_list_idx` (`ip` ASC, `list` ASC),
  INDEX `fad_idx` (`firstActivityDate` ASC),
  INDEX `lad_idx` (`lastActivityDate` ASC),
  UNIQUE INDEX `ip_UNIQUE` (`ip` ASC),
  INDEX `src_ip6_idx_idx` (`src_ip6` ASC),
  CONSTRAINT `src_ip6_idx`
    FOREIGN KEY (`src_ip6`)
    REFERENCES `colmena`.`server` (`ip6`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `colmena`.`hs_related_ip`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `colmena`.`hs_related_ip` ;

CREATE TABLE IF NOT EXISTS `colmena`.`hs_related_ip` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `hosted_service` INT NOT NULL,
  `ip` VARCHAR(39) NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_hs_consumed_by_ip_hosting1_idx` (`hosted_service` ASC),
  INDEX `fk_hs_consumed_by_ip_ip_fw_list1_idx` (`ip` ASC),
  INDEX `hs_ip` (`hosted_service` ASC, `ip` ASC),
  CONSTRAINT `fk_hs_consumed_by_ip_hosting1`
    FOREIGN KEY (`hosted_service`)
    REFERENCES `colmena`.`hosting` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_hs_consumed_by_ip_ip_fw_list1`
    FOREIGN KEY (`ip`)
    REFERENCES `colmena`.`ip_fw_list` (`ip`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `colmena`.`quota`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `colmena`.`quota` ;

CREATE TABLE IF NOT EXISTS `colmena`.`quota` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(25) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `name_UNIQUE` (`name` ASC))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `colmena`.`hs_quota`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `colmena`.`hs_quota` ;

CREATE TABLE IF NOT EXISTS `colmena`.`hs_quota` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `hosted_service` INT NOT NULL,
  `quota_id` INT NOT NULL,
  `quota_val` INT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_hs_quota_hosting1_idx` (`hosted_service` ASC),
  INDEX `fk_hs_quota_quota1_idx` (`quota_id` ASC),
  INDEX `hs_qi` (`hosted_service` ASC, `quota_id` ASC),
  CONSTRAINT `fk_hs_quota_hosting1`
    FOREIGN KEY (`hosted_service`)
    REFERENCES `colmena`.`hosting` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_hs_quota_quota1`
    FOREIGN KEY (`quota_id`)
    REFERENCES `colmena`.`quota` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `colmena`.`port`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `colmena`.`port` ;

CREATE TABLE IF NOT EXISTS `colmena`.`port` (
  `id` INT NOT NULL,
  `IANA_assignment` VARCHAR(255) NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `colmena`.`server_port`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `colmena`.`server_port` ;

CREATE TABLE IF NOT EXISTS `colmena`.`server_port` (
  `server` INT NOT NULL,
  `port` INT NOT NULL,
  `lastUpdate` INT(11) NULL,
  `events` INT NULL,
  INDEX `fk_server-port_server1_idx` (`server` ASC),
  INDEX `fk_server-port_port1_idx` (`port` ASC),
  UNIQUE INDEX `srv_port_idx` (`server` ASC, `port` ASC),
  CONSTRAINT `fk_server-port_server1`
    FOREIGN KEY (`server`)
    REFERENCES `colmena`.`server` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_server-port_port1`
    FOREIGN KEY (`port`)
    REFERENCES `colmena`.`port` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `colmena`.`ip_port`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `colmena`.`ip_port` ;

CREATE TABLE IF NOT EXISTS `colmena`.`ip_port` (
  `ip` VARCHAR(39) NOT NULL,
  `port` INT NOT NULL,
  `lastUpdate` INT(11) NULL,
  `events` INT NULL,
  INDEX `fk_ip_port_port1_idx` (`port` ASC),
  INDEX `fk_ip_port_ip_fw_list1_idx` (`ip` ASC),
  UNIQUE INDEX `ip_port_idx` (`ip` ASC, `port` ASC),
  INDEX `port_idx` (`port` ASC),
  CONSTRAINT `fk_ip_port_port1`
    FOREIGN KEY (`port`)
    REFERENCES `colmena`.`port` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_ip_port_ip_fw_list1`
    FOREIGN KEY (`ip`)
    REFERENCES `colmena`.`ip_fw_list` (`ip`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `colmena`.`records`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `colmena`.`records` ;

CREATE TABLE IF NOT EXISTS `colmena`.`records` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT 'pdns4.2.1',
  `domain_id` INT NOT NULL,
  `name` VARCHAR(255) NULL,
  `type` VARCHAR(10) NULL,
  `content` VARCHAR(21000) NULL,
  `ttl` INT NULL,
  `prio` INT NULL,
  `disabled` TINYINT(1) NULL DEFAULT 0,
  `ordername` VARCHAR(255) BINARY NULL,
  `auth` TINYINT(1) NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  INDEX `fk_records_domain1_idx` (`domain_id` ASC),
  INDEX `nametype_index` (`name` ASC, `type` ASC),
  INDEX `domain_id` (`domain_id` ASC),
  INDEX `ordername` (`ordername` ASC),
  CONSTRAINT `fk_records_domain1`
    FOREIGN KEY (`domain_id`)
    REFERENCES `colmena`.`domain` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `colmena`.`supermasters`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `colmena`.`supermasters` ;

CREATE TABLE IF NOT EXISTS `colmena`.`supermasters` (
  `ip` VARCHAR(64) NOT NULL COMMENT 'pdns4.2.1',
  `nameserver` VARCHAR(255) CHARACTER SET 'utf8' NOT NULL,
  `account` VARCHAR(40) NULL,
  PRIMARY KEY (`ip`, `nameserver`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `colmena`.`comments`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `colmena`.`comments` ;

CREATE TABLE IF NOT EXISTS `colmena`.`comments` (
  `id` INT NOT NULL AUTO_INCREMENT COMMENT 'pdns4.2.1',
  `domain_id` INT NOT NULL,
  `name` VARCHAR(255) NOT NULL,
  `type` VARCHAR(10) NOT NULL,
  `modified_at` INT NOT NULL,
  `account` VARCHAR(40) CHARACTER SET 'utf8' NULL,
  `comment` TEXT CHARACTER SET 'utf8' NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_comments_domain1_idx` (`domain_id` ASC),
  INDEX `comments_name_type_idx` (`name` ASC, `type` ASC),
  INDEX `comments_order_idx` (`domain_id` ASC, `modified_at` ASC),
  CONSTRAINT `fk_comments_domain1`
    FOREIGN KEY (`domain_id`)
    REFERENCES `colmena`.`domain` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `colmena`.`domainmetadata`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `colmena`.`domainmetadata` ;

CREATE TABLE IF NOT EXISTS `colmena`.`domainmetadata` (
  `id` INT NOT NULL AUTO_INCREMENT COMMENT 'pdns4.2.1',
  `domain_id` INT NOT NULL,
  `kind` VARCHAR(32) NULL,
  `content` TEXT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_domainmetadata_domain1_idx` (`domain_id` ASC),
  INDEX `domainmetadata_idx` (`domain_id` ASC, `kind` ASC),
  CONSTRAINT `fk_domainmetadata_domain1`
    FOREIGN KEY (`domain_id`)
    REFERENCES `colmena`.`domain` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `colmena`.`cryptokeys`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `colmena`.`cryptokeys` ;

CREATE TABLE IF NOT EXISTS `colmena`.`cryptokeys` (
  `id` INT NOT NULL AUTO_INCREMENT COMMENT 'pdns4.2.1',
  `domain_id` INT NOT NULL,
  `flags` INT NOT NULL,
  `active` TINYINT(1) NULL,
  `content` TEXT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_cryptokeys_domain1_idx` (`domain_id` ASC),
  INDEX `domainidindex` (`domain_id` ASC),
  CONSTRAINT `fk_cryptokeys_domain1`
    FOREIGN KEY (`domain_id`)
    REFERENCES `colmena`.`domain` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `colmena`.`tsigkeys`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `colmena`.`tsigkeys` ;

CREATE TABLE IF NOT EXISTS `colmena`.`tsigkeys` (
  `id` INT NOT NULL AUTO_INCREMENT COMMENT 'pdns4.2.1',
  `name` VARCHAR(255) NULL,
  `algorithm` VARCHAR(50) NULL,
  `secret` VARCHAR(255) NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `namealgoindex` (`name` ASC, `algorithm` ASC))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `colmena`.`trigger_script`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `colmena`.`trigger_script` ;

CREATE TABLE IF NOT EXISTS `colmena`.`trigger_script` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  `description` TEXT NULL,
  `default_port` SMALLINT UNSIGNED NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `colmena`.`ip_trigger`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `colmena`.`ip_trigger` ;

CREATE TABLE IF NOT EXISTS `colmena`.`ip_trigger` (
  `ip` VARCHAR(39) NOT NULL,
  `trigger_id` INT NOT NULL,
  `lastUpdate` INT(11) NULL,
  `events` INT NULL,
  INDEX `fk_ip-trigger_ip_fw_list1_idx` (`ip` ASC),
  INDEX `fk_ip-trigger_trigger1_idx` (`trigger_id` ASC),
  UNIQUE INDEX `ip_trig_idx` (`ip` ASC, `trigger_id` ASC),
  CONSTRAINT `fk_ip-trigger_ip_fw_list1`
    FOREIGN KEY (`ip`)
    REFERENCES `colmena`.`ip_fw_list` (`ip`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_ip-trigger_trigger1`
    FOREIGN KEY (`trigger_id`)
    REFERENCES `colmena`.`trigger_script` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
