/* ===========================================================================
   TABLE: CUSTOMER
   DICTIONARY & EXPLANATIONS:
   - Purpose: Stores basic information about customers visiting the restaurant or using the app.
   - Customer_ID (INT): Primary Key. Unique identifier for each customer.
   - first_name (VARCHAR(50)): Customer's first name.
   - last_name (VARCHAR(50)): Customer's last name.
   - phone (VARCHAR(15)): Customer's phone number. Must be unique to avoid
     duplicate account registrations. Minimum 7 characters to reject obviously
     invalid numbers.
   - email (VARCHAR(100)): Customer's email address. Must be unique for account
     identification. Basic format validation ensures it contains '@' and a domain.
   - created_at (DATE): Date when the customer record was first created.
   - is_active (INT): Boolean-style flag restricted to 0 or 1 (CHECK constraint)
     to handle soft deletes or account deactivations. Defaults to 1 (active).
=========================================================================== */

CREATE TABLE CUSTOMER
(
  Customer_ID INT NOT NULL,
  first_name VARCHAR(50) NOT NULL,
  last_name VARCHAR(50) NOT NULL,
  phone VARCHAR(15) NOT NULL CHECK (LENGTH(phone) >= 7),
  email VARCHAR(100) NOT NULL CHECK (email LIKE '%_@_%.__%'),
  created_at DATE NOT NULL,
  is_active INT DEFAULT 1 CHECK (is_active IN (0, 1)),
  PRIMARY KEY (Customer_ID),
  UNIQUE (phone),
  UNIQUE (email)
);

/* ===========================================================================
   TABLE: STATUS_TYPE
   DICTIONARY & EXPLANATIONS:
   - Purpose: A lookup table (enum-like) for various statuses used across
     different entities (e.g., Pending, Confirmed, Cancelled).
   - status_ID (INT): Primary Key. Unique numeric identifier for the status.
   - description (VARCHAR(50)): Human-readable name/description of the status.
     Must be unique so that no two statuses share the same label.
=========================================================================== */

CREATE TABLE STATUS_TYPE
(
  status_ID INT NOT NULL,
  description VARCHAR(50) NOT NULL,
  PRIMARY KEY (status_ID),
  UNIQUE (description)
);

/* ===========================================================================
   TABLE: RESERVATION
   DICTIONARY & EXPLANATIONS:
   - Purpose: Records scheduled dining arrangements made by customers.
   - reservation_ID (INT): Primary Key. Unique identifier for each reservation.
   - datetime (DATE): The scheduled date and time for the reservation.
   - party_size (INT): Number of guests. Must be between 1 and 20 (CHECK
     constraints) because a reservation cannot have zero people, and the
     restaurant has a maximum seating capacity per single booking.
   - special_requests (VARCHAR(255)): Optional notes from the customer
     (e.g., allergies, seating preferences).
   - created_at (DATE): Timestamp of when the reservation request was made.
   - Customer_ID (INT): Foreign Key linking the reservation to a specific customer.
   - status_ID (INT): Foreign Key linking to STATUS_TYPE to track current state
     (e.g., Confirmed).
=========================================================================== */

CREATE TABLE RESERVATION
(
  reservation_ID INT NOT NULL,
  datetime DATE NOT NULL,
  party_size INT NOT NULL CHECK (party_size > 0 AND party_size <= 20),
  special_requests VARCHAR(255),
  created_at DATE NOT NULL,
  Customer_ID INT NOT NULL,
  status_ID INT NOT NULL,
  PRIMARY KEY (reservation_ID),
  FOREIGN KEY (Customer_ID) REFERENCES CUSTOMER(Customer_ID),
  FOREIGN KEY (status_ID) REFERENCES STATUS_TYPE(status_ID)
);

/* ===========================================================================
   TABLE: WAITLIST
   DICTIONARY & EXPLANATIONS:
   - Purpose: Tracks walk-in customers waiting for a table when immediate
     seating is unavailable.
   - waitlist_ID (INT): Primary Key. Unique identifier for the waitlist entry.
   - party_size (INT): Number of guests. Must be between 1 and 20 (CHECK
     constraints) to match the restaurant's maximum single-party capacity.
   - request_time (DATE): The time the customer arrived and joined the waitlist.
   - est_wait_time (INT): Estimated waiting period in minutes. Cannot be
     negative (CHECK >= 0) and capped at 300 minutes (5 hours) because
     quoting longer waits is unrealistic for restaurant operations.
   - Customer_ID (INT): Foreign Key linking to the customer record.
   - status_ID (INT): Foreign Key linking to STATUS_TYPE (e.g., Waiting, Seated).
=========================================================================== */

CREATE TABLE WAITLIST
(
  waitlist_ID INT NOT NULL,
  party_size INT NOT NULL CHECK (party_size > 0 AND party_size <= 20),
  request_time DATE NOT NULL,
  est_wait_time INT NOT NULL CHECK (est_wait_time >= 0 AND est_wait_time <= 300),
  Customer_ID INT NOT NULL,
  status_ID INT NOT NULL,
  PRIMARY KEY (waitlist_ID),
  FOREIGN KEY (Customer_ID) REFERENCES CUSTOMER(Customer_ID),
  FOREIGN KEY (status_ID) REFERENCES STATUS_TYPE(status_ID)
);

