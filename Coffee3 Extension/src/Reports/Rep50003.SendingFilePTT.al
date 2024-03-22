report 50003 "Sending File PTT"
{
    ApplicationArea = All;
    Caption = 'Zending bestand PTT';
    UsageCategory = Tasks;
    ProcessingOnly = true;
    UseRequestPage = false;

    trigger OnPostReport()
    var
        myInt: Integer;
    begin
        Xmlport.Run(Xmlport::"Sending File PTT");
    end;
}
