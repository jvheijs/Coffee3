table 50018 "CS Default Service Lines"
{
    Caption = 'CS Default Service Lines';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(2; Type; Enum "Service Line Type")
        {
            Caption = 'Type';

            trigger OnValidate()
            begin
                if xRec.Type <> rec.Type then begin
                    "No." := '';
                    Description := '';
                end;
            end;
        }
        field(3; "No."; Code[20])
        {
            Caption = 'No.';
            TableRelation = if (Type = const(" ")) "Standard Text"
            else
            if (Type = const("G/L Account")) "G/L Account"
            else
            if (Type = const(Item)) Item where(Blocked = const(false), "Service Blocked" = const(false))
            else
            if (Type = const(Resource)) Resource
            else
            if (Type = const(Cost)) "Service Cost";

            trigger OnValidate()
            begin
                Description := '';

                if rec."No." <> '' then
                    case Type of
                        Type::" ":
                            CopyFromStdTxt();
                        Type::"G/L Account":
                            CopyFromGLAccount();
                        Type::Cost:
                            CopyFromCost();
                        Type::Item:
                            CopyFromItem();
                        Type::Resource:
                            CopyFromResource();
                    end;
            end;
        }
        field(4; Description; Text[100])
        {
            Caption = 'Description';
        }
    }
    keys
    {
        key(PK; "Line No.")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    begin
        TestField("No.");
    end;

    trigger OnModify()
    begin
        TestField("No.");
    end;

    local procedure CopyFromStdTxt()
    var
        StandardText: Record "Standard Text";
    begin
        StandardText.Get("No.");
        Description := StandardText.Description;
    end;

    local procedure CopyFromGLAccount()
    var
        GLAcc: Record "G/L Account";
    begin
        GLAcc.Get("No.");
        Description := GLAcc.Name;
    end;

    local procedure CopyFromCost()
    var
        ServCost: Record "Service Cost";
    begin
        ServCost.Get("No.");
        Description := ServCost.Description;
    end;

    local procedure CopyFromItem()
    var
        Item: Record Item;
    begin

        Item.Get("No.");
        Description := Item.Description;
    end;

    local procedure CopyFromResource()
    var
        Res: Record Resource;
    begin
        Res.Get("No.");
        Description := Res.Name;
    end;
}
