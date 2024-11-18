
DROP SCHEMA if exists football;
CREATE SCHEMA if not exists football;




use football;

CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,           -- 시스템 내부 고유 식별자
    userid VARCHAR(50) NOT NULL UNIQUE,          -- 로그인용 아이디
    password VARCHAR(255) NOT NULL,              -- 암호화된 비밀번호
    email VARCHAR(100) NOT NULL UNIQUE,          -- 이메일
    phone_number VARCHAR(15),                    -- 전화번호
    name VARCHAR(100) NOT NULL,                  -- 사용자 이름 또는 닉네임
    role ENUM('admin', 'user', 'manager') DEFAULT 'user', -- 사용자 역할
    position ENUM('forward', 'midfield', 'defense', 'goalkeeper') DEFAULT 'midfield', -- 성향
    tier ENUM('bronze', 'silver', 'gold', 'platinum', 'diamond') DEFAULT 'bronze',   -- 랭크
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP -- 생성 시간
);




CREATE TABLE stadium (
    id INT AUTO_INCREMENT PRIMARY KEY,           -- 고유 ID
    name VARCHAR(100) NOT NULL,                  -- 경기장 이름
    address VARCHAR(255) NOT NULL,               -- 경기장 주소
    price INT DEFAULT NULL,                      -- 대여 비용
    capacity INT NOT NULL,                       -- 수용 인원
    image VARCHAR(255) DEFAULT NULL,             -- 경기장 이미지 URL
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- 생성 시간
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP -- 갱신 시간
);

CREATE TABLE matches (
    id INT AUTO_INCREMENT PRIMARY KEY,           -- 고유 ID
    stadium_id INT NOT NULL,                     -- 경기장이 매핑된 ID
    start_time DATETIME NOT NULL,                -- 경기 시작 시간
    end_time DATETIME NOT NULL,                  -- 경기 종료 시간
    status ENUM('pending', 'approved', 'rejected', 'canceled') DEFAULT 'pending', -- 경기 상태
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- 생성 시간
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, -- 갱신 시간
    FOREIGN KEY (stadium_id) REFERENCES stadium(id) ON DELETE CASCADE -- 경기장 삭제 시 매치도 삭제
);

CREATE TABLE userstat (
    id INT AUTO_INCREMENT PRIMARY KEY,           -- 고유 ID
    user_id VARCHAR(50) NOT NULL,                        -- 사용자를 참조하는 ID
    shoot TINYINT NOT NULL CHECK (shoot BETWEEN 0 AND 100), -- 슛 스탯
    pass TINYINT NOT NULL CHECK (pass BETWEEN 0 AND 100),   -- 패스 스탯
    speed TINYINT NOT NULL CHECK (speed BETWEEN 0 AND 100), -- 스피드 스탯
    stamina TINYINT NOT NULL CHECK (stamina BETWEEN 0 AND 100), -- 체력 스탯
    dribble TINYINT NOT NULL CHECK (dribble BETWEEN 0 AND 100), -- 드리블 스탯
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- 생성 시간
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, -- 수정 시간
    match_id INT,                                 -- 경기를 참조하는 ID
    FOREIGN KEY (user_id) REFERENCES users(userid) ON DELETE CASCADE, -- 사용자 삭제 시 스탯도 삭제
    FOREIGN KEY (match_id) REFERENCES matches(id) ON DELETE CASCADE -- 경기 삭제 시 스탯도 삭제
);

CREATE TABLE reservations (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id VARCHAR(50) NOT NULL,                        -- 예약한 사용자 ID
    match_id INT NOT NULL,                       -- 예약한 경기 ID
    reservation_date DATETIME NOT NULL,          -- 예약 날짜 및 시간
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- 생성 시간
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, -- 갱신 시간
    FOREIGN KEY (user_id) REFERENCES users(userid) ON DELETE CASCADE,  -- 사용자 삭제 시 예약도 삭제
    FOREIGN KEY (match_id) REFERENCES matches(id) ON DELETE CASCADE -- 매치 삭제 시 예약도 삭제
);

