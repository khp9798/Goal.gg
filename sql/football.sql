
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
    team VARCHAR(100) NOT NULL,
    playerimg TEXT null,
    nation VARCHAR(100) NOT NULL DEFAULT 'REPUBLIC OF KOREA',
    nationimg TEXT NULL,
    playercode int not null,
    seasonimg VARCHAR(255) NOT null DEFAULT 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/seasonicon2/season_icon_x2024.png?v=2401030a',
    backgroundimg VARCHAR(255) NOT NULL DEFAULT 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/seasonbgimage2/seasonbg_image_x2024.png?v=2401030a',
    position ENUM('ST', 'CF', 'RW', 'LW','CM','CAM','CDM','LM','RM','CB','RB','LB','RWB','LWB','GK') DEFAULT 'GK', -- 성향
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
    manager_id INT null,
    capacity int null,
    start_time DATETIME NOT NULL,                -- 경기 시작 시간
    end_time DATETIME NOT NULL,                  -- 경기 종료 시간
    status ENUM('신청 가능', '마감 임박', '신청 마감','경기 취소') DEFAULT '신청 가능', -- 경기 상태
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- 생성 시간
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, -- 갱신 시간
    FOREIGN KEY (stadium_id) REFERENCES stadium(id) ON DELETE CASCADE -- 경기장 삭제 시 매치도 삭제
);
select * from matches;

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
    
    reservation_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- 생성 시간
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
('ssafy', 'ssafy', 'ssafy@example.com', '010-1111-2222', '양명균', 'manager', 'forward', 'bronze', '충청권', '대전', '대덕구'),
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
('choi','1234','1sasdjklfjsadlkf@naver.com', '010-1010-1111', '최현만', 'user', 'midfield', 'diamond', '충청권', '대전', '유성구'),
('q1', '123', 'q1@example.com', '010-1111-0001', 'User One', 'user', 'goalkeeper', 'bronze', 'Region A', 'Province A', 'District A'),
('q2', '123', 'q2@example.com', '010-1111-0002', 'User Two', 'user', 'defense', 'silver', 'Region B', 'Province B', 'District B'),
('q3', '123', 'q3@example.com', '010-1111-0003', 'User Three', 'user', 'midfield', 'gold', 'Region C', 'Province C', 'District C'),
('q4', '123', 'q4@example.com', '010-1111-0004', 'User Four', 'user', 'forward', 'platinum', 'Region D', 'Province D', 'District D'),
('q5', '123', 'q5@example.com', '010-1111-0005', 'User Five', 'user', 'midfield', 'diamond', 'Region E', 'Province E', 'District E'),
('q6', '123', 'q6@example.com', '010-1111-0006', 'User Six', 'user', 'defense', 'unranked', 'Region F', 'Province F', 'District F'),
('q7', '123', 'q7@example.com', '010-1111-0007', 'User Seven', 'user', 'goalkeeper', 'bronze', 'Region G', 'Province G', 'District G'),
('q8', '123', 'q8@example.com', '010-1111-0008', 'User Eight', 'user', 'midfield', 'silver', 'Region H', 'Province H', 'District H'),
('q9', '123', 'q9@example.com', '010-1111-0009', 'User Nine', 'user', 'forward', 'gold', 'Region I', 'Province I', 'District I'),
('q10', '123', 'q10@example.com', '010-1111-0010', 'User Ten', 'user', 'defense', 'platinum', 'Region J', 'Province J', 'District J');


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
('대전한국생명공학연구원풋살장','대전광역시 유성구 어은동53한국생명공학연구원풋살장',30000,50,'https://cdn.pixabay.com/photo/2016/08/31/16/28/stadium-1634035_1280.jpg'),
('서울 강동 송파 풋살장','서울특별시 송파구 풍납동 403-3', 12000,30,'https://d31wz4d3hgve8q.cloudfront.net/media/kd_sp_goal.jpeg?w=1920');
select * from stadium;
select * from matches;

INSERT INTO matches (name, stadium_id, capacity, start_time, end_time, status)
VALUES
-- 신청 가능: 시작 시간이 아직 1시간 이상 남은 경우
('축구 경기 1', 1, 18, '2024-11-21 18:00:00', '2024-11-21 20:00:00', '신청 가능'),
('축구 경기 ㅂ', 1, 18, '2024-11-22 18:00:00', '2024-11-22 20:00:00', '경기 취소'),
('축구 경기 ㅂ', 1, 18, '2024-11-22 17:00:00', '2024-11-22 20:00:00', '경기 취소'),

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
('축구 경기 11', 10, 18, '2024-11-18 13:00:00', '2024-11-18 15:00:00', '신청 가능'),
('서울 강동 풋살장 경기', 19, 18, '2024-11-26 14:00:00', '2024-11-26 16:00:00', '신청 가능'),
('서울 강동 풋살장 경기', 19, 18, '2024-11-26 14:00:00', '2024-11-26 16:00:00', '마감 임박'),
('서울 강동 풋살장 경기', 19, 18, '2024-11-26 14:00:00', '2024-11-26 16:00:00', '신청 마감'),
('서울 강동 풋살장 경기', 19, 18, '2024-11-26 14:00:00', '2024-11-26 16:00:00', '경기 취소');







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
('choi', 100, 100, 100, 100, 100, 1), -- Amelia with match 10 (Suwon Sports Complex)
('amelia_playmaker', 0, 0, 0, 0, 0, 1),
('q1', 5, 10, 15, 20, 5, 1),   -- Very low stats
('q2', 15, 20, 25, 30, 15, 1),
('q3', 25, 30, 35, 40, 25, 2),
('q4', 35, 40, 45, 50, 35, 2),
('q5', 45, 50, 55, 60, 45, 3),
('q6', 60, 60, 80, 67, 69, 3),
('q7', 63, 68, 66, 54, 72, 4),
('q8', 75, 80, 85, 90, 75, 4),
('q9', 53, 55, 35, 32, 51, 5),
('q10', 66, 64, 72, 59, 67, 5);



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

 INSERT INTO kleagueplayers (name, playercode, team, nation, position, shoot, pass, speed, stamina, dribble, playerimg) VALUES

