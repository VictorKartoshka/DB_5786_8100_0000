/* ===========================================================================
   METHOD A: Manual SQL — Lookup / Enum Tables
   ===========================================================================
   These small categorical tables are populated by hand because their values
   are predefined business constants, not user-generated data.
=========================================================================== */

-- STATUS_TYPE: Defines all possible states for reservations and waitlist entries.
--   IDs 1-5 are reservation-oriented; IDs 1-8 are waitlist-oriented.
INSERT INTO STATUS_TYPE (status_ID, description) VALUES
(1, 'Pending'),
(2, 'Confirmed'),
(3, 'Cancelled'),
(4, 'Completed'),
(5, 'No-Show'),
(6, 'Waiting'),
(7, 'Seated'),
(8, 'Expired');

-- LOYALTY_TIER: The four levels of the restaurant's loyalty program.
--   Ordered from entry-level (Bronze) to highest reward level (Platinum).
INSERT INTO LOYALTY_TIER (tier_id, level) VALUES
(1, 'Bronze'),
(2, 'Silver'),
(3, 'Gold'),
(4, 'Platinum');

-- REASON: Categorizes why loyalty points were added or deducted.
--   Positive reasons (1-5) add points; Negative reasons (6-8) remove points.
INSERT INTO REASON (reason_id, description) VALUES
(1, 'Dining Purchase'),
(2, 'Referral Bonus'),
(3, 'Birthday Reward'),
(4, 'Sign-Up Bonus'),
(5, 'Review Bonus'),
(6, 'Points Redemption'),
(7, 'Promotional Offer'),
(8, 'Penalty Adjustment');
