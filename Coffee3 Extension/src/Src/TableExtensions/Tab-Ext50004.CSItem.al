tableextension 50004 "CS Item" extends Item
{
    Description = 'CS1.0';
    fields
    {
        field(50003; "Type artikel"; Option)
        {
            Caption = 'Item Type';
            OptionCaption = 'Machinery, Trade-items, Service-parts, Item Check';
            OptionMembers = Apparaten,Handelsgoederen,"Service-onderdelen","Controle artikel";
            Description = '2000-901-09';
            DataClassification = ToBeClassified;
        }
        field(50009; "Export Item"; Boolean)
        {
            Description = 'FNT-84';
            Caption = 'Export Item';
            DataClassification = ToBeClassified;
        }

    }

    fieldgroups
    {
        addlast(DropDown; "Vendor Item No.") { }
    }
}
