tableextension 50001 "CS Customer" extends Customer
{
    Description = 'CS1.0';
    fields
    {
        field(50000; Bezoekadres; Text[60])
        {
            caption = 'Visit Address';
            Description = '2000-901-02 verlengd import 051000';
            DataClassification = ToBeClassified;
        }
        field(50001; "Postcode bezoekadres"; Code[10])
        {
            Caption = 'Post Code Visit Address';
            Description = '2000-901-02';
            DataClassification = ToBeClassified;
            TableRelation = "Post Code";
            trigger OnValidate()
            var
                PostCode: Record "Post Code";
            begin
                IF PostCode.GET("Postcode bezoekadres") THEN
                    "Plaats bezoekadres" := PostCode.City;
            end;
        }
        field(50002; "Plaats bezoekadres"; Text[30])
        {
            Caption = 'City Visit Address';
            Description = '2000-901-02';
            DataClassification = ToBeClassified;
        }
        field(50003; "GSM-nummer"; Text[30])
        {
            Caption = 'GSM-number';
            Description = '2000-901-18';
            DataClassification = ToBeClassified;
        }
        field(50004; Klantstatus; Code[10])
        {
            Caption = 'Customer Status';
            Description = '2000-901-20';
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                "Place of Export" := Klantstatus;
            end;
        }
        field(50005; Rayon; Integer)
        {
            Description = '2000-901-21';
            Caption = 'Area';
            DataClassification = ToBeClassified;
            TableRelation = "Area and Customerstatus".Rayoncode WHERE(Rayoncode = FILTER(<> 0), Rayoncode = FIELD(Rayon));
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
            Caption = 'Cust.Memo2';
            DataClassification = ToBeClassified;
        }
        field(50032; "Mark 01"; Boolean)
        {
            Caption = 'Fountain';
            Description = 'FNT-80';
            DataClassification = ToBeClassified;
        }
        field(50033; "Mark 02"; Boolean)
        {
            Caption = 'Nestle';
            Description = 'FNT-80';
            DataClassification = ToBeClassified;
        }
        field(50034; "Mark 03"; Boolean)
        {
            Caption = 'Illy';
            Description = 'FNT-80';
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
            OptionMembers = " ",Company,Person;
            OptionCaption = ' ,Company,Person';
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(CSKey1; Rayon, Routenummer, Dropcode)
        {

        }

    }
}