pageextension 50605 "JGV Job Queue Entry Card BIQS" extends "Job Queue Entry Card"
{
    layout
    {
        addafter(Description)
        {
            field("JGV Monitor For Errors BIQS"; Rec."JGV Monitor For Errors BIQS")
            {
                ApplicationArea = All;
                ToolTip = 'Geeft aan of deze taakwachtrij-post wordt bewaakt door de taakwachtrij-foutmelding wanneer de status Fout is.';
            }
            field("JGV Max Restart Att. BIQS"; Rec."JGV Max Restart Att. BIQS")
            {
                ApplicationArea = All;
            }
            field("JGV Notif. Cooldown BIQS"; Rec."JGV Notif. Cooldown BIQS")
            {
                ApplicationArea = All;
            }
        }
    }
}
