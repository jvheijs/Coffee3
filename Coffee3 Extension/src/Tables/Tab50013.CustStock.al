table 50013 "Cust. Stock"
{
    Caption = 'Cust. Stock';
    DrillDownPageID = "DP Sales Line FactBox";
    LookupPageID = "DP Sales Line FactBox";

    fields
    {
        field(1; "Cust. No."; Code[20])
        {
            Caption = 'Cust. No.';
            TableRelation = Customer;
        }
        field(2; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            TableRelation = Item;
        }
        field(3; "Check Date"; Date)
        {
            Caption = 'Check Date';
        }
        field(4; "Quantity in stock"; Decimal)
        {
            Caption = 'Quantity in stock';
        }
    }

    keys
    {
        key(Key1; "Cust. No.", "Item No.", "Check Date")
        {
            Clustered = true;
        }
        key(Key2; "Item No.", "Cust. No.", "Check Date")
        {
        }
        key(Key3; "Check Date")
        {
        }
    }

    fieldgroups
    {
    }
}