CREATE TABLE reviews (
    id INT AUTO_INCREMENT PRIMARY KEY,           -- 고유 ID
    user_id VARCHAR(50) NOT NULL,                        -- 리뷰를 작성한 사용자 ID
    match_id INT NOT NULL,                       -- 리뷰 대상 경기 ID
    rating TINYINT NOT NULL CHECK (rating BETWEEN 1 AND 5), -- 별점 (1~5)
    comment TEXT,                                -- 리뷰 내용
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- 생성 시간
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, -- 갱신 시간
    FOREIGN KEY (user_id) REFERENCES users(userid) ON DELETE CASCADE,  -- 사용자 삭제 시 리뷰 삭제
    FOREIGN KEY (match_id) REFERENCES matches(id) ON DELETE CASCADE -- 매치 삭제 시 리뷰 삭제
);

INSERT INTO users (userid, password, email, phone_number, name, role, position, tier) VALUES
('ssafy', 'ssafy', 'ssafy@example.com', '010-1111-2222', '양명균', 'admin', 'forward', 'bronze'),
('john_doe', 'hashedpassword1', 'john@example.com', '010-1111-2222', 'John Doe', 'user', 'forward', 'bronze'),
('jane_smith', 'hashedpassword2', 'jane@example.com', '010-2222-3333', 'Jane Smith', 'user', 'midfield', 'silver'),
('michael_admin', 'hashedpassword3', 'admin@example.com', '010-3333-4444', 'Michael Admin', 'admin', 'defense', 'gold'),
('lucas_manager', 'hashedpassword4', 'manager@example.com', '010-4444-5555', 'Lucas Manager', 'manager', 'goalkeeper', 'platinum'),
('emily_forward', 'hashedpassword5', 'emily@example.com', '010-5555-6666', 'Emily Forward', 'user', 'forward', 'diamond'),
('chris_defense', 'hashedpassword6', 'chris@example.com', '010-6666-7777', 'Chris Defense', 'user', 'defense', 'bronze'),
('sarah_midfield', 'hashedpassword7', 'sarah@example.com', '010-7777-8888', 'Sarah Midfield', 'user', 'midfield', 'silver'),
('david_goalkeeper', 'hashedpassword8', 'david@example.com', '010-8888-9999', 'David Goalkeeper', 'user', 'goalkeeper', 'gold'),
('oliver_striker', 'hashedpassword9', 'oliver@example.com', '010-9999-0000', 'Oliver Striker', 'user', 'forward', 'platinum'),
('amelia_playmaker', 'hashedpassword10', 'amelia@example.com', '010-1010-1111', 'Amelia Playmaker', 'user', 'midfield', 'diamond');

INSERT INTO stadium (name, address, price, capacity, image) VALUES
('Seoul Futbol Stadium', '123 Soccer Lane, Seoul', 50000, 100, 'seoul_stadium.jpg'),
('Busan Arena', '45 Beach Road, Busan', 40000, 80, 'busan_arena.jpg'),
('Daegu Grounds', '789 Hilltop Drive, Daegu', 45000, 90, 'daegu_grounds.jpg'),
('Incheon Park', '135 Lakeview St, Incheon', 60000, 120, 'incheon_park.jpg'),
('Gwangju Field', '246 Riverbank Blvd, Gwangju', 30000, 70, 'gwangju_field.jpg'),
('Jeju Stadium', '369 Island Way, Jeju', 35000, 75, 'jeju_stadium.jpg'),
('Daejeon Arena', '101 City Center, Daejeon', 55000, 110, 'daejeon_arena.jpg'),
('Ulsan Grounds', '202 Industrial Rd, Ulsan', 48000, 95, 'ulsan_grounds.jpg'),
('Pohang Pitch', '303 Steelworks Ave, Pohang', 52000, 100, 'pohang_pitch.jpg'),
('Suwon Sports Complex', '404 Cultural Blvd, Suwon', 50000, 85, 'suwon_sports_complex.jpg');


