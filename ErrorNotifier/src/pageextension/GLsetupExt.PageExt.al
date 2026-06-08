pageextension 50602 "G/L Setup Ext BIQS" extends "General Ledger Setup"
{
    layout
    {
        addlast(General)
        {
            field("Support E-Mail BIQS"; Rec."Support E-Mail BIQS")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the recipient e-mail address used by the job queue error notifier to report errors.';
            }
            field("Support Mail Acc. Id BIQS"; Rec."Support Mail Acc. Id BIQS")
            {
                ApplicationArea = All;
                Caption = 'Support E-Mail Account';
                ToolTip = 'Specifies the e-mail account used as sender for job queue error notifications. Click the assist-edit button to select from configured e-mail accounts.';

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
                ToolTip = 'Specifies how many consecutive failed restart attempts trigger a notification e-mail. Leave at 0 for the default of 3 (approx. 15 min. at a 5-min. interval). The counter resets after each e-mail.';
            }
            field("Notif. Cooldown Hrs BIQS"; Rec."Notif. Cooldown Hrs BIQS")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the minimum number of minutes between consecutive notification e-mails for the same job queue entry. Leave at 0 for the default of 120 minutes.';
            }
        }
    }
}
