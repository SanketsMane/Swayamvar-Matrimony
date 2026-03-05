# System Breaker: Security & Logic Audit Report

As a senior QA automation engineer and "system breaker," I have performed a deep-dive audit of the application. The following critical vulnerabilities and logic failures were identified.

---

### BUG_ID: SB-001
**SEVERITY**: **CRITICAL**
**AREA**: API / Security (Authorization)
**TITLE**: Global IDOR in Interest Acceptance/Rejection
**DESCRIPTION**: The `InterestService` (and its calling `InterestController`) lacks any ownership check when accepting or rejecting interests. Any authenticated user can accept or reject an interest request belonging to any other user by simply providing the `interest_id`.
**STEPS TO REPRODUCE**:
1. Log in as User A.
2. Obtain an `interest_id` belonging to a request sent to User B.
3. Call `/member/interest-accept` or `/member/interest-reject` with that ID.
**EXPECTED RESULT**: The system should return "Not Authorized."
**ACTUAL RESULT**: The interest status is updated, and notifications are sent falsely.
**TECH ROOT CAUSE**: `InterestService::accept()` and `reject()` find records by ID but do not filter by `auth()->id()`.
**SUGGESTED FIX**: Add `->where('user_id', auth()->id())` to the query finding the interest record.

---

### BUG_ID: SB-002
**SEVERITY**: **CRITICAL**
**AREA**: API / Finance / Security
**TITLE**: Financial Fraud: Unverified Stripe Payment Callback
**DESCRIPTION**: The `StripeController::success` method processes payments based solely on URL parameters. It does not verify the transaction status with the Stripe API or use webhooks. An attacker can manually trigger this endpoint to add unlimited balance or upgrade packages.
**STEPS TO REPRODUCE**:
1. Identify the structure of the success URL: `/stripe/success?payment_type=wallet_payment&amount=10000&user_id=[YOUR_ID]`.
2. Visit the URL directly while logged in.
**EXPECTED RESULT**: System should verify transaction with Stripe before granting credits.
**ACTUAL RESULT**: Credits/Balance are added immediately based on URL params.
**TECH ROOT CAUSE**: Blind trust in request parameters in `success()` method.
**SUGGESTED FIX**: Use Stripe SDK to retrieve the session/payment-intent by ID and verify its status before calling `wallet_payment_done`.

---

### BUG_ID: SB-003
**SEVERITY**: **CRITICAL**
**AREA**: API / Finance / Security
**TITLE**: Financial Fraud: Unverified Razorpay Success Callback
**DESCRIPTION**: Identical to the Stripe issue, the `RazorpayController::success` method trusts `payment_details` passed in the request without server-side verification against the Razorpay API.
**STEPS TO REPRODUCE**:
1. Craft a POST request to the Razorpay success endpoint with fabricated `payment_details` and `amount`.
**EXPECTED RESULT**: Server-side signature verification or API check.
**ACTUAL RESULT**: Transaction processed as successful.
**TECH ROOT CAUSE**: Trusting client-side "success" signal.
**SUGGESTED FIX**: Implement Razorpay signature verification.

---

### BUG_ID: SB-004
**SEVERITY**: **CRITICAL**
**AREA**: API / Privacy / Security
**TITLE**: Total Chat Hijacking & Message Leak
**DESCRIPTION**: The `ChatController::chat_view` and `ChatService::store` methods lack participation checks. Any user can read the entire conversation of any two other users, or inject messages into their private chat thread.
**STEPS TO REPRODUCE**:
1. Guess or find a `chat_thread_id`.
2. Call `/member/chat-view/{id}`.
**EXPECTED RESULT**: 403 Forbidden.
**ACTUAL RESULT**: Full message history returned.
**TECH ROOT CAUSE**: Missing `where(sender_user_id, me)->orWhere(receiver_user_id, me)` in the thread lookup.
**SUGGESTED FIX**: Enforce participant check on all Chat API calls.

---

