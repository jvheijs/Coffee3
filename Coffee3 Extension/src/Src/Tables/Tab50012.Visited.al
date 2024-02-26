table 50012 "Visited"
{
    Caption = 'Visited';
    DrillDownPageID = "DP SalesOrderList";
    LookupPageID = "DP SalesOrderList";

    fields
    {
        field(1; "Cust. No."; Code[20])
        {
            Caption = 'Cust. No.';
            TableRelation = Customer;
        }
        field(2; "Date Visited"; Date)
        {
            Caption = 'Date Visited';
        }
        field(3; "Time Visited"; Time)
        {
            Caption = 'Time Visited';
        }
        field(4; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
    }

    keys
    {
        key(Key1; "Cust. No.", "Date Visited", "Time Visited")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

