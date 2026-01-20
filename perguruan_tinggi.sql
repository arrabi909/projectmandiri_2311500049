-- phpMyAdmin SQL Dump
-- version 5.2.2
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Jan 15, 2026 at 03:07 PM
-- Server version: 8.4.3
-- PHP Version: 8.3.28

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `perguruan_tinggi`
--

-- --------------------------------------------------------

--
-- Table structure for table `alumni`
--

CREATE TABLE `alumni` (
  `nim` char(10) NOT NULL,
  `nm_alumni` varchar(30) NOT NULL,
  `prodi` enum('Sistem Informasi','Teknik Informatika','Bisnis Digital','Manajemen Informatika','Komputerisasi Akuntansi','Sistem Informasi Manajemen') NOT NULL,
  `tmpt_lahir` varchar(20) NOT NULL,
  `tgl_lahir` date NOT NULL,
  `alamat` text NOT NULL,
  `no_hp` varchar(13) NOT NULL,
  `tgl_lulus` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `alumni`
--

INSERT INTO `alumni` (`nim`, `nm_alumni`, `prodi`, `tmpt_lahir`, `tgl_lahir`, `alamat`, `no_hp`, `tgl_lulus`) VALUES
('0711500096', 'Rio Saputra', 'Teknik Informatika', 'Jakarta', '1980-07-11', 'Jl. Raya Bogor no. 625, Jakarta Timur', '08924256178', 2011),
('0911500142', 'Trihandoko', 'Teknik Informatika', 'Bandung', '1987-01-05', 'Jl. Ahmad Yani no. 77A, Surabaya', '082819802109', 2013),
('1022300001', 'Septiawan', 'Manajemen Informatika', 'Cimahi', '1990-08-31', 'Jl. Pahlawan, Semarang', '08181210981', 2016),
('1111510082', 'Yura Johansen', 'Teknik Informatika', 'Serang', '1979-12-13', 'Boulevard St., New York, USA', '25718981', 2013),
('1222501272', 'Annisa Melati', 'Sistem Informasi', 'Kediri', '1996-03-24', 'Jl. Riau no. 152, Bandung', '081261829182', 2016),
('1444300025', 'Berliana Hertanti', 'Komputerisasi Akuntansi', 'Purwakarta', '1999-02-13', 'Jl. Depati Amir no. 98, Pangkalpinang', '081271782910', 2011);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `alumni`
--
ALTER TABLE `alumni`
  ADD PRIMARY KEY (`nim`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
