pageextension 50003 "CS Customer Card" extends "Customer Card"
{
    Description = 'CS2.0';

    layout
    {
        addafter("Last Date Modified")
        {
            field("GSM-nummer"; Rec."GSM-nummer")
            {
                ApplicationArea = All;
            }
            field(Klantstatus; Rec.Klantstatus)
            {
                ApplicationArea = All;
            }
            field("Mark 01"; Rec."Mark 01")
            {
                ApplicationArea = All;
            }
            field("Mark 02"; Rec."Mark 02")
            {
                ApplicationArea = All;
            }
            field("Mark 03"; Rec."Mark 03")
            {
                ApplicationArea = All;
            }
            field(Bevyz; Rec.Bevyz)
            {
                ApplicationArea = All;
            }
            field(Rayon; Rec.Rayon)
            {
                ApplicationArea = All;
            }
            field(Routenummer; Rec.Routenummer)
            {
                ApplicationArea = All;
            }
            field(Dropcode; Rec.Dropcode)
            {
                ApplicationArea = All;
            }
            field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
            {
                ApplicationArea = All;
            }
            field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
            {
                ApplicationArea = All;
            }
            field("Cust.Memo1"; Rec."Cust.Memo1")
            {
                ApplicationArea = All;
            }
            field("Cust.Memo2"; Rec."Cust.Memo2")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        addafter(CustomerReportSelections)
        {
            action(Onderhoudsregistratie)
            {
                ApplicationArea = All;
                RunObject = Page 50006;
                RunPageLink = Klantnummer = FIELD("No.");
            }
        }

        addafter(NewFinanceChargeMemo)
        {
            action(MakeNewSalesOrder)
            {
                ApplicationArea = All;
                Image = NewSalesInvoice;
                trigger OnAction()
                begin
                    CondorFunc.CS_CustomerCard_MakeNewSalesOrder(Rec);
                end;
            }
            action(MakeNewSalesInvoice)
            {
                ApplicationArea = All;
                Image = NewSalesInvoice;
                trigger OnAction()
                begin
                    CondorFunc.CS_CustomerCard_MakeNewSalesOrder(Rec);
                end;
            }
        }
    }

    var
        CondorFunc: Codeunit Condor;
}
