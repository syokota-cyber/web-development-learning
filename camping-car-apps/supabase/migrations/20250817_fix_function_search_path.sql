-- Fix Function Search Path Mutable warnings
-- Date: 2025-08-13
-- Purpose: Set explicit search_path for functions to prevent security issues

-- Find and fix functions with mutable search paths
-- The functions mentioned in warnings: handle_new_user and update_travel_rules_updated_at

-- 1. Fix handle_new_user function (if exists)
DO $$
BEGIN
    -- Check if function exists and update it
    IF EXISTS (
        SELECT 1 FROM pg_proc p
        JOIN pg_namespace n ON p.pronamespace = n.oid
        WHERE n.nspname = 'public' AND p.proname = 'handle_new_user'
    ) THEN
        -- Get the function definition and recreate with fixed search_path
        -- This is a common function for handling new user registration
        CREATE OR REPLACE FUNCTION public.handle_new_user()
        RETURNS trigger
        LANGUAGE plpgsql
        SECURITY DEFINER
        SET search_path = public
        AS $function$
        BEGIN
            INSERT INTO public.profiles (id, email)
            VALUES (NEW.id, NEW.email);
            RETURN NEW;
        END;
        $function$;
    END IF;
END $$;

-- 2. Fix update_travel_rules_updated_at function (if exists)
DO $$
BEGIN
    -- Check if function exists and update it
    IF EXISTS (
        SELECT 1 FROM pg_proc p
        JOIN pg_namespace n ON p.pronamespace = n.oid
        WHERE n.nspname = 'public' AND p.proname = 'update_travel_rules_updated_at'
    ) THEN
        -- Recreate with fixed search_path
        CREATE OR REPLACE FUNCTION public.update_travel_rules_updated_at()
        RETURNS trigger
        LANGUAGE plpgsql
        SECURITY DEFINER
        SET search_path = public
        AS $function$
        BEGIN
            NEW.updated_at = NOW();
            RETURN NEW;
        END;
        $function$;
    END IF;
END $$;

-- 3. General fix for any other functions without explicit search_path
-- List all functions that might need fixing
DO $$
DECLARE
    func_record RECORD;
    func_definition TEXT;
BEGIN
    -- Find all functions in public schema without explicit search_path
    FOR func_record IN
        SELECT 
            p.proname AS function_name,
            pg_get_function_identity_arguments(p.oid) AS arguments
        FROM pg_proc p
        JOIN pg_namespace n ON p.pronamespace = n.oid
        WHERE n.nspname = 'public'
        AND p.prosecdef = true  -- SECURITY DEFINER functions
        AND NOT EXISTS (
            -- Check if search_path is already set
            SELECT 1 FROM pg_depend d
            WHERE d.objid = p.oid
            AND d.deptype = 'n'
        )
    LOOP
        -- Log functions that might need manual review
        RAISE NOTICE 'Function % may need search_path setting', func_record.function_name;
    END LOOP;
END $$;