report 50006 "Service Order CS"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/Reports/Rep50006/Rep50006.ServiceOrderCS.rdlc';
    Caption = 'Service Order';
    Permissions = TableData "Sales Shipment Buffer" = rimd;
    PreviewMode = PrintLayout;

    ApplicationArea = all;
    UsageCategory = Documents;

    dataset
    {
        dataitem("Integer"; "Integer")
        {
            DataItemTableView = sorting(Number) where(Number = const(1));
            column(CompanyInfo2Picture; CompanyInfo2.Picture)
            {
            }
            column(CompanyInfo1Picture; CompanyInfo1.Picture)
            {
            }
            column(CompanyInfo3Picture; CompanyInfo3.Picture)
            {
            }

        }
        dataitem("Service Header"; "Service Header")
        {
            DataItemTableView = sorting("Document Type", "No.") where("Document Type" = const(Order));
            RequestFilterFields = "Customer No.", "No.";
            RequestFilterHeading = 'Service Order';
            column(ReportTitle; TextReportTitle)
            {
            }
            column(lblCustDetails; TextCustDetails)
            {
            }
            column(No_ServHdr; "Service Header"."No.")
            {
            }
            column(Resp_ServHdr; "Salesperson Code")
            {
            }
            column(Service_ServHdr; gBooServiceOrderYN)
            {
            }
            column(CustAddrNo; "Service Header"."Customer No.")
            {
            }
            column(CustAddr1; CustAddr[1])
            {
            }
            column(CustAddr2; CustAddr[2])
            {
            }
            column(CustAddr3; CustAddr[3])
            {
            }
            column(CustAddr4; CustAddr[4])
            {
            }
            column(CustAddr5; CustAddr[5])
            {
            }
            column(CustAddr6; CustAddr[6])
            {
            }
            dataitem(CopyLoop; "Integer")
            {
                DataItemTableView = sorting(Number);
                dataitem(PageLoop; "Integer")
                {
                    DataItemTableView = sorting(Number) where(Number = const(1));
                    column(OutputNo; OutputNo)
                    {
                    }
                    dataitem("Service Item Line"; "Service Item Line")
                    {
                        DataItemLink = "Document Type" = field("Document Type"), "Document No." = field("No.");
                        DataItemLinkReference = "Service Header";
                        DataItemTableView = sorting("Document Type", "Document No.", "Line No.");
                        column(lblMachineType; TextMachineType)
                        {
                        }
                        column(lblServiceContract; TextServiceContract)
                        {
                        }
                        column(lblResp; TextResp)
                        {
                        }
                        column(lblSerialNo; TextSerialNo)
                        {
                        }
                        column(lblCounter; TextCounter)
                        {
                        }
                        column(TextLine1; TextLine1)
                        {
                        }
                        column(TextLine2; TextLine2)
                        {
                        }
                        column(TextLine3; TextLine3)
                        {
                        }
                        column(TextLine4; TextLine4)
                        {
                        }
                        column(TextLine5; TextLine5)
                        {
                        }
                        column(TextLine6; TextLine6)
                        {
                        }
                        column(TextLine7; TextLine7)
                        {
                        }
                        column(TextLine8; TextLine8)
                        {
                        }
                        column(TextLineHdr1; TextLineHdr1)
                        {
                        }
                        column(TextLineCapt1; TextLineCapt1)
                        {
                        }
                        column(TextLineCapt2; TextLineCapt2)
                        {
                        }
                        column(TextLineCapt3; TextLineCapt3)
                        {
                        }
                        column(TextLineRemarks; TextLineRemarks)
                        {
                        }
                        column(TextDate; TextDate)
                        {
                        }
                        column(TextNameSignCust; TextNameSignCust)
                        {
                        }
                        column(TextNameSignEmpl; TextNameSignEmpl)
                        {
                        }
                        column(LineNo_ServItem; "Service Item Line"."Line No.")
                        {
                        }
                        column(Desc_ServItem; Description)
                        {
                        }
                        column(Serial_ServItem; "Serial No.")
                        {
                        }
                    }
                }

                trigger OnAfterGetRecord()
                begin
                    if Number > 1 then begin
                        CopyText := FormatDocument.GetCOPYText;
                        OutputNo += 1;
                    end;
                end;

                trigger OnPreDataItem()
                begin
                    NoOfLoops := Abs(NoOfCopies) + 1;
                    if NoOfLoops <= 0 then
                        NoOfLoops := 1;
                    CopyText := '';
                    SetRange(Number, 1, NoOfLoops);

                    OutputNo := 1;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                if "Language Code" <> '' then
                    CurrReport.Language := CuLanguage.GetLanguageID("Language Code");

                FormatAddressFields("Service Header");
                if ("Service Order Type" = 'ONDERHOUD') then
                    gBooServiceOrderYN := TextYes
                else
                    gBooServiceOrderYN := TextNo;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(NoOfCopies; NoOfCopies)
                    {
                        Caption = 'No. of Copies';
                        ApplicationArea = All;
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnInitReport()
    begin
        GLSetup.Get();
        CompanyInfo.Get();
        CompanyInfo.VerifyAndSetPaymentInfo;
        SalesSetup.Get();
        FormatDocument.SetLogoPosition(SalesSetup."Logo Position on Documents", CompanyInfo1, CompanyInfo2, CompanyInfo3);
    end;

    var
        TextReportTitle: Label 'Periodieke onderhouds checklist Coffee3';
        TextCustDetails: Label 'Customer Details';
        TextMachineType: Label 'Machine Type:';
        TextServiceContract: Label 'Service Contract:';
        TextResp: Label 'Responsible:';
        TextSerialNo: Label 'Serial No.:';
        TextCounter: Label 'Counter:';
        SalesSetup: Record "Sales & Receivables Setup";
        CompanyInfo1: Record "Company Information";
        CompanyInfo2: Record "Company Information";
        CompanyInfo3: Record "Company Information";
        GLSetup: Record "General Ledger Setup";
        CompanyInfo: Record "Company Information";
        RespCenter: Record "Responsibility Center";
        CuLanguage: Codeunit Language;
        FormatAddr: Codeunit "Format Address";
        FormatDocument: Codeunit "Format Document";
        CustAddr: array[8] of Text[50];
        CompanyAddr: array[8] of Text[50];
        CopyText: Text;
        OutputNo: Integer;
        NoOfCopies: Integer;
        NoOfLoops: Integer;
        TextLine1: Label 'Bij de jaarlijkse onderhoudsbeurt is uw gehele apparaat door onze technische dienst geËÇ‰nspecteerd, te weten;';
        TextLine2: Label 'Het gehele watersysteem, boiler en alle ventielen zijn gereinigd of vervangen, eventuele kalkafzetting is verwijderd';
        TextLine3: Label 'Het ventilatorsysteem, ventilatormotor, kanalen en roosters zijn schoongemaakt';
        TextLine4: Label 'Het mixersysteem, motor en mixervin worden gereviseerd en afdichtingen zijn, indien nodig vervangen';
        TextLine5: Label 'De waterfilters zijn, indien van toepassing, vervangen';
        TextLine6: Label 'Het gehele apparaat is op een goede werking gecontroleerd';
        TextLine7: Label 'Als onderdeel van uw onderhoudscontract heeft uw jaarlijkse periodieke onderhoudsbeurt vandaag succesvol plaatsgevonden aan uw Coffee3 apparaat.  ';
        TextLine8: Label 'Hiermee kunt u weer volledig vertrouwen op een jaar lang een prima warme drankenvoorziening! ';
        TextLineHdr1: Label 'Verbruikte onderdelen:';
        TextLineCapt1: Label 'Nr.';
        TextLineCapt2: Label 'Omschrijving';
        TextLineCapt3: Label 'Aantal';
        TextLineRemarks: Label 'Eventuele Opmerkingen';
        TextDate: Label 'Datum uitvoering periodiek onderhoud';
        TextNameSignCust: Label 'Naam en handtekening klant';
        TextNameSignEmpl: Label 'Handtekening technische dienst';
        gBooServiceOrderYN: Code[1];
        TextYes: Label 'Y';
        TextNo: Label 'N';

    local procedure FormatAddressFields(var ServiceHeader: Record "Service Header")
    var
        iPosPhoneNo: Integer;
    begin
        //FormatAddr.GetCompanyAddr(ServiceHeader."Responsibility Center",RespCenter,CompanyInfo,CompanyAddr);
        FormatAddr.ServiceOrderShipto(CustAddr, ServiceHeader);
        iPosPhoneNo := CompressArray(CustAddr) + 1;
        CustAddr[iPosPhoneNo] := "Service Header"."Phone No.";
    end;
}

