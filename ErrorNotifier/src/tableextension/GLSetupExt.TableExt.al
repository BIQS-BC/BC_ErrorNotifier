tableextension 50603 "GL Setup Ext BIQS" extends "General Ledger Setup"
{
    fields
    {
        field(50606; "Support E-Mail BIQS"; Text[80])
        {
            Caption = 'Ondersteunings-e-mail';
            ExtendedDatatype = EMail;
            DataClassification = CustomerContent;
        }
        field(50607; "Support Mail Acc. Id BIQS"; Text[250])
        {
            Caption = 'Ondersteunings-e-mailaccount';
            ExtendedDatatype = EMail;
            DataClassification = CustomerContent;
        }
        field(50608; "Max Restart Att. BIQS"; Integer)
        {
            Caption = 'Max. herstartpogingen';
            DataClassification = CustomerContent;
            MinValue = 0;
        }
        field(50609; "Notif. Cooldown Hrs BIQS"; Integer)
        {
            Caption = 'Wachttijd melding (minuten)';
            DataClassification = CustomerContent;
            MinValue = 0;
        }
    }
}
