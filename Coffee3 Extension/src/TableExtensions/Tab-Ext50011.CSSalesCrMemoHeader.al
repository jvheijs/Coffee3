tableextension 50011 "CS Sales Cr.Memo Header" extends "Sales Cr.Memo Header"
{
    fields
    {
        field(50005; Rayon; Integer)
        {
            Description = '2000-901-21';
            Caption = 'Area';
            DataClassification = ToBeClassified;
        }
        field(50006; Routenummer; Integer)
        {
            Description = '2000-901-21';
            Caption = 'Round Number';
            DataClassification = ToBeClassified;
        }
        field(50008; "Aantal colli"; Decimal)
        {
            Description = '2000-901-55';
            Caption = 'Quantity Packages';
            DataClassification = ToBeClassified;
        }
    }
}
