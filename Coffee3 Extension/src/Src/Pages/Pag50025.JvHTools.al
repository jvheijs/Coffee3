page 50025 "Toolbox John-Condor"
{
    ApplicationArea = All;
    Caption = 'Toolbox John-Condor';
    PageType = List;
    SourceTable = "record link";
    UsageCategory = Lists;
    Permissions = tabledata 112 = RIMD,
                  tabledata 110 = RIMD;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Entry nummer"; Rec."Link ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Entry nummer field.';
                }
                field("Record ID"; Rec."Record ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Record ID field.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field(URL1; Rec.URL1)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the URL1 field.';
                }
                field("Type"; Rec."Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Type field.';
                }
                field("User ID"; Rec."User ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the User ID field.';
                }
                field("To User ID"; Rec."To User ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the To User ID field.';
                }
                field(Company; Rec.Company)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Company field.';
                }
                field(Created; Rec.Created)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Created field.';
                }
                field(Note; Rec.Note)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Note field.';
                }
                field(Notify; Rec.Notify)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Notify field.';
                }
                field(SystemCreatedAt; Rec.SystemCreatedAt)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the SystemCreatedAt field.';
                }
                field(SystemCreatedBy; Rec.SystemCreatedBy)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the SystemCreatedBy field.';
                }
                field(SystemId; Rec.SystemId)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the SystemId field.';
                }
                field(SystemModifiedAt; Rec.SystemModifiedAt)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the SystemModifiedAt field.';
                }
                field(SystemModifiedBy; Rec.SystemModifiedBy)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the SystemModifiedBy field.';
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("DB instellen als testomgeving")
            {
                trigger OnAction()
                var
                    lRecShiptoAddress: Record "Ship-to Address";
                    lRecCustomer: Record Customer;
                    lRecContact: record Contact;
                begin
                    error('Pas op met gebruiken');
                    lRecCustomer.MODIFYALL("E-Mail", 'Marc.vanOudheusden@coffee3.nl');
                    lRecShiptoAddress.MODIFYALL("E-Mail", 'Marc.vanOudheusden@coffee3.nl');
                    lRecContact.ModifyAll("E-Mail", 'Marc.vanOudheusden@coffee3.nl');
                    lRecContact.ModifyAll("Search E-Mail", 'Marc.vanOudheusden@coffee3.nl');
                    lreccontact.ModifyAll("E-Mail 2", 'Marc.vanOudheusden@coffee3.nl');
                    Message('Alle afleveradressen/klanten omgezet.');
                end;
            }
            action("Eenmalig code John Verzendadressen")
            {
                trigger OnAction()
                var
                    lRecVerzendadressen: record "Ship-to Address";
                    lRecKlant: Record Customer;
                begin
                    lRecVerzendadressen.Reset();
                    if lRecVerzendadressen.findset then begin
                        repeat
                            lRecKlant.get(lRecVerzendadressen."Customer No.");
                            lRecVerzendadressen."E-Mail" := lRecKlant."E-Mail";
                            lRecVerzendadressen.Modify();
                        until lRecVerzendadressen.Next() = 0;
                    end;
                    Message('Uitgevoerd 08-11-2023');
                end;
            }

        }
    }
}