/* ===========================================================================
   TABLE: FEEDBACK
   DICTIONARY & EXPLANATIONS:
   - Purpose: Stores customer reviews and ratings regarding their dining experience.
   - feedback_ID (INT): Primary Key. Unique identifier for the feedback entry.
   - rating (INT): Numerical score between 1 (worst) and 5 (best). Enforced by
     a CHECK constraint to guarantee only valid scores are recorded.
   - comment (VARCHAR(500)): Optional free-text feedback from the customer.
   - feedback_date (DATE): Date when the feedback was submitted.
   - reservation_ID (INT): Foreign Key linking feedback to a specific reservation.
     Must be unique so that a customer can only submit one review per visit.
=========================================================================== */

CREATE TABLE FEEDBACK
(
  feedback_ID INT NOT NULL,
  rating INT NOT NULL CHECK (rating >= 1 AND rating <= 5),
  comment VARCHAR(500),
  feedback_date DATE NOT NULL,
  reservation_ID INT NOT NULL,
  PRIMARY KEY (feedback_ID),
  FOREIGN KEY (reservation_ID) REFERENCES RESERVATION(reservation_ID),
  UNIQUE (reservation_ID)
);

/* ===========================================================================
   TABLE: LOYALTY_TIER
   DICTIONARY & EXPLANATIONS:
   - Purpose: Defines the different levels of the loyalty program
     (e.g., Bronze, Silver, Gold).
   - tier_id (INT): Primary Key. Unique identifier for the tier level.
   - level (VARCHAR(50)): Name of the loyalty tier. Must be unique so that
     no two tiers share the same label.
=========================================================================== */

CREATE TABLE LOYALTY_TIER
(
  tier_id INT NOT NULL,
  level VARCHAR(50) NOT NULL,
  PRIMARY KEY (tier_id),
  UNIQUE (level)
);

/* ===========================================================================
   TABLE: LOYALTY
   DICTIONARY & EXPLANATIONS:
   - Purpose: Manages the point balance and current tier progress for each customer.
   - loyalty_ID (INT): Primary Key. Unique identifier for the loyalty account.
   - points (INT): Current accumulated points. Cannot be negative (CHECK >= 0).
   - last_Updated (DATE): Date of the most recent points change.
   - Customer_ID (INT): Foreign Key linking to the customer. Each customer can have only one loyalty record (UNIQUE).
   - tier_id (INT): Foreign Key linking to the current benefit level of the customer.
=========================================================================== */

CREATE TABLE LOYALTY
(
  loyalty_ID INT NOT NULL,
  points INT NOT NULL CHECK (points >= 0),
  last_Updated DATE NOT NULL,
  Customer_ID INT NOT NULL,
  tier_id INT NOT NULL,
  PRIMARY KEY (loyalty_ID),
  FOREIGN KEY (Customer_ID) REFERENCES CUSTOMER(Customer_ID),
  FOREIGN KEY (tier_id) REFERENCES LOYALTY_TIER(tier_id),
  UNIQUE (Customer_ID)
);

/* ===========================================================================
   TABLE: REASON
   DICTIONARY & EXPLANATIONS:
   - Purpose: A lookup table for reasons behind loyalty point changes
     (e.g., Purchase, Referral, Reward Redemption).
   - reason_id (INT): Primary Key. Unique identifier for the reason.
   - description (VARCHAR(100)): Detailed explanation of why points were
     added or removed. Must be unique to prevent duplicate reason entries.
=========================================================================== */

CREATE TABLE REASON
(
  reason_id INT NOT NULL,
  description VARCHAR(100) NOT NULL,
  PRIMARY KEY (reason_id),
  UNIQUE (description)
);

/* ===========================================================================
   TABLE: LOYALTY_TRANSACTION
   DICTIONARY & EXPLANATIONS:
   - Purpose: Keeps a detailed audit trail of every addition or subtraction
     of loyalty points.
   - transaction_ID (INT): Primary Key. Unique identifier for the transaction.
   - points_change (INT): The amount of points added (positive) or removed
     (negative). Cannot be zero (CHECK <> 0) because a zero-point transaction
     carries no meaning and would pollute the audit log.
   - created_at (DATE): Timestamp of the transaction.
   - loyalty_ID (INT): Foreign Key linking to the customer's loyalty account.
   - reason_id (INT): Foreign Key linking to the specific reason for this
     point update.
=========================================================================== */

CREATE TABLE LOYALTY_TRANSACTION
(
  transaction_ID INT NOT NULL,
  points_change INT NOT NULL CHECK (points_change <> 0),
  created_at DATE NOT NULL,
  loyalty_ID INT NOT NULL,
  reason_id INT NOT NULL,
  PRIMARY KEY (transaction_ID),
  FOREIGN KEY (loyalty_ID) REFERENCES LOYALTY(loyalty_ID),
  FOREIGN KEY (reason_id) REFERENCES REASON(reason_id)
);