### BUG_ID: SB-005
**SEVERITY**: **CRITICAL**
**AREA**: API / Security
**TITLE**: Unauthorized Gallery Image Deletion
**DESCRIPTION**: The `GalleryImageController::destroy` method deletes records by ID without checking ownership. Any user can delete any image from any other user's gallery.
**STEPS TO REPRODUCE**:
1. Call DELETE `/member/gallery-image/{id}` with an ID belonging to another user.
**EXPECTED RESULT**: 403 Forbidden.
**ACTUAL RESULT**: Image record is deleted from DB.
**TECH ROOT CAUSE**: `GalleryImage::destroy($id)` called without ownership filter.
**SUGGESTED FIX**: Use `GalleryImage::where('id', $id)->where('user_id', auth()->id())->delete()`.

---

### BUG_ID: SB-006
**SEVERITY**: **HIGH**
**AREA**: API / Logic / UI
**TITLE**: Broken Status Tracking in Member Listings (MemberResource)
**DESCRIPTION**: A logic error in `MemberResource.php` causes 'interest_status', 'shortlist_status', etc., to **ALWAYS** return `true/1`, regardless of actual status. This makes the UI display every user as interested/shortlisted.
**STEPS TO REPRODUCE**:
1. Search for members.
2. Observe interest/shortlist icons.
**EXPECTED RESULT**: Icons reflect actual database state.
**ACTUAL RESULT**: All members show up as having a sent/received interest because the `Builder` object is always truthy.
**TECH ROOT CAUSE**: Queries like `$shortlist->first()` are called but results are discarded; the variable remains the `Builder` object.
**SUGGESTED FIX**: Assign `->first()` or `->exists()` to the variable: `$shortlist = $shortlist->exists();`.

---

### BUG_ID: SB-007
**SEVERITY**: **HIGH**
**AREA**: API / Stability
**TITLE**: App Crash on Invalid Manual Payment ID
**DESCRIPTION**: In `WalletController::recharge`, the code attempts to access `->heading` on a potentially null object if a user provides an invalid `manual_payment_id`.
**STEPS TO REPRODUCE**:
1. Submit a recharge request with `payment_method = manual_payment` and a non-existent `manual_payment_id`.
**EXPECTED RESULT**: Validation error.
**ACTUAL RESULT**: 500 Internal Server Error (Trying to get property of non-object).
**TECH ROOT CAUSE**: Unchecked `ManualPaymentMethod::find()`.
**SUGGESTED FIX**: Use `findOrFail` or an explicit null check.

---

### BUG_ID: SB-008
**SEVERITY**: **MEDIUM**
**AREA**: API / Validation
**TITLE**: Missing Input Validation in Support Tickets
**DESCRIPTION**: The `SupportTicketController` (implicit via `apiResource`) may lack strict validation on ticket categories or message lengths, leading to database spam.
**SUGGESTED FIX**: Add request validation for all `store` methods.

---

### BUG_ID: SB-009
**SEVERITY**: **CRITICAL**
**AREA**: API / Security / Auth
**TITLE**: Account Takeover via Null Verification Code
**DESCRIPTION**: The `resetPassword` method compares the provided `verification_code` with the one in the database without checking if the database value is `null`. Since `verification_code` is set to `null` after a successful verification or reset, an attacker can reset any user's password by sending a request with an empty/null code.
**STEPS TO REPRODUCE**:
1. Identify a target user email.
2. Send a POST request to `/reset/password` with the user's email, a new password, and an empty/null `verification_code`.
**EXPECTED RESULT**: The system should reject the request if no reset was initiated.
**ACTUAL RESULT**: Password is reset successfully because `null == null` evaluates to true.
**TECH ROOT CAUSE**: Missing `whereNotNull('verification_code')` or explicit null check on the user's stored code before comparison.
**SUGGESTED FIX**: Add a check: `if ($user->verification_code != null && $user->verification_code == $request->verification_code)`.

---
**Summary**: The application has significant security vulnerabilities, particularly around **IDOR**, **Financial Integrity**, and **Authentication**. These must be addressed immediately before any production release.
