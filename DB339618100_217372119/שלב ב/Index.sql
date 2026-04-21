/* ===================================================================
   I N D E X E S  (3)
   =================================================================== */

   -- This file creates 3 performance indexes.
   
   -- Run these AFTER the initial schema (01-create-tables.sql) has been
   -- applied. These improve data integrity for the queries.
/* -------------------------------------------------------------------
   INDEX 1: RESERVATION.Customer_ID for faster JOINs
   -------------------------------------------------------------------
   Performance: Many of our SELECT queries join RESERVATION to CUSTOMER.
   An index on Customer_ID speeds up these lookups significantly.
   ------------------------------------------------------------------- */

CREATE INDEX IF NOT EXISTS idx_reservation_customer
ON RESERVATION (Customer_ID);


/* -------------------------------------------------------------------
   INDEX 2: RESERVATION.datetime for date queries
   -------------------------------------------------------------------
   Performance: Queries S1, S6, S8, U2 all filter or group by
   reservation datetime. An index improves GROUP BY and range scans.
   ------------------------------------------------------------------- */

CREATE INDEX IF NOT EXISTS idx_reservation_datetime
ON RESERVATION (datetime);


/* -------------------------------------------------------------------
   INDEX 3: LOYALTY_TRANSACTION.created_at for date queries
   -------------------------------------------------------------------
   Performance: Query S4 groups by EXTRACT(YEAR/QUARTER) from created_at.
   An index on created_at speeds up the date-based aggregation.
   ------------------------------------------------------------------- */

CREATE INDEX IF NOT EXISTS idx_loyalty_txn_created
ON LOYALTY_TRANSACTION (created_at);