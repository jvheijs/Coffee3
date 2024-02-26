table 50017 "Copy Record Link"
{
    Caption = 'Record Link';
    DataPerCompany = false;
    ReplicateData = false;
    Scope = Cloud;

    fields
    {
        field(1; "Link ID"; Integer)
        {
            AutoIncrement = true;
            Caption = 'Link ID';
        }
        field(2; "Record ID"; RecordID)
        {
            Caption = 'Record ID';
        }
        field(3; URL1; Text[2048])
        {
            Caption = 'URL1';
        }
        field(4; URL2; Text[250])
        {
            Caption = 'URL2';
            ObsoleteReason = 'URL1 field size increased';
            ObsoleteState = Removed;
        }
        field(5; URL3; Text[250])
        {
            Caption = 'URL3';
            ObsoleteReason = 'URL1 field size increased';
            ObsoleteState = Removed;
        }
        field(6; URL4; Text[250])
        {
            Caption = 'URL4';
            ObsoleteReason = 'URL1 field size increased';
            ObsoleteState = Removed;
        }
        field(7; Description; Text[250])
        {
            Caption = 'Description';
        }
        field(8; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = 'Link,Note';
            OptionMembers = Link,Note;
        }
        field(9; Note; BLOB)
        {
            Caption = 'Note';
            SubType = Memo;
        }
        field(10; Created; DateTime)
        {
            Caption = 'Created';
        }
        field(11; "User ID"; Text[132])
        {
            Caption = 'User ID';
        }
        field(12; Company; Text[30])
        {
            Caption = 'Company';
            TableRelation = Company.Name;
        }
        field(13; Notify; Boolean)
        {
            Caption = 'Notify';
        }
        field(14; "To User ID"; Text[132])
        {
            Caption = 'To User ID';
        }
        field(50000; "RecRefPos"; Text[250])
        {
            Caption = 'RecRefPos';
        }
        field(50001; "TableID"; Integer)
        {
            Caption = 'TableID';
        }
        field(50002; "Imported into Blob"; Boolean)
        {
            Caption = 'Imported into Blob';
        }
        field(50003; "Attached File"; Blob)
        {
            Caption = 'Attached File';
        }
        field(50004; "Attached"; Boolean)
        {
            Caption = 'Attached';
        }
    }

    keys
    {
        key(Key1; "Link ID")
        {
            Clustered = true;
        }
        key(Key2; "Record ID")
        {
        }
        key(Key3; Company, "Record ID")
        {
        }
    }

    fieldgroups
    {
    }
}

