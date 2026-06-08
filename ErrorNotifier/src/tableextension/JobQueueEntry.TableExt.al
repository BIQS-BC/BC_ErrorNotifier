tableextension 50601 "Job Queue Entry Ext BIQS" extends "Job Queue Entry"
{
    fields
    {
        field(50610; "Monitor For Errors BIQS"; Boolean)
        {
            Caption = 'Bewaken op fouten';
            ToolTip = 'Geeft aan of deze taakwachtrij-post wordt bewaakt op fouten. Indien ingeschakeld, wordt de post automatisch herstart bij een fout en ontvangt u een melding als dit herhaaldelijk mislukt.';
            DataClassification = CustomerContent;
        }
        field(50611; "Restart Attempts BIQS"; Integer)
        {
            Caption = 'Herstartpogingen';
            ToolTip = 'Geeft het aantal opeenvolgende keren aan dat deze post opnieuw is opgestart na een fout. Wordt gereset wanneer de post succesvol wordt uitgevoerd of wanneer de wachttijd na een melding is verstreken.';
            DataClassification = CustomerContent;
        }
        field(50612; "Last Notif. Sent BIQS"; DateTime)
        {
            Caption = 'Laatste melding verzonden';
            ToolTip = 'Geeft de datum en tijd op waarop de laatste foutmelding voor deze taakwachtrij-post is verzonden.';
            DataClassification = CustomerContent;
        }
        field(50613; "Max Restart Att. BIQS"; Integer)
        {
            Caption = 'Max. herstartpogingen';
            ToolTip = 'Geeft het maximale aantal herstartpogingen op voor deze post. Laat op 0 staan om de waarde uit de grootboekinstelling te gebruiken.';
            DataClassification = CustomerContent;
            MinValue = 0;
        }
        field(50614; "Notif. Cooldown BIQS"; Integer)
        {
            Caption = 'Wachttijd melding (minuten)';
            ToolTip = 'Geeft de minimale wachttijd in minuten op tussen opeenvolgende meldingen voor deze post. Laat op 0 staan om de waarde uit de grootboekinstelling te gebruiken.';
            DataClassification = CustomerContent;
            MinValue = 0;
        }
    }
}
