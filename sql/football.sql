
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

CREATE TABLE userstat (
    id INT AUTO_INCREMENT PRIMARY KEY,           -- 고유 ID
    user_id INT NOT NULL,                        -- 사용자를 참조하는 ID
    shoot TINYINT NOT NULL CHECK (shoot BETWEEN 0 AND 100), -- 슛 스탯
    pass TINYINT NOT NULL CHECK (pass BETWEEN 0 AND 100),   -- 패스 스탯
    speed TINYINT NOT NULL CHECK (speed BETWEEN 0 AND 100), -- 스피드 스탯
    stamina TINYINT NOT NULL CHECK (stamina BETWEEN 0 AND 100), -- 체력 스탯
    dribble TINYINT NOT NULL CHECK (dribble BETWEEN 0 AND 100), -- 드리블 스탯
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- 생성 시간
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, -- 수정 시간
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE -- 사용자 삭제 시 스탯도 삭제
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

CREATE TABLE reservations (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,                        -- 예약한 사용자 ID
    match_id INT NOT NULL,                       -- 예약한 경기 ID
    reservation_date DATETIME NOT NULL,          -- 예약 날짜 및 시간
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- 생성 시간
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, -- 갱신 시간
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,  -- 사용자 삭제 시 예약도 삭제
    FOREIGN KEY (match_id) REFERENCES matches(id) ON DELETE CASCADE -- 매치 삭제 시 예약도 삭제
);

CREATE TABLE reviews (
    id INT AUTO_INCREMENT PRIMARY KEY,           -- 고유 ID
    user_id INT NOT NULL,                        -- 리뷰를 작성한 사용자 ID
    match_id INT NOT NULL,                       -- 리뷰 대상 경기 ID
    rating TINYINT NOT NULL CHECK (rating BETWEEN 1 AND 5), -- 별점 (1~5)
    comment TEXT,                                -- 리뷰 내용
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- 생성 시간
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, -- 갱신 시간
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,  -- 사용자 삭제 시 리뷰 삭제
    FOREIGN KEY (match_id) REFERENCES matches(id) ON DELETE CASCADE -- 매치 삭제 시 리뷰 삭제
);

INSERT INTO users (userid, password, email, phone_number, name, role, position, tier) VALUES
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

INSERT INTO userstat (user_id, shoot, pass, speed, stamina, dribble) VALUES
(1, 85, 60, 78, 80, 70), -- John is good at shooting
(2, 60, 85, 75, 90, 68), -- Jane excels in passing and stamina
(3, 50, 55, 65, 70, 60), -- Michael focuses on defense
(4, 45, 60, 50, 85, 40), -- Lucas is a goalkeeper, stamina-heavy
(5, 90, 75, 85, 88, 92), -- Emily is an all-round forward
(6, 60, 55, 70, 80, 65), -- Chris is reliable in defense
(7, 75, 80, 75, 85, 78), -- Sarah is a creative midfielder
(8, 50, 45, 70, 75, 55), -- David has average stats
(9, 88, 72, 90, 80, 85), -- Oliver is a fast and strong striker
(10, 65, 85, 78, 88, 70); -- Amelia shines in playmaking

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

INSERT INTO reservations (user_id, match_id, reservation_date) VALUES
(1, 1, '2024-11-18 09:00:00'), -- John reserved for Seoul match
(2, 2, '2024-11-18 10:00:00'), -- Jane reserved for Busan match
(3, 3, '2024-11-18 11:00:00'), -- Michael reserved for Daegu match
(4, 4, '2024-11-18 12:00:00'), -- Lucas reserved for Incheon match
(5, 5, '2024-11-18 13:00:00'), -- Emily reserved for Gwangju match
(6, 6, '2024-11-18 14:00:00'), -- Chris reserved for Jeju match
(7, 7, '2024-11-18 15:00:00'), -- Sarah reserved for Daejeon match
(8, 8, '2024-11-18 16:00:00'), -- David reserved for Ulsan match
(9, 9, '2024-11-18 17:00:00'), -- Oliver reserved for Pohang match
(10, 10, '2024-11-18 18:00:00'); -- Amelia reserved for Suwon match

INSERT INTO reviews (user_id, match_id, rating, comment) VALUES
(1, 1, 5, 'Amazing experience! The game was thrilling.'), 
(2, 2, 4, 'Great match but the facilities could be better.'),
(3, 3, 3, 'Decent game, but the weather was bad.'),
(4, 4, 2, 'Disappointing organization. Too chaotic.'),
(5, 5, 1, 'Terrible experience. The match got canceled.'),
(6, 6, 5, 'Perfectly arranged match. Highly recommend!'),
(7, 7, 4, 'Fun game with a slight delay in starting.'),
(8, 8, 3, 'The pitch quality was below average.'),
(9, 9, 2, 'Not enough players showed up. Disorganized.'),
(10, 10, 1, 'Worst experience. Poor communication.');
