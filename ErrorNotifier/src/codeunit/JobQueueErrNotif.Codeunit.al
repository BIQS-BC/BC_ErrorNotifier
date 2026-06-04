// Monitors Job Queue Entries in Error, retries restart automatically, and sends
// a notification e-mail after a configurable number of failed attempts. After each
// e-mail the counter resets so restarts are retried before the next notification.
// Thresholds (max attempts, cooldown minutes) can be set per entry or globally in
// GL Setup; leaving them at 0 applies defaults (3 attempts, 120 minutes).
codeunit 50600 "JGV Job Queue Err Notif BIQS"
{
    trigger OnRun()
    begin
        this.NotifyJobQueueErrors();
    end;

    procedure NotifyJobQueueErrors()
    var
        GLSetup: Record "General Ledger Setup";
    begin
        GLSetup.Get();
        GLSetup.TestField("JGV Support E-Mail BIQS");
        GLSetup.TestField("JGV Support Mail Acc. Id BIQS");

        this.ResetCountersForRecoveredEntries();
        this.IncrementCountersForErrorEntries();
        this.SendNotificationsIfNeeded(GLSetup);
        this.RestartErrorEntries();
    end;

    local procedure ResetCountersForRecoveredEntries()
    var
        JobQueueEntry: Record "Job Queue Entry";
    begin
        JobQueueEntry.SetRange("JGV Monitor For Errors BIQS", true);
        JobQueueEntry.SetFilter(Status, '<>%1', JobQueueEntry.Status::Error);
        JobQueueEntry.SetFilter("JGV Restart Attempts BIQS", '>0');
        if not JobQueueEntry.FindSet(true) then
            exit;
        repeat
            JobQueueEntry."JGV Restart Attempts BIQS" := 0;
            JobQueueEntry."JGV Last Notif. Sent BIQS" := 0DT;
            JobQueueEntry.Modify();
        until JobQueueEntry.Next() = 0;
    end;

    local procedure IncrementCountersForErrorEntries()
    var
        JobQueueEntry: Record "Job Queue Entry";
    begin
        JobQueueEntry.SetRange(Status, JobQueueEntry.Status::Error);
        JobQueueEntry.SetRange("JGV Monitor For Errors BIQS", true);
        if not JobQueueEntry.FindSet(true) then
            exit;
        repeat
            JobQueueEntry."JGV Restart Attempts BIQS" += 1;
            JobQueueEntry.Modify();
        until JobQueueEntry.Next() = 0;
    end;

    local procedure SendNotificationsIfNeeded(GLSetup: Record "General Ledger Setup")
    var
        JobQueueEntry: Record "Job Queue Entry";
        EntriesToNotify: List of [Guid];
        EmailMessage: Codeunit "Email Message";
        Body: TextBuilder;
        CooldownThreshold: DateTime;
        SubjectLbl: Label 'Jan Gevers Business Central: Job Queue Errors detected (%1)', Comment = '%1 = number of Job Queue Entries in error';
    begin
        JobQueueEntry.SetRange(Status, JobQueueEntry.Status::Error);
        JobQueueEntry.SetRange("JGV Monitor For Errors BIQS", true);
        if not JobQueueEntry.FindSet(true) then
            exit;

        repeat
            if JobQueueEntry."JGV Restart Attempts BIQS" <= this.GetMaxRestartAttempts(GLSetup, JobQueueEntry) then
                continue;

            CooldownThreshold := CurrentDateTime() - (this.GetNotifCooldownMins(GLSetup, JobQueueEntry) * 60000);

            if JobQueueEntry."JGV Last Notif. Sent BIQS" = 0DT then begin
                EntriesToNotify.Add(JobQueueEntry.ID);
                JobQueueEntry."JGV Last Notif. Sent BIQS" := CurrentDateTime();
                JobQueueEntry.Modify();
            end else if JobQueueEntry."JGV Last Notif. Sent BIQS" <= CooldownThreshold then begin
                EntriesToNotify.Add(JobQueueEntry.ID);
                JobQueueEntry."JGV Restart Attempts BIQS" := 0;
                JobQueueEntry."JGV Last Notif. Sent BIQS" := CurrentDateTime();
                JobQueueEntry.Modify();
            end;
        until JobQueueEntry.Next() = 0;

        if EntriesToNotify.Count() = 0 then
            exit;

        this.BuildBody(Body, EntriesToNotify);

        EmailMessage.Create(
            GLSetup."JGV Support E-Mail BIQS",
            StrSubstNo(SubjectLbl, EntriesToNotify.Count()),
            Body.ToText(),
            true);

        this.SendEmailMessage(EmailMessage, GLSetup);
    end;

    local procedure RestartErrorEntries()
    var
        JobQueueEntry: Record "Job Queue Entry";
    begin
        JobQueueEntry.SetRange(Status, JobQueueEntry.Status::Error);
        JobQueueEntry.SetRange("JGV Monitor For Errors BIQS", true);
        if not JobQueueEntry.FindSet() then
            exit;
        repeat
            TrySetEntryReady(JobQueueEntry);
        until JobQueueEntry.Next() = 0;
    end;

    [TryFunction]
    local procedure TrySetEntryReady(var JobQueueEntry: Record "Job Queue Entry")
    begin
        JobQueueEntry.Status := JobQueueEntry.Status::Ready;
        JobQueueEntry.Modify();
    end;

    local procedure BuildBody(var Body: TextBuilder; EntriesToNotify: List of [Guid])
    var
        JobQueueEntry: Record "Job Queue Entry";
        EntryId: Guid;
        IntroLbl: Label 'The following Job Queue Entries are currently in status <b>Error</b> and could not be restarted automatically:';
        OutroLbl: Label 'Please review them in Business Central and resolve the underlying issue.';
        DescriptionHdrLbl: Label 'Description';
        ObjectHdrLbl: Label 'Object';
        AttemptsHdrLbl: Label 'Restart Attempts';
        ErrorHdrLbl: Label 'Error';
        RowTpl: Label '<tr><td style="border:1px solid #ccc;padding:6px 10px;vertical-align:top;">%1</td><td style="border:1px solid #ccc;padding:6px 10px;vertical-align:top;white-space:nowrap;">%2 %3</td><td style="border:1px solid #ccc;padding:6px 10px;vertical-align:top;text-align:center;">%4</td><td style="border:1px solid #ccc;padding:6px 10px;vertical-align:top;color:#a00;">%5</td></tr>', Comment = '%1 = description, %2 = object type, %3 = object id, %4 = restart attempts, %5 = error message', Locked = true;
    begin
        Body.Append('<p style="font-family:Segoe UI,Arial,sans-serif;font-size:13px;">');
        Body.Append(IntroLbl);
        Body.Append('</p>');

        Body.Append('<table style="border-collapse:collapse;font-family:Segoe UI,Arial,sans-serif;font-size:12px;">');
        Body.Append('<thead><tr style="background:#f2f2f2;">');
        Body.Append(StrSubstNo('<th style="border:1px solid #ccc;padding:6px 10px;text-align:left;">%1</th>', DescriptionHdrLbl));
        Body.Append(StrSubstNo('<th style="border:1px solid #ccc;padding:6px 10px;text-align:left;">%1</th>', ObjectHdrLbl));
        Body.Append(StrSubstNo('<th style="border:1px solid #ccc;padding:6px 10px;text-align:left;">%1</th>', AttemptsHdrLbl));
        Body.Append(StrSubstNo('<th style="border:1px solid #ccc;padding:6px 10px;text-align:left;">%1</th>', ErrorHdrLbl));
        Body.Append('</tr></thead><tbody>');

        foreach EntryId in EntriesToNotify do
            if JobQueueEntry.Get(EntryId) then
                Body.Append(
                    StrSubstNo(
                        RowTpl,
                        this.HtmlEncode(JobQueueEntry.Description),
                        this.HtmlEncode(Format(JobQueueEntry."Object Type to Run")),
                        Format(JobQueueEntry."Object ID to Run"),
                        Format(JobQueueEntry."JGV Restart Attempts BIQS"),
                        this.HtmlEncode(JobQueueEntry."Error Message")));

        Body.Append('</tbody></table>');

        Body.Append('<p style="font-family:Segoe UI,Arial,sans-serif;font-size:13px;">');
        Body.Append(OutroLbl);
        Body.Append('</p>');
    end;

    local procedure SendEmailMessage(var EmailMessage: Codeunit "Email Message"; GLSetup: Record "General Ledger Setup")
    var
        TempEmailAccount: Record "Email Account" temporary;
        Email: Codeunit Email;
        EmailAccountMgt: Codeunit "Email Account";
        AccountNotFoundErr: Label 'No e-mail account with address %1 was found. Re-select the Support E-Mail Account in General Ledger Setup.', Comment = '%1 = the configured sender e-mail address';
    begin
        EmailAccountMgt.GetAllAccounts(TempEmailAccount);
        TempEmailAccount.SetRange("Email Address", GLSetup."JGV Support Mail Acc. Id BIQS");
        if not TempEmailAccount.FindFirst() then
            Error(AccountNotFoundErr, GLSetup."JGV Support Mail Acc. Id BIQS");

        Email.Send(EmailMessage, TempEmailAccount."Account Id", TempEmailAccount.Connector);
    end;

    local procedure GetMaxRestartAttempts(GLSetup: Record "General Ledger Setup"; JobQueueEntry: Record "Job Queue Entry"): Integer
    begin
        if JobQueueEntry."JGV Max Restart Att. BIQS" > 0 then
            exit(JobQueueEntry."JGV Max Restart Att. BIQS");
        if GLSetup."JGV Max Restart Att. BIQS" > 0 then
            exit(GLSetup."JGV Max Restart Att. BIQS");
        exit(3);
    end;

    local procedure GetNotifCooldownMins(GLSetup: Record "General Ledger Setup"; JobQueueEntry: Record "Job Queue Entry"): Integer
    begin
        if JobQueueEntry."JGV Notif. Cooldown BIQS" > 0 then
            exit(JobQueueEntry."JGV Notif. Cooldown BIQS");
        if GLSetup."JGV Notif. Cooldown Hrs BIQS" > 0 then
            exit(GLSetup."JGV Notif. Cooldown Hrs BIQS");
        exit(120);
    end;

    local procedure HtmlEncode(Value: Text): Text
    begin
        Value := Value.Replace('&', '&amp;');
        Value := Value.Replace('<', '&lt;');
        Value := Value.Replace('>', '&gt;');
        exit(Value);
    end;
}
