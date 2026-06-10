-- =====================================================================
--  AOL GROUP PROJECT - COMP6799001 Database Technology
--  SejutaStay Hotel Booking Database (Tourism & Hospitality Sector)
--  Normalization UNF -> 1NF -> 2NF -> 3NF, implemented in MySQL
--
--  Group Members:
--    1. Daniel Steffen Kurniawan - 2602071171
--    2. Edvardo Khong            - 2602177171
--
--  Semester / Academic Year : 4 / 2025-2026
--
--  Contents:
--    1. CREATE DATABASE + 8 tables in 3NF (PK, FK, UNIQUE, CHECK)
--    2. Sample data (minimum 5 rows in every table)
--    3. Verification queries (JOIN, totals, row counts, data quality)
-- =====================================================================

DROP DATABASE IF EXISTS sejutastay;

CREATE DATABASE sejutastay
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE sejutastay;

-- ---------------------------------------------------------------------
-- 1. CREATE TABLES
--    Referenced tables are created before tables containing foreign keys.
-- ---------------------------------------------------------------------

-- 1.1 Guest: one row per customer
CREATE TABLE Guest (
    GuestID     VARCHAR(5)   NOT NULL,
    GuestName   VARCHAR(60)  NOT NULL,
    GuestPhone  VARCHAR(20)  NOT NULL,
    GuestEmail  VARCHAR(60)  NOT NULL,

    CONSTRAINT pk_guest PRIMARY KEY (GuestID),
    CONSTRAINT uq_guest_phone UNIQUE (GuestPhone),
    CONSTRAINT uq_guest_email UNIQUE (GuestEmail)
) ENGINE = InnoDB;

-- 1.2 Hotel: one row per hotel branch
CREATE TABLE Hotel (
    HotelID     VARCHAR(5)   NOT NULL,
    HotelName   VARCHAR(60)  NOT NULL,
    HotelCity   VARCHAR(40)  NOT NULL,

    CONSTRAINT pk_hotel PRIMARY KEY (HotelID)
) ENGINE = InnoDB;

-- 1.3 RoomType: one row per room category
CREATE TABLE RoomType (
    RoomTypeID     VARCHAR(5)     NOT NULL,
    RoomTypeName   VARCHAR(30)    NOT NULL,
    PricePerNight  DECIMAL(12,2)  NOT NULL,

    CONSTRAINT pk_roomtype PRIMARY KEY (RoomTypeID),
    CONSTRAINT uq_roomtype_name UNIQUE (RoomTypeName),
    CONSTRAINT chk_roomtype_price CHECK (PricePerNight >= 0)
) ENGINE = InnoDB;

-- 1.4 Service: one row per add-on service
CREATE TABLE Service (
    ServiceID     VARCHAR(5)     NOT NULL,
    ServiceName   VARCHAR(40)    NOT NULL,
    ServicePrice  DECIMAL(12,2)  NOT NULL,

    CONSTRAINT pk_service PRIMARY KEY (ServiceID),
    CONSTRAINT uq_service_name UNIQUE (ServiceName),
    CONSTRAINT chk_service_price CHECK (ServicePrice >= 0)
) ENGINE = InnoDB;

