-- phpMyAdmin SQL Dump
-- version 4.8.4
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: 23-Fev-2019 às 22:59
-- Versão do servidor: 10.1.37-MariaDB
-- versão do PHP: 7.3.0

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `db_ecommerce`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_addresses_save` (`pidaddress` INT(11), `pidperson` INT(11), `pdesaddress` VARCHAR(128), `pdesnumber` VARCHAR(16), `pdescomplement` VARCHAR(32), `pdescity` VARCHAR(32), `pdesstate` VARCHAR(32), `pdescountry` VARCHAR(32), `pdeszipcode` CHAR(8), `pdesdistrict` VARCHAR(32))  BEGIN

	IF pidaddress > 0 THEN
		
		UPDATE tb_addresses
        SET
			idperson = pidperson,
            desaddress = pdesaddress,
            desnumber = pdesnumber,
            descomplement = pdescomplement,
            descity = pdescity,
            desstate = pdesstate,
            descountry = pdescountry,
            deszipcode = pdeszipcode, 
            desdistrict = pdesdistrict
		WHERE idaddress = pidaddress;
        
    ELSE
		
		INSERT INTO tb_addresses (idperson, desaddress, desnumber, descomplement, descity, desstate, descountry, deszipcode, desdistrict)
        VALUES(pidperson, pdesaddress, pdesnumber, pdescomplement, pdescity, pdesstate, pdescountry, pdeszipcode, pdesdistrict);
        
        SET pidaddress = LAST_INSERT_ID();
        
    END IF;
    
    SELECT * FROM tb_addresses WHERE idaddress = pidaddress;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_carts_save` (`pidcart` INT, `pdessessionid` VARCHAR(64), `piduser` INT, `pdeszipcode` CHAR(8), `pvlfreight` DECIMAL(10,2), `pnrdays` INT)  BEGIN

    IF pidcart > 0 THEN
        
        UPDATE tb_carts
        SET
            dessessionid = pdessessionid,
            iduser = piduser,
            deszipcode = pdeszipcode,
            vlfreight = pvlfreight,
            nrdays = pnrdays
        WHERE idcart = pidcart;
        
    ELSE
        
        INSERT INTO tb_carts (dessessionid, iduser, deszipcode, vlfreight, nrdays)
        VALUES(pdessessionid, piduser, pdeszipcode, pvlfreight, pnrdays);
        
        SET pidcart = LAST_INSERT_ID();
        
    END IF;
    
    SELECT * FROM tb_carts WHERE idcart = pidcart;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_categories_save` (`pidcategory` INT, `pdescategory` VARCHAR(64))  BEGIN
	
	IF pidcategory > 0 THEN
		
		UPDATE tb_categories
        SET descategory = pdescategory
        WHERE idcategory = pidcategory;
        
    ELSE
		
		INSERT INTO tb_categories (descategory) VALUES(pdescategory);
        
        SET pidcategory = LAST_INSERT_ID();
        
    END IF;
    
    SELECT * FROM tb_categories WHERE idcategory = pidcategory;
    
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_orders_save` (`pidorder` INT, `pidcart` INT(11), `piduser` INT(11), `pidstatus` INT(11), `pidaddress` INT(11), `pvltotal` DECIMAL(10,2))  BEGIN
	
	IF pidorder > 0 THEN
		
		UPDATE tb_orders
        SET
			idcart = pidcart,
            iduser = piduser,
            idstatus = pidstatus,
            idaddress = pidaddress,
            vltotal = pvltotal
		WHERE idorder = pidorder;
        
    ELSE
    
		INSERT INTO tb_orders (idcart, iduser, idstatus, idaddress, vltotal)
        VALUES(pidcart, piduser, pidstatus, pidaddress, pvltotal);
		
		SET pidorder = LAST_INSERT_ID();
        
    END IF;
    
    SELECT * 
    FROM tb_orders a
    INNER JOIN tb_ordersstatus b USING(idstatus)
    INNER JOIN tb_carts c USING(idcart)
    INNER JOIN tb_users d ON d.iduser = a.iduser
    INNER JOIN tb_addresses e USING(idaddress)
    WHERE idorder = pidorder;
    
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_products_save` (`pidproduct` INT(11), `pdesproduct` VARCHAR(64), `pvlprice` DECIMAL(10,2), `pvlwidth` DECIMAL(10,2), `pvlheight` DECIMAL(10,2), `pvllength` DECIMAL(10,2), `pvlweight` DECIMAL(10,2), `pdesurl` VARCHAR(128))  BEGIN
	
	IF pidproduct > 0 THEN
		
		UPDATE tb_products
        SET 
			desproduct = pdesproduct,
            vlprice = pvlprice,
            vlwidth = pvlwidth,
            vlheight = pvlheight,
            vllength = pvllength,
            vlweight = pvlweight,
            desurl = pdesurl
        WHERE idproduct = pidproduct;
        
    ELSE
		
		INSERT INTO tb_products (desproduct, vlprice, vlwidth, vlheight, vllength, vlweight, desurl) 
        VALUES(pdesproduct, pvlprice, pvlwidth, pvlheight, pvllength, pvlweight, pdesurl);
        
        SET pidproduct = LAST_INSERT_ID();
        
    END IF;
    
    SELECT * FROM tb_products WHERE idproduct = pidproduct;
    
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_userspasswordsrecoveries_create` (`piduser` INT, `pdesip` VARCHAR(45))  BEGIN
	
	INSERT INTO tb_userspasswordsrecoveries (iduser, desip)
    VALUES(piduser, pdesip);
    
    SELECT * FROM tb_userspasswordsrecoveries
    WHERE idrecovery = LAST_INSERT_ID();
    
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_usersupdate_save` (`piduser` INT, `pdesperson` VARCHAR(64), `pdeslogin` VARCHAR(64), `pdespassword` VARCHAR(256), `pdesemail` VARCHAR(128), `pnrphone` BIGINT, `pinadmin` TINYINT)  BEGIN
	
    DECLARE vidperson INT;
    
	SELECT idperson INTO vidperson
    FROM tb_users
    WHERE iduser = piduser;
    
    UPDATE tb_persons
    SET 
		desperson = pdesperson,
        desemail = pdesemail,
        nrphone = pnrphone
	WHERE idperson = vidperson;
    
    UPDATE tb_users
    SET
		deslogin = pdeslogin,
        despassword = pdespassword,
        inadmin = pinadmin
	WHERE iduser = piduser;
    
    SELECT * FROM tb_users a INNER JOIN tb_persons b USING(idperson) WHERE a.iduser = piduser;
    
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_users_delete` (`piduser` INT)  BEGIN
    
    DECLARE vidperson INT;
    
    SET FOREIGN_KEY_CHECKS = 0;
	
	SELECT idperson INTO vidperson
    FROM tb_users
    WHERE iduser = piduser;
	
    DELETE FROM tb_addresses WHERE idperson = vidperson;
    DELETE FROM tb_addresses WHERE idaddress IN(SELECT idaddress FROM tb_orders WHERE iduser = piduser);
	DELETE FROM tb_persons WHERE idperson = vidperson;
    
    DELETE FROM tb_userslogs WHERE iduser = piduser;
    DELETE FROM tb_userspasswordsrecoveries WHERE iduser = piduser;
    DELETE FROM tb_orders WHERE iduser = piduser;
    DELETE FROM tb_cartsproducts WHERE idcart IN(SELECT idcart FROM tb_carts WHERE iduser = piduser);
    DELETE FROM tb_carts WHERE iduser = piduser;
    DELETE FROM tb_users WHERE iduser = piduser;
    
    SET FOREIGN_KEY_CHECKS = 1;
    
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_users_save` (`pdesperson` VARCHAR(64), `pdeslogin` VARCHAR(64), `pdespassword` VARCHAR(256), `pdesemail` VARCHAR(128), `pnrphone` BIGINT, `pinadmin` TINYINT)  BEGIN
	
    DECLARE vidperson INT;
    
	INSERT INTO tb_persons (desperson, desemail, nrphone)
    VALUES(pdesperson, pdesemail, pnrphone);
    
    SET vidperson = LAST_INSERT_ID();
    
    INSERT INTO tb_users (idperson, deslogin, despassword, inadmin)
    VALUES(vidperson, pdeslogin, pdespassword, pinadmin);
    
    SELECT * FROM tb_users a INNER JOIN tb_persons b USING(idperson) WHERE a.iduser = LAST_INSERT_ID();
    
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estrutura da tabela `tb_addresses`
--

CREATE TABLE `tb_addresses` (
  `idaddress` int(11) NOT NULL,
  `idperson` int(11) NOT NULL,
  `desaddress` varchar(128) NOT NULL,
  `desnumber` varchar(16) NOT NULL,
  `descomplement` varchar(32) DEFAULT NULL,
  `descity` varchar(32) NOT NULL,
  `desstate` varchar(32) NOT NULL,
  `descountry` varchar(32) NOT NULL,
  `deszipcode` char(8) NOT NULL,
  `desdistrict` varchar(32) NOT NULL,
  `dtregister` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Extraindo dados da tabela `tb_addresses`
--

INSERT INTO `tb_addresses` (`idaddress`, `idperson`, `desaddress`, `desnumber`, `descomplement`, `descity`, `desstate`, `descountry`, `deszipcode`, `desdistrict`, `dtregister`) VALUES
(1, 12, 'Avenida Miguel Gonçalves da Silva', '133', '', 'Jataí', 'GO', 'Brasil', '75801380', 'Vila Sofia', '2019-01-21 19:48:31'),
(2, 12, 'Avenida Miguel Gonçalves da Silva', '133', '', 'Jataí', 'GO', 'Brasil', '75801380', 'Vila Sofia', '2019-01-21 19:53:32'),
(3, 12, 'Avenida Miguel Gonçalves da Silva', '133', '', 'Jataí', 'GO', 'Brasil', '75801380', 'Vila Sofia', '2019-01-21 19:54:36'),
(4, 12, 'Avenida Miguel Gonçalves da Silva', '133', '', 'Jataí', 'GO', 'Brasil', '75801380', 'Vila Sofia', '2019-01-21 19:57:55'),
(5, 12, 'Avenida Miguel Gonçalves da Silva', '133', '', 'Jataí', 'GO', 'Brasil', '75801380', 'Vila Sofia', '2019-01-21 20:06:09'),
(6, 13, 'Avenida Miguel Gonçalves da Silva', '133', '', 'Jataí', 'GO', 'Brasil', '75801380', 'Vila Sofia', '2019-01-22 15:00:37'),
(7, 15, 'Avenida Miguel Gonçalves da Silva', '133', '', 'Jataí', 'GO', 'Brasil', '75801380', 'Vila Sofia', '2019-01-23 02:41:09'),
(8, 15, 'Avenida Miguel Gonçalves da Silva', '133', '', 'Jataí', 'GO', 'Brasil', '75801380', 'Vila Sofia', '2019-01-23 03:05:39'),
(9, 15, 'Avenida Miguel Gonçalves da Silva', '133', '', 'Jataí', 'GO', 'Brasil', '75801380', 'Vila Sofia', '2019-01-23 03:22:56'),
(10, 15, 'Avenida Miguel Gonçalves da Silva', '133', '', 'Jataí', 'GO', 'Brasil', '75801380', 'Vila Sofia', '2019-01-23 03:23:14'),
(11, 15, 'Avenida Miguel Gonçalves da Silva', '133', '', 'Jataí', 'GO', 'Brasil', '75801380', 'Vila Sofia', '2019-01-24 18:33:05'),
(12, 15, 'Avenida Miguel Gonçalves da Silva', '133', '', 'Jataí', 'GO', 'Brasil', '75801380', 'Vila Sofia', '2019-01-24 18:36:49'),
(13, 15, 'Avenida Miguel Gonçalves da Silva', '', '', 'Jataí', 'GO', 'Brasil', '75801380', 'Vila Sofia', '2019-01-24 18:37:52'),
(14, 15, 'Avenida Miguel Gonçalves da Silva', '', '', 'Jataí', 'GO', 'Brasil', '75801380', 'Vila Sofia', '2019-01-24 18:38:18'),
(15, 15, 'Avenida Miguel Gonçalves da Silva', '133', '', 'Jataí', 'GO', 'Brasil', '75801380', 'Vila Sofia', '2019-01-24 18:39:03'),
(16, 15, 'Avenida Miguel Gonçalves da Silva', '133', '', 'Jataí', 'GO', 'Brasil', '75801380', 'Vila Sofia', '2019-01-24 18:40:27'),
(17, 15, 'Avenida Miguel Gonçalves da Silva', '133', '', 'Jataí', 'GO', 'Brasil', '75801380', 'Vila Sofia', '2019-01-24 18:50:48'),
(18, 15, 'Avenida Miguel Gonçalves da Silva', '', '', 'Jataí', 'GO', 'Brasil', '75801380', 'Vila Sofia', '2019-01-24 18:54:45'),
(19, 15, 'Avenida Miguel Gonçalves da Silva', '', '', 'Jataí', 'GO', 'Brasil', '75801380', 'Vila Sofia', '2019-01-24 18:56:41'),
(20, 15, 'Avenida Miguel Gonçalves da Silva', '133', '', 'Jataí', 'GO', 'Brasil', '75801380', 'Vila Sofia', '2019-01-24 18:57:16'),
(21, 15, 'Avenida Miguel Gonçalves da Silva', '', '', 'Jataí', 'GO', 'Brasil', '75801380', 'Vila Sofia', '2019-01-24 19:05:55'),
(22, 15, 'Avenida Miguel Gonçalves da Silva', '', '', 'Jataí', 'GO', 'Brasil', '75801380', 'Vila Sofia', '2019-01-24 19:06:18'),
(23, 15, 'Avenida Miguel Gonçalves da Silva', '', '', 'Jataí', 'GO', 'Brasil', '75801380', 'Vila Sofia', '2019-01-24 19:06:27'),
(24, 15, 'Avenida Miguel Gonçalves da Silva', '', '', 'Jataí', 'GO', 'Brasil', '75801380', 'Vila Sofia', '2019-01-24 19:06:49'),
(25, 15, 'Avenida Miguel Gonçalves da Silva', '', '', 'Jataí', 'GO', 'Brasil', '75801380', 'Vila Sofia', '2019-01-24 19:08:05'),
(26, 15, 'Avenida Miguel Gonçalves da Silva', '', '', 'Jataí', 'GO', 'Brasil', '75801380', 'Vila Sofia', '2019-01-24 19:08:40'),
(27, 15, 'Avenida Miguel Gonçalves da Silva', '', '', 'Jataí', 'GO', 'Brasil', '75801380', 'Vila Sofia', '2019-01-24 19:09:12'),
(28, 15, 'Avenida Miguel Gonçalves da Silva', '', '', 'Jataí', 'GO', 'Brasil', '75801380', 'Vila Sofia', '2019-01-24 19:10:37'),
(29, 15, 'Avenida Miguel Gonçalves da Silva', '', '', 'Jataí', 'GO', 'Brasil', '75801380', 'Vila Sofia', '2019-01-24 19:11:10'),
(30, 15, 'Avenida Miguel Gonçalves da Silva', '', '', 'Jataí', 'GO', 'Brasil', '75801380', 'Vila Sofia', '2019-01-24 19:14:36'),
(31, 15, 'Avenida Miguel Gonçalves da Silva', '', '', 'Jataí', 'GO', 'Brasil', '75801380', 'Vila Sofia', '2019-01-24 19:15:27'),
(32, 15, 'Avenida Miguel Gonçalves da Silva', '', '', 'Jataí', 'GO', 'Brasil', '75801380', 'Vila Sofia', '2019-01-24 19:16:08'),
(33, 15, 'Avenida Miguel Gonçalves da Silva', '133', '', 'Jataí', 'GO', 'Brasil', '75801380', 'Vila Sofia', '2019-01-24 19:20:55'),
(34, 15, 'Avenida Miguel Gonçalves da Silva', '', '', 'Jataí', 'GO', 'Brasil', '75801380', 'Vila Sofia', '2019-01-24 19:21:55'),
(35, 15, 'Avenida Miguel Gonçalves da Silva', '', '', 'Jataí', 'GO', 'Brasil', '75801380', 'Vila Sofia', '2019-01-24 19:22:56'),
(36, 15, 'Avenida Miguel Gonçalves da Silva', '', '', 'Jataí', 'GO', 'Brasil', '75801380', 'Vila Sofia', '2019-01-24 19:24:03'),
(37, 15, 'Avenida Miguel Gonçalves da Silva', '', '', 'Jataí', 'GO', 'Brasil', '75801380', 'Vila Sofia', '2019-01-24 19:24:20'),
(38, 15, 'Avenida Miguel Gonçalves da Silva', '', '', 'Jataí', 'GO', 'Brasil', '75801380', 'Vila Sofia', '2019-01-24 19:25:01'),
(39, 15, 'Avenida Miguel Gonçalves da Silva', '133', '', 'Jataí', 'GO', 'Brasil', '75801380', 'Vila Sofia', '2019-01-24 19:26:18'),
(40, 15, 'Avenida Miguel Gonçalves da Silva', '133', '', 'Jataí', 'GO', 'Brasil', '75801380', 'Vila Sofia', '2019-01-24 19:26:44'),
(41, 15, 'Avenida Miguel Gonçalves da Silva', '133', '', 'Jataí', 'GO', 'Brasil', '75801380', 'Vila Sofia', '2019-01-24 19:29:43'),
(42, 15, 'Avenida Miguel Gonçalves da Silva', '133', '', 'Jataí', 'GO', 'Brasil', '75801380', 'Vila Sofia', '2019-01-24 19:32:25'),
(43, 15, 'Avenida Miguel Gonçalves da Silva', '133', '', 'Jataí', 'GO', 'Brasil', '75801380', 'Vila Sofia', '2019-01-24 19:33:01'),
(44, 15, 'Avenida Miguel Gonçalves da Silva', '133', '', 'Jataí', 'GO', 'Brasil', '75801380', 'Vila Sofia', '2019-01-24 19:33:15'),
(45, 15, 'Avenida Miguel Gonçalves da Silva', '133', '', 'Jataí', 'GO', 'Brasil', '75801380', 'Vila Sofia', '2019-01-24 19:33:30'),
(46, 15, 'Avenida Miguel Gonçalves da Silva', '133', '', 'Jataí', 'GO', 'Brasil', '75801380', 'Vila Sofia', '2019-01-24 19:34:05'),
(47, 15, 'Avenida Miguel Gonçalves da Silva', '133', '', 'Jataí', 'GO', 'Brasil', '75801380', 'Vila Sofia', '2019-01-24 19:34:24'),
(48, 15, 'Avenida Miguel Gonçalves da Silva', '', '', 'Jataí', 'GO', 'Brasil', '75801380', 'Vila Sofia', '2019-01-24 19:34:57'),
(49, 15, 'Avenida Miguel Gonçalves da Silva', '', '', 'Jataí', 'GO', 'Brasil', '75801380', 'Vila Sofia', '2019-01-24 19:35:04'),
(50, 15, 'Avenida Miguel Gonçalves da Silva', '133', '', 'Jataí', 'GO', 'Brasil', '75801380', 'Vila Sofia', '2019-01-24 19:37:49'),
(51, 15, 'Avenida Miguel Gonçalves da Silva', '133', '', 'Jataí', 'GO', 'Brasil', '75801380', 'Vila Sofia', '2019-01-24 19:38:24'),
(52, 15, 'Avenida Miguel Gonçalves da Silva', '133', '', 'Jataí', 'GO', 'Brasil', '75801380', 'Vila Sofia', '2019-01-24 19:40:09'),
(53, 15, 'Avenida Miguel Gonçalves da Silva', '133', '', 'Jataí', 'GO', 'Brasil', '75801380', 'Vila Sofia', '2019-01-24 19:41:01'),
(54, 16, 'Avenida Miguel Gonçalves da Silva', '133', '', 'Jataí', 'GO', 'Brasil', '75801380', 'Vila Sofia', '2019-01-24 19:43:29'),
(55, 16, 'Avenida Miguel Gonçalves da Silva', '133', '', 'Jataí', 'GO', 'Brasil', '75801380', 'Vila Sofia', '2019-01-24 19:43:59'),
(56, 15, 'Avenida Miguel Gonçalves da Silva', '133', '', 'Jataí', 'GO', 'Brasil', '75801380', 'Vila Sofia', '2019-01-24 19:57:14');

-- --------------------------------------------------------

--
-- Estrutura da tabela `tb_carts`
--

CREATE TABLE `tb_carts` (
  `idcart` int(11) NOT NULL,
  `dessessionid` varchar(64) NOT NULL,
  `iduser` int(11) DEFAULT NULL,
  `deszipcode` char(8) DEFAULT NULL,
  `vlfreight` decimal(10,2) DEFAULT NULL,
  `nrdays` int(11) DEFAULT NULL,
  `dtregister` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Extraindo dados da tabela `tb_carts`
--

INSERT INTO `tb_carts` (`idcart`, `dessessionid`, `iduser`, `deszipcode`, `vlfreight`, `nrdays`, `dtregister`) VALUES
(1, '8hcko3j7hmgp8sv7ggnseueupv', NULL, '22041080', NULL, 2, '2017-09-04 18:50:50'),
(2, 'm8iq807es95o2hj1a30772df1d', NULL, '21615338', '72.92', 2, '2017-09-06 13:12:50'),
(3, 'cl1s6p6ti29vns970emmbhe7tb', 7, NULL, NULL, NULL, '2017-09-06 13:46:15'),
(4, 'a8frnbabuqu60gguivlmrpagin', NULL, '01310100', '61.12', 1, '2017-09-08 11:39:01'),
(5, '51jglmd9n3cdirc1ah75m31pt1', NULL, NULL, NULL, NULL, '2017-09-14 11:26:39'),
(6, 'tlvjs3tas1bml5uit8b5qgjn9l', NULL, '01310100', '42.79', 1, '2017-09-21 13:18:21'),
(7, 'id4ikere9eb10vmup660tnml1k', NULL, '75801380', '87.84', 4, '2019-01-21 15:28:25'),
(8, '2dh36qok3d7ar3nss02ut5lsse', NULL, '75801380', NULL, NULL, '2019-01-21 15:51:21'),
(9, '5868gvks76cjjj9l4oduh2n2gp', NULL, '75801380', NULL, NULL, '2019-01-21 15:52:58'),
(10, 'c5js37c5ck8cadraheu4799uv9', NULL, '75801380', '75.46', 4, '2019-01-21 17:30:52'),
(11, 'lcdgc71fs47d1lr8rk8q2diq2q', NULL, '75801380', '101.44', 4, '2019-01-21 18:26:23'),
(12, 'o83vu529tds0b3u5s61is2jftu', NULL, NULL, NULL, NULL, '2019-01-22 01:10:12'),
(13, 'h8hh7a96a2kvnc8tj8nk6551mo', NULL, NULL, NULL, NULL, '2019-01-22 01:48:35'),
(14, 'jbkbkspki9bq8ncn73qdohp6kr', NULL, '75801380', '75.46', 4, '2019-01-22 14:59:19'),
(15, 'tldobsge2fils5k2oodkffsq0n', NULL, '75801380', '137.37', 4, '2019-01-22 16:26:01'),
(16, 'kuc7ne01kvd7vr904ujct8gu9n', NULL, NULL, NULL, NULL, '2019-01-22 16:30:48'),
(17, 'ld7trd013l26dlmkse1urmdutv', NULL, '75801380', '75.46', 4, '2019-01-23 02:40:17'),
(18, 'sri66396f5raqloanbunfb21v2', NULL, '75801380', '89.06', 4, '2019-01-24 18:32:24'),
(19, 'ngo3mdig4lhqc8piumfl60javc', NULL, '75801380', '89.06', 4, '2019-01-24 19:42:28');

-- --------------------------------------------------------

--
-- Estrutura da tabela `tb_cartsproducts`
--

CREATE TABLE `tb_cartsproducts` (
  `idcartproduct` int(11) NOT NULL,
  `idcart` int(11) NOT NULL,
  `idproduct` int(11) NOT NULL,
  `dtremoved` datetime DEFAULT NULL,
  `dtregister` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Extraindo dados da tabela `tb_cartsproducts`
--

INSERT INTO `tb_cartsproducts` (`idcartproduct`, `idcart`, `idproduct`, `dtremoved`, `dtregister`) VALUES
(1, 1, 2, '2017-09-04 15:51:33', '2017-09-04 18:51:14'),
(2, 1, 2, '2017-09-04 15:52:09', '2017-09-04 18:51:31'),
(3, 1, 4, '2017-09-04 15:53:42', '2017-09-04 18:53:36'),
(4, 1, 4, '2017-09-04 15:54:11', '2017-09-04 18:53:40'),
(5, 1, 2, '2017-09-04 16:32:57', '2017-09-04 18:54:01'),
(6, 1, 2, '2017-09-04 16:33:04', '2017-09-04 19:31:05'),
(7, 1, 2, '2017-09-04 16:41:33', '2017-09-04 19:32:59'),
(8, 1, 2, '2017-09-04 16:41:38', '2017-09-04 19:33:02'),
(9, 1, 2, NULL, '2017-09-04 19:39:39'),
(10, 2, 2, '2017-09-06 10:21:57', '2017-09-06 13:20:44'),
(11, 2, 4, NULL, '2017-09-06 13:42:37'),
(12, 2, 4, NULL, '2017-09-06 15:28:56'),
(13, 4, 4, '2017-09-08 09:39:01', '2017-09-08 11:39:01'),
(14, 4, 4, NULL, '2017-09-08 12:27:38'),
(15, 4, 4, NULL, '2017-09-08 12:38:57'),
(16, 6, 4, NULL, '2017-09-21 13:59:32'),
(17, 7, 3, NULL, '2019-01-21 15:28:45'),
(18, 10, 5, NULL, '2019-01-21 17:31:44'),
(19, 11, 5, NULL, '2019-01-21 19:38:37'),
(20, 11, 3, NULL, '2019-01-21 19:52:47'),
(21, 12, 5, NULL, '2019-01-22 01:45:47'),
(22, 13, 1, NULL, '2019-01-22 01:48:48'),
(23, 12, 4, NULL, '2019-01-22 02:03:33'),
(24, 14, 5, NULL, '2019-01-22 14:59:24'),
(25, 15, 3, '2019-01-22 15:14:44', '2019-01-22 16:26:08'),
(26, 15, 3, '2019-01-22 15:14:44', '2019-01-22 16:28:27'),
(27, 15, 2, NULL, '2019-01-22 16:33:34'),
(28, 15, 2, NULL, '2019-01-22 16:38:13'),
(29, 17, 5, NULL, '2019-01-23 02:40:26'),
(30, 18, 5, '2019-01-24 17:25:56', '2019-01-24 18:32:33'),
(31, 18, 5, '2019-01-24 17:26:02', '2019-01-24 18:38:51'),
(32, 18, 5, '2019-01-24 17:26:05', '2019-01-24 18:40:09'),
(33, 18, 5, NULL, '2019-01-24 19:20:41'),
(34, 18, 5, NULL, '2019-01-24 19:29:33'),
(35, 19, 5, NULL, '2019-01-24 19:43:42'),
(36, 19, 5, NULL, '2019-01-24 19:43:47');

-- --------------------------------------------------------

--
-- Estrutura da tabela `tb_categories`
--

CREATE TABLE `tb_categories` (
  `idcategory` int(11) NOT NULL,
  `descategory` varchar(32) NOT NULL,
  `dtregister` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Extraindo dados da tabela `tb_categories`
--

INSERT INTO `tb_categories` (`idcategory`, `descategory`, `dtregister`) VALUES
(1, 'Android', '2017-09-21 15:18:08'),
(2, 'IOS', '2017-09-21 15:18:15'),
(3, 'Samsung', '2017-09-21 15:19:14');

-- --------------------------------------------------------

--
-- Estrutura da tabela `tb_orders`
--

CREATE TABLE `tb_orders` (
  `idorder` int(11) NOT NULL,
  `idcart` int(11) NOT NULL,
  `iduser` int(11) NOT NULL,
  `idstatus` int(11) NOT NULL,
  `idaddress` int(11) NOT NULL,
  `vltotal` decimal(10,2) NOT NULL,
  `dtregister` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Extraindo dados da tabela `tb_orders`
--

INSERT INTO `tb_orders` (`idorder`, `idcart`, `iduser`, `idstatus`, `idaddress`, `vltotal`, `dtregister`) VALUES
(1, 14, 13, 1, 6, '755.36', '2019-01-22 15:00:38'),
(2, 17, 15, 1, 7, '755.36', '2019-01-23 02:41:09'),
(3, 17, 15, 1, 8, '755.36', '2019-01-23 03:05:41'),
(4, 17, 15, 1, 9, '755.36', '2019-01-23 03:22:56'),
(5, 17, 15, 1, 10, '755.36', '2019-01-23 03:23:14'),
(6, 18, 15, 1, 11, '755.36', '2019-01-24 18:33:06'),
(7, 18, 15, 1, 12, '755.36', '2019-01-24 18:36:49'),
(8, 18, 15, 1, 13, '755.36', '2019-01-24 18:37:53'),
(9, 18, 15, 1, 14, '755.36', '2019-01-24 18:38:18'),
(10, 18, 15, 1, 15, '1448.86', '2019-01-24 18:39:03'),
(11, 18, 15, 1, 16, '2144.95', '2019-01-24 18:40:30'),
(12, 18, 15, 1, 17, '2144.95', '2019-01-24 18:50:49'),
(13, 18, 15, 1, 18, '2144.95', '2019-01-24 18:54:46'),
(14, 18, 15, 1, 19, '2144.95', '2019-01-24 18:56:42'),
(15, 18, 15, 1, 20, '2144.95', '2019-01-24 18:57:18'),
(16, 18, 15, 1, 21, '2144.95', '2019-01-24 19:05:55'),
(17, 18, 15, 1, 22, '2144.95', '2019-01-24 19:06:19'),
(18, 18, 15, 1, 23, '2144.95', '2019-01-24 19:06:27'),
(19, 18, 15, 1, 24, '2144.95', '2019-01-24 19:06:50'),
(20, 18, 15, 1, 25, '2144.95', '2019-01-24 19:08:06'),
(21, 18, 15, 1, 26, '2144.95', '2019-01-24 19:08:41'),
(22, 18, 15, 1, 27, '2144.95', '2019-01-24 19:09:12'),
(23, 18, 15, 1, 28, '2144.95', '2019-01-24 19:10:40'),
(24, 18, 15, 1, 29, '2144.95', '2019-01-24 19:11:11'),
(25, 18, 15, 1, 30, '2144.95', '2019-01-24 19:14:37'),
(26, 18, 15, 1, 31, '2144.95', '2019-01-24 19:15:28'),
(27, 18, 15, 1, 32, '2144.95', '2019-01-24 19:16:09'),
(28, 18, 15, 1, 33, '2838.45', '2019-01-24 19:20:55'),
(29, 18, 15, 1, 34, '2838.45', '2019-01-24 19:21:56'),
(30, 18, 15, 1, 35, '2838.45', '2019-01-24 19:22:57'),
(31, 18, 15, 1, 36, '2838.45', '2019-01-24 19:24:04'),
(32, 18, 15, 1, 37, '2838.45', '2019-01-24 19:24:21'),
(33, 18, 15, 1, 38, '2838.45', '2019-01-24 19:25:03'),
(34, 18, 15, 1, 39, '755.36', '2019-01-24 19:26:19'),
(35, 18, 15, 1, 40, '755.36', '2019-01-24 19:26:45'),
(36, 18, 15, 1, 41, '1448.86', '2019-01-24 19:29:43'),
(37, 18, 15, 1, 42, '1448.86', '2019-01-24 19:32:26'),
(38, 18, 15, 1, 43, '1448.86', '2019-01-24 19:33:02'),
(39, 18, 15, 1, 44, '1448.86', '2019-01-24 19:33:16'),
(40, 18, 15, 1, 45, '1448.86', '2019-01-24 19:33:30'),
(41, 18, 15, 1, 46, '1448.86', '2019-01-24 19:34:06'),
(42, 18, 15, 1, 47, '1448.86', '2019-01-24 19:34:25'),
(43, 18, 15, 1, 48, '1448.86', '2019-01-24 19:34:58'),
(44, 18, 15, 1, 49, '1448.86', '2019-01-24 19:35:04'),
(45, 18, 15, 1, 50, '1448.86', '2019-01-24 19:37:50'),
(46, 18, 15, 1, 51, '1448.86', '2019-01-24 19:38:26'),
(47, 18, 15, 1, 52, '1448.86', '2019-01-24 19:40:12'),
(48, 18, 15, 1, 53, '1448.86', '2019-01-24 19:41:01'),
(49, 19, 16, 1, 54, '0.00', '2019-01-24 19:43:29'),
(50, 19, 16, 1, 55, '1448.86', '2019-01-24 19:44:00'),
(51, 18, 15, 1, 56, '1448.86', '2019-01-24 19:57:15');

-- --------------------------------------------------------

--
-- Estrutura da tabela `tb_ordersstatus`
--

CREATE TABLE `tb_ordersstatus` (
  `idstatus` int(11) NOT NULL,
  `desstatus` varchar(32) NOT NULL,
  `dtregister` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Extraindo dados da tabela `tb_ordersstatus`
--

INSERT INTO `tb_ordersstatus` (`idstatus`, `desstatus`, `dtregister`) VALUES
(1, 'Em Aberto', '2017-03-13 03:00:00'),
(2, 'Aguardando Pagamento', '2017-03-13 03:00:00'),
(3, 'Pago', '2017-03-13 03:00:00'),
(4, 'Entregue', '2017-03-13 03:00:00');

-- --------------------------------------------------------

--
-- Estrutura da tabela `tb_persons`
--

CREATE TABLE `tb_persons` (
  `idperson` int(11) NOT NULL,
  `desperson` varchar(64) NOT NULL,
  `desemail` varchar(128) DEFAULT NULL,
  `nrphone` bigint(20) DEFAULT NULL,
  `dtregister` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Extraindo dados da tabela `tb_persons`
--

INSERT INTO `tb_persons` (`idperson`, `desperson`, `desemail`, `nrphone`, `dtregister`) VALUES
(7, 'Suporte', 'suporte@hcode.com.br', 1112345678, '2017-03-15 16:10:27'),
(8, '', '', 0, '2017-09-04 20:43:40'),
(10, 'Hcode', 'suporte@hcode.com.br', 1112345678, '2017-09-06 14:32:15'),
(11, 'Grégore', 'degloriocg@gmail.com', 62998620372, '2019-01-21 15:29:27'),
(12, 'Lorenzo', 'lorenzo@gmail.com', 62998620372, '2019-01-21 19:36:58'),
(13, 'Nicole', 'nicole@gmail.com', 62998620372, '2019-01-22 15:00:27'),
(14, 'Teste', 'teste@gmail.com', 62998620372, '2019-01-22 17:24:13'),
(15, 'Sara', 'saracosta1107@gmail.com', 62998620372, '2019-01-23 02:40:59'),
(16, 'Dudu', 'dudu@gmail.com', 62998620372, '2019-01-24 19:43:11');

-- --------------------------------------------------------

--
-- Estrutura da tabela `tb_products`
--

CREATE TABLE `tb_products` (
  `idproduct` int(11) NOT NULL,
  `desproduct` varchar(64) NOT NULL,
  `vlprice` decimal(10,2) NOT NULL,
  `vlwidth` decimal(10,2) NOT NULL,
  `vlheight` decimal(10,2) NOT NULL,
  `vllength` decimal(10,2) NOT NULL,
  `vlweight` decimal(10,2) NOT NULL,
  `desurl` varchar(128) NOT NULL,
  `dtregister` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Extraindo dados da tabela `tb_products`
--

INSERT INTO `tb_products` (`idproduct`, `desproduct`, `vlprice`, `vlwidth`, `vlheight`, `vllength`, `vlweight`, `desurl`, `dtregister`) VALUES
(1, 'Smartphone Motorola Moto G5 Plus', '1135.23', '15.20', '7.40', '0.70', '0.16', 'smartphone-motorola-moto-g5-plus', '2017-09-04 18:30:32'),
(2, 'Smartphone Moto Z Play', '1887.78', '14.10', '0.90', '1.16', '0.13', 'smartphone-moto-z-play', '2017-09-04 18:30:32'),
(3, 'Smartphone Samsung Galaxy J5 Pro', '1299.00', '14.60', '7.10', '0.80', '0.16', 'smartphone-samsung-galaxy-j5', '2017-09-04 18:30:32'),
(4, 'Smartphone Samsung Galaxy J7 Prime', '1149.00', '15.10', '7.50', '0.80', '0.16', 'smartphone-samsung-galaxy-j7', '2017-09-04 18:30:32'),
(5, 'Smartphone Samsung Galaxy J3 Dual', '679.90', '14.20', '7.10', '0.70', '0.14', 'smartphone-samsung-galaxy-j3', '2017-09-04 18:30:32');

-- --------------------------------------------------------

--
-- Estrutura da tabela `tb_productscategories`
--

CREATE TABLE `tb_productscategories` (
  `idcategory` int(11) NOT NULL,
  `idproduct` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estrutura da tabela `tb_users`
--

CREATE TABLE `tb_users` (
  `iduser` int(11) NOT NULL,
  `idperson` int(11) NOT NULL,
  `deslogin` varchar(64) NOT NULL,
  `despassword` varchar(256) NOT NULL,
  `inadmin` tinyint(4) NOT NULL DEFAULT '0',
  `dtregister` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Extraindo dados da tabela `tb_users`
--

INSERT INTO `tb_users` (`iduser`, `idperson`, `deslogin`, `despassword`, `inadmin`, `dtregister`) VALUES
(7, 7, 'suporte', '$2y$12$0HoqGJEa8UPrgQPYvDbjgOmnnnFXCVMehIRgM0zuPD87VM85Ykwjq', 1, '2017-03-15 16:10:27'),
(8, 8, '', '$2y$12$aEeuHG8QdmmcU1cZy.CLb.d8ffjQ4H0fGiNM.51ua9QYgYce.nVWG', 0, '2017-09-04 20:43:40'),
(10, 10, 'suporte@hcode.com.br', '$2y$12$U1J8BTm4LHRVg8s9I9icneryymudMIdS51hBeIa0w60P8D4VRSs/m', 1, '2017-09-06 14:32:15'),
(11, 11, 'degloriocg@gmail.com', '$2y$12$rkQBZnEurPB9XGIdLR2KZeQ0z0.GiuvZp4CqWmLp1iqjrq9MYryZm', 1, '2019-01-21 15:29:27'),
(12, 12, 'Lorenzo', '$2y$12$rkQBZnEurPB9XGIdLR2KZeQ0z0.GiuvZp4CqWmLp1iqjrq9MYryZm', 0, '2019-01-21 19:36:58'),
(13, 13, 'nicole@gmail.com', '$2y$12$/Vj/Y2ZjK8ds.lVnBCeEWO7Y2RLJc/WW.ou7fMbOl8RVXh3gJLp3.', 0, '2019-01-22 15:00:27'),
(14, 14, 'teste@gmail.com', '$2y$12$Y9BBxUbH.UawrSwhtABPP.mLxFyaBioM/X3LcQbUb/zlTSj.FHIeC', 0, '2019-01-22 17:24:13'),
(15, 15, 'saracosta1107@gmail.com', '$2y$12$uE3L0Q60a53/fs0ts6YBxuSEIM1O7KVlMoI47ZuMi5DnFHXlzAJs.', 0, '2019-01-23 02:40:59'),
(16, 16, 'dudu@gmail.com', '$2y$12$rmSF/r3lIsHR0CPiZLdjY.SR1bvxXBtklj2Gf0NS6yhM6FV/HZoiO', 0, '2019-01-24 19:43:11');

-- --------------------------------------------------------

--
-- Estrutura da tabela `tb_userslogs`
--

CREATE TABLE `tb_userslogs` (
  `idlog` int(11) NOT NULL,
  `iduser` int(11) NOT NULL,
  `deslog` varchar(128) NOT NULL,
  `desip` varchar(45) NOT NULL,
  `desuseragent` varchar(128) NOT NULL,
  `dessessionid` varchar(64) NOT NULL,
  `desurl` varchar(128) NOT NULL,
  `dtregister` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estrutura da tabela `tb_userspasswordsrecoveries`
--

CREATE TABLE `tb_userspasswordsrecoveries` (
  `idrecovery` int(11) NOT NULL,
  `iduser` int(11) NOT NULL,
  `desip` varchar(45) NOT NULL,
  `dtrecovery` datetime DEFAULT NULL,
  `dtregister` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Extraindo dados da tabela `tb_userspasswordsrecoveries`
--

INSERT INTO `tb_userspasswordsrecoveries` (`idrecovery`, `iduser`, `desip`, `dtrecovery`, `dtregister`) VALUES
(1, 7, '127.0.0.1', NULL, '2017-03-15 16:10:59'),
(2, 7, '127.0.0.1', '2017-03-15 13:33:45', '2017-03-15 16:11:18'),
(3, 7, '127.0.0.1', '2017-03-15 13:37:35', '2017-03-15 16:37:12'),
(4, 7, '127.0.0.1', NULL, '2017-09-06 13:44:34'),
(5, 7, '127.0.0.1', '2017-09-06 10:45:54', '2017-09-06 13:45:28');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `tb_addresses`
--
ALTER TABLE `tb_addresses`
  ADD PRIMARY KEY (`idaddress`),
  ADD KEY `fk_addresses_persons_idx` (`idperson`);

--
-- Indexes for table `tb_carts`
--
ALTER TABLE `tb_carts`
  ADD PRIMARY KEY (`idcart`),
  ADD KEY `FK_carts_users_idx` (`iduser`);

--
-- Indexes for table `tb_cartsproducts`
--
ALTER TABLE `tb_cartsproducts`
  ADD PRIMARY KEY (`idcartproduct`),
  ADD KEY `FK_cartsproducts_carts_idx` (`idcart`),
  ADD KEY `fk_cartsproducts_products_idx` (`idproduct`);

--
-- Indexes for table `tb_categories`
--
ALTER TABLE `tb_categories`
  ADD PRIMARY KEY (`idcategory`);

--
-- Indexes for table `tb_orders`
--
ALTER TABLE `tb_orders`
  ADD PRIMARY KEY (`idorder`),
  ADD KEY `FK_orders_users_idx` (`iduser`),
  ADD KEY `fk_orders_ordersstatus_idx` (`idstatus`),
  ADD KEY `fk_orders_carts_idx` (`idcart`),
  ADD KEY `fk_orders_addresses_idx` (`idaddress`);

--
-- Indexes for table `tb_ordersstatus`
--
ALTER TABLE `tb_ordersstatus`
  ADD PRIMARY KEY (`idstatus`);

--
-- Indexes for table `tb_persons`
--
ALTER TABLE `tb_persons`
  ADD PRIMARY KEY (`idperson`);

--
-- Indexes for table `tb_products`
--
ALTER TABLE `tb_products`
  ADD PRIMARY KEY (`idproduct`);

--
-- Indexes for table `tb_productscategories`
--
ALTER TABLE `tb_productscategories`
  ADD PRIMARY KEY (`idcategory`,`idproduct`),
  ADD KEY `fk_productscategories_products_idx` (`idproduct`);

--
-- Indexes for table `tb_users`
--
ALTER TABLE `tb_users`
  ADD PRIMARY KEY (`iduser`),
  ADD KEY `FK_users_persons_idx` (`idperson`);

--
-- Indexes for table `tb_userslogs`
--
ALTER TABLE `tb_userslogs`
  ADD PRIMARY KEY (`idlog`),
  ADD KEY `fk_userslogs_users_idx` (`iduser`);

--
-- Indexes for table `tb_userspasswordsrecoveries`
--
ALTER TABLE `tb_userspasswordsrecoveries`
  ADD PRIMARY KEY (`idrecovery`),
  ADD KEY `fk_userspasswordsrecoveries_users_idx` (`iduser`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `tb_addresses`
--
ALTER TABLE `tb_addresses`
  MODIFY `idaddress` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=57;

--
-- AUTO_INCREMENT for table `tb_carts`
--
ALTER TABLE `tb_carts`
  MODIFY `idcart` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

--
-- AUTO_INCREMENT for table `tb_cartsproducts`
--
ALTER TABLE `tb_cartsproducts`
  MODIFY `idcartproduct` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=37;

--
-- AUTO_INCREMENT for table `tb_categories`
--
ALTER TABLE `tb_categories`
  MODIFY `idcategory` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `tb_orders`
--
ALTER TABLE `tb_orders`
  MODIFY `idorder` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=52;

--
-- AUTO_INCREMENT for table `tb_ordersstatus`
--
ALTER TABLE `tb_ordersstatus`
  MODIFY `idstatus` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `tb_persons`
--
ALTER TABLE `tb_persons`
  MODIFY `idperson` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT for table `tb_products`
--
ALTER TABLE `tb_products`
  MODIFY `idproduct` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `tb_users`
--
ALTER TABLE `tb_users`
  MODIFY `iduser` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT for table `tb_userslogs`
--
ALTER TABLE `tb_userslogs`
  MODIFY `idlog` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `tb_userspasswordsrecoveries`
--
ALTER TABLE `tb_userspasswordsrecoveries`
  MODIFY `idrecovery` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- Constraints for dumped tables
--

--
-- Limitadores para a tabela `tb_addresses`
--
ALTER TABLE `tb_addresses`
  ADD CONSTRAINT `fk_addresses_persons` FOREIGN KEY (`idperson`) REFERENCES `tb_persons` (`idperson`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Limitadores para a tabela `tb_carts`
--
ALTER TABLE `tb_carts`
  ADD CONSTRAINT `fk_carts_users` FOREIGN KEY (`iduser`) REFERENCES `tb_users` (`iduser`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Limitadores para a tabela `tb_cartsproducts`
--
ALTER TABLE `tb_cartsproducts`
  ADD CONSTRAINT `fk_cartsproducts_carts` FOREIGN KEY (`idcart`) REFERENCES `tb_carts` (`idcart`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_cartsproducts_products` FOREIGN KEY (`idproduct`) REFERENCES `tb_products` (`idproduct`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Limitadores para a tabela `tb_orders`
--
ALTER TABLE `tb_orders`
  ADD CONSTRAINT `fk_orders_addresses` FOREIGN KEY (`idaddress`) REFERENCES `tb_addresses` (`idaddress`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_orders_carts` FOREIGN KEY (`idcart`) REFERENCES `tb_carts` (`idcart`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_orders_ordersstatus` FOREIGN KEY (`idstatus`) REFERENCES `tb_ordersstatus` (`idstatus`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_orders_users` FOREIGN KEY (`iduser`) REFERENCES `tb_users` (`iduser`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Limitadores para a tabela `tb_productscategories`
--
ALTER TABLE `tb_productscategories`
  ADD CONSTRAINT `fk_productscategories_categories` FOREIGN KEY (`idcategory`) REFERENCES `tb_categories` (`idcategory`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_productscategories_products` FOREIGN KEY (`idproduct`) REFERENCES `tb_products` (`idproduct`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Limitadores para a tabela `tb_users`
--
ALTER TABLE `tb_users`
  ADD CONSTRAINT `fk_users_persons` FOREIGN KEY (`idperson`) REFERENCES `tb_persons` (`idperson`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Limitadores para a tabela `tb_userslogs`
--
ALTER TABLE `tb_userslogs`
  ADD CONSTRAINT `fk_userslogs_users` FOREIGN KEY (`iduser`) REFERENCES `tb_users` (`iduser`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Limitadores para a tabela `tb_userspasswordsrecoveries`
--
ALTER TABLE `tb_userspasswordsrecoveries`
  ADD CONSTRAINT `fk_userspasswordsrecoveries_users` FOREIGN KEY (`iduser`) REFERENCES `tb_users` (`iduser`) ON DELETE NO ACTION ON UPDATE NO ACTION;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
