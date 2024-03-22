xmlport 50003 "Repair Item"
{
    DefaultFieldsValidation = false;
    FieldDelimiter = '<None>';
    FieldSeparator = ';';
    Format = VariableText;
    FormatEvaluate = Legacy;

    schema
    {
        textelement(root)
        {
            tableelement(Item; Item)
            {
                AutoSave = false;
                XmlName = 'item';
                textelement(ItemTxt)
                {
                }
                textelement(TypeItemTxt)
                {

                    trigger OnAfterAssignVariable()
                    var
                        ItemRec: Record Item;
                    begin
                    end;
                }

                trigger OnBeforeInsertRecord()
                var
                    ItemRec: Record Item;
                begin
                    ItemRec.Get(ItemTxt);
                    case TypeItemTxt of
                        'Apparaten':
                            begin
                                ItemRec."Type artikel" := ItemRec."Type artikel"::Apparaten;
                                ItemRec.Modify;
                            end;
                        'Handelsgoederen':
                            begin
                                ItemRec."Type artikel" := ItemRec."Type artikel"::Handelsgoederen;
                                ItemRec.Modify;
                            end;
                        'Service-onderdelen':
                            begin
                                ItemRec."Type artikel" := ItemRec."Type artikel"::"Service-onderdelen";
                                ItemRec.Modify;
                            end;
                        'Controle artikel':
                            begin
                                ItemRec."Type artikel" := ItemRec."Type artikel"::"Controle artikel";
                                ItemRec.Modify;
                            end;
                    end;
                    ItemRec.Modify;
                end;
            }

            trigger OnAfterAssignVariable()
            var
                ItemRec: Record Item;
            begin
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    trigger OnPostXmlPort()
    begin
        Message('Klaar');
    end;
}

