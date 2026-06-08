pageextension 50605 "Job Queue Entry Card Ext BIQS" extends "Job Queue Entry Card"
{
    layout
    {
        addafter(Description)
        {
            field("Monitor For Errors BIQS"; Rec."Monitor For Errors BIQS")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies whether this job queue entry is monitored by the error notifier when its status is Error.';
            }
            field("Max Restart Att. BIQS"; Rec."Max Restart Att. BIQS")
            {
                ApplicationArea = All;
            }
            field("Notif. Cooldown BIQS"; Rec."Notif. Cooldown BIQS")
            {
                ApplicationArea = All;
            }
        }
    }
}
