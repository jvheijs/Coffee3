report 50016 "Case Number List"
{
    // CS-W-1901_006 150119 JvH : Omdat de import Dolphin nu verkooporders creert het filter van Invoice naar Order gezet.
    DefaultLayout = RDLC;
    RDLCLayout = './src/Reports/Rep50016/Rep50016.CaseNumberList.rdlc';

    PreviewMode = PrintLayout;

    dataset
    {
        dataitem("Sales Header"; "Sales Header")
        {
            CalcFields = "Amount Including VAT";
            DataItemTableView = WHERE("Document Type" = CONST(Order), "Amount Including VAT" = FILTER(<> 0), "Sell-to Customer No." = FILTER('892000' .. '892260'));
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
            column(SH_GroupTotal; StrSubstNo(GtxtTotaal, FieldCaption(Rayon), Rayon))
            {
            }
            column(SH_Rayon_Capt; FieldCaption(Rayon))
            {
            }
            column(SH_SellToCustNo_Capt; FieldCaption("Sell-to Customer No."))
            {
            }
            column(SH_No_Capt; FieldCaption("No."))
            {
            }
            column(SH_PaymntMeth_Capt; FieldCaption("Payment Method Code"))
            {
            }
            column(SH_AmountInclVat_Capt; FieldCaption("Amount Including VAT"))
            {
            }
            column(SH_RouteNo_Capt; FieldCaption(Routenummer))
            {
            }
            column(SH_Rayon; Rayon)
            {
            }
            column(SH_SellToCustNo; "Sell-to Customer No.")
            {
            }
            column(SH_No; "No.")
            {
            }
            column(SH_PaymntMeth; "Payment Method Code")
            {
            }
            column(SH_AmountInclVat; "Amount Including VAT")
            {
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

    labels
    {
    }

    var
        GtxtReportTitle: Label 'Zaaknummer overzicht';
        GtxtPage: Label 'Page ';
        GtxtTotaal: Label 'Totaal voor %1 %2 :';
}

