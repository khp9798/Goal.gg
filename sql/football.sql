
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
    tier ENUM('unranked','bronze', 'silver', 'gold', 'platinum', 'diamond') DEFAULT 'unranked',   -- 랭크
    region VARCHAR(50) NOT NULL,
    province VARCHAR(50) NOT NULL,
    district VARCHAR(50) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP -- 생성 시간
);
CREATE TABLE kleagueplayers(
    id INT AUTO_INCREMENT PRIMARY KEY,           -- 시스템 내부 고유 식별자
    name VARCHAR(100) NOT NULL,                  -- 사용자 이름 또는 닉네임
    position ENUM('forward', 'midfield', 'defense', 'goalkeeper') DEFAULT 'midfield', -- 성향
	shoot TINYINT NOT NULL CHECK (shoot BETWEEN 0 AND 100), -- 슛 스탯
    pass TINYINT NOT NULL CHECK (pass BETWEEN 0 AND 100),   -- 패스 스탯
    speed TINYINT NOT NULL CHECK (speed BETWEEN 0 AND 100), -- 스피드 스탯
    stamina TINYINT NOT NULL CHECK (stamina BETWEEN 0 AND 100), -- 체력 스탯
    dribble TINYINT NOT NULL CHECK (dribble BETWEEN 0 AND 100) -- 드리블 스탯
);




CREATE TABLE stadium (
    id INT AUTO_INCREMENT PRIMARY KEY,           -- 고유 ID
    name VARCHAR(100) NOT NULL,                  -- 경기장 이름
    address VARCHAR(255) NOT NULL,               -- 경기장 주소
    price INT DEFAULT NULL,                      -- 대여 비용
    capacity INT NOT NULL,                       -- 수용 인원
    image TEXT DEFAULT NULL,             -- 경기장 이미지 URL
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- 생성 시간
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP -- 갱신 시간
);

