-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema apoteka
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `apoteka` ;

-- -----------------------------------------------------
-- Schema apoteka
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `apoteka` DEFAULT CHARACTER SET utf8 ;
USE `apoteka` ;

-- -----------------------------------------------------
-- Table `apoteka`.`apotekar`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `apoteka`.`apotekar` ;

CREATE TABLE IF NOT EXISTS `apoteka`.`apotekar` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `ime` VARCHAR(45) NOT NULL,
  `prezime` VARCHAR(45) NOT NULL,
  `telefon` VARCHAR(45) NULL,
  `email` VARCHAR(45) NOT NULL,
  `plata` FLOAT NOT NULL,
  `zvanje` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `apoteka`.`sef_sluzbe`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `apoteka`.`sef_sluzbe` ;

CREATE TABLE IF NOT EXISTS `apoteka`.`sef_sluzbe` (
  `apotekar_id` INT NOT NULL,
  PRIMARY KEY (`apotekar_id`),
  CONSTRAINT `fk_sef_sluzbe_apotekar`
    FOREIGN KEY (`apotekar_id`)
    REFERENCES `apoteka`.`apotekar` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `apoteka`.`dobavljac`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `apoteka`.`dobavljac` ;

CREATE TABLE IF NOT EXISTS `apoteka`.`dobavljac` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `naziv` VARCHAR(45) NOT NULL,
  `telefon` VARCHAR(45) NULL,
  `email` VARCHAR(45) NOT NULL,
  `adresa` VARCHAR(45) NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `apoteka`.`narudzba`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `apoteka`.`narudzba` ;

CREATE TABLE IF NOT EXISTS `apoteka`.`narudzba` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `datum` DATE NOT NULL DEFAULT NOW(),
  `sef_sluzbe_apotekar_id` INT NOT NULL,
  `dobavljac_id` INT NOT NULL,
  PRIMARY KEY (`id`, `sef_sluzbe_apotekar_id`, `dobavljac_id`),
  INDEX `fk_narudzba_dobavljac1_idx` (`dobavljac_id` ASC),
  CONSTRAINT `fk_narudzba_sef_sluzbe1`
    FOREIGN KEY (`sef_sluzbe_apotekar_id`)
    REFERENCES `apoteka`.`sef_sluzbe` (`apotekar_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_narudzba_dobavljac1`
    FOREIGN KEY (`dobavljac_id`)
    REFERENCES `apoteka`.`dobavljac` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `apoteka`.`racun`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `apoteka`.`racun` ;

CREATE TABLE IF NOT EXISTS `apoteka`.`racun` (
  `broj` INT NOT NULL AUTO_INCREMENT,
  `datum` DATE NOT NULL DEFAULT NOW(),
  `apotekar_id` INT NOT NULL,
  PRIMARY KEY (`broj`, `apotekar_id`),
  INDEX `fk_racun_apotekar1_idx` (`apotekar_id` ASC),
  CONSTRAINT `fk_racun_apotekar1`
    FOREIGN KEY (`apotekar_id`)
    REFERENCES `apoteka`.`apotekar` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `apoteka`.`supstanca`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `apoteka`.`supstanca` ;

CREATE TABLE IF NOT EXISTS `apoteka`.`supstanca` (
  `sifra` INT NOT NULL,
  `naziv` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`sifra`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `apoteka`.`osiguranik`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `apoteka`.`osiguranik` ;

CREATE TABLE IF NOT EXISTS `apoteka`.`osiguranik` (
  `id_osiguranika` INT NOT NULL,
  `id_kartice` INT NOT NULL,
  `ime` VARCHAR(45) NOT NULL,
  `prezime` VARCHAR(45) NOT NULL,
  `telefon` VARCHAR(45) NULL,
  `email` VARCHAR(45) NULL,
  `jmbg` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id_osiguranika`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `apoteka`.`zdravstvena_ustanova`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `apoteka`.`zdravstvena_ustanova` ;

CREATE TABLE IF NOT EXISTS `apoteka`.`zdravstvena_ustanova` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `naziv` VARCHAR(45) NOT NULL,
  `telefon` VARCHAR(45) NULL,
  `email` VARCHAR(45) NOT NULL,
  `adresa` VARCHAR(45) NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `apoteka`.`lijek`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `apoteka`.`lijek` ;

CREATE TABLE IF NOT EXISTS `apoteka`.`lijek` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `naziv` VARCHAR(45) NOT NULL,
  `proizvodjac` VARCHAR(45) NULL,
  `stanje` FLOAT NOT NULL,
  `barkod` VARCHAR(45) NOT NULL,
  `cijena` FLOAT NOT NULL,
  `lista` VARCHAR(45) NOT NULL,
  `sifra_fonda` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `apoteka`.`recept`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `apoteka`.`recept` ;

CREATE TABLE IF NOT EXISTS `apoteka`.`recept` (
  `broj` INT NOT NULL,
  `datum` DATE NOT NULL,
  `ljekar` VARCHAR(45) NOT NULL,
  `dijagnoza` VARCHAR(45) NOT NULL,
  `izdat` VARCHAR(45) NOT NULL,
  `osiguranik_id_osiguranika` INT NOT NULL,
  `zdravstvena_ustanova_id` INT NOT NULL,
  `lijek_id` INT NOT NULL,
  PRIMARY KEY (`broj`, `osiguranik_id_osiguranika`, `zdravstvena_ustanova_id`, `lijek_id`),
  INDEX `fk_recept_osiguranik1_idx` (`osiguranik_id_osiguranika` ASC),
  INDEX `fk_recept_zdravstvena_ustanova1_idx` (`zdravstvena_ustanova_id` ASC),
  INDEX `fk_recept_lijek1_idx` (`lijek_id` ASC),
  CONSTRAINT `fk_recept_osiguranik1`
    FOREIGN KEY (`osiguranik_id_osiguranika`)
    REFERENCES `apoteka`.`osiguranik` (`id_osiguranika`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_recept_zdravstvena_ustanova1`
    FOREIGN KEY (`zdravstvena_ustanova_id`)
    REFERENCES `apoteka`.`zdravstvena_ustanova` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_recept_lijek1`
    FOREIGN KEY (`lijek_id`)
    REFERENCES `apoteka`.`lijek` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `apoteka`.`racun_has_lijek`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `apoteka`.`racun_has_lijek` ;

CREATE TABLE IF NOT EXISTS `apoteka`.`racun_has_lijek` (
  `kolicina` FLOAT NOT NULL,
  `racun_broj` INT NOT NULL,
  `racun_apotekar_id` INT NOT NULL,
  `lijek_id` INT NOT NULL,
  PRIMARY KEY (`racun_broj`, `racun_apotekar_id`, `lijek_id`),
  INDEX `fk_racun_has_lijek_lijek1_idx` (`lijek_id` ASC),
  INDEX `fk_racun_has_lijek_racun1_idx` (`racun_broj` ASC, `racun_apotekar_id` ASC),
  CONSTRAINT `fk_racun_has_lijek_racun1`
    FOREIGN KEY (`racun_broj` , `racun_apotekar_id`)
    REFERENCES `apoteka`.`racun` (`broj` , `apotekar_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_racun_has_lijek_lijek1`
    FOREIGN KEY (`lijek_id`)
    REFERENCES `apoteka`.`lijek` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `apoteka`.`lijek_has_supstanca`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `apoteka`.`lijek_has_supstanca` ;

CREATE TABLE IF NOT EXISTS `apoteka`.`lijek_has_supstanca` (
  `lijek_id` INT NOT NULL,
  `supstanca_sifra` INT NOT NULL,
  `kolicina` FLOAT NOT NULL,
  PRIMARY KEY (`lijek_id`, `supstanca_sifra`),
  INDEX `fk_lijek_has_supstanca_supstanca1_idx` (`supstanca_sifra` ASC),
  INDEX `fk_lijek_has_supstanca_lijek1_idx` (`lijek_id` ASC),
  CONSTRAINT `fk_lijek_has_supstanca_lijek1`
    FOREIGN KEY (`lijek_id`)
    REFERENCES `apoteka`.`lijek` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_lijek_has_supstanca_supstanca1`
    FOREIGN KEY (`supstanca_sifra`)
    REFERENCES `apoteka`.`supstanca` (`sifra`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `apoteka`.`zamjena`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `apoteka`.`zamjena` ;

CREATE TABLE IF NOT EXISTS `apoteka`.`zamjena` (
  `lijek_id` INT NOT NULL,
  `lijek_id1` INT NOT NULL,
  PRIMARY KEY (`lijek_id`, `lijek_id1`),
  INDEX `fk_lijek_has_lijek_lijek2_idx` (`lijek_id1` ASC),
  INDEX `fk_lijek_has_lijek_lijek1_idx` (`lijek_id` ASC),
  CONSTRAINT `fk_lijek_has_lijek_lijek1`
    FOREIGN KEY (`lijek_id`)
    REFERENCES `apoteka`.`lijek` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_lijek_has_lijek_lijek2`
    FOREIGN KEY (`lijek_id1`)
    REFERENCES `apoteka`.`lijek` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `apoteka`.`narudzba_has_lijek`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `apoteka`.`narudzba_has_lijek` ;

CREATE TABLE IF NOT EXISTS `apoteka`.`narudzba_has_lijek` (
  `narudzba_id` INT NOT NULL,
  `narudzba_sef_sluzbe_apotekar_id` INT NOT NULL,
  `narudzba_dobavljac_id` INT NOT NULL,
  `lijek_id` INT NOT NULL,
  PRIMARY KEY (`narudzba_id`, `narudzba_sef_sluzbe_apotekar_id`, `narudzba_dobavljac_id`, `lijek_id`),
  INDEX `fk_narudzba_has_lijek_lijek1_idx` (`lijek_id` ASC),
  INDEX `fk_narudzba_has_lijek_narudzba1_idx` (`narudzba_id` ASC, `narudzba_sef_sluzbe_apotekar_id` ASC, `narudzba_dobavljac_id` ASC),
  CONSTRAINT `fk_narudzba_has_lijek_narudzba1`
    FOREIGN KEY (`narudzba_id` , `narudzba_sef_sluzbe_apotekar_id` , `narudzba_dobavljac_id`)
    REFERENCES `apoteka`.`narudzba` (`id` , `sef_sluzbe_apotekar_id` , `dobavljac_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_narudzba_has_lijek_lijek1`
    FOREIGN KEY (`lijek_id`)
    REFERENCES `apoteka`.`lijek` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

USE `apoteka` ;

-- -----------------------------------------------------
-- procedure dodavanje_zamjene
-- -----------------------------------------------------

USE `apoteka`;
DROP procedure IF EXISTS `apoteka`.`dodavanje_zamjene`;

DELIMITER $$
USE `apoteka`$$
CREATE PROCEDURE `dodavanje_zamjene` (IN id1 INT, IN id2 INT)
BEGIN
   DECLARE lista1 VARCHAR(45);
   DECLARE lista2 VARCHAR(45);
   START TRANSACTION;
   SELECT `lijek`.`lista` INTO lista1 FROM `lijek` WHERE id = id1;
   SELECT `lijek`.`lista` INTO lista2 FROM `lijek` WHERE id = id2;
   INSERT INTO `zamjena`(lijek_id, lijek_id1) VALUES(id1, id2);
   INSERT INTO `zamjena`(lijek_id, lijek_id1) VALUES(id2, id1);
   IF lista1 = lista2 THEN
      COMMIT;
      SELECT 'Uspjesno dodavanje.';
   ELSE
	  ROLLBACK;
      SELECT 'Lijekovi nisu sa iste liste.';
   END IF;
END$$

DELIMITER ;
USE `apoteka`;

DELIMITER $$

USE `apoteka`$$
DROP TRIGGER IF EXISTS `apoteka`.`apotekar_AFTER_INSERT` $$
USE `apoteka`$$
CREATE DEFINER = CURRENT_USER TRIGGER `apoteka`.`apotekar_AFTER_INSERT` AFTER INSERT ON `apotekar` FOR EACH ROW
BEGIN
   IF new.plata >= 1800 and new.zvanje = 'magistar farmacije' THEN
      INSERT INTO `sef_sluzbe`(apotekar_id) VALUES(new.id);
   END IF;
END$$


USE `apoteka`$$
DROP TRIGGER IF EXISTS `apoteka`.`racun_has_lijek_AFTER_INSERT` $$
USE `apoteka`$$
CREATE DEFINER = CURRENT_USER TRIGGER `apoteka`.`racun_has_lijek_AFTER_INSERT` AFTER INSERT ON `racun_has_lijek` FOR EACH ROW
BEGIN
   UPDATE `lijek` SET stanje = stanje - new.kolicina WHERE lijek.id = new.lijek_id;
END$$


DELIMITER ;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
