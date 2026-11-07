-- Local-only seed data. All accounts use the password: password
-- The BCrypt hash is intentionally shared only for disposable development data.

INSERT INTO app_user (id, role, username, email, password_hash, first_name, last_name, date_of_birth)
VALUES
    (1, 'ADMIN', 'admin', 'admin@local.test', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', 'Admin', 'User', NULL),
    (2, 'CUSTOMER', 'testuser', 'testuser@local.test', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', 'Test', 'User', DATE '1998-05-12');

INSERT INTO app_user (id, role, username, email, password_hash, first_name, last_name, manager_id)
VALUES
    (3, 'REPRESENTATIVE', 'rep2', 'rep2@local.test', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', 'Casey', 'Representative', 1);

INSERT INTO station (id, station_code, name, city, state_code)
VALUES
    (1, 'PA', 'Pennsylvania', 'Philadelphia', 'PA'),
    (2, 'NYP', 'NY PENN', 'New York', 'NY'),
    (3, 'BOS', 'Boston South', 'Boston', 'MA'),
    (4, 'PVD', 'Providence', 'Providence', 'RI'),
    (5, 'PRN', 'Princeton', 'Princeton', 'NJ'),
    (6, 'NBK', 'New Brunswick', 'New Brunswick', 'NJ'),
    (7, 'EDN', 'Edison', 'Edison', 'NJ');

INSERT INTO transit_line (id, line_code, name, base_fare)
VALUES
    (1, 'NE-01', 'Northeast Express', 18.00),
    (2, 'NJ-01', 'NJ Shuttle', 8.00),
    (3, 'NE-02', 'New England Connector', 14.00);

INSERT INTO transit_line_fare_policy (transit_line_id, passenger_type, discount_rate)
VALUES
    (1, 'ADULT', 0), (1, 'CHILD', 0.50), (1, 'SENIOR', 0.25), (1, 'DISABLED', 0.25),
    (2, 'ADULT', 0), (2, 'CHILD', 0.50), (2, 'SENIOR', 0.25), (2, 'DISABLED', 0.25),
    (3, 'ADULT', 0), (3, 'CHILD', 0.50), (3, 'SENIOR', 0.25), (3, 'DISABLED', 0.25);

INSERT INTO transit_line_stop (id, transit_line_id, station_id, stop_sequence, arrival_time, departure_time)
VALUES
    (1, 1, 1, 1, NULL, TIME '08:00'),
    (2, 1, 2, 2, TIME '10:00', NULL),
    (3, 2, 5, 1, NULL, TIME '09:15'),
    (4, 2, 6, 2, TIME '09:45', TIME '09:50'),
    (5, 2, 7, 3, TIME '10:15', NULL),
    (6, 3, 3, 1, NULL, TIME '11:00'),
    (7, 3, 4, 2, TIME '12:10', NULL);

INSERT INTO train (id, train_code, transit_line_id)
VALUES
    (1, 'NE-101', 1),
    (2, 'NJ-201', 2),
    (3, 'NE-301', 3);

INSERT INTO train_schedule (id, train_id, departure_at, arrival_at)
VALUES
    (1, 1, TIMESTAMPTZ '2027-07-15 08:00:00-04', TIMESTAMPTZ '2027-07-15 10:00:00-04'),
    (2, 2, TIMESTAMPTZ '2027-07-15 09:15:00-04', TIMESTAMPTZ '2027-07-15 10:15:00-04'),
    (3, 3, TIMESTAMPTZ '2027-07-16 11:00:00-04', TIMESTAMPTZ '2027-07-16 12:10:00-04');

INSERT INTO schedule_stop (schedule_id, station_id, stop_sequence, arrival_at, departure_at)
VALUES
    (1, 1, 1, NULL, TIMESTAMPTZ '2027-07-15 08:00:00-04'),
    (1, 2, 2, TIMESTAMPTZ '2027-07-15 10:00:00-04', NULL),
    (2, 5, 1, NULL, TIMESTAMPTZ '2027-07-15 09:15:00-04'),
    (2, 6, 2, TIMESTAMPTZ '2027-07-15 09:45:00-04', TIMESTAMPTZ '2027-07-15 09:50:00-04'),
    (2, 7, 3, TIMESTAMPTZ '2027-07-15 10:15:00-04', NULL),
    (3, 3, 1, NULL, TIMESTAMPTZ '2027-07-16 11:00:00-04'),
    (3, 4, 2, TIMESTAMPTZ '2027-07-16 12:10:00-04', NULL);

INSERT INTO reservation (id, customer_id, status, passenger_type, total_fare, booked_at)
VALUES
    (1, 2, 'ACTIVE', 'ADULT', 18.00, TIMESTAMPTZ '2027-07-01 14:30:00-04');

INSERT INTO reservation_leg (reservation_id, schedule_id, origin_station_id, destination_station_id, leg_sequence, fare_amount)
VALUES
    (1, 1, 1, 2, 1, 18.00);

INSERT INTO support_conversation (id, customer_id, status, subject)
VALUES
    (1, 2, 'ANSWERED', 'Question about reservation changes');

INSERT INTO support_message (conversation_id, sender_id, body, created_at)
VALUES
    (1, 2, 'Can I change my trip before departure?', TIMESTAMPTZ '2027-07-02 09:00:00-04'),
    (1, 3, 'Please contact support before departure and we can help review the available options.', TIMESTAMPTZ '2027-07-02 10:15:00-04');

SELECT setval(pg_get_serial_sequence('app_user', 'id'), (SELECT MAX(id) FROM app_user));
SELECT setval(pg_get_serial_sequence('station', 'id'), (SELECT MAX(id) FROM station));
SELECT setval(pg_get_serial_sequence('transit_line', 'id'), (SELECT MAX(id) FROM transit_line));
SELECT setval(pg_get_serial_sequence('transit_line_stop', 'id'), (SELECT MAX(id) FROM transit_line_stop));
SELECT setval(pg_get_serial_sequence('train', 'id'), (SELECT MAX(id) FROM train));
SELECT setval(pg_get_serial_sequence('train_schedule', 'id'), (SELECT MAX(id) FROM train_schedule));
SELECT setval(pg_get_serial_sequence('reservation', 'id'), (SELECT MAX(id) FROM reservation));
SELECT setval(pg_get_serial_sequence('support_conversation', 'id'), (SELECT MAX(id) FROM support_conversation));
