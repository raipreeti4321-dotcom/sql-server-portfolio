# Database Mail Troubleshooting

## Overview

A critical SQL Server alerting process stopped sending emails to support teams. Although SQL Agent jobs were executing successfully, no email notifications were being received by users.

The issue impacted monitoring and delayed response to production incidents.

## Business Problem

Several automated processes relied on Database Mail for:

* ETL Failure Notifications
* SQL Agent Job Alerts
* Backup Failure Alerts
* Daily Operational Reports

Users reported that no emails were being received despite jobs completing successfully.

## Investigation

### Step 1: Verify Database Mail Status

Checked whether Database Mail was enabled:

```sql
EXEC sp_configure 'Database Mail XPs';
```

### Step 2: Review Mail Queue

Checked email delivery status:

```sql
SELECT
    mailitem_id,
    recipients,
    subject,
    sent_status,
    send_request_date
FROM msdb.dbo.sysmail_allitems
ORDER BY send_request_date DESC;
```

### Step 3: Review Error Logs

Investigated Database Mail errors:

```sql
SELECT
    log_date,
    description
FROM msdb.dbo.sysmail_event_log
ORDER BY log_date DESC;
```

### Step 4: Validate Mail Profile

Verified:

* Mail Profile Configuration
* SMTP Server Settings
* Authentication Credentials
* SQL Agent Mail Profile

### Step 5: Test Email Delivery

Executed a test email:

```sql
EXEC msdb.dbo.sp_send_dbmail
     @profile_name = 'DBA_Profile',
     @recipients = 'support@company.com',
     @subject = 'Database Mail Test',
     @body = 'Database Mail Validation';
```

## Root Cause

Investigation revealed:

* Incorrect SMTP configuration
* Authentication failure between SQL Server and mail server
* SQL Agent was referencing an outdated mail profile

These issues prevented successful email delivery.

## Resolution

Implemented the following fixes:

1. Updated SMTP configuration.
2. Corrected authentication credentials.
3. Updated SQL Agent mail profile.
4. Restarted Database Mail services.
5. Validated outbound connectivity.

Performed multiple test executions to confirm successful email delivery.

## Results

* Email alerts restored successfully.
* Monitoring processes resumed normal operation.
* Incident response visibility improved.
* Business users received automated reports on schedule.

## Lessons Learned

* Validate Database Mail after server migrations.
* Monitor sysmail_event_log regularly.
* Configure alerting for mail delivery failures.
* Periodically test Database Mail functionality.

## Skills Demonstrated

* SQL Server Administration
* Database Mail Configuration
* Production Support
* Monitoring & Alerting
* Root Cause Analysis
* Troubleshooting
