-- Fix Auth-related security warnings
-- Date: 2025-08-13
-- Purpose: Fix OTP expiry and password protection settings

-- Note: These settings need to be configured in Supabase Dashboard
-- This SQL file documents the required changes

-- 1. OTP Expiry Setting (Warning: Auth OTP Long Expiry)
-- Recommended: Set OTP expiry to 3600 seconds (1 hour) or less
-- Current: Likely set to longer than recommended
-- Action: Update in Dashboard > Authentication > Providers > Email > OTP Expiry

-- 2. Leaked Password Protection (Warning: Leaked Password Protection Disabled)
-- Recommended: Enable leaked password protection
-- Current: Disabled
-- Action: Update in Dashboard > Authentication > Auth Settings > Enable Password Leak Protection

-- SQL commands for documentation purposes (these may need to be run via Dashboard):
-- UPDATE auth.config SET value = '3600' WHERE key = 'MFA_OTP_EXPIRY';
-- UPDATE auth.config SET value = 'true' WHERE key = 'PASSWORD_LEAK_PROTECTION_ENABLED';

-- Note: These configurations are typically managed through the Supabase Dashboard
-- rather than SQL migrations. Please update them manually in the Dashboard.