('이창근', 300210941, '대전 하나 시티즌', '대한민국', 'gk', 19, 29, 43, 22, 17, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p210941.png?v=2401030a'),
('김현욱', 300237091, '대전 하나 시티즌', '대한민국', 'rw', 61, 59, 72, 80, 67, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p237091.png?v=2401030a'),
('이순민', 300238098, '대전 하나 시티즌', '대한민국', 'cm', 53, 66, 61, 83, 60, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p238098.png?v=2401030a'),
('안톤', 300263034, '대전 하나 시티즌', '대한민국', 'cb', 33, 53, 78, 74, 54, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p263034.png?v=2401030a'),
('임덕근', 300252810, '대전 하나 시티즌', '대한민국', 'cdm', 38, 62, 59, 73, 53, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p252810.png?v=2401030a'),
('빅토르 보브싱', 300263787, '대전 하나 시티즌', '대한민국', 'cdm', 46, 63, 56, 65, 65, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p263787.png?v=2401030a'),
('V. 구트코프스키스', 300233214, '대전 하나 시티즌', '대한민국', 'st', 59, 59, 70, 66, 59, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p233214.png?v=2401030a'),
('주세종', 300208063, '대전 하나 시티즌', '대한민국', 'cdm', 42, 66, 51, 73, 54, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p208063.png?v=2401030a'),
('켈빈', 300070420, '대전 하나 시티즌', '대한민국', 'lm', 59, 59, 67, 64, 62, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p70420.png?v=2401030a'),
('김인균', 300255329, '대전 하나 시티즌', '대한민국', 'st', 62, 54, 84, 75, 67, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p255329.png?v=2401030a'),
('애론 칼베르', 300212535, '대전 하나 시티즌', '대한민국', 'cb', 29, 53, 60, 65, 45, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p212535.png?v=2401030a'),
('마사', 300247471, '대전 하나 시티즌', '대한민국', 'cm', 61, 63, 71, 81, 62, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p247471.png?v=2401030a'),
('홍정운', 300233012, '대전 하나 시티즌', '대한민국', 'cb', 22, 59, 47, 61, 45, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p233012.png?v=2401030a'),
('김문환', 300244800, '대전 하나 시티즌', '대한민국', 'rb', 48, 57, 75, 81, 60, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p244800.png?v=2401030a'),
('박정인', 300248131, '대전 하나 시티즌', '대한민국', 'st', 63, 59, 73, 57, 59, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p248131.png?v=2401030a'),
('이정택', 300273633, '대전 하나 시티즌', '대한민국', 'cb', 22, 44, 79, 69, 38, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p273633.png?v=2401030a'),
('김승대', 300212791, '대전 하나 시티즌', '대한민국', 'st', 54, 58, 72, 60, 57, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p212791.png?v=2401030a'),
('강윤성', 300233770, '대전 하나 시티즌', '대한민국', 'rb', 38, 59, 65, 73, 56, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p233770.png?v=2401030a'),
('천성훈', 300246930, '대전 하나 시티즌', '대한민국', 'st', 60, 50, 51, 55, 54, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p246930.png?v=2401030a'),
('윤도영', 300071205, '대전 하나 시티즌', '대한민국', 'rw', 50, 51, 67, 60, 61, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p71205.png?v=2401030a'),
('김재우', 300242082, '대전 하나 시티즌', '대한민국', 'cb', 45, 44, 67, 66, 38, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p242082.png?v=2401030a'),
('김현우', 300242182, '대전 하나 시티즌', '대한민국', 'cb', 36, 46, 62, 63, 43, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p242182.png?v=2401030a'),
('김준범', 300243173, '대전 하나 시티즌', '대한민국', 'cm', 46, 56, 62, 62, 59, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p243173.png?v=2401030a'),
('이준규', 300071204, '대전 하나 시티즌', '대한민국', 'cm', 31, 59, 59, 63, 53, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p71204.png?v=2401030a'),
('이상민', 300274017, '대전 하나 시티즌', '대한민국', 'rm', 43, 40, 74, 65, 62, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p274017.png?v=2401030a'),
('신상은', 300261104, '대전 하나 시티즌', '대한민국', 'rw', 49, 51, 74, 58, 56, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p261104.png?v=2401030a'),
('공민현', 300212759, '대전 하나 시티즌', '대한민국', 'st', 54, 51, 58, 52, 55, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p212759.png?v=2401030a'),
('박진성', 300261055, '대전 하나 시티즌', '대한민국', 'lb', 25, 33, 66, 67, 51, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p261055.png?v=2401030a'),
('오재석', 300232626, '대전 하나 시티즌', '대한민국', 'rb', 30, 53, 53, 54, 54, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p232626.png?v=2401030a'),
('이준서', 300261106, '대전 하나 시티즌', '대한민국', 'gk', 10, 28, 29, 19, 8, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p261106.png?v=2401030a'),
('최건주', 300255245, '대전 하나 시티즌', '대한민국', 'st', 56, 50, 79, 38, 59, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p255245.png?v=2401030a'),
('정산', 300191684, '대전 하나 시티즌', '대한민국', 'gk', 13, 35, 36, 29, 15, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p191684.png?v=2401030a'),
('김민우', 300073439, '대전 하나 시티즌', '대한민국', 'cm', 39, 57, 59, 63, 54, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p73439.png?v=2401030a'),
('김한서', 300071206, '대전 하나 시티즌', '대한민국', 'cm', 40, 56, 63, 58, 53, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p71206.png?v=2401030a'),
('임유석', 300274428, '대전 하나 시티즌', '대한민국', 'cb', 17, 47, 55, 56, 29, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p274428.png?v=2401030a'),
('송창석', 300266766, '대전 하나 시티즌', '대한민국', 'cam', 51, 49, 62, 59, 54, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p266766.png?v=2401030a'),
('노동건', 300071201, '대전 하나 시티즌', '대한민국', 'cb', 19, 27, 55, 58, 26, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p71201.png?v=2401030a'),
('유선우', 300274431, '대전 하나 시티즌', '대한민국', 'rw', 48, 42, 57, 45, 53, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p274431.png?v=2401030a'),
('이동원', 300274432, '대전 하나 시티즌', '대한민국', 'lb', 39, 43, 67, 57, 53, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p274432.png?v=2401030a'),
('이한빈', 300266768, '대전 하나 시티즌', '대한민국', 'cb', 20, 27, 61, 53, 21, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p266768.png?v=2401030a'),
('김민수', 300071207, '대전 하나 시티즌', '대한민국', 'gk', 11, 17, 26, 23, 19, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p71207.png?v=2401030a'),
('정진우', 300274232, '대전 하나 시티즌', '대한민국', 'cm', 33, 52, 56, 56, 46, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p274232.png?v=2401030a'),
('정우빈', 300266327, '대전 하나 시티즌', '대한민국', 'lw', 49, 43, 59, 42, 51, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p266327.png?v=2401030a'),
('강성윤', 300071202, '대전 하나 시티즌', '대한민국', 'cb', 22, 34, 47, 38, 29, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p71202.png?v=2401030a'),
('김민기', 300071203, '대전 하나 시티즌', '대한민국', 'st', 50, 36, 53, 40, 43, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p71203.png?v=2401030a'),
('안태윤', 300257391, '대전 하나 시티즌', '대한민국', 'gk', 9, 26, 20, 21, 9, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p257391.png?v=2401030a'),
('김경환', 300274427, '대전 하나 시티즌', '대한민국', 'cdm', 30, 49, 54, 43, 49, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p274427.png?v=2401030a'),
('김도윤', 300274434, '대전 하나 시티즌', '대한민국', 'st', 46, 50, 60, 47, 49, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p274434.png?v=2401030a'),
('이선호', 300266769, '대전 하나 시티즌', '대한민국', 'rb', 26, 26, 57, 51, 50, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p266769.png?v=2401030a'),
('이은재', 300266772, '대전 하나 시티즌', '대한민국', 'cm', 32, 48, 54, 56, 43, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p266772.png?v=2401030a'),
('박준서', 300274435, '대전 하나 시티즌', '대한민국', 'cb', 24, 30, 48, 47, 21, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p274435.png?v=2401030a'),
('김태현', 300274429, '대전 하나 시티즌', '대한민국', 'rb', 26, 36, 51, 52, 45, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p274429.png?v=2401030a'),
('일류첸코', 300228861, 'FC 서울', '대한민국', 'st', 73, 59, 62, 72, 61, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p228861.png?v=2401030a'),
('기성용', 300180283, 'FC 서울', '대한민국', 'cm', 55, 71, 51, 79, 64, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p180283.png?v=2401030a'),
('제시 린가드', 300207494, 'FC 서울', '대한민국', 'cam', 63, 68, 66, 54, 72, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p207494.png?v=2401030a'),
('류재문', 300228461, 'FC 서울', '대한민국', 'cdm', 36, 64, 62, 81, 53, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p228461.png?v=2401030a'),
('권완규', 300221789, 'FC 서울', '대한민국', 'cb', 26, 52, 70, 65, 48, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p221789.png?v=2401030a'),
('강현무', 300221912, 'FC 서울', '대한민국', 'gk', 17, 28, 44, 27, 20, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p221912.png?v=2401030a'),
('최준', 300251161, 'FC 서울', '대한민국', 'rb', 42, 64, 76, 80, 64, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p251161.png?v=2401030a'),
('윌리안', 300210544, 'FC 서울', '대한민국', 'lm', 58, 55, 79, 67, 68, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p210544.png?v=2401030a'),
('김주성', 300251162, 'FC 서울', '대한민국', 'cb', 37, 57, 66, 56, 43, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p251162.png?v=2401030a'),
('호날두 타바레스', 300237641, 'FC 서울', '대한민국', 'st', 64, 52, 72, 60, 50, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p237641.png?v=2401030a'),
('이상민', 300238574, 'FC 서울', '대한민국', 'cb', 24, 49, 58, 51, 30, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p238574.png?v=2401030a'),
('조영욱', 300234222, 'FC 서울', '대한민국', 'st', 60, 55, 75, 72, 63, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p234222.png?v=2401030a'),
('임상협', 300191657, 'FC 서울', '대한민국', 'lm', 61, 57, 70, 71, 61, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p191657.png?v=2401030a'),
('강상우', 300222734, 'FC 서울', '대한민국', 'lb', 58, 61, 72, 79, 60, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p222734.png?v=2401030a'),
('윤종규', 300237965, 'FC 서울', '대한민국', 'rb', 38, 54, 70, 69, 57, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p237965.png?v=2401030a'),
('백종범', 300252658, 'FC 서울', '대한민국', 'gk', 11, 23, 23, 19, 15, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p252658.png?v=2401030a'),
('Y. 알아랍', 300073466, 'FC 서울', '대한민국', 'cb', 28, 42, 55, 54, 33, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p73466.png?v=2401030a'),
('강성진', 300261401, 'FC 서울', '대한민국', 'rm', 53, 43, 73, 59, 66, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p261401.png?v=2401030a'),
('김진야', 300236586, 'FC 서울', '대한민국', 'rb', 50, 53, 75, 76, 59, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p236586.png?v=2401030a'),
('루카스 호드리기스', 300245717, 'FC 서울', '대한민국', 'lm', 59, 57, 72, 56, 63, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p245717.png?v=2401030a'),
('박성훈', 300266196, 'FC 서울', '대한민국', 'cb', 30, 53, 54, 59, 46, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p266196.png?v=2401030a'),
('이승모', 300237101, 'FC 서울', '대한민국', 'cdm', 50, 59, 67, 68, 57, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p237101.png?v=2401030a'),
('황도윤', 300273787, 'FC 서울', '대한민국', 'cm', 42, 58, 63, 66, 51, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p273787.png?v=2401030a'),
('백상훈', 300261060, 'FC 서울', '대한민국', 'cm', 41, 57, 59, 51, 59, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p261060.png?v=2401030a'),
('황성민', 300213076, 'FC 서울', '대한민국', 'gk', 20, 25, 33, 30, 16, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p213076.png?v=2401030a'),
('최철원', 300234301, 'FC 서울', '대한민국', 'gk', 17, 25, 27, 35, 16, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p234301.png?v=2401030a'),
('손승범', 300273788, 'FC 서울', '대한민국', 'lm', 40, 47, 61, 58, 50, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p273788.png?v=2401030a'),
('박장한결', 300266198, 'FC 서울', '대한민국', 'cam', 36, 52, 62, 51, 42, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p266198.png?v=2401030a'),
('강주혁', 300072560, 'FC 서울', '대한민국', 'lw', 45, 35, 59, 40, 54, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p72560.png?v=2401030a'),
('이승준', 300273789, 'FC 서울', '대한민국', 'rm', 34, 47, 59, 54, 50, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p273789.png?v=2401030a'),
('김현덕', 300273794, 'FC 서울', '대한민국', 'cb', 16, 41, 51, 54, 23, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p273794.png?v=2401030a'),
('서주환', 300254978, 'FC 서울', '대한민국', 'gk', 8, 21, 27, 26, 12, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p254978.png?v=2401030a'),
('허동민', 300071010, 'FC 서울', '대한민국', 'cdm', 27, 49, 52, 49, 39, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p71010.png?v=2401030a'),
('함선우', 300071011, 'FC 서울', '대한민국', 'cb', 22, 28, 51, 56, 25, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p71011.png?v=2401030a'),
('민지훈', 300071008, 'FC 서울', '대한민국', 'cam', 30, 52, 60, 38, 45, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p71008.png?v=2401030a'),
('배현서', 300071009, 'FC 서울', '대한민국', 'lb', 24, 27, 54, 52, 47, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p71009.png?v=2401030a'),
('주민규', 300213189, '울산 HD FC', '대한민국', 'st', 73, 59, 65, 68, 59, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p213189.png?v=2401030a'),
('조현우', 300212432, '울산 HD FC', '대한민국', 'gk', 19, 27, 47, 28, 13, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p212432.png?v=2401030a'),
('D. 보야니치', 300213471, '울산 HD FC', '대한민국', 'cm', 53, 71, 40, 71, 65, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p213471.png?v=2401030a'),
('야구 카리엘루', 300270203, '울산 HD FC', '대한민국', 'st', 71, 58, 59, 68, 57, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p270203.png?v=2401030a'),
('루빅손', 300256370, '울산 HD FC', '대한민국', 'lm', 68, 63, 81, 82, 65, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p256370.png?v=2401030a'),
('엄원상', 300246937, '울산 HD FC', '대한민국', 'rm', 66, 59, 85, 71, 70, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p246937.png?v=2401030a'),
('고승범', 300232595, '울산 HD FC', '대한민국', 'cm', 53, 66, 67, 83, 60, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p232595.png?v=2401030a'),
('원두재', 300254814, '울산 HD FC', '대한민국', 'cdm', 43, 64, 57, 77, 52, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p254814.png?v=2401030a'),
('G. 아라비제', 300244182, '울산 HD FC', '대한민국', 'rw', 59, 60, 73, 59, 68, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p244182.png?v=2401030a'),
('이규성', 300228009, '울산 HD FC', '대한민국', 'cdm', 35, 64, 64, 80, 58, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p228009.png?v=2401030a'),
('황석호', 300211002, '울산 HD FC', '대한민국', 'cb', 19, 59, 48, 65, 57, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p211002.png?v=2401030a'),
('김기희', 300203002, '울산 HD FC', '대한민국', 'cb', 33, 56, 56, 57, 36, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p203002.png?v=2401030a'),
('김영권', 300201528, '울산 HD FC', '대한민국', 'cb', 37, 63, 63, 65, 51, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p201528.png?v=2401030a'),
('아타루', 300232775, '울산 HD FC', '대한민국', 'cam', 60, 61, 69, 62, 61, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p232775.png?v=2401030a'),
('정우영', 300211003, '울산 HD FC', '대한민국', 'cdm', 47, 66, 51, 71, 52, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p211003.png?v=2401030a'),
('이명재', 300222052, '울산 HD FC', '대한민국', 'lb', 37, 59, 70, 74, 64, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p222052.png?v=2401030a'),
('이청용', 300155355, '울산 HD FC', '대한민국', 'lm', 49, 65, 59, 56, 64, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p155355.png?v=2401030a'),
('마테우스 살리스', 300225765, '울산 HD FC', '대한민국', 'cdm', 48, 61, 64, 57, 54, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p225765.png?v=2401030a'),
('임종은', 300191915, '울산 HD FC', '대한민국', 'cb', 36, 58, 49, 52, 47, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p191915.png?v=2401030a'),
('김민우', 300218471, '울산 HD FC', '대한민국', 'lm', 54, 59, 60, 75, 56, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p218471.png?v=2401030a'),
('윤일록', 300202968, '울산 HD FC', '대한민국', 'rb', 51, 59, 63, 53, 61, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p202968.png?v=2401030a'),
('심상민', 300221567, '울산 HD FC', '대한민국', 'lb', 44, 58, 69, 77, 55, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p221567.png?v=2401030a'),
('김민혁', 300226651, '울산 HD FC', '대한민국', 'cdm', 54, 64, 46, 73, 59, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p226651.png?v=2401030a'),
('김민준', 300255160, '울산 HD FC', '대한민국', 'rw', 57, 57, 74, 64, 58, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p255160.png?v=2401030a'),
('김지현', 300245400, '울산 HD FC', '대한민국', 'st', 51, 53, 71, 74, 54, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p245400.png?v=2401030a'),
('강윤구', 300261054, '울산 HD FC', '대한민국', 'rm', 43, 59, 67, 55, 60, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p261054.png?v=2401030a'),
('조수혁', 300187144, '울산 HD FC', '대한민국', 'gk', 15, 14, 35, 21, 14, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p187144.png?v=2401030a'),
('문현호', 300267433, '울산 HD FC', '대한민국', 'gk', 11, 27, 30, 20, 14, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p267433.png?v=2401030a'),
('박주영', 300165889, '울산 HD FC', '대한민국', 'st', 53, 55, 35, 32, 51, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p165889.png?v=2401030a'),
('장시영', 300274415, '울산 HD FC', '대한민국', 'rm', 48, 43, 64, 41, 58, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p274415.png?v=2401030a'),
('강민우', 300071318, '울산 HD FC', '대한민국', 'cb', 17, 51, 60, 60, 28, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p71318.png?v=2401030a'),
('김주환', 300255769, '울산 HD FC', '대한민국', 'rb', 23, 35, 71, 55, 50, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p255769.png?v=2401030a'),
('최강민', 300071317, '울산 HD FC', '대한민국', 'rb', 32, 54, 63, 63, 50, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p71317.png?v=2401030a'),
('오베르단', 300272733, '포항 스틸러스', '대한민국', 'cdm', 54, 67, 77, 83, 66, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p272733.png?v=2401030a'),
('완델손', 300229343, '포항 스틸러스', '대한민국', 'lb', 55, 63, 83, 75, 67, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p229343.png?v=2401030a'),
('황인재', 300233286, '포항 스틸러스', '대한민국', 'gk', 16, 23, 24, 35, 17, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p233286.png?v=2401030a'),
('전민광', 300227632, '포항 스틸러스', '대한민국', 'cb', 43, 59, 68, 75, 50, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p227632.png?v=2401030a'),
('허용준', 300232269, '포항 스틸러스', '대한민국', 'st', 65, 59, 65, 59, 58, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p232269.png?v=2401030a'),
('정재희', 300234276, '포항 스틸러스', '대한민국', 'rm', 63, 52, 82, 73, 67, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p234276.png?v=2401030a'),
('이동희', 300261053, '포항 스틸러스', '대한민국', 'cb', 21, 59, 59, 52, 33, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p261053.png?v=2401030a'),
('백성동', 300207730, '포항 스틸러스', '대한민국', 'lm', 53, 60, 69, 71, 66, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p207730.png?v=2401030a'),
('안재준', 300261126, '포항 스틸러스', '대한민국', 'st', 64, 46, 74, 55, 61, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p261126.png?v=2401030a'),
('조르지 테이셰이라', 300274437, '포항 스틸러스', '대한민국', 'st', 56, 52, 78, 68, 57, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p274437.png?v=2401030a'),
('김인성', 300208047, '포항 스틸러스', '대한민국', 'rm', 54, 53, 82, 66, 66, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p208047.png?v=2401030a'),
('이호재', 300261115, '포항 스틸러스', '대한민국', 'st', 67, 49, 35, 56, 51, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p261115.png?v=2401030a'),
('한찬희', 300231942, '포항 스틸러스', '대한민국', 'cm', 51, 64, 63, 68, 59, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p231942.png?v=2401030a'),
('홍윤상', 300276616, '포항 스틸러스', '대한민국', 'lm', 60, 56, 77, 62, 66, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p276616.png?v=2401030a'),
('이태석', 300261063, '포항 스틸러스', '대한민국', 'lb', 31, 55, 68, 77, 59, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p261063.png?v=2401030a'),
('신광훈', 300184901, '포항 스틸러스', '대한민국', 'rb', 44, 59, 53, 67, 54, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p184901.png?v=2401030a'),
('민상기', 300202978, '포항 스틸러스', '대한민국', 'cb', 27, 56, 63, 55, 43, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p202978.png?v=2401030a'),
('김종우', 300227787, '포항 스틸러스', '대한민국', 'cm', 52, 59, 67, 76, 56, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p227787.png?v=2401030a'),
('J. 아스프로포타미티스', 300228191, '포항 스틸러스', '대한민국', 'cb', 27, 54, 65, 67, 43, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p228191.png?v=2401030a'),
('윤평국', 300212915, '포항 스틸러스', '대한민국', 'gk', 17, 26, 46, 25, 13, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p212915.png?v=2401030a'),
('조성준', 300213181, '포항 스틸러스', '대한민국', 'rw', 51, 52, 75, 60, 60, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p213181.png?v=2401030a'),
('어정원', 300261078, '포항 스틸러스', '대한민국', 'lb', 45, 48, 72, 72, 59, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p261078.png?v=2401030a'),
('윤민호', 300266479, '포항 스틸러스', '대한민국', 'cam', 45, 54, 60, 54, 59, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p266479.png?v=2401030a'),
('김동진', 300070763, '포항 스틸러스', '대한민국', 'cm', 44, 54, 46, 61, 52, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p70763.png?v=2401030a'),
('김규형', 300241515, '포항 스틸러스', '대한민국', 'cam', 49, 51, 61, 49, 52, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p241515.png?v=2401030a'),
('윤석주', 300261121, '포항 스틸러스', '대한민국', 'cdm', 28, 52, 51, 49, 43, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p261121.png?v=2401030a'),
('강성혁', 300070764, '포항 스틸러스', '대한민국', 'gk', 11, 25, 31, 23, 13, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p70764.png?v=2401030a'),
('최현웅', 300266324, '포항 스틸러스', '대한민국', 'cb', 20, 36, 52, 35, 26, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p266324.png?v=2401030a'),
('이규백', 300266478, '포항 스틸러스', '대한민국', 'cb', 22, 42, 50, 43, 34, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p266478.png?v=2401030a'),
('강현제', 300274026, '포항 스틸러스', '대한민국', 'cm', 35, 51, 48, 47, 51, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p274026.png?v=2401030a'),
('이규민', 300070762, '포항 스틸러스', '대한민국', 'lw', 47, 40, 56, 43, 47, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p70762.png?v=2401030a'),
('이승환', 300266477, '포항 스틸러스', '대한민국', 'gk', 11, 29, 23, 17, 12, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p266477.png?v=2401030a'),
('김명준', 300070758, '포항 스틸러스', '대한민국', 'st', 46, 39, 45, 50, 42, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p70758.png?v=2401030a'),
('황서웅', 300070759, '포항 스틸러스', '대한민국', 'cam', 32, 43, 56, 36, 51, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p70759.png?v=2401030a'),
('이동협', 300070761, '포항 스틸러스', '대한민국', 'lb', 26, 35, 55, 44, 43, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p70761.png?v=2401030a'),
('박형우', 300274028, '포항 스틸러스', '대한민국', 'rm', 38, 41, 56, 43, 50, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p274028.png?v=2401030a'),
('김동민', 300070760, '포항 스틸러스', '대한민국', 'cdm', 28, 47, 47, 43, 43, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p70760.png?v=2401030a'),
('이승우', 300232000, '전북 현대 모터스', '대한민국', 'cam', 66, 64, 72, 59, 67, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p232000.png?v=2401030a'),
('송민규', 300248188, '전북 현대 모터스', '대한민국', 'cam', 64, 67, 73, 69, 64, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p248188.png?v=2401030a'),
('박진섭', 300243673, '전북 현대 모터스', '대한민국', 'cb', 44, 59, 65, 77, 57, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p243673.png?v=2401030a'),
('이영재', 300228007, '전북 현대 모터스', '대한민국', 'cm', 54, 67, 71, 82, 66, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p228007.png?v=2401030a'),
('티아고', 300267825, '전북 현대 모터스', '대한민국', 'st', 67, 52, 75, 67, 59, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p267825.png?v=2401030a'),
('한국영', 300211004, '전북 현대 모터스', '대한민국', 'cdm', 43, 63, 55, 77, 57, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p211004.png?v=2401030a'),
('김진규', 300227659, '전북 현대 모터스', '대한민국', 'cm', 57, 67, 71, 81, 65, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p227659.png?v=2401030a'),
('안드리고', 300232710, '전북 현대 모터스', '대한민국', 'rw', 59, 66, 68, 71, 67, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p232710.png?v=2401030a'),
('홍정호', 300200588, '전북 현대 모터스', '대한민국', 'cb', 38, 58, 64, 60, 46, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p200588.png?v=2401030a'),
('안현범', 300227788, '전북 현대 모터스', '대한민국', 'rb', 56, 58, 83, 83, 65, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p227788.png?v=2401030a'),
('김준홍', 300266323, '전북 현대 모터스', '대한민국', 'gk', 11, 27, 28, 26, 11, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p266323.png?v=2401030a'),
('B. 아제이-보아텡', 300210970, '전북 현대 모터스', '대한민국', 'cdm', 54, 60, 70, 78, 59, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p210970.png?v=2401030a'),
('이재익', 300242826, '전북 현대 모터스', '대한민국', 'cb', 21, 56, 54, 63, 27, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p242826.png?v=2401030a'),
('김진수', 300213317, '전북 현대 모터스', '대한민국', 'lb', 32, 59, 75, 71, 56, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p213317.png?v=2401030a'),
('에르난데스', 300257386, '전북 현대 모터스', '대한민국', 'st', 58, 52, 78, 63, 63, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p257386.png?v=2401030a'),
('연제운', 300234186, '전북 현대 모터스', '대한민국', 'cb', 27, 58, 65, 67, 38, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p234186.png?v=2401030a'),
('이수빈', 300248487, '전북 현대 모터스', '대한민국', 'cdm', 44, 66, 52, 65, 61, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p248487.png?v=2401030a'),
('문선민', 300229694, '전북 현대 모터스', '대한민국', 'lm', 63, 51, 82, 56, 67, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p229694.png?v=2401030a'),
('구자룡', 300212018, '전북 현대 모터스', '대한민국', 'cb', 24, 53, 60, 60, 35, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p212018.png?v=2401030a'),
('전병관', 300261105, '전북 현대 모터스', '대한민국', 'lm', 63, 48, 76, 68, 67, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p261105.png?v=2401030a'),
('김정훈', 300252662, '전북 현대 모터스', '대한민국', 'gk', 10, 19, 18, 24, 11, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p252662.png?v=2401030a'),
('김태환', 300199231, '전북 현대 모터스', '대한민국', 'rb', 44, 54, 75, 67, 56, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p199231.png?v=2401030a'),
('유제호', 300266541, '전북 현대 모터스', '대한민국', 'cm', 35, 58, 51, 72, 53, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p266541.png?v=2401030a'),
('박재용', 300268420, '전북 현대 모터스', '대한민국', 'st', 59, 43, 65, 63, 53, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p268420.png?v=2401030a'),
('김태현', 300243672, '전북 현대 모터스', '대한민국', 'rb', 44, 57, 62, 71, 59, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p243672.png?v=2401030a'),
('정우재', 300222798, '전북 현대 모터스', '대한민국', 'lb', 52, 57, 67, 67, 61, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p222798.png?v=2401030a'),
('전진우', 300242004, '전북 현대 모터스', '대한민국', 'lm', 50, 52, 72, 50, 60, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p242004.png?v=2401030a'),
('김하준', 300277378, '전북 현대 모터스', '대한민국', 'cb', 36, 43, 60, 49, 41, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p277378.png?v=2401030a'),
('최철순', 300176346, '전북 현대 모터스', '대한민국', 'rb', 40, 53, 50, 52, 51, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p176346.png?v=2401030a'),
('박규민', 300267752, '전북 현대 모터스', '대한민국', 'rm', 46, 46, 66, 53, 57, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p267752.png?v=2401030a'),
('권창훈', 300211927, '전북 현대 모터스', '대한민국', 'rw', 40, 51, 47, 33, 54, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p211927.png?v=2401030a'),
('엄승민', 300266269, '전북 현대 모터스', '대한민국', 'rw', 44, 39, 72, 42, 56, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p266269.png?v=2401030a'),
('박준범', 300266316, '전북 현대 모터스', '대한민국', 'st', 51, 46, 51, 43, 47, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p266316.png?v=2401030a'),
('박창우', 300266321, '전북 현대 모터스', '대한민국', 'rb', 35, 46, 58, 59, 54, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p266321.png?v=2401030a'),
('이우연', 300266320, '전북 현대 모터스', '대한민국', 'cb', 26, 43, 43, 39, 31, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p266320.png?v=2401030a'),
('박채준', 300266322, '전북 현대 모터스', '대한민국', 'rm', 45, 48, 57, 48, 53, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p266322.png?v=2401030a'),
('진시우', 300071325, '전북 현대 모터스', '대한민국', 'cb', 25, 34, 44, 45, 23, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p71325.png?v=2401030a'),
('강영석', 300266318, '전북 현대 모터스', '대한민국', 'cdm', 26, 48, 52, 52, 43, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p266318.png?v=2401030a'),
('마지강', 300071253, '전북 현대 모터스', '대한민국', 'lb', 26, 32, 52, 56, 43, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p71253.png?v=2401030a'),
('장남웅', 300071323, '전북 현대 모터스', '대한민국', 'cm', 39, 48, 46, 42, 41, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p71323.png?v=2401030a'),
('성진영', 300071324, '전북 현대 모터스', '대한민국', 'cam', 34, 54, 63, 41, 41, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p71324.png?v=2401030a'),
('장민준', 300260243, '전북 현대 모터스', '대한민국', 'cm', 31, 54, 58, 43, 41, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p260243.png?v=2401030a'),
('황재윤', 300071326, '전북 현대 모터스', '대한민국', 'gk', 11, 20, 27, 25, 17, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p71326.png?v=2401030a'),
('박시화', 300071327, '전북 현대 모터스', '대한민국', 'lb', 26, 31, 53, 52, 40, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p71327.png?v=2401030a'),
('김태양', 300278200, '전북 현대 모터스', '대한민국', 'gk', 10, 27, 22, 19, 14, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p278200.png?v=2401030a'),
('공시현', 300278308, '전북 현대 모터스', '대한민국', 'gk', 11, 23, 21, 23, 11, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p278308.png?v=2401030a'),
('김창훈', 300071329, '전북 현대 모터스', '대한민국', 'st', 44, 43, 55, 51, 51, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p71329.png?v=2401030a'),
('이탈로', 300070419, '제주 유나이티드', '대한민국', 'cm', 58, 67, 63, 78, 67, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p70419.png?v=2401030a'),
('헤이스', 300211786, '제주 유나이티드', '대한민국', 'lw', 62, 62, 74, 72, 70, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p211786.png?v=2401030a'),
('임채민', 300212439, '제주 유나이티드', '대한민국', 'cb', 26, 58, 66, 68, 36, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p212439.png?v=2401030a'),
('김동준', 300232065, '제주 유나이티드', '대한민국', 'gk', 18, 40, 41, 40, 14, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p232065.png?v=2401030a'),
('유리', 300238763, '제주 유나이티드', '대한민국', 'st', 68, 54, 61, 69, 58, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p238763.png?v=2401030a'),
('남태희', 300193144, '제주 유나이티드', '대한민국', 'rm', 59, 58, 68, 64, 64, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p193144.png?v=2401030a'),
('서진수', 300251580, '제주 유나이티드', '대한민국', 'st', 65, 54, 76, 75, 67, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p251580.png?v=2401030a'),
('갈레구', 300259325, '제주 유나이티드', '대한민국', 'lw', 57, 52, 81, 64, 65, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p259325.png?v=2401030a'),
('송주훈', 300234749, '제주 유나이티드', '대한민국', 'cb', 41, 51, 47, 63, 37, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p234749.png?v=2401030a'),
('정운', 300211635, '제주 유나이티드', '대한민국', 'cb', 46, 59, 69, 68, 58, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p211635.png?v=2401030a'),
('최영준', 300205156, '제주 유나이티드', '대한민국', 'cdm', 65, 58, 41, 72, 53, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p205156.png?v=2401030a'),
('임창우', 300205278, '제주 유나이티드', '대한민국', 'cb', 49, 58, 68, 72, 59, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p205278.png?v=2401030a'),
('김건웅', 300231912, '제주 유나이티드', '대한민국', 'cb', 42, 59, 57, 66, 57, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p231912.png?v=2401030a'),
('이주용', 300221859, '제주 유나이티드', '대한민국', 'lb', 53, 54, 73, 65, 61, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p221859.png?v=2401030a'),
('Y. 가이나', 300237919, '제주 유나이티드', '대한민국', 'cam', 58, 61, 69, 60, 60, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p237919.png?v=2401030a'),
('김주공', 300252278, '제주 유나이티드', '대한민국', 'cm', 56, 60, 71, 70, 59, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p252278.png?v=2401030a'),
('홍준호', 300233284, '제주 유나이티드', '대한민국', 'cb', 38, 52, 54, 61, 49, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p233284.png?v=2401030a'),
('진성욱', 300210726, '제주 유나이티드', '대한민국', 'st', 56, 55, 64, 57, 59, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p210726.png?v=2401030a'),
('김태환', 300247667, '제주 유나이티드', '대한민국', 'rb', 33, 53, 62, 75, 51, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p247667.png?v=2401030a'),
('김정민', 300244852, '제주 유나이티드', '대한민국', 'cm', 48, 59, 51, 59, 53, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p244852.png?v=2401030a'),
('안태현', 300232865, '제주 유나이티드', '대한민국', 'lb', 54, 51, 75, 76, 56, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p232865.png?v=2401030a'),
('구자철', 300182152, '제주 유나이티드', '대한민국', 'cm', 51, 58, 40, 33, 54, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p182152.png?v=2401030a'),
('안찬기', 300255919, '제주 유나이티드', '대한민국', 'gk', 10, 27, 25, 25, 10, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p255919.png?v=2401030a'),
('한종무', 300267947, '제주 유나이티드', '대한민국', 'cm', 40, 59, 49, 70, 60, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p267947.png?v=2401030a'),
('김근배', 300191685, '제주 유나이티드', '대한민국', 'gk', 12, 31, 42, 43, 13, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p191685.png?v=2401030a'),
('곽승민', 300273811, '제주 유나이티드', '대한민국', 'st', 52, 45, 54, 59, 45, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p273811.png?v=2401030a'),
('김현우', 300263372, '제주 유나이티드', '대한민국', 'lw', 58, 47, 55, 53, 51, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p263372.png?v=2401030a'),
('허강준', 300260634, '제주 유나이티드', '대한민국', 'cb', 16, 51, 57, 54, 43, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p260634.png?v=2401030a'),
('박주영', 300071328, '제주 유나이티드', '대한민국', 'rw', 50, 40, 60, 45, 51, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p71328.png?v=2401030a'),
('여홍규', 300071460, '제주 유나이티드', '대한민국', 'rb', 40, 44, 65, 58, 60, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p71460.png?v=2401030a'),
('홍재석', 300071315, '제주 유나이티드', '대한민국', 'cdm', 35, 51, 46, 51, 45, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p71315.png?v=2401030a'),
('전성진', 300273809, '제주 유나이티드', '대한민국', 'lb', 23, 53, 56, 61, 51, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p273809.png?v=2401030a'),
('백승헌', 300071461, '제주 유나이티드', '대한민국', 'rw', 43, 37, 60, 48, 53, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p71461.png?v=2401030a'),
('박주승', 300071391, '제주 유나이티드', '대한민국', 'st', 43, 43, 53, 50, 47, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p71391.png?v=2401030a'),
('김재민', 300071392, '제주 유나이티드', '대한민국', 'cm', 36, 52, 52, 53, 39, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p71392.png?v=2401030a'),
('원희도', 300071458, '제주 유나이티드', '대한민국', 'cm', 24, 49, 59, 60, 43, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p71458.png?v=2401030a'),
('조인정', 300071459, '제주 유나이티드', '대한민국', 'cm', 32, 51, 61, 58, 44, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p71459.png?v=2401030a'),
('임준섭', 300267946, '제주 유나이티드', '대한민국', 'gk', 10, 23, 19, 17, 11, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p267946.png?v=2401030a'),
('이동경', 300245054, '김천 상무', '대한민국', 'cam', 67, 68, 72, 79, 69, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p245054.png?v=2401030a'),
('김대원', 300233018, '김천 상무', '대한민국', 'lm', 61, 61, 80, 72, 67, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p233018.png?v=2401030a'),
('서민우', 300255500, '김천 상무', '대한민국', 'cm', 50, 63, 56, 78, 59, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p255500.png?v=2401030a'),
('조진우', 300246345, '김천 상무', '대한민국', 'cb', 37, 49, 58, 58, 27, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p246345.png?v=2401030a'),
('이동준', 300243061, '김천 상무', '대한민국', 'rm', 58, 52, 81, 55, 69, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p243061.png?v=2401030a'),
('김봉수', 300260474, '김천 상무', '대한민국', 'cb', 43, 62, 63, 75, 54, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p260474.png?v=2401030a'),
('김민덕', 300250896, '김천 상무', '대한민국', 'cb', 31, 48, 56, 59, 43, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p250896.png?v=2401030a'),
('박승욱', 300263845, '김천 상무', '대한민국', 'rb', 33, 57, 75, 78, 56, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p263845.png?v=2401030a'),
('이진용', 300256791, '김천 상무', '대한민국', 'cm', 39, 63, 57, 79, 59, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p256791.png?v=2401030a'),
('박수일', 300243824, '김천 상무', '대한민국', 'rb', 44, 59, 73, 73, 61, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p243824.png?v=2401030a'),
('유강현', 300228534, '김천 상무', '대한민국', 'st', 60, 49, 70, 56, 56, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p228534.png?v=2401030a'),
('이현식', 300243175, '김천 상무', '대한민국', 'rm', 43, 62, 67, 75, 63, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p243175.png?v=2401030a'),
('박찬용', 300256252, '김천 상무', '대한민국', 'cb', 24, 54, 57, 56, 22, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p256252.png?v=2401030a'),
('이상민', 300255162, '김천 상무', '대한민국', 'cdm', 43, 65, 55, 63, 52, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p255162.png?v=2401030a'),
('김동헌', 300252659, '김천 상무', '대한민국', 'gk', 11, 49, 25, 24, 12, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p252659.png?v=2401030a'),
('김찬', 300247574, '김천 상무', '대한민국', 'st', 59, 40, 69, 58, 51, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p247574.png?v=2401030a'),
('김강산', 300255297, '김천 상무', '대한민국', 'cb', 30, 43, 62, 64, 45, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p255297.png?v=2401030a'),
('원기종', 300252349, '김천 상무', '대한민국', 'st', 63, 43, 59, 43, 54, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p252349.png?v=2401030a'),
('모재현', 300238173, '김천 상무', '대한민국', 'rm', 59, 54, 74, 55, 63, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p238173.png?v=2401030a'),
('김경준', 300238287, '김천 상무', '대한민국', 'st', 57, 38, 70, 59, 51, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p238287.png?v=2401030a'),
('박상혁', 300260396, '김천 상무', '대한민국', 'st', 56, 51, 59, 54, 53, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p260396.png?v=2401030a'),
('김준호', 300261123, '김천 상무', '대한민국', 'cdm', 34, 59, 59, 52, 48, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p261123.png?v=2401030a'),
('조현택', 300255035, '김천 상무', '대한민국', 'lb', 34, 49, 68, 66, 58, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p255035.png?v=2401030a'),
('박대원', 300252277, '김천 상무', '대한민국', 'cb', 34, 53, 64, 63, 52, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p252277.png?v=2401030a'),
('맹성웅', 300252432, '김천 상무', '대한민국', 'cm', 36, 63, 51, 59, 49, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p252432.png?v=2401030a'),
('오인표', 300233185, '김천 상무', '대한민국', 'rm', 52, 51, 60, 64, 58, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p233185.png?v=2401030a'),
('김승섭', 300242821, '김천 상무', '대한민국', 'lw', 58, 53, 75, 54, 57, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p242821.png?v=2401030a'),
('최기윤', 300266366, '김천 상무', '대한민국', 'rw', 46, 48, 64, 59, 60, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p266366.png?v=2401030a'),
('유선', 300274050, '김천 상무', '대한민국', 'cb', 21, 34, 49, 55, 31, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p274050.png?v=2401030a'),
('추상훈', 300264597, '김천 상무', '대한민국', 'rw', 47, 41, 67, 56, 57, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p264597.png?v=2401030a'),
('이승원', 300274035, '김천 상무', '대한민국', 'cm', 39, 54, 54, 51, 57, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p274035.png?v=2401030a'),
('홍욱현', 300267403, '김천 상무', '대한민국', 'cb', 20, 43, 50, 45, 26, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p267403.png?v=2401030a'),
('이주현', 300255239, '김천 상무', '대한민국', 'gk', 11, 25, 22, 20, 14, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p255239.png?v=2401030a'),
('김태훈', 300252428, '김천 상무', '대한민국', 'gk', 8, 26, 27, 21, 11, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p252428.png?v=2401030a'),
('정명제', 300261074, '김천 상무', '대한민국', 'gk', 8, 24, 27, 28, 11, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p261074.png?v=2401030a'),
('최예훈', 300267402, '김천 상무', '대한민국', 'lb', 25, 29, 52, 59, 52, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p267402.png?v=2401030a'),
('세징야', 300225733, '대구 FC', '대한민국', 'st', 68, 66, 76, 70, 68, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p225733.png?v=2401030a'),
('에드가', 300179947, '대구 FC', '대한민국', 'st', 68, 60, 52, 53, 59, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p179947.png?v=2401030a'),
('김진혁', 300228464, '대구 FC', '대한민국', 'cb', 51, 59, 53, 67, 54, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p228464.png?v=2401030a'),
('황재원', 300266789, '대구 FC', '대한민국', 'cb', 36, 63, 71, 83, 65, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p266789.png?v=2401030a'),
('루카스 바르셀루스', 300272870, '대구 FC', '대한민국', 'lw', 68, 52, 70, 73, 68, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p272870.png?v=2401030a'),
('고재현', 300242924, '대구 FC', '대한민국', 'rw', 63, 52, 79, 77, 67, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p242924.png?v=2401030a'),
('홍철', 300199236, '대구 FC', '대한민국', 'lb', 36, 58, 77, 74, 61, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p199236.png?v=2401030a'),
('오승훈', 300228130, '대구 FC', '대한민국', 'gk', 18, 28, 45, 17, 16, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p228130.png?v=2401030a'),
('이탈로', 300073654, '대구 FC', '대한민국', 'st', 64, 51, 61, 63, 56, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p73654.png?v=2401030a'),
('K. 요시노', 300232603, '대구 FC', '대한민국', 'cdm', 52, 60, 61, 70, 51, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p232603.png?v=2401030a'),
('이용래', 300191871, '대구 FC', '대한민국', 'cm', 42, 65, 34, 69, 55, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p191871.png?v=2401030a'),
('박세진', 300274409, '대구 FC', '대한민국', 'cm', 43, 64, 60, 62, 62, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p274409.png?v=2401030a'),
('고명석', 300240186, '대구 FC', '대한민국', 'cb', 29, 54, 66, 65, 31, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p240186.png?v=2401030a'),
('이찬동', 300221475, '대구 FC', '대한민국', 'cm', 50, 59, 50, 72, 52, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p221475.png?v=2401030a'),
('카이우 마르셀루', 300245848, '대구 FC', '대한민국', 'cb', 25, 36, 61, 58, 31, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p245848.png?v=2401030a'),
('장성원', 300246043, '대구 FC', '대한민국', 'rb', 43, 52, 68, 69, 57, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p246043.png?v=2401030a'),
('최영은', 300245074, '대구 FC', '대한민국', 'gk', 8, 22, 17, 24, 11, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p245074.png?v=2401030a'),
('정치인', 300233011, '대구 FC', '대한민국', 'lm', 57, 45, 71, 56, 61, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p233011.png?v=2401030a'),
('박용희', 300270319, '대구 FC', '대한민국', 'rw', 46, 43, 65, 54, 60, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p270319.png?v=2401030a'),
('김영준', 300272843, '대구 FC', '대한민국', 'st', 52, 44, 56, 55, 46, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p272843.png?v=2401030a'),
('김정현', 300266394, '대구 FC', '대한민국', 'cam', 46, 50, 59, 51, 52, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p266394.png?v=2401030a'),
('김민영', 300070642, '대구 FC', '대한민국', 'st', 52, 41, 59, 43, 51, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p70642.png?v=2401030a'),
('한지율', 300266785, '대구 FC', '대한민국', 'gk', 14, 20, 18, 26, 13, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p266785.png?v=2401030a'),
('정윤서', 300274413, '대구 FC', '대한민국', 'cb', 19, 46, 36, 34, 26, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p274413.png?v=2401030a'),
('이원우', 300266788, '대구 FC', '대한민국', 'cb', 30, 42, 38, 33, 38, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p266788.png?v=2401030a'),
('정재상', 300070634, '대구 FC', '대한민국', 'st', 50, 35, 50, 56, 43, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p70634.png?v=2401030a'),
('한태희', 300274411, '대구 FC', '대한민국', 'gk', 16, 23, 34, 32, 25, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p274411.png?v=2401030a'),
('윤태민', 300274412, '대구 FC', '대한민국', 'cb', 20, 35, 42, 37, 31, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p274412.png?v=2401030a'),
('배수민', 300270318, '대구 FC', '대한민국', 'cm', 36, 49, 57, 56, 46, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p270318.png?v=2401030a'),
('전용준', 300266786, '대구 FC', '대한민국', 'rw', 42, 43, 58, 49, 50, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p266786.png?v=2401030a'),
('박상영', 300070629, '대구 FC', '대한민국', 'gk', 11, 23, 16, 23, 14, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p70629.png?v=2401030a'),
('손승민', 300070633, '대구 FC', '대한민국', 'cm', 36, 50, 50, 37, 43, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p70633.png?v=2401030a'),
('박진영', 300070636, '대구 FC', '대한민국', 'cb', 23, 26, 48, 52, 22, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p70636.png?v=2401030a'),
('박세민', 300070640, '대구 FC', '대한민국', 'rw', 50, 36, 63, 45, 48, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p70640.png?v=2401030a'),
('김민섭', 300070639, '대구 FC', '대한민국', 'cm', 40, 51, 55, 40, 47, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p70639.png?v=2401030a'),
('임지민', 300070643, '대구 FC', '대한민국', 'rb', 26, 31, 53, 56, 43, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p70643.png?v=2401030a'),
('최민기', 300260795, '대구 FC', '대한민국', 'cm', 30, 50, 62, 57, 42, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p260795.png?v=2401030a'),
('안창민', 300261065, '대구 FC', '대한민국', 'st', 44, 41, 52, 55, 38, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p261065.png?v=2401030a'),
('정은우', 300274426, '대구 FC', '대한민국', 'rw', 43, 37, 58, 37, 50, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p274426.png?v=2401030a'),
('박재현', 300266790, '대구 FC', '대한민국', 'lm', 34, 38, 58, 58, 46, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p266790.png?v=2401030a'),
('권광덕', 300070632, '대구 FC', '대한민국', 'cm', 34, 48, 56, 56, 43, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p70632.png?v=2401030a'),
('심연원', 300070635, '대구 FC', '대한민국', 'cb', 28, 30, 49, 41, 31, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p70635.png?v=2401030a'),
('정헌택', 300070637, '대구 FC', '대한민국', 'rb', 27, 31, 51, 51, 45, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p70637.png?v=2401030a'),
('한서진', 300070638, '대구 FC', '대한민국', 'rw', 42, 40, 53, 43, 50, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p70638.png?v=2401030a'),
('김현준', 300070641, '대구 FC', '대한민국', 'cb', 19, 28, 43, 45, 26, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p70641.png?v=2401030a'),
('유지운', 300274414, '대구 FC', '대한민국', 'rb', 39, 45, 58, 55, 47, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p274414.png?v=2401030a'),
('무고사', 300223994, '인천 유나이티드', '대한민국', 'st', 71, 55, 60, 69, 59, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p223994.png?v=2401030a'),
('제르소', 300209449, '인천 유나이티드', '대한민국', 'lw', 59, 59, 83, 71, 70, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p209449.png?v=2401030a'),
('P. 음포쿠', 300187858, '인천 유나이티드', '대한민국', 'cm', 62, 67, 66, 68, 70, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p187858.png?v=2401030a'),
('이명주', 300208636, '인천 유나이티드', '대한민국', 'cm', 55, 67, 62, 70, 60, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p208636.png?v=2401030a'),
('신진호', 300202986, '인천 유나이티드', '대한민국', 'cm', 54, 65, 53, 75, 58, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p202986.png?v=2401030a'),
('마테이 요니치', 300228124, '인천 유나이티드', '대한민국', 'cb', 47, 57, 66, 69, 43, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p228124.png?v=2401030a'),
('델브리지', 300241970, '인천 유나이티드', '대한민국', 'cb', 24, 51, 39, 68, 37, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p241970.png?v=2401030a'),
('김보섭', 300237027, '인천 유나이티드', '대한민국', 'rw', 57, 53, 79, 77, 65, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p237027.png?v=2401030a'),
('김동민', 300238351, '인천 유나이티드', '대한민국', 'cb', 34, 53, 70, 75, 50, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p238351.png?v=2401030a'),
('김도혁', 300221643, '인천 유나이티드', '대한민국', 'cm', 52, 61, 58, 80, 59, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p221643.png?v=2401030a'),
('오반석', 300207753, '인천 유나이티드', '대한민국', 'cb', 30, 50, 33, 52, 43, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p207753.png?v=2401030a'),
('박승호', 300273797, '인천 유나이티드', '대한민국', 'rw', 57, 46, 75, 66, 64, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p273797.png?v=2401030a'),
('문지환', 300238242, '인천 유나이티드', '대한민국', 'cm', 41, 61, 51, 75, 51, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p238242.png?v=2401030a'),
('홍시후', 300256685, '인천 유나이티드', '대한민국', 'rw', 51, 56, 75, 54, 59, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p256685.png?v=2401030a'),
('이범수', 300204725, '인천 유나이티드', '대한민국', 'gk', 11, 34, 53, 23, 12, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p204725.png?v=2401030a'),
('지언학', 300228480, '인천 유나이티드', '대한민국', 'cam', 51, 57, 67, 65, 60, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p228480.png?v=2401030a'),
('권한진', 300233410, '인천 유나이티드', '대한민국', 'cb', 41, 51, 33, 43, 45, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p233410.png?v=2401030a'),
('송시우', 300233581, '인천 유나이티드', '대한민국', 'st', 60, 55, 67, 36, 52, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p233581.png?v=2401030a'),
('김준엽', 300202949, '인천 유나이티드', '대한민국', 'rb', 52, 58, 64, 55, 59, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p202949.png?v=2401030a'),
('정동윤', 300233281, '인천 유나이티드', '대한민국', 'rb', 41, 55, 64, 67, 51, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p233281.png?v=2401030a'),
('김민석', 300260494, '인천 유나이티드', '대한민국', 'lw', 50, 41, 76, 51, 61, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p260494.png?v=2401030a'),
('민경현', 300266496, '인천 유나이티드', '대한민국', 'lb', 32, 46, 70, 70, 53, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p266496.png?v=2401030a'),
('최우진', 300273800, '인천 유나이티드', '대한민국', 'lm', 52, 49, 64, 61, 63, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p273800.png?v=2401030a'),
('김건희', 300272772, '인천 유나이티드', '대한민국', 'cb', 19, 42, 58, 51, 27, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p272772.png?v=2401030a'),
('민성준', 300269029, '인천 유나이티드', '대한민국', 'gk', 12, 32, 32, 38, 13, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p269029.png?v=2401030a'),
('김연수', 300238250, '인천 유나이티드', '대한민국', 'cb', 21, 34, 44, 59, 27, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p238250.png?v=2401030a'),
('이종욱', 300255323, '인천 유나이티드', '대한민국', 'rw', 51, 35, 67, 61, 59, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p255323.png?v=2401030a'),
('김성민', 300266495, '인천 유나이티드', '대한민국', 'rb', 37, 43, 68, 67, 54, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p266495.png?v=2401030a'),
('임형진', 300273799, '인천 유나이티드', '대한민국', 'cb', 22, 43, 57, 61, 33, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p273799.png?v=2401030a'),
('김유성', 300255322, '인천 유나이티드', '대한민국', 'gk', 10, 19, 24, 22, 14, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p255322.png?v=2401030a'),
('김현서', 300273796, '인천 유나이티드', '대한민국', 'cm', 34, 50, 62, 54, 50, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p273796.png?v=2401030a'),
('성윤수', 300070649, '인천 유나이티드', '대한민국', 'gk', 9, 23, 17, 28, 11, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p70649.png?v=2401030a'),
('하동선', 300273801, '인천 유나이티드', '대한민국', 'st', 50, 42, 55, 55, 40, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p273801.png?v=2401030a'),
('강도욱', 300070646, '인천 유나이티드', '대한민국', 'cam', 41, 48, 57, 40, 52, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p70646.png?v=2401030a'),
('김훈', 300070644, '인천 유나이티드', '대한민국', 'cam', 37, 43, 58, 43, 51, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p70644.png?v=2401030a'),
('백민규', 300070647, '인천 유나이티드', '대한민국', 'st', 45, 35, 57, 53, 48, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p70647.png?v=2401030a'),
('최승구', 300070648, '인천 유나이티드', '대한민국', 'rb', 26, 38, 56, 52, 45, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p70648.png?v=2401030a'),
('김세훈', 300272771, '인천 유나이티드', '대한민국', 'cm', 27, 51, 59, 49, 43, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p272771.png?v=2401030a'),
('이가람', 300070645, '인천 유나이티드', '대한민국', 'cm', 34, 45, 57, 43, 43, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p70645.png?v=2401030a'),
('박진홍', 300273798, '인천 유나이티드', '대한민국', 'cm', 29, 48, 58, 56, 40, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p273798.png?v=2401030a'),
('강투지', 300276140, '강원 FC', '대한민국', 'cb', 27, 54, 59, 67, 36, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p276140.png?v=2401030a'),
('이상헌', 300233568, '강원 FC', '대한민국', 'st', 66, 58, 75, 60, 68, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p233568.png?v=2401030a'),
('이광연', 300251157, '강원 FC', '대한민국', 'gk', 10, 25, 27, 26, 12, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p251157.png?v=2401030a'),
('김동현', 300245981, '강원 FC', '대한민국', 'cm', 42, 67, 61, 79, 58, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p245981.png?v=2401030a'),
('양민혁', 300071106, '강원 FC', '대한민국', 'lm', 61, 50, 78, 66, 69, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p71106.png?v=2401030a'),
('황문기', 300230921, '강원 FC', '대한민국', 'rb', 48, 62, 64, 76, 63, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p230921.png?v=2401030a'),
('김영빈', 300222582, '강원 FC', '대한민국', 'cb', 22, 53, 57, 63, 29, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p222582.png?v=2401030a'),
('H. 호어', 300264721, '강원 FC', '대한민국', 'lm', 60, 63, 62, 67, 61, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p264721.png?v=2401030a'),
('김강국', 300251579, '강원 FC', '대한민국', 'cm', 45, 65, 57, 81, 56, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p251579.png?v=2401030a'),
('이기혁', 300261128, '강원 FC', '대한민국', 'cb', 49, 58, 71, 74, 63, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p261128.png?v=2401030a'),
('빅토르 가브리엘', 300276516, '강원 FC', '대한민국', 'st', 60, 46, 72, 57, 62, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p276516.png?v=2401030a'),
('F. 코바체비치', 300259256, '강원 FC', '대한민국', 'st', 60, 59, 67, 64, 67, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p259256.png?v=2401030a'),
('윤석영', 300191980, '강원 FC', '대한민국', 'lb', 44, 55, 67, 72, 53, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p191980.png?v=2401030a'),
('I. 하지치', 300205062, '강원 FC', '대한민국', 'st', 63, 43, 61, 59, 55, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p205062.png?v=2401030a'),
('유인수', 300232857, '강원 FC', '대한민국', 'rb', 54, 53, 71, 71, 60, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p232857.png?v=2401030a'),
('이유현', 300238089, '강원 FC', '대한민국', 'rb', 36, 54, 67, 70, 59, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p238089.png?v=2401030a'),
('김이석', 300228487, '강원 FC', '대한민국', 'cm', 45, 61, 67, 74, 52, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p228487.png?v=2401030a'),
('박청효', 300212839, '강원 FC', '대한민국', 'gk', 17, 27, 45, 24, 20, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p212839.png?v=2401030a'),
('이지솔', 300247689, '강원 FC', '대한민국', 'cb', 45, 53, 58, 68, 24, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p247689.png?v=2401030a'),
('김우석', 300232402, '강원 FC', '대한민국', 'cb', 26, 46, 45, 51, 36, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p232402.png?v=2401030a'),
('김경민', 300243321, '강원 FC', '대한민국', 'st', 55, 41, 77, 59, 57, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p243321.png?v=2401030a'),
('김대우', 300260395, '강원 FC', '대한민국', 'cm', 29, 54, 58, 67, 53, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p260395.png?v=2401030a'),
('정한민', 300255554, '강원 FC', '대한민국', 'lm', 54, 39, 65, 57, 59, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p255554.png?v=2401030a'),
('송준석', 300261582, '강원 FC', '대한민국', 'lb', 27, 50, 59, 59, 48, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p261582.png?v=2401030a'),
('류광현', 300277010, '강원 FC', '대한민국', 'lb', 28, 36, 59, 55, 54, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p277010.png?v=2401030a'),
('박경배', 300255497, '강원 FC', '대한민국', 'st', 53, 46, 50, 51, 51, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p255497.png?v=2401030a'),
('신민하', 300071103, '강원 FC', '대한민국', 'cb', 21, 33, 52, 55, 27, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p71103.png?v=2401030a'),
('진준서', 300073438, '강원 FC', '대한민국', 'st', 50, 41, 59, 42, 51, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p73438.png?v=2401030a'),
('김형진', 300073087, '강원 FC', '대한민국', 'lw', 50, 43, 59, 42, 47, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p73087.png?v=2401030a'),
('박상현', 300071104, '강원 FC', '대한민국', 'cb', 19, 27, 55, 57, 26, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p71104.png?v=2401030a'),
('김해승', 300266483, '강원 FC', '대한민국', 'st', 47, 35, 67, 45, 41, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p266483.png?v=2401030a'),
('홍성무', 300266491, '강원 FC', '대한민국', 'cm', 29, 49, 51, 60, 43, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p266491.png?v=2401030a'),
('박태랑', 300071190, '강원 FC', '대한민국', 'cb', 20, 34, 59, 58, 21, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p71190.png?v=2401030a'),
('조민규', 300274115, '강원 FC', '대한민국', 'gk', 11, 22, 25, 26, 12, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p274115.png?v=2401030a'),
('조진혁', 300274117, '강원 FC', '대한민국', 'rw', 45, 41, 59, 50, 51, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p274117.png?v=2401030a'),
('김유성', 300071105, '강원 FC', '대한민국', 'gk', 10, 17, 27, 21, 10, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p71105.png?v=2401030a'),
('조현태', 300274116, '강원 FC', '대한민국', 'cb', 19, 32, 46, 51, 26, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p274116.png?v=2401030a'),
('정호연', 300266751, '광주 FC', '대한민국', 'cm', 48, 67, 61, 83, 67, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p266751.png?v=2401030a'),
('안영규', 300208073, '광주 FC', '대한민국', 'cb', 27, 51, 59, 63, 45, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p208073.png?v=2401030a'),
('최경록', 300221767, '광주 FC', '대한민국', 'cm', 57, 65, 47, 75, 68, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p221767.png?v=2401030a'),
('이희균', 300247748, '광주 FC', '대한민국', 'st', 59, 62, 69, 80, 69, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p247748.png?v=2401030a'),
('아사니', 300254886, '광주 FC', '대한민국', 'rm', 59, 59, 73, 67, 66, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p254886.png?v=2401030a'),
('두현석', 300243422, '광주 FC', '대한민국', 'rb', 52, 54, 76, 81, 64, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p243422.png?v=2401030a'),
('김경민', 300221759, '광주 FC', '대한민국', 'gk', 19, 31, 46, 26, 17, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p221759.png?v=2401030a'),
('이건희', 300255519, '광주 FC', '대한민국', 'st', 67, 43, 67, 69, 55, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p255519.png?v=2401030a'),
('B. 미켈타제', 300263166, '광주 FC', '대한민국', 'st', 61, 59, 69, 71, 58, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p263166.png?v=2401030a'),
('가브리엘 치그랑', 300070418, '광주 FC', '대한민국', 'rm', 65, 52, 69, 70, 66, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p70418.png?v=2401030a'),
('허율', 300255868, '광주 FC', '대한민국', 'cb', 59, 51, 75, 59, 52, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p255868.png?v=2401030a'),
('브루누 올리베이라', 300071309, '광주 FC', '대한민국', 'cb', 34, 52, 59, 58, 43, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p71309.png?v=2401030a'),
('변준수', 300259843, '광주 FC', '대한민국', 'cb', 27, 50, 74, 78, 42, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p259843.png?v=2401030a'),
('주앙 마그누', 300269978, '광주 FC', '대한민국', 'st', 62, 47, 63, 64, 54, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p269978.png?v=2401030a'),
('이민기', 300233280, '광주 FC', '대한민국', 'lb', 28, 54, 70, 75, 57, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p233280.png?v=2401030a'),
('A. 포포비치', 300264070, '광주 FC', '대한민국', 'cb', 28, 53, 65, 62, 44, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p264070.png?v=2401030a'),
('이강현', 300260497, '광주 FC', '대한민국', 'cdm', 33, 59, 54, 70, 49, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p260497.png?v=2401030a'),
('김진호', 300269093, '광주 FC', '대한민국', 'lb', 44, 45, 67, 80, 63, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p269093.png?v=2401030a'),
('박태준', 300243064, '광주 FC', '대한민국', 'cm', 44, 58, 67, 80, 58, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p243064.png?v=2401030a'),
('이으뜸', 300213172, '광주 FC', '대한민국', 'lb', 43, 52, 66, 69, 54, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p213172.png?v=2401030a'),
('문민서', 300071359, '광주 FC', '대한민국', 'lm', 49, 60, 60, 58, 59, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p71359.png?v=2401030a'),
('김한길', 300237977, '광주 FC', '대한민국', 'rm', 53, 49, 72, 73, 61, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p237977.png?v=2401030a'),
('이상기', 300237102, '광주 FC', '대한민국', 'rb', 49, 54, 68, 76, 56, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p237102.png?v=2401030a'),
('이준', 300238571, '광주 FC', '대한민국', 'gk', 19, 22, 24, 16, 19, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p238571.png?v=2401030a'),
('정지용', 300252809, '광주 FC', '대한민국', 'lm', 54, 40, 67, 66, 59, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p252809.png?v=2401030a'),
('김경재', 300232216, '광주 FC', '대한민국', 'cb', 29, 50, 71, 64, 51, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p232216.png?v=2401030a'),
('신창무', 300221831, '광주 FC', '대한민국', 'lm', 51, 54, 59, 67, 53, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p221831.png?v=2401030a'),
('하승운', 300238579, '광주 FC', '대한민국', 'lw', 55, 43, 72, 64, 59, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p238579.png?v=2401030a'),
('조성권', 300274694, '광주 FC', '대한민국', 'cb', 22, 39, 52, 59, 28, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p274694.png?v=2401030a'),
('여봉훈', 300237999, '광주 FC', '대한민국', 'rb', 51, 59, 61, 72, 56, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p237999.png?v=2401030a'),
('김승우', 300247845, '광주 FC', '대한민국', 'cb', 23, 36, 51, 55, 28, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p247845.png?v=2401030a'),
('정지훈', 300274839, '광주 FC', '대한민국', 'lm', 52, 44, 61, 53, 59, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p274839.png?v=2401030a'),
('오후성', 300252644, '광주 FC', '대한민국', 'st', 53, 51, 69, 57, 52, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p252644.png?v=2401030a'),
('김윤호', 300074599, '광주 FC', '대한민국', 'st', 51, 36, 50, 58, 35, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p74599.png?v=2401030a'),
('안혁주', 300071358, '광주 FC', '대한민국', 'lm', 36, 52, 54, 38, 46, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p71358.png?v=2401030a'),
('노희동', 300266750, '광주 FC', '대한민국', 'gk', 9, 26, 26, 26, 11, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p266750.png?v=2401030a'),
('김태준', 300278309, '광주 FC', '대한민국', 'gk', 9, 26, 23, 19, 10, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p278309.png?v=2401030a'),
('손준호', 300221875, '수원 FC', '대한민국', 'cdm', 51, 67, 71, 83, 61, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p221875.png?v=2401030a'),
('윤빛가람', 300200601, '수원 FC', '대한민국', 'cm', 56, 69, 62, 75, 63, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p200601.png?v=2401030a'),
('안데르송 올리베이라', 300254225, '수원 FC', '대한민국', 'lm', 60, 60, 80, 67, 69, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p254225.png?v=2401030a'),
('정승원', 300234264, '수원 FC', '대한민국', 'cm', 55, 64, 64, 81, 59, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p234264.png?v=2401030a'),
('안준수', 300237778, '수원 FC', '대한민국', 'gk', 10, 18, 26, 27, 15, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p237778.png?v=2401030a'),
('정민기', 300252427, '수원 FC', '대한민국', 'gk', 9, 20, 18, 27, 12, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p252427.png?v=2401030a'),
('래클랜 잭슨', 300228210, '수원 FC', '대한민국', 'cb', 21, 52, 48, 59, 40, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p228210.png?v=2401030a'),
('박철우', 300268342, '수원 FC', '대한민국', 'lb', 41, 52, 66, 74, 63, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p268342.png?v=2401030a'),
('지동원', 300199266, '수원 FC', '대한민국', 'st', 60, 53, 44, 52, 54, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p199266.png?v=2401030a'),
('이재원', 300247844, '수원 FC', '대한민국', 'cm', 51, 61, 59, 72, 61, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p247844.png?v=2401030a'),
('이용', 300200577, '수원 FC', '대한민국', 'rb', 39, 57, 54, 64, 54, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p200577.png?v=2401030a'),
('김태한', 300243528, '수원 FC', '대한민국', 'cb', 17, 43, 51, 64, 21, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p243528.png?v=2401030a'),
('최규백', 300232831, '수원 FC', '대한민국', 'cb', 21, 55, 59, 66, 31, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p232831.png?v=2401030a'),
('노동건', 300221700, '수원 FC', '대한민국', 'gk', 17, 27, 39, 24, 13, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p221700.png?v=2401030a'),
('한교원', 300202994, '수원 FC', '대한민국', 'rm', 56, 55, 68, 57, 59, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p202994.png?v=2401030a'),
('강상윤', 300268895, '수원 FC', '대한민국', 'cm', 46, 59, 67, 67, 62, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p268895.png?v=2401030a'),
('R. 소타', 300074007, '수원 FC', '대한민국', 'cb', 26, 45, 58, 58, 32, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p74007.png?v=2401030a'),
('안병준', 300233671, '수원 FC', '대한민국', 'st', 59, 49, 48, 59, 51, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p233671.png?v=2401030a'),
('박배종', 300213283, '수원 FC', '대한민국', 'gk', 12, 23, 47, 32, 13, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p213283.png?v=2401030a'),
('정동호', 300212065, '수원 FC', '대한민국', 'lb', 31, 53, 65, 62, 54, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p212065.png?v=2401030a'),
('노경호', 300261116, '수원 FC', '대한민국', 'st', 53, 54, 66, 64, 62, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p261116.png?v=2401030a'),
('김주엽', 300252051, '수원 FC', '대한민국', 'rb', 34, 43, 55, 64, 50, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p252051.png?v=2401030a'),
('황순민', 300207836, '수원 FC', '대한민국', 'lb', 48, 52, 59, 66, 53, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p207836.png?v=2401030a'),
('장영우', 300071369, '수원 FC', '대한민국', 'rb', 51, 53, 54, 55, 51, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p71369.png?v=2401030a'),
('한상규', 300071193, '수원 FC', '대한민국', 'cb', 21, 38, 59, 58, 35, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p71193.png?v=2401030a'),
('강민성', 300277535, '수원 FC', '대한민국', 'lw', 42, 35, 59, 39, 58, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p277535.png?v=2401030a'),
('아르한', 300070421, '수원 FC', '대한민국', 'lb', 25, 37, 60, 59, 51, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p70421.png?v=2401030a'),
('이재훈', 300071192, '수원 FC', '대한민국', 'gk', 11, 20, 30, 22, 11, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p71192.png?v=2401030a'),
('이경민', 300071197, '수원 FC', '대한민국', 'gk', 11, 18, 31, 19, 12, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p71197.png?v=2401030a'),
('하정우', 300071196, '수원 FC', '대한민국', 'st', 46, 40, 49, 60, 42, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p71196.png?v=2401030a'),
('정승배', 300071200, '수원 FC', '대한민국', 'rw', 48, 42, 63, 39, 51, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p71200.png?v=2401030a'),
('조준현', 300279850, '수원 FC', '대한민국', 'cam', 37, 52, 56, 51, 50, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p279850.png?v=2401030a'),
('김대현', 300279852, '수원 FC', '대한민국', 'cb', 20, 31, 49, 46, 26, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p279852.png?v=2401030a'),
('이현용', 300274422, '수원 FC', '대한민국', 'cb', 19, 32, 49, 36, 29, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p274422.png?v=2401030a'),
('신일연', 300071194, '수원 FC', '대한민국', 'rb', 21, 28, 54, 58, 48, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p71194.png?v=2401030a'),
('이윤건', 300071195, '수원 FC', '대한민국', 'cdm', 32, 51, 65, 59, 46, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p71195.png?v=2401030a'),
('김원형', 300071198, '수원 FC', '대한민국', 'rm', 46, 45, 67, 44, 44, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p71198.png?v=2401030a'),
('박진우', 300071199, '수원 FC', '대한민국', 'st', 50, 43, 58, 48, 42, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p71199.png?v=2401030a'),
('안치우', 300277536, '수원 FC', '대한민국', 'cm', 35, 48, 53, 42, 49, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p277536.png?v=2401030a'),
('이요셉', 300071102, '수원 FC', '대한민국', 'cdm', 32, 53, 57, 48, 43, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p71102.png?v=2401030a'),
('김도윤', 300278595, '수원 FC', '대한민국', 'st', 43, 36, 64, 45, 39, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p278595.png?v=2401030a'),
('강교훈', 300279851, '수원 FC', '대한민국', 'cm', 34, 49, 50, 50, 40, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p279851.png?v=2401030a'),
('김현민', 300071463, '수원 FC', '대한민국', 'cdm', 43, 44, 57, 41, 41, 'https://static.inven.co.kr/image_2011/site_image/fifaonline4/playerimage2/p71463.png?v=2401030a');

select * from kleagueplayers;

SET SQL_SAFE_UPDATES = 0;

delete from kleagueplayers where playercode in 
(300073439,
300245717,
300072560,
300073654,
300245848,
300274414,
300276140,
300071106,
300277010,
300073438,
300073087,
300071190,
300074599,
300074007,
300071199);
SET SQL_SAFE_UPDATES = 1;




