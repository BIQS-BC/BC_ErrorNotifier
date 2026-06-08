pageextension 50602 "G/L Setup Ext BIQS" extends "General Ledger Setup"
{
    layout
    {
        addlast(General)
        {
            field("Support E-Mail BIQS"; Rec."Support E-Mail BIQS")
            {
                ApplicationArea = All;
                ToolTip = 'Geeft het e-mailadres op van de ontvanger die door de taakwachtrij-foutmelding wordt gebruikt om fouten in taakwachtrij-posten te rapporteren.';
            }
            field("Support Mail Acc. Id BIQS"; Rec."Support Mail Acc. Id BIQS")
            {
                ApplicationArea = All;
                Caption = 'Ondersteunings-e-mailaccount';
                ToolTip = 'Geeft het e-mailadres op van het account dat als afzender wordt gebruikt voor de taakwachtrij-foutmelding. Klik op de knop Bewerken om een account te kiezen uit de geconfigureerde e-mailaccounts.';

                trigger OnAssistEdit()
                var
                    TempEmailAccount: Record "Email Account" temporary;
                    EmailAccountMgt: Codeunit "Email Account";
                    EmailAccountsPage: Page "Email Accounts";
                    NoAccountErr: Label 'No e-mail accounts are configured. Please configure one in E-Mail Accounts before selecting an account here.';
                begin
                    EmailAccountMgt.GetAllAccounts(TempEmailAccount);
                    if not TempEmailAccount.FindSet() then
                        Error(NoAccountErr);

                    EmailAccountsPage.LookupMode(true);
                    if EmailAccountsPage.RunModal() <> Action::LookupOK then
                        exit;

                    EmailAccountsPage.GetRecord(TempEmailAccount);

                    Rec."Support Mail Acc. Id BIQS" :=
                        CopyStr(TempEmailAccount."Email Address", 1, MaxStrLen(Rec."Support Mail Acc. Id BIQS"));
                    CurrPage.SaveRecord();
                end;
            }
            field("Max Restart Att. BIQS"; Rec."Max Restart Att. BIQS")
            {
                ApplicationArea = All;
                ToolTip = 'Geeft aan hoeveel opeenvolgende mislukte herstartpogingen worden gedaan voordat een meldingse-mail wordt verzonden. Laat op 0 staan voor de standaardwaarde van 3 (ca. 15 min. bij een interval van 5 min.). De teller wordt na elke e-mail gereset.';
            }
            field("Notif. Cooldown Hrs BIQS"; Rec."Notif. Cooldown Hrs BIQS")
            {
                ApplicationArea = All;
                ToolTip = 'Geeft het minimale aantal minuten op tussen opeenvolgende meldingse-mails voor dezelfde taakwachtrij-post. Laat op 0 staan voor de standaardwaarde van 120 minuten.';
            }
        }
    }
}
