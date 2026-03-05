# Swayamvar Matrimony: Technical Audit & System Breaking Report

**Auditor:** Sanket (Senior QA Automation Engineer & System Breaker)  
**Status:** CRITICAL AUDIT COMPLETE  
**Focus:** Finding architecture flaws, security gaps, and production-stoppers.

---

## 🚨 Executive Summary
The system contains multiple **Critical and High severity** issues. Primary risks include **IDOR (Bypass of Admin Controls)**, **Partial Data Corruption** during profile updates, and **Silent Failures** causing a broken UX. The separation between the Flutter app's expectations and the Backend API's constraints is a major source of production fragility.

---

## 🐞 Bug Log

### 1. IDOR & Access Control (Security)
**BUG_ID:** B-011  
**SEVERITY:** **High**  
**AREA:** Security / Auth Flow  
**TITLE:** Login Bypass for Unapproved Accounts  
**DESCRIPTION:** The `signin` API ignores the `approved` status. Even if an admin hasn't approved the user (or has revoked approval), the user can still log in and generate valid tokens.  
**TECH ROOT CAUSE:** Missing `approved == 0` check in `AuthController.signin`.  
**SUGGESTED FIX:** Add `if ($user->approved == 0) return failure('Pending Approval');` before returning the auth response.

**BUG_ID:** B-005  
**SEVERITY:** **Critical**  
**AREA:** Security / Logic  
**TITLE:** Forced Deactivation Bypass (Account Hijack Risk)  
**DESCRIPTION:** The `update_account_deactivation_status` endpoint allows a user (or anyone with their token) to toggle deactivation without any password confirmation. If an admin deactivates an account for disciplinary reasons, the user can immediately "reactivate" themselves.  
**SUGGESTED FIX:** Enforce password re-verification for state-changing operations and check if the account was deactivated by a SYSTEM/ADMIN vs the USER.

---

### 2. Data Integrity & Race Conditions (Functional)
**BUG_ID:** B-001  
**SEVERITY:** **High**  
**AREA:** Data Integrity  
**TITLE:** Partial Profile Update Success (Atomic Failure)  
**DESCRIPTION:** `manage_profile.dart` fires 6 parallel API calls. If 5 succeed and 1 fails (e.g., poor network), the user gets a "Failed" message, but half their data is saved. This creates "Zombie Profiles" where only some attributes are current.  
**TECH ROOT CAUSE:** Front-end uses `Future.wait` without a rollback mechanism or transactional API.  
**SUGGESTED FIX:** Implement a single `upsert_profile` endpoint on the backend that handles all sections in one DB transaction.

**BUG_ID:** B-002  
**SEVERITY:** **Medium**  
**AREA:** Database / Logic  
**TITLE:** Education/Career Record Duplication  
**DESCRIPTION:** Every time a user edits their profile, the app calls `educationCreate` instead of `educationUpdate`. This causes the `education` table to grow infinitely with duplicate records for the same user.  
**SUGGESTED FIX:** Change frontend logic to check if an ID exists and use `update(id)` instead of `create()`.

---

### 3. API & Performance (Technical Debt)
**BUG_ID:** B-003  
**SEVERITY:** **Medium**  
**AREA:** Performance  
**TITLE:** N+1 Query Problem in Member Listing  
**DESCRIPTION:** The member listing endpoint does not eager-load relationships. Fetching 20 members triggers ~100+ database queries. This will crash the server once the user base exceeds 1,000 active members.  
**SUGGESTED FIX:** Add `->with(['member', 'spiritual_background', 'physical_attributes', 'address'])` to the listing query.

**BUG_ID:** B-007  
**SEVERITY:** **Low**  
**AREA:** API Stability  
**TITLE:** Inconsistent Error Response Format (JSON Crash Risk)  
**DESCRIPTION:** `basic_info_update` returns a raw string message on error instead of an object.  
**ACTUAL:** `"Email and Phone number both can not be null. "`  
**EXPECTED:** `{"result": false, "message": "..."}`.  
**RESULT:** Flutter JSON parser throws an exception, leading to a silent UI hang.

---

### 4. Validation & Edge Cases
**BUG_ID:** B-010  
**SEVERITY:** **Medium**  
**AREA:** Backend Validation  
**TITLE:** Validation Mismatch (Flutter "N/A" vs Laravel "Numeric")  
**DESCRIPTION:** The Flutter app sends `"N/A"` for missing dates/numbers. The Laravel backend expects `numeric`. Every request with missing dates results in a 422 Unprocessable Entity error that is not handled gracefully.  
**SUGGESTED FIX:** Backend validation should allow `nullable` or `0`, and Frontend should never send placeholder strings to numeric fields.

**BUG_ID:** B-006  
**SEVERITY:** **Medium**  
**AREA:** Data Corruption  
**TITLE:** Silent Nullification of Birthday  
**DESCRIPTION:** `basic_info_update` uses `strtotime` on input without validation. If the date format is slightly off, the birthday reverts to `1970-01-01`.  
**SUGGESTED FIX:** Use `Carbon::parse()` or strict Regex validation on the backend date input.

---

## 🛠️ Performance Risks (High Traffic)
1. **Search Enumerable Code:** Users can iterate through codes (M001, M002) to scrape the entire database (B-004).
2. **Missing Pagination:** Some lists (`ignored_user_list`, etc.) lack robust pagination, eventually leading to huge payload sizes.

---

## 🔒 Security Summary
The system is vulnerable to **IDOR** (Insecure Direct Object Reference) and **State Injection**. The lack of `approved` check during login is the most critical find.

**Recommendation:** Halt deployment of the new Profile form until the **B-001 (Atomic Update)** and **B-011 (Login Check)** are resolved.