-- 1.5 Room: one row per physical room
--     Added HotelID so every room is assigned to a hotel branch.
--     This design assumes RoomNo is unique across the SejutaStay network.
CREATE TABLE Room (
    RoomNo      INT         NOT NULL,
    HotelID     VARCHAR(5)  NOT NULL,
    RoomTypeID  VARCHAR(5)  NOT NULL,

    CONSTRAINT pk_room PRIMARY KEY (RoomNo),

    CONSTRAINT fk_room_hotel
        FOREIGN KEY (HotelID)
        REFERENCES Hotel (HotelID)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_room_roomtype
        FOREIGN KEY (RoomTypeID)
        REFERENCES RoomType (RoomTypeID)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE = InnoDB;

-- 1.6 Booking: one row per reservation
CREATE TABLE Booking (
    BookingID     VARCHAR(6)  NOT NULL,
    BookingDate   DATE        NOT NULL,
    CheckInDate   DATE        NOT NULL,
    CheckOutDate  DATE        NOT NULL,
    GuestID       VARCHAR(5)  NOT NULL,
    HotelID       VARCHAR(5)  NOT NULL,

    CONSTRAINT pk_booking PRIMARY KEY (BookingID),

    CONSTRAINT fk_booking_guest
        FOREIGN KEY (GuestID)
        REFERENCES Guest (GuestID)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_booking_hotel
        FOREIGN KEY (HotelID)
        REFERENCES Hotel (HotelID)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT chk_booking_stay_dates
        CHECK (CheckOutDate > CheckInDate),

    CONSTRAINT chk_booking_created_before_stay
        CHECK (BookingDate <= CheckInDate)
) ENGINE = InnoDB;

-- 1.7 BookingRoom: junction table for Booking M:N Room
CREATE TABLE BookingRoom (
    BookingID  VARCHAR(6)  NOT NULL,
    RoomNo     INT         NOT NULL,

    CONSTRAINT pk_bookingroom PRIMARY KEY (BookingID, RoomNo),

    CONSTRAINT fk_bookingroom_booking
        FOREIGN KEY (BookingID)
        REFERENCES Booking (BookingID)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT fk_bookingroom_room
        FOREIGN KEY (RoomNo)
        REFERENCES Room (RoomNo)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE = InnoDB;

-- 1.8 BookingService: junction table for Booking M:N Service
CREATE TABLE BookingService (
    BookingID  VARCHAR(6)  NOT NULL,
    ServiceID  VARCHAR(5)  NOT NULL,

    CONSTRAINT pk_bookingservice PRIMARY KEY (BookingID, ServiceID),

    CONSTRAINT fk_bookingservice_booking
        FOREIGN KEY (BookingID)
        REFERENCES Booking (BookingID)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT fk_bookingservice_service
        FOREIGN KEY (ServiceID)
        REFERENCES Service (ServiceID)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE = InnoDB;

-- ---------------------------------------------------------------------
-- 2. INSERT SAMPLE DATA
--    Every table contains at least 5 rows, as required by the AOL brief.
-- ---------------------------------------------------------------------

-- 2.1 Guest (6 rows)
INSERT INTO Guest (GuestID, GuestName, GuestPhone, GuestEmail) VALUES
('G01', 'Andi Wijaya',   '081234567801', 'andi.wijaya@email.com'),
('G02', 'Bella Sari',    '081234567802', 'bella.sari@email.com'),
('G03', 'Citra Dewi',    '081234567803', 'citra.dewi@email.com'),
('G04', 'Doni Pratama',  '081234567804', 'doni.pratama@email.com'),
('G05', 'Eka Putri',     '081234567805', 'eka.putri@email.com'),
('G06', 'Fajar Nugroho', '081234567806', 'fajar.nugroho@email.com');

-- 2.2 Hotel (5 rows)
INSERT INTO Hotel (HotelID, HotelName, HotelCity) VALUES
('H01', 'Grand Jakarta Hotel',    'Jakarta'),
('H02', 'Bali Beach Resort',      'Denpasar'),
('H03', 'Yogya Heritage Hotel',   'Yogyakarta'),
('H04', 'Bandung Highland Hotel', 'Bandung'),
('H05', 'Lombok Paradise Resort', 'Mataram');

-- 2.3 RoomType (5 rows)
INSERT INTO RoomType (RoomTypeID, RoomTypeName, PricePerNight) VALUES
('RT1', 'Standard',   500000.00),
('RT2', 'Deluxe',     850000.00),
('RT3', 'Suite',     1500000.00),
('RT4', 'Family',    1200000.00),
('RT5', 'Executive', 2000000.00);

-- 2.4 Service (5 rows)
INSERT INTO Service (ServiceID, ServiceName, ServicePrice) VALUES
('SV1', 'Breakfast',        100000.00),
('SV2', 'Spa',              250000.00),
('SV3', 'Airport Transfer', 150000.00),
('SV4', 'Laundry',           75000.00),
('SV5', 'Late Checkout',    120000.00);

-- 2.5 Room (9 rows)
--     HotelID was added to identify the branch that owns each room.
INSERT INTO Room (RoomNo, HotelID, RoomTypeID) VALUES
(101, 'H01', 'RT2'),
(201, 'H02', 'RT3'),
(202, 'H02', 'RT3'),
(203, 'H02', 'RT2'),
(301, 'H03', 'RT1'),
(302, 'H03', 'RT1'),
(401, 'H04', 'RT4'),
(402, 'H04', 'RT4'),
(501, 'H05', 'RT5');

-- 2.6 Booking (7 rows)
INSERT INTO Booking
    (BookingID, BookingDate, CheckInDate, CheckOutDate, GuestID, HotelID)
VALUES
('B001', '2026-02-20', '2026-03-01', '2026-03-03', 'G01', 'H01'),
('B002', '2026-02-22', '2026-03-05', '2026-03-08', 'G02', 'H02'),
('B003', '2026-02-25', '2026-03-10', '2026-03-12', 'G01', 'H03'),
('B004', '2026-03-01', '2026-03-15', '2026-03-18', 'G03', 'H02'),
('B005', '2026-03-03', '2026-03-20', '2026-03-22', 'G04', 'H04'),
('B006', '2026-03-05', '2026-03-25', '2026-03-28', 'G05', 'H05'),
('B007', '2026-03-08', '2026-04-01', '2026-04-03', 'G06', 'H03');

-- 2.7 BookingRoom (9 rows)
INSERT INTO BookingRoom (BookingID, RoomNo) VALUES
('B001', 101),
('B002', 201),
('B002', 202),
('B003', 301),
('B004', 203),
('B005', 401),
('B005', 402),
('B006', 501),
('B007', 302);

-- 2.8 BookingService (12 rows)
INSERT INTO BookingService (BookingID, ServiceID) VALUES
('B001', 'SV1'),
('B001', 'SV2'),
('B002', 'SV1'),
('B002', 'SV3'),
('B003', 'SV1'),
('B004', 'SV2'),
('B004', 'SV4'),
('B004', 'SV5'),
('B005', 'SV1'),
('B006', 'SV3'),
('B006', 'SV5'),
('B007', 'SV1');

-- ---------------------------------------------------------------------
-- 3. VERIFICATION QUERIES
-- ---------------------------------------------------------------------

-- 3.1 Full booking detail
--     The Room join checks that the room belongs to the booked hotel.
SELECT
    b.BookingID,
    g.GuestName,
    h.HotelName,
    h.HotelCity,
    r.RoomNo,
    rt.RoomTypeName,
    rt.PricePerNight,
    b.CheckInDate,
    b.CheckOutDate
FROM Booking AS b
JOIN Guest AS g
    ON b.GuestID = g.GuestID
JOIN Hotel AS h
    ON b.HotelID = h.HotelID
JOIN BookingRoom AS br
    ON b.BookingID = br.BookingID
JOIN Room AS r
    ON br.RoomNo = r.RoomNo
   AND b.HotelID = r.HotelID
JOIN RoomType AS rt
    ON r.RoomTypeID = rt.RoomTypeID
ORDER BY b.BookingID, r.RoomNo;

-- 3.2 Services taken in each booking
SELECT
    bs.BookingID,
    s.ServiceName,
    s.ServicePrice
FROM BookingService AS bs
JOIN Service AS s
    ON bs.ServiceID = s.ServiceID
ORDER BY bs.BookingID, s.ServiceID;

-- 3.3 Total service cost per booking
SELECT
    bs.BookingID,
    COUNT(*) AS TotalServices,
    SUM(s.ServicePrice) AS TotalServiceCost
FROM BookingService AS bs
JOIN Service AS s
    ON bs.ServiceID = s.ServiceID
GROUP BY bs.BookingID
ORDER BY bs.BookingID;

-- 3.4 Verify that every table contains at least 5 rows
SELECT 'Guest' AS TableName, COUNT(*) AS TotalRows FROM Guest
UNION ALL
SELECT 'Hotel', COUNT(*) FROM Hotel
UNION ALL
SELECT 'RoomType', COUNT(*) FROM RoomType
UNION ALL
SELECT 'Service', COUNT(*) FROM Service
UNION ALL
SELECT 'Room', COUNT(*) FROM Room
UNION ALL
SELECT 'Booking', COUNT(*) FROM Booking
UNION ALL
SELECT 'BookingRoom', COUNT(*) FROM BookingRoom
UNION ALL
SELECT 'BookingService', COUNT(*) FROM BookingService;

-- 3.5 Data-quality check: this should return zero rows
--     Any returned row means a booking is linked to a room in another hotel.
SELECT
    br.BookingID,
    br.RoomNo,
    b.HotelID AS BookingHotelID,
    r.HotelID AS RoomHotelID
FROM BookingRoom AS br
JOIN Booking AS b
    ON br.BookingID = b.BookingID
JOIN Room AS r
    ON br.RoomNo = r.RoomNo
WHERE b.HotelID <> r.HotelID;

-- End of script
