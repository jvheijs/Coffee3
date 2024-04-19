tableextension 50019 "CS My Customer" extends "My Customer"
{
    fields
    {
        field(50000; Bezoekadres; Text[60])
        {
            Description = '2000-901-02 verlengd import 051000';
            Caption = 'Visit Address';
            DataClassification = ToBeClassified;
        }
        field(50001; "Postcode bezoekadres"; Code[10])
        {
            Description = '2000-901-02';
            Caption = 'Post Code Visit Address';
            DataClassification = ToBeClassified;
        }
        field(50002; "Plaats bezoekadres"; Text[30])
        {
            Description = '2000-901-02';
            Caption = 'City Visit Address';
            DataClassification = ToBeClassified;
        }
        field(50003; "GSM-nummer"; Text[30])
        {
            Description = '2000-901-18';
            Caption = 'GSM-number';
            DataClassification = ToBeClassified;
        }
        field(50004; Klantstatus; Code[10])
        {
            Description = '2000-901-20';
            Caption = 'Customer Status';
            DataClassification = ToBeClassified;
        }
        field(50005; Rayon; Integer)
        {
            Description = '2000-901-21';
            Caption = 'Area';
            DataClassification = ToBeClassified;
            TableRelation = "Area and Customerstatus".Rayoncode where(Rayoncode = filter(<> 0), Rayoncode = field(Rayon));
        }
        field(50006; Routenummer; Integer)
        {
            Description = '2000-901-21';
            Caption = 'Round Number';
            DataClassification = ToBeClassified;
        }
        field(50007; Dropcode; Integer)
        {
            Description = '2000-901-21';
            Caption = 'Dropcode';
            DataClassification = ToBeClassified;
        }
        field(50029; "Cust.Memo1"; Text[20])
        {
            Caption = 'Cust.Memo1';
            DataClassification = ToBeClassified;
        }
        field(50030; "Cust.Memo2"; Text[20])
        {
            Caption = 'Cust.Memo1';
            DataClassification = ToBeClassified;
        }
        field(50032; "Mark 01"; Boolean)
        {
            Description = 'FNT-80';
            Caption = 'Fountain';
            DataClassification = ToBeClassified;
        }
        field(50033; "Mark 02"; Boolean)
        {
            Description = 'FNT-80';
            Caption = 'Nestle';
            DataClassification = ToBeClassified;
        }
        field(50034; "Mark 03"; Boolean)
        {
            Description = 'FNT-80';
            Caption = 'Illy';
            DataClassification = ToBeClassified;
        }
        field(50035; Bevyz; Boolean)
        {
            Caption = 'Bevyz';
            DataClassification = ToBeClassified;
        }
        field(50036; "Partner Type Org"; Option)
        {
            Caption = 'Partner Type';
            OptionCaption = ' ,Company,Person';
            OptionMembers = " ",Company,Person;
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(CSKey1; Rayon, Routenummer)
        {

        }
    }
}
