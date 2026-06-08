tableextension 50601 "Job Queue Entry Ext BIQS" extends "Job Queue Entry"
{
    fields
    {
        field(50610; "Monitor For Errors BIQS"; Boolean)
        {
            Caption = 'Monitor for Errors';
            ToolTip = 'Specifies whether this job queue entry is monitored for errors. When enabled, the entry is automatically restarted on failure and a notification is sent if it fails repeatedly.';
            DataClassification = CustomerContent;
        }
        field(50611; "Restart Attempts BIQS"; Integer)
        {
            Caption = 'Restart Attempts';
            ToolTip = 'Shows the number of consecutive times this entry has been restarted after an error. Reset when the entry runs successfully or after the notification cooldown period expires.';
            DataClassification = CustomerContent;
        }
        field(50612; "Last Notif. Sent BIQS"; DateTime)
        {
            Caption = 'Last Notification Sent';
            ToolTip = 'Specifies the date and time the last error notification was sent for this job queue entry.';
            DataClassification = CustomerContent;
        }
        field(50613; "Max Restart Att. BIQS"; Integer)
        {
            Caption = 'Max. Attempts Before Notification';
            ToolTip = 'Number of consecutive restart attempts before an error notification is sent. Does not affect BC''s own restart behaviour. Leave at 0 to use the value from General Ledger Setup.';
            DataClassification = CustomerContent;
            MinValue = 0;
        }
        field(50614; "Notif. Cooldown BIQS"; Integer)
        {
            Caption = 'Notification Cooldown (minutes)';
            ToolTip = 'Specifies the minimum number of minutes between consecutive notifications for this entry. Leave at 0 to use the value from General Ledger Setup.';
            DataClassification = CustomerContent;
            MinValue = 0;
        }
    }
}