INSERT INTO matches (stadium_id, start_time, end_time, status) VALUES
(1, '2024-11-19 14:00:00', '2024-11-19 16:00:00', 'approved'),
(2, '2024-11-20 10:00:00', '2024-11-20 12:00:00', 'pending'),
(3, '2024-11-21 18:00:00', '2024-11-21 20:00:00', 'rejected'),
(4, '2024-11-22 13:00:00', '2024-11-22 15:00:00', 'canceled'),
(5, '2024-11-23 09:00:00', '2024-11-23 11:00:00', 'approved'),
(6, '2024-11-24 16:00:00', '2024-11-24 18:00:00', 'pending'),
(7, '2024-11-25 14:00:00', '2024-11-25 16:00:00', 'approved'),
(8, '2024-11-26 19:00:00', '2024-11-26 21:00:00', 'approved'),
(9, '2024-11-27 11:00:00', '2024-11-27 13:00:00', 'canceled'),
(10, '2024-11-28 15:00:00', '2024-11-28 17:00:00', 'approved');

INSERT INTO userstat (user_id, shoot, pass, speed, stamina, dribble, match_id) VALUES
('ssafy', 85, 60, 78, 80, 70, 1),  -- John with match 1 (Seoul Futbol Stadium)
('john_doe', 60, 85, 75, 90, 68, 2),  -- Jane with match 2 (Busan Arena)
('jane_smith', 50, 55, 65, 70, 60, 3),  -- Michael with match 3 (Daegu Grounds)
('michael_admin', 45, 60, 50, 85, 40, 4),  -- Lucas with match 4 (Incheon Park)
('lucas_manager', 90, 75, 85, 88, 92, 5),  -- Emily with match 5 (Gwangju Field)
('emily_forward', 60, 55, 70, 80, 65, 6),  -- Chris with match 6 (Jeju Stadium)
('chris_defense', 75, 80, 75, 85, 78, 7),  -- Sarah with match 7 (Daejeon Arena)
('sarah_midfield', 50, 45, 70, 75, 55, 8),  -- David with match 8 (Ulsan Grounds)
('david_goalkeeper', 88, 72, 90, 80, 85, 9),  -- Oliver with match 9 (Pohang Pitch)
('oliver_striker', 65, 85, 78, 88, 70, 10); -- Amelia with match 10 (Suwon Sports Complex)





INSERT INTO reservations (user_id, match_id, reservation_date) VALUES
('ssafy', 1, '2024-11-18 09:00:00'),       -- ssafy reserved for Seoul match
('john_doe', 2, '2024-11-18 10:00:00'),    -- john_doe reserved for Busan match
('jane_smith', 3, '2024-11-18 11:00:00'),  -- jane_smith reserved for Daegu match
('michael_admin', 4, '2024-11-18 12:00:00'), -- michael_admin reserved for Incheon match
('lucas_manager', 5, '2024-11-18 13:00:00'), -- lucas_manager reserved for Gwangju match
('emily_forward', 6, '2024-11-18 14:00:00'), -- emily_forward reserved for Jeju match
('chris_defense', 7, '2024-11-18 15:00:00'), -- chris_defense reserved for Daejeon match
('sarah_midfield', 8, '2024-11-18 16:00:00'), -- sarah_midfield reserved for Ulsan match
('david_goalkeeper', 9, '2024-11-18 17:00:00'), -- david_goalkeeper reserved for Pohang match
('oliver_striker', 10, '2024-11-18 18:00:00'); -- oliver_striker reserved for Suwon match


INSERT INTO reviews (user_id, match_id, rating, comment) VALUES
('ssafy', 1, 5, 'Amazing experience! The game was thrilling.'), 
('john_doe', 2, 4, 'Great match but the facilities could be better.'),
('jane_smith', 3, 3, 'Decent game, but the weather was bad.'),
('michael_admin', 4, 2, 'Disappointing organization. Too chaotic.'),
('lucas_manager', 5, 1, 'Terrible experience. The match got canceled.'),
('emily_forward', 6, 5, 'Perfectly arranged match. Highly recommend!'),
('chris_defense', 7, 4, 'Fun game with a slight delay in starting.'),
('sarah_midfield', 8, 3, 'The pitch quality was below average.'),
('david_goalkeeper', 9, 2, 'Not enough players showed up. Disorganized.'),
('oliver_striker', 10, 1, 'Worst experience. Poor communication.');


select * from users;
