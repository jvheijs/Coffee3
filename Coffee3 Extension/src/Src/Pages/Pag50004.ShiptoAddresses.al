page 50004 "Ship-to Addresses"
{
    ApplicationArea = All;
    Caption = 'Ship-to Addresses';
    PageType = List;
    SourceTable = "Ship-to Address";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the customer number.';
                }
                field("Code"; Rec."Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies a ship-to address code.';
                }
                field(Address; Rec.Address)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the ship-to address.';
                }
                field("Address 2"; Rec."Address 2")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies additional address information.';
                }
                field(City; Rec.City)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the city the items are being shipped to.';
                }
                field(Contact; Rec.Contact)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the name of the person you contact about orders shipped to this address.';
                }
                field("Country/Region Code"; Rec."Country/Region Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the country/region of the address.';
                }
                field(County; Rec.County)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the state, province, or county as a part of the address.';
                }
                field("E-Mail"; Rec."E-Mail")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the recipient''s email address.';
                }
                field("Fax No."; Rec."Fax No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the recipient''s fax number.';
                }
                field(GLN; Rec.GLN)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the recipient''s GLN code.';
                }
                field("Home Page"; Rec."Home Page")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the recipient''s web site.';
                }
                field("Last Date Modified"; Rec."Last Date Modified")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies when the ship-to address was last modified.';
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the location code to be used for the recipient.';
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the name associated with the ship-to address.';
                }
                field("Name 2"; Rec."Name 2")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Name 2 field.';
                }
                field("Phone No."; Rec."Phone No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the recipient''s telephone number.';
                }
                field("Place of Export"; Rec."Place of Export")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Place of Export field.';
                }
                field("Post Code"; Rec."Post Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the postal code.';
                }
                field(Rayon; Rec.Rayon)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Area field.';
                }
                field(Routenummer; Rec.Routenummer)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Round Number field.';
                }
                field("Service Zone Code"; Rec."Service Zone Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the code for the service zone in which the ship-to address is located.';
                }
                field("Shipment Method Code"; Rec."Shipment Method Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies a code for the shipment method to be used for the recipient.';
                }
                field("Shipping Agent Code"; Rec."Shipping Agent Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the code for the shipping agent who is transporting the items.';
                }
                field("Shipping Agent Service Code"; Rec."Shipping Agent Service Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the code for the service, such as a one-day delivery, that is offered by the shipping agent.';
                }
                field("Tax Area Code"; Rec."Tax Area Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Tax Area Code field.';
                }
                field("Tax Liable"; Rec."Tax Liable")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Tax Liable field.';
                }
                field("Telex Answer Back"; Rec."Telex Answer Back")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Telex Answer Back field.';
                }
                field("Telex No."; Rec."Telex No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Telex No. field.';
                }
            }
        }
    }
}
