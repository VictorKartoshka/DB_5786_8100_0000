/* ===================================================================
   LUXE DINE — Phase 2: Constraints (שלב ב)
   ===================================================================
   This file contains ALTER TABLE statements to add 3 new business
   rule constraints.
   =================================================================== */


/* ===================================================================
   C O N S T R A I N T S  (3)
   =================================================================== */

/* -------------------------------------------------------------------
   CONSTRAINT 1: Ensure reservation date is not in the past relative to creation
   -------------------------------------------------------------------
   Business Rule: The scheduled dining time (datetime) must be on or 
   after the time the reservation was actually requested (created_at).
   ------------------------------------------------------------------- */

ALTER TABLE RESERVATION
DROP CONSTRAINT IF EXISTS chk_reservation_future_date;

ALTER TABLE RESERVATION
ADD CONSTRAINT chk_reservation_future_date
CHECK (datetime >= created_at);


/* -------------------------------------------------------------------
   CONSTRAINT 2: Prevent placeholder/junk feedback comments
   -------------------------------------------------------------------
   Business Rule: If a customer leaves a feedback comment, it must be 
   meaningful (at least 4 characters long). "Ok", "No", or random 
   1-letter typos are rejected.
   ------------------------------------------------------------------- */

ALTER TABLE FEEDBACK
DROP CONSTRAINT IF EXISTS chk_meaningful_comment;

ALTER TABLE FEEDBACK
ADD CONSTRAINT chk_meaningful_comment
CHECK (comment IS NULL OR LENGTH(TRIM(comment)) >= 4);


/* -------------------------------------------------------------------
   CONSTRAINT 3: Ensure Customer Names are logical
   -------------------------------------------------------------------
   Business Rule: A customer's first name and last name cannot be 
   exactly identical (e.g., "John John"), which often indicates a 
   data entry error.
   ------------------------------------------------------------------- */

ALTER TABLE CUSTOMER
DROP CONSTRAINT IF EXISTS chk_names_different;

ALTER TABLE CUSTOMER
ADD CONSTRAINT chk_names_different
CHECK (LOWER(first_name) <> LOWER(last_name));



