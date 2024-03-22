page 50002 "DP My Customers"
{
    PageType = List;
    SourceTable = "My Customer";
    UsageCategory = Lists;
    ApplicationArea = all;
    InsertAllowed = false;
    Editable = false;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the customer numbers that are displayed in the My Customer Cue on the Role Center.';
                    Width = 4;

                    trigger OnValidate()
                    begin
                        SyncFieldsWithCustomer;
                    end;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = all;
                    Caption = 'Name';
                    DrillDown = false;
                    Lookup = false;
                    ToolTip = 'Specifies the name of the customer.';
                    Width = 20;
                }
                field("Phone No."; Rec."Phone No.")
                {
                    ApplicationArea = all;
                    Caption = 'Phone No.';
                    DrillDown = false;
                    ExtendedDatatype = PhoneNo;
                    Lookup = false;
                    ToolTip = 'Specifies the customer''s phone number.';
                    Width = 8;
                }
                field(Rayon; Rec.Rayon)
                {
                    ApplicationArea = All;
                }
                field(Routenummer; Rec.Routenummer)
                {
                    ApplicationArea = All;
                }
                field(Bezoekadres; Rec.Bezoekadres)
                {
                    ApplicationArea = All;
                }
                field("Postcode bezoekadres"; Rec."Postcode bezoekadres")
                {
                    ApplicationArea = All;
                }
                field("Plaats bezoekadres "; Rec."Plaats bezoekadres")
                {
                    ApplicationArea = All;
                }
                field("Cust.Memo1"; Rec."Cust.Memo1")
                {
                    Caption = 'Klant memo 1';
                    ApplicationArea = All;
                }
                field("Cust.Memo2"; Rec."Cust.Memo2")
                {
                    Caption = 'Klant memo 2';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        // area(Processing)
        // {
        //     action("Verkoop order")
        //     {
        //         Caption = 'Nieuwe verkooporder';
        //         ApplicationArea = All;
        //         Promoted = true;
        //         PromotedCategory = Process;
        //         Image = Sales;
        //         trigger OnAction()
        //         var
        //             Condor: Codeunit Condor;
        //         begin
        //             Condor.CS_MyCustomers_Verkoorder(Rec);
        //         end;
        //     }
        //     action("Service Items")
        //     {
        //         Caption = 'Service Artikelen';
        //         ApplicationArea = All;
        //         Promoted = true;
        //         PromotedCategory = Process;
        //         RunObject = page "Service Item List";
        //         RunPageView = sorting("Customer No.", "Ship-to Code", "Item No.", "Serial No.");
        //         RunPageLink = "Customer No." = field("Customer No.");
        //     }
        // }
        area(Processing)
        {
            action(Verkooporder)
            {
                Caption = 'Nieuwe verkooporder';
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                Image = Sales;
                trigger OnAction()
                var
                    Condor: Codeunit Condor;
                begin
                    Condor.CS_MyCustomers_Verkoorder(Rec);
                end;
            }
            action(ServiceItems)
            {
                Caption = 'Service Artikelen';
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = page "Service Item List";
                RunPageView = sorting("Customer No.", "Ship-to Code", "Item No.", "Serial No.");
                RunPageLink = "Customer No." = field("Customer No.");
            }

            action(SortRoute)
            {
                Caption = 'Sort by Route';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    Rec.SETCURRENTKEY(Rayon, Routenummer);
                    Rec.FINDFIRST;
                end;
            }
            action(SortName)
            {
                Caption = 'Sort by Name';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    Rec.SETCURRENTKEY(Name);
                    Rec.FINDFIRST;
                end;
            }
            action(Open)
            {
                ApplicationArea = all;
                Caption = 'Open';
                Image = ViewDetails;
                RunObject = Page "Customer Card";
                RunPageLink = "No." = FIELD("Customer No.");
                RunPageMode = View;
                RunPageView = SORTING("No.");
                Scope = Repeater;
                ShortCutKey = 'Return';
                ToolTip = 'Open the card for the selected record.';
            }
            action(UpdateUsers)                                       // jvh 16-05-2023
            {
                ApplicationArea = all;
                Caption = 'Bijwerken gebruikers-klanten';
                Image = Process;
                ToolTip = 'Werk alle gebruikers bij.';

                trigger OnAction()
                var
                    Condor: Codeunit Condor;
                begin
                    Condor.gFncFillMyCustomer();
                    message('Uitgevoerd.');
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        SyncFieldsWithCustomer;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Clear(Customer)
    end;

    trigger OnOpenPage()
    begin
        Rec.SetRange("User ID", UserId);
        Rec.SetCurrentKey(Rayon, Routenummer);
        Rec.SETFILTER(Rayon, '0..99999');
        Rec.SETFILTER(Routenummer, '0..99999');
    end;

    var
        Customer: Record Customer;

    local procedure SyncFieldsWithCustomer()
    var
        MyCustomer: Record "My Customer";
    begin
        Clear(Customer);

        if Customer.Get(Rec."Customer No.") then
            if (Rec.Name <> Customer.Name) or (Rec."Phone No." <> Customer."Phone No.") then begin
                Rec.Name := Customer.Name;
                Rec."Phone No." := Customer."Phone No.";
                if MyCustomer.Get(Rec."User ID", Rec."Customer No.") then
                    Rec.Modify;
            end;
    end;
}


