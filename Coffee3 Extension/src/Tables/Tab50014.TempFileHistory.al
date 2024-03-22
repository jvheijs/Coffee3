table 50014 "Temp File History"
{

    fields
    {
        field(1; "Cust. No."; Code[20])
        {
            Caption = 'Cust. No.';
        }
        field(2; "Item No."; Code[20])
        {
            Caption = 'Item No.';
        }
        field(3; "Date stock/ordered"; Date)
        {
            Caption = 'Date stock/ordered';
        }
        field(4; "Quantity Stock"; Decimal)
        {
            Caption = 'Quantity';
        }
        field(5; "Quantity Ordered"; Decimal)
        {
            Caption = 'Quantity ordered';
        }
        field(6; Counted; Boolean)
        {
            Caption = 'Counted';
        }
    }

    keys
    {
        key(Key1; "Cust. No.", "Item No.", "Date stock/ordered")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

