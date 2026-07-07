/* 
=============================================================================
                    SESSION INITIALIZATION SCRIPT
=============================================================================
PROJECT : TarunSQL Corp – Executive Analytics Dashboard
FILE    : 00_init_session.sql
PURPOSE:
This script initializes the database session for the project.
All analytics scripts are written in a dbt-style format and
intentionally exclude database definitions (USE statements).
EXECUTION INSTRUCTIONS:
1. Run this script FIRST.
2. Confirm successful database selection.
3. Execute any analytics SQL file without session errors.
 =============================================================================*/

USE tarunsql_dashboard;

-- Session validation message
SELECT 
    'Database selected successfully. You may now execute analytics models.' 
    AS session_status;