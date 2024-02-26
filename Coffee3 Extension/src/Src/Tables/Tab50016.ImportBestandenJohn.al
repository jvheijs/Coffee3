table 50016 "Import Bestanden"
{
    Caption = 'Import Bestanden';
    DataClassification = ToBeClassified;

    fields
    {
        field(10; "Entry nummer"; Integer)
        {
            Caption = 'Entry nummer';
            DataClassification = ToBeClassified;
        }
        field(20; Omschrijving; Text[250])
        {
            Caption = 'Omschrijving';
            DataClassification = ToBeClassified;
        }
        field(30; Bestandsnaam; Blob)
        {
            Caption = 'Bestandsnaam';
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; "Entry nummer")
        {
            Clustered = true;
        }
    }
}
