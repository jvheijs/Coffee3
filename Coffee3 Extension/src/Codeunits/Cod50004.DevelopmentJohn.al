codeunit 50004 "Development John"
{
    Permissions = TableData "Cust. Ledger Entry" = rimd,
                  TableData "Issued Reminder Header" = rimd,
                  TableData "Issued Reminder Line" = rimd;

    trigger OnRun()
    var
        lRecBestanden: record 50016;
    begin

        Message('Uitgevoerd');
    end;
}