-- 신청가능 (시작 시간 1시간 전까지), 마감 임박(인원이 12명 이상이 됐을 때), 마감(인원이 다 차거나 신청 시간이 끝나거나), 경기 취소(시작 시간 1시간전까지 최소인원 못채웠다.)
CREATE TABLE matches (
    id INT AUTO_INCREMENT PRIMARY KEY,           -- 고유 ID
    name varchar(50) not null,
    stadium_id INT NOT NULL,                     -- 경기장이 매핑된 ID
    capacity int not null,
    start_time DATETIME NOT NULL,                -- 경기 시작 시간
    end_time DATETIME NOT NULL,                  -- 경기 종료 시간
    status ENUM('신청 가능', '마감 임박', '신청 마감','경기 취소') DEFAULT '신청 가능', -- 경기 상태
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

DELIMITER //

CREATE EVENT update_status_to_closed
ON SCHEDULE EVERY 1 second
DO
BEGIN
    -- 신청 마감 처리
    UPDATE matches
    SET status = '신청 마감'
    WHERE start_time <= DATE_ADD(NOW(), INTERVAL 1 HOUR)
      AND status IN ('신청 가능', '마감 임박');

    -- 마감 임박 처리
    UPDATE matches
    SET status = '마감 임박'
    WHERE EXISTS (
        SELECT 1
        FROM reservations
        WHERE reservations.match_id = matches.id
        GROUP BY match_id
        HAVING COUNT(*) >= 12
    )
    AND status = '신청 가능';
END //

DELIMITER ;



SET GLOBAL event_scheduler = ON;

INSERT INTO users (userid, password, email, phone_number, name, role, position, tier, region, province, district) VALUES
('ssafy', 'ssafy', 'ssafy@example.com', '010-1111-2222', '양명균', 'admin', 'forward', 'bronze', '수도권', '서울', '강남구'),
('john_doe', 'hashedpassword1', 'john@example.com', '010-1111-2222', 'John Doe', 'user', 'forward', 'bronze', '경상권', '부산', '해운대구'),
('jane_smith', 'hashedpassword2', 'jane@example.com', '010-2222-3333', 'Jane Smith', 'user', 'midfield', 'silver', '전라권', '전남', '순천시'),
('michael_admin', 'hashedpassword3', 'admin@example.com', '010-3333-4444', 'Michael Admin', 'admin', 'defense', 'gold', '충청권', '충북', '청주시 서원구'),
('lucas_manager', 'hashedpassword4', 'manager@example.com', '010-4444-5555', 'Lucas Manager', 'manager', 'goalkeeper', 'platinum', '제주권', '제주특별자치도', '제주시'),
('emily_forward', 'hashedpassword5', 'emily@example.com', '010-5555-6666', 'Emily Forward', 'user', 'forward', 'diamond', '강원권', '강원', '춘천시'),
('chris_defense', 'hashedpassword6', 'chris@example.com', '010-6666-7777', 'Chris Defense', 'user', 'defense', 'bronze', '수도권', '경기', '수원시 영통구'),
('sarah_midfield', 'hashedpassword7', 'sarah@example.com', '010-7777-8888', 'Sarah Midfield', 'user', 'midfield', 'silver', '수도권', '인천', '미추홀구'),
('david_goalkeeper', 'hashedpassword8', 'david@example.com', '010-8888-9999', 'David Goalkeeper', 'user', 'goalkeeper', 'gold', '경상권', '대구', '달서구'),
('oliver_striker', 'hashedpassword9', 'oliver@example.com', '010-9999-0000', 'Oliver Striker', 'user', 'forward', 'platinum', '전라권', '전북', '전주시 덕진구'),
('amelia_playmaker', 'hashedpassword10', 'amelia@example.com', '010-1010-1111', 'Amelia Playmaker', 'user', 'midfield', 'diamond', '충청권', '대전', '유성구'),
('choi','1234','1sasdjklfjsadlkf@naver.com', '010-1010-1111', '최현만', 'user', 'midfield', 'diamond', '충청권', '대전', '유성구');

INSERT INTO stadium (name, address, price, capacity, image) VALUES
('대전 삼정 풋살파크', '대전 유성구 한밭대로371번길 25-4 삼정풋살파크', 50000, 100, 'https://d31wz4d3hgve8q.cloudfront.net/media/dg_sj_coner_1.jpeg?w=1920'),
('대전 바우풋살클럽', '대전 대덕구 신탄진로115번안길 39', 40000, 80, 'https://d31wz4d3hgve8q.cloudfront.net/media/dj_bow_center.jpeg?w=1920'),
('대전 남대전 풋살장', '대전 동구 이사로 43-33', 45000, 90, 'https://cdn.pixabay.com/photo/2013/09/11/19/03/stadium-181457_1280.jpg'),
('대전 가장 풋살구장', '대전 서구 유등로 451', 60000, 120, 'https://d31wz4d3hgve8q.cloudfront.net/media/IMG_0755.jpg?w=1920'),
('대전 가오 풋살장', '대전광역시 동구 가오동 7-9, Gwangju', 30000, 70, 'https://cdn.pixabay.com/photo/2015/04/06/11/54/stadium-709180_1280.jpg'),
('대전 시리우스 스타디움', '대전 중구 유등천동로 762', 35000, 75, 'https://d31wz4d3hgve8q.cloudfront.net/media/IMG_0605.JPG?w=1920'),
('대전 도안 풋살구장', '대전광역시 서구 월드컵대로484번길 148-13', 55000, 110, 'https://cdn.pixabay.com/photo/2020/01/12/16/57/stadium-4760441_1280.jpg'),
('대전 S루프탑 풋살파크', '대전 서구 대덕대로185번길 46', 48000, 95, 'https://d31wz4d3hgve8q.cloudfront.net/media/dj_srooftop_coner.jpeg?w=1920'),
('대전 유성 풋살구장', '대전 유성구 유성대로713번길 83', 52000, 100, 'https://d31wz4d3hgve8q.cloudfront.net/media/dgys_coner.jpg?w=1920'),
('대전 하나 풋살장', '대전 유성구 노은로367번길 108', 50000, 85, 'https://d31wz4d3hgve8q.cloudfront.net/media/KakaoTalk_Photo_2024-10-21-17-05-12_001.jpeg?w=1920'),
('대전 S가수원 풋살파크','대전광역시 서구 도안동 2069',30000,50,'https://d31wz4d3hgve8q.cloudfront.net/media/KakaoTalk_Photo_2023-11-14-16-43-58_001.jpeg?w=1920'),
('대전 S루프탑 신탄진 풋살파크','신탄진동 118-5번지 옥상층',30000,50,'https://cdn.pixabay.com/photo/2024/10/09/23/53/ai-generated-9109557_1280.jpg'),
('대전 대덕비즈센터 루프탑 풋살장','대전광역시 유성구 테크노4로 17',30000,50,'https://cdn.pixabay.com/photo/2017/08/01/19/48/donbass-2567563_1280.jpg'),
('대전 스마트 풋살장','대전 유성구 엑스포로 213',30000,50,'https://cdn.pixabay.com/photo/2013/02/24/22/36/fc-red-bull-arena-85865_1280.jpg'),
('대전 위너스 풋살파크','대전 유성구 원신흥동 576-2',30000,50,'https://d31wz4d3hgve8q.cloudfront.net/media/dg_winners_goal.jpeg?w=1920'),
('대전도안아이파크아파트풋살장','대전광역시 서구 도안동 1362',30000,50,'https://cdn.pixabay.com/photo/2020/02/09/11/58/sports-arena-4832845_1280.jpg'),
('대전전천후게이트볼경기장축구장','대전광역시 유성구 원촌동 4',30000,50,'https://cdn.pixabay.com/photo/2014/05/17/10/26/brazil-346129_1280.jpg'),
('대전한국생명공학연구원풋살장','대전광역시 유성구 어은동53한국생명공학연구원풋살장',30000,50,'https://cdn.pixabay.com/photo/2016/08/31/16/28/stadium-1634035_1280.jpg');



INSERT INTO matches (name, stadium_id, capacity, start_time, end_time, status)
VALUES
-- 신청 가능: 시작 시간이 아직 1시간 이상 남은 경우
('축구 경기 1', 1, 18, '2024-11-21 18:00:00', '2024-11-21 20:00:00', '신청 가능'),
('축구 경기 ㅂ', 1, 18, '2024-11-22 18:00:00', '2024-11-22 20:00:00', '경기 취소'),
('축구 경기 ㅈ', 1, 18, '2024-11-22 18:00:00', '2024-11-22 20:00:00', '마감 임박'),
('축구 경기 1', 1, 18, '2024-11-22 18:00:00', '2024-11-22 20:00:00', '신청 가능'),
('축구 경기 1', 1, 18, '2024-11-22 18:00:00', '2024-11-22 20:00:00', '신청 가능'),
('축구 경기 1', 1, 18, '2024-11-22 18:00:00', '2024-11-22 20:00:00', '신청 가능'),


('축구 경기 2', 2, 18, '2024-11-23 15:00:00', '2024-11-23 17:00:00', '신청 가능'),

-- 마감 임박: 시작 시간이 1시간 이내인 경우
('축구 경기 3', 3, 18, '2024-11-21 14:30:00', '2024-11-21 16:30:00', '마감 임박'),
('축구 경기 4', 4, 18, '2024-11-21 15:15:00', '2024-11-21 17:15:00', '마감 임박'),

-- 신청 마감: 신청 시간이 지나거나 인원이 모두 찬 경우
('축구 경기 5', 5, 18, '2024-11-20 12:00:00', '2024-11-20 14:00:00', '신청 마감'),
('축구 경기 6', 6, 18, '2024-11-20 10:00:00', '2024-11-20 12:00:00', '신청 마감'),

-- 경기 취소: 최소 인원을 채우지 못해 취소된 경우
('축구 경기 7', 7, 18, '2024-11-20 09:00:00', '2024-11-20 11:00:00', '경기 취소'),
('축구 경기 8', 8, 18, '2024-11-19 14:00:00', '2024-11-19 16:00:00', '경기 취소'),

-- 추가로 다양한 상태 조합
('축구 경기 9', 9, 18, '2024-11-25 19:00:00', '2024-11-25 21:00:00', '신청 가능'),
('축구 경기 10', 10, 18, '2024-11-18 13:00:00', '2024-11-18 15:00:00', '경기 취소'),
('축구 경기 11', 10, 18, '2024-11-18 13:00:00', '2024-11-18 15:00:00', '신청 가능');






INSERT INTO userstat (user_id, shoot, pass, speed, stamina, dribble, match_id) VALUES
('john_doe', 60, 85, 75, 90, 68, 2),  -- Jane with match 2 (Busan Arena)
('jane_smith', 50, 55, 65, 70, 60, 3),  -- Michael with match 3 (Daegu Grounds)
('michael_admin', 45, 60, 50, 85, 40, 4),  -- Lucas with match 4 (Incheon Park)
('lucas_manager', 90, 75, 85, 88, 92, 5),  -- Emily with match 5 (Gwangju Field)
('emily_forward', 60, 55, 70, 80, 65, 6),  -- Chris with match 6 (Jeju Stadium)
('chris_defense', 75, 80, 75, 85, 78, 7),  -- Sarah with match 7 (Daejeon Arena)
('sarah_midfield', 50, 45, 70, 75, 55, 8),  -- David with match 8 (Ulsan Grounds)
('david_goalkeeper', 88, 72, 90, 80, 85, 9),  -- Oliver with match 9 (Pohang Pitch)
('oliver_striker', 65, 85, 78, 88, 70, 10), -- Amelia with match 10 (Suwon Sports Complex)
('choi', 100, 100, 100, 100, 100, 1); -- Amelia with match 10 (Suwon Sports Complex)



INSERT INTO userstat (user_id, shoot, pass, speed, stamina, dribble, match_id) VALUES
('ssafy', 70, 80, 75, 85, 60, 1), -- Match 1
('ssafy', 88, 65, 70, 90, 75, 2), -- Match 2
('ssafy', 85, 70, 80, 78, 68, 3), -- Match 3
('ssafy', 75, 60, 85, 80, 72, 4), -- Match 4
('ssafy', 90, 75, 88, 85, 78, 5), -- Match 5
('ssafy', 65, 72, 75, 70, 60, 6), -- Match 6
('ssafy', 80, 85, 78, 90, 65, 7), -- Match 7
('ssafy', 72, 68, 70, 80, 75, 8), -- Match 8
('ssafy', 85, 80, 88, 85, 90, 9), -- Match 9
('ssafy', 78, 75, 80, 78, 70, 10), -- Match 10
('ssafy', 80, 88, 75, 85, 65, 11), -- Match 11
('ssafy', 68, 70, 78, 80, 72, 12), -- Match 12
('ssafy', 90, 85, 80, 78, 75, 13), -- Match 13
('ssafy', 72, 75, 78, 85, 70, 14), -- Match 14
('ssafy', 85, 78, 85, 90, 88, 15); -- Match 15




INSERT INTO reservations (user_id, match_id, reservation_date) VALUES
('ssafy', 1, '2024-11-18 09:00:00'),       -- ssafy reserved for Seoul match
('john_doe', 2, '2024-11-18 10:00:00'),    -- john_doe reserved for Busan match
('jane_smith', 3, '2024-11-18 11:00:00'),  -- jane_smith reserved for Daegu match
('michael_admin', 4, '2024-11-18 12:00:00'), -- michael_admin reserved for Incheon match
('lucas_manager', 5, '2024-11-18 13:00:00'), -- lucas_manager reserved for Gwangju match
('emily_forward', 6, '2024-11-18 14:00:00'), -- emily_forward reserved for Jeju match
('chris_defense', 7, '2024-11-18 15:00:00'), -- chris_defense reserved for Daejeon match
('sarah_midfield', 8, '2024-11-18 16:00:00'), -- sarah_midfield reserved for Ulsan match
('ssafy', 9, '2024-11-18 17:00:00'), -- david_goalkeeper reserved for Pohang match
('ssafy', 10, '2024-11-18 18:00:00'); -- oliver_striker reserved for Suwon match






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





INSERT INTO reservations (user_id, match_id, reservation_date) VALUES
-- match_id = 1 (Seoul match, 총 12개)
('ssafy', 2, '2024-11-18 09:10:00'),
('ssafy', 2, '2024-11-18 09:15:00'),
('ssafy',2, '2024-11-18 09:20:00'),
('ssafy', 2, '2024-11-18 09:25:00'),
('ssafy', 2, '2024-11-18 09:30:00'),
('ssafy', 2, '2024-11-18 09:35:00'),
('ssafy', 2, '2024-11-18 09:40:00'),
('ssafy', 2, '2024-11-18 09:45:00'),
('ssafy', 2, '2024-11-18 09:50:00'),
('ssafy', 2, '2024-11-18 09:55:00'),
('ssafy', 2, '2024-11-18 10:00:00'),
('ssafy', 2, '2024-11-18 10:05:00');

 INSERT INTO kleagueplayers (name, position, shoot, pass, speed, stamina, dribble) VALUES
('이승우', 'forward', 80, 60, 85, 70, 88),
('주민규', 'forward', 78, 68, 75, 73, 80),
('황의조', 'forward', 82, 70, 83, 75, 85),
('세징야', 'forward', 85, 75, 87, 72, 88),
('무고사', 'forward', 78, 67, 79, 74, 77),
('엄원상', 'forward', 79, 62, 88, 71, 85),
('나상호', 'forward', 77, 63, 83, 70, 84),
('기성용', 'midfield', 65, 85, 72, 80, 70),
('팔로세비치', 'midfield', 70, 82, 74, 77, 75),
('이진현', 'midfield', 68, 80, 70, 76, 72),
('백승호', 'midfield', 67, 83, 71, 78, 73),
('이청용', 'midfield', 70, 80, 73, 76, 74),
('송민규', 'midfield', 72, 77, 75, 73, 76),
('정승원', 'midfield', 69, 78, 74, 75, 71),
('김민우', 'defense', 40, 75, 68, 83, 50),
('박지수', 'defense', 42, 70, 66, 85, 48),
('조유민', 'defense', 45, 72, 67, 84, 50),
('홍정호', 'defense', 44, 68, 65, 87, 47),
('정승현', 'defense', 43, 70, 64, 86, 49),
('강상우', 'defense', 46, 73, 69, 82, 52),
('김진수', 'defense', 47, 71, 68, 84, 53),
('조현우', 'goalkeeper', 30, 65, 55, 90, 40),
('송범근', 'goalkeeper', 32, 60, 53, 88, 42),
('김동헌', 'goalkeeper', 28, 58, 52, 85, 38),
('김기희', 'goalkeeper', 30, 62, 50, 87, 41),
('이창민', 'goalkeeper', 29, 63, 51, 86, 39),
('손흥민', 'forward', 90, 90, 90, 90, 90);


SELECT u.user_id, u.shoot, u.pass, u.speed, u.stamina, u.dribble, m.start_time, u.match_id
		FROM userstat u, matches m WHERE u.user_id='ssafy' and u.match_id = m.id

