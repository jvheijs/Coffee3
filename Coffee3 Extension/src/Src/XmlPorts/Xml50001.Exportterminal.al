xmlport 50001 "Export terminal"
{
    // CS1.0 06-12-2017 JvH : Created.

    DefaultFieldsValidation = false;
    Direction = Export;
    FieldDelimiter = '<None>';
    Format = VariableText;
    UseRequestPage = false;

    schema
    {
        textelement(root)
        {
            tableelement("Export terminal"; "Export terminal")
            {
                XmlName = 'ExportTerminal';
                fieldelement(OmschrijvingTxt; "Export terminal".Omschrijving)
                {
                }
            }
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
        // Bestand hernoemen
        SalesSetUp.Get();
        SalesSetUp.TestField("Name exportdirectory");
        ActieveTerminalCode := Format(ActieveTerminal);
        while StrLen(ActieveTerminalCode) < 2 do
            ActieveTerminalCode := '0' + ActieveTerminalCode;
        NieuweNaamBestand := SalesSetUp."Name exportdirectory" + 'pdtup' + ActieveTerminalCode + '.txt';
    end;

    trigger OnPreXmlPort()
    begin
        // Bepaal voor welke terminal een exportbestand moet worden aangemaakt
        Hulptabel50007Rec.Reset;
        Hulptabel50007Rec.SetRange("Meenemen in export?", true);
        Hulptabel50007Rec.SetRange(Geexporteerd, false);
        if Hulptabel50007Rec.Find('-') then
            ActieveTerminal := Hulptabel50007Rec.Volgnummer;
    end;

    var
        SalesSetUp: Record "Sales & Receivables Setup";
        Line: Text[4];
        ActieveTerminal: Integer;
        Hulptabel50007Rec: Record "Temp. Table Export";
        NaamBestand: Text[100];
        NieuweNaamBestand: Text[100];
        ActieveTerminalCode: Code[2];
        Lengte: Integer;
        Text60003: Label 'Exportbestanden zijn klaar!';
        CurrFilename: File;
        DiaStatus: Dialog;
}

