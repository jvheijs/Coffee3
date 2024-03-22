xmlport 50005 "Repair Cust Ledger Pay. Method"
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
            tableelement("Cust. Ledger Entry"; "Cust. Ledger Entry")
            {
                AutoSave = false;
                XmlName = 'CustLedger';
                textelement(Volgnr)
                {
                }
                textelement(Betaalwijze)
                {

                    trigger OnAfterAssignVariable()
                    var
                        ItemRec: Record Item;
                    begin
                    end;
                }

                trigger OnBeforeInsertRecord()
                var
                    lRecCustLedger: Record "Cust. Ledger Entry";
                begin
                    if lRecCustLedger.Get(Volgnr) then begin
                        lRecCustLedger."Payment Method Code" := Betaalwijze;
                        lRecCustLedger.Modify;
                    end;
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

