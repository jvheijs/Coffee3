report 50005 "Reimbursement 2"
{
    // CS1.1 090718 JHE : Modify stond uit.
    DefaultLayout = RDLC;
    RDLCLayout = './src/Reports/Rep50005/Rep50005.Rembours2.rdlc';

    PreviewMode = PrintLayout;

    ApplicationArea = all;
    UsageCategory = Documents;

    dataset
    {
        dataitem("Rembours etiketten"; "Reimbursement Label")
        {
            DataItemTableView = WHERE(Afgedrukt = CONST(false), Betalingswijze = FILTER('05'));
            RequestFilterFields = "Code";
            column(CompanyAddr1; CompanyAddr[1])
            {
            }
            column(CompanyAddr2; CompanyAddr[2])
            {
            }
            column(CompanyAddr3; CompanyAddr[3])
            {
            }
            column(CompanyAddr4; CompanyAddr[4])
            {
            }
            column(Addr1; Addr[1])
            {
            }
            column(Addr2; Addr[2])
            {
            }
            column(Addr3; Addr[3])
            {
            }
            column(Addr4; Addr[4])
            {
            }
            column("Code"; Code)
            {
            }
            column(CustCode; Klantnr)
            {
            }
            column(Amount; Bedrag)
            {
            }
            column(CompanyIBAN; CompanyInfo.IBAN)
            {
            }

            trigger OnAfterGetRecord()
            begin
                //CustAddres
                FormatAddr.FormatAddr(Addr, Naam, '', '', Adres, '', Plaats, Postcode, '', '');

                Afgedrukt := true;
                Modify;
            end;

            trigger OnPreDataItem()
            begin
                //CompanyAddr
                CompanyInfo.Get;
                FormatAddr.Company(CompanyAddr, CompanyInfo);
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

    labels
    {
    }

    var
        CompanyInfo: Record "Company Information";
        FormatAddr: Codeunit "Format Address";
        CompanyAddr: array[8] of Text[50];
        Addr: array[8] of Text[50];

}

