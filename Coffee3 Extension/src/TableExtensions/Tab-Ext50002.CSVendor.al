tableextension 50002 "CS Vendor" extends Vendor
{
    Description = 'CS1.0';
    fields
    {
        field(50005; "Telefoonnr. contactpersoon"; Text[30])
        {
            Description = 'import 021000 ATW VVK';
            Caption = 'Telephone Contactperson';
            DataClassification = ToBeClassified;
        }
        field(50036; "Partner Type Org"; Option)
        {
            Caption = 'Partner Type';
            OptionCaption = ' ,Company,Person';
            OptionMembers = " ",Company,Person;
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
                myInt: Integer;
            begin
                IF NOT CONFIRM(PartnerTypeMismatchMsg, FALSE) THEN
                    ERROR('')
            end;
        }
    }

    var
        PartnerTypeMismatchMsg: Label 'PartnerTypeMismatchMsg', MaxLength = 999, Locked = true;
}
