report 50012 "PDT-List"
{
    // CS2.0         051218 JHE : Indien creditnota de aantallen/bedragen met -1 vermenigvuldigen, zodat het op de PDT lijst zichtbaar wordt
    //                            dat het terugname betreft.
    // CS-W-1901_006 150119 JvH : Omdat de import Dolphin nu verkooporders creert het filter van Invoice naar Order gezet.
    // CS2.0         210519 JvH : Aanpassingen gedaan omdat er nu naar orders/retourorders gekeken moet worden.
    DefaultLayout = RDLC;
    RDLCLayout = './src/Reports/Rep50012/Rep50012.PDTList.rdlc';

    Caption = 'PDT-List';
    PreviewMode = PrintLayout;

    dataset
    {
        dataitem("Sales Header"; "Sales Header")
        {
            DataItemTableView = SORTING("Document Type", Rayon, "No.") WHERE("Document Type" = FILTER(Order | "Return Order"));
            RequestFilterFields = Rayon;
            column(Report_Title; GtxtReportTitle)
            {
            }
            column(Report_Page; GtxtPage)
            {
            }
            column(CompanyName; CompanyName)
            {
            }
            column(SH_No_Capt; FieldCaption("No."))
            {
            }
            column(SH_SellToCustNo_Capt; FieldCaption("Sell-to Customer No."))
            {
            }
            column(SH_PaymntMeth_Capt; FieldCaption("Payment Method Code"))
            {
            }
            column(SH_PostDate_Capt; FieldCaption("Posting Date"))
            {
            }
            column(SH_TimeTerminal_Capt; FieldCaption("Tijd terminal"))
            {
            }
            column(SH_AmountInclVat_Capt; FieldCaption("Amount Including VAT"))
            {
            }
            column(SH_RouteNo_Capt; FieldCaption(Routenummer))
            {
            }
            column(SH_SellToName_Capt; FieldCaption("Sell-to Customer Name"))
            {
            }
            column(SH_SellToCity_Capt; FieldCaption("Sell-to City"))
            {
            }
            column(SH_Rayon_Capt; FieldCaption(Rayon))
            {
            }
            column(SH_No; "No.")
            {
            }
            column(SH_SellToCustNo; "Sell-to Customer No.")
            {
            }
            column(SH_PaymntMeth; "Payment Method Code")
            {
            }
            column(SH_PostDate; "Posting Date")
            {
            }
            column(SH_TimeTerminal; "Tijd terminal")
            {
            }
            column(SH_AmountInclVat; "Amount Including VAT")
            {
            }
            column(SH_RouteNo; Routenummer)
            {
            }
            column(SH_SellToName; "Sell-to Customer Name")
            {
            }
            column(SH_SellToCity; "Sell-to City")
            {
            }
            column(SH_Rayon; Rayon)
            {
            }
            dataitem("Sales Line"; "Sales Line")
            {
                DataItemLink = "Document Type" = FIELD("Document Type"), "Document No." = FIELD("No.");
                DataItemTableView = SORTING("Document Type", "Document No.", "Line No.");
                column(SL_No; "No.")
                {
                }
                column(SL_Qty; Quantity)
                {
                }
                column(SL_Amount; Amount)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    // CS2.0 <<
                    if "Sales Line"."Document Type" = "Sales Line"."Document Type"::"Return Order" then begin
                        "Sales Line".Quantity := "Sales Line".Quantity * -1;
                        "Sales Line".Amount := "Sales Line".Amount * -1;
                    end;
                    // CS2.0 >>
                end;
            }

            trigger OnAfterGetRecord()
            begin
                gTmpSalesRec.TransferFields("Sales Header");
                if gTmpSalesRec.Insert then;
            end;

            trigger OnPreDataItem()
            begin
                if not gBooTest then
                    "Sales Header".SetRange("PDT-lijst afgedrukt", false);
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

    trigger OnInitReport()
    begin
        gBooTest := UpperCase(UserId) = 'CONDOR\CONDORGUEST';
        if not gTmpSalesRec.IsTemporary then Error('Temp record needs to be temporary');
    end;

    trigger OnPostReport()
    begin
        if not gBooTest and gTmpSalesRec.FindSet then begin
            repeat
                "Sales Header".Get(gTmpSalesRec."Document Type", gTmpSalesRec."No.");
                "Sales Header"."PDT-lijst afgedrukt" := true;
                "Sales Header".Modify;
            until gTmpSalesRec.Next = 0;
        end;
    end;

    var
        GtxtReportTitle: Label 'PDT-List';
        gTmpSalesRec: Record "Sales Header" temporary;
        gBooTest: Boolean;
        GtxtPage: Label 'Page ';
}

