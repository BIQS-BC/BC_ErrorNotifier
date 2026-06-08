pageextension 50605 "Job Queue Entry Card Ext BIQS" extends "Job Queue Entry Card"
{
    layout
    {
        addafter(Description)
        {
            field("Monitor For Errors BIQS"; Rec."Monitor For Errors BIQS")
            {
                ApplicationArea = All;
                ToolTip = 'Geeft aan of deze taakwachtrij-post wordt bewaakt door de taakwachtrij-foutmelding wanneer de status Fout is.';
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
