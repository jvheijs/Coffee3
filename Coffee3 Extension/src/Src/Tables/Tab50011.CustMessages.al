table 50011 "Cust. Messages"
{
    // (28-09-05 RB) Extra veld erbij 'To Send' om aan te geven of deze message nog verzonden moet worden
    // (28-09-05 RB) Extra sleutel erbij op 'Customer No.' en 'To Send'

    Caption = 'Cust. Messages';

    fields
    {
        field(1; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            TableRelation = Customer;
        }
        field(2; "Message Date"; Date)
        {
            Caption = 'Message Date';
        }
        field(3; "Confirm Date"; Date)
        {
            Caption = 'Confirm Date';
        }
        field(4; "Cust. Message 1"; Text[20])
        {
            Caption = 'Cust. Message 1';
        }
        field(5; "Cust. Message 2"; Text[20])
        {
            Caption = 'Cust. Message 2';
        }
        field(6; "To Send"; Boolean)
        {
            Caption = 'To Send';
            InitValue = true;
        }
    }

    keys
    {
        key(Key1; "Customer No.", "Message Date")
        {
            Clustered = true;
        }
        key(Key2; "Customer No.", "Confirm Date")
        {
        }
        key(Key3; "Customer No.", "To Send")
        {
        }
    }

    fieldgroups
    {
    }
}

