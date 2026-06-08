tableextension 50603 "GL Setup Ext BIQS" extends "General Ledger Setup"
{
    fields
    {
        field(50606; "Support E-Mail BIQS"; Text[80])
        {
            Caption = 'Support E-Mail';
            ExtendedDatatype = EMail;
            DataClassification = CustomerContent;
        }
        field(50607; "Support Mail Acc. Id BIQS"; Text[250])
        {
            Caption = 'Support E-Mail Account';
            ExtendedDatatype = EMail;
            DataClassification = CustomerContent;
        }
        field(50608; "Max Restart Att. BIQS"; Integer)
        {
            Caption = 'Max. Attempts Before Notification';
            DataClassification = CustomerContent;
            MinValue = 0;
        }
        field(50609; "Notif. Cooldown Hrs BIQS"; Integer)
        {
            Caption = 'Notification Cooldown (minutes)';
            DataClassification = CustomerContent;
            MinValue = 0;
        }
    }
}
