page 50011 "DP Sales Order"
{
    Caption = 'Verkoop order';
    PageType = Document;
    RefreshOnActivate = true;
    SourceTable = "Sales Header";
    SourceTableView = where("Document Type" = filter(Order));
    ApplicationArea = all;

    layout
    {
        area(content)
        {
            group("Order")
            {
                Caption = 'Invoice';
                Editable = false;
                field("No."; Rec."No.")
                {
                    ApplicationArea = all;
                    Editable = false;
                    Importance = Additional;
                    ToolTip = 'Specifies the number of the record.';
                }
                field("Sell-to Customer No."; Rec."Sell-to Customer No.")
                {
                    Editable = false;
                    ApplicationArea = all;
                }
                field("Sell-to Customer Name"; Rec."Sell-to Customer Name")
                {
                    ApplicationArea = all;
                    Caption = 'Customer Name';
                    Editable = false;
                    Importance = Promoted;
                    Lookup = true;
                    ShowMandatory = true;

                    trigger OnValidate()
                    var
                        Customer: Record Customer;
                    begin
                    end;
                }
                field("Sell-to Address"; Rec."Sell-to Address")
                {
                    ApplicationArea = all;
                    Caption = 'Address';
                    Editable = false;
                    Importance = Additional;
                    ToolTip = 'Specifies the customer''s sell-to address.';
                }
                field("Sell-to Address 2"; Rec."Sell-to Address 2")
                {
                    ApplicationArea = all;
                    Caption = 'Address 2';
                    Editable = false;
                    Importance = Additional;
                    ToolTip = 'Specifies an additional part of the customer''s sell-to address.';
                }
                field("Sell-to City"; Rec."Sell-to City")
                {
                    ApplicationArea = all;
                    Caption = 'City';
                    Editable = false;
                    Importance = Additional;
                }
                field("Sell-to Post Code"; Rec."Sell-to Post Code")
                {
                    ApplicationArea = all;
                    Caption = 'Post Code';
                    Editable = false;
                    Importance = Additional;
                }
                field("Sell-to County"; Rec."Sell-to County")
                {
                    ApplicationArea = all;
                    Caption = 'County';
                    Editable = false;
                    Importance = Additional;
                }
                field("Sell-to Country/Region Code"; Rec."Sell-to Country/Region Code")
                {
                    ApplicationArea = all;
                    Caption = 'Country/Region';
                    Editable = false;
                    Importance = Additional;
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = all;
                    Caption = 'Invoice Date';
                    Editable = false;
                    Importance = Additional;
                }
                field("Due Date"; Rec."Due Date")
                {
                    ApplicationArea = all;
                    Editable = false;
                    Importance = Additional;
                    ToolTip = 'Specifies when the sales invoice must be paid.';
                }
                field("Payment Method Code"; Rec."Payment Method Code")
                {
                    ApplicationArea = all;
                }
            }
            part("DP Sales Order Line"; "DP Sales Order Line")
            {
                ApplicationArea = all;
                Caption = 'Lines';
                SubPageLink = "Document Type" = field("Document Type"),
                              "Document No." = field("No.");
                UpdatePropagation = Both;
            }

        }
        // area(factboxes)
        // {
        //     part(Control1000000005; "DP Sales Line FactBox")
        //     {
        //         ApplicationArea = Suite;
        //         Provider = "DP Sales Order Line";
        //         SubPageLink = "Document Type" = FIELD("Document Type"),
        //                       "Document No." = FIELD("Document No."),
        //                       "Line No." = FIELD("Line No.");
        //     }
        // }
    }

    actions
    {
        area(navigation)
        {
            group("P&osting")
            {
                Caption = 'P&osting';
                Image = Post;
                action(Items)
                {
                    ApplicationArea = all;
                    Caption = '&Artikelen';
                    Image = Item;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    PromotedOnly = true;

                    trigger OnAction()
                    var
                        lRecCustStock: Record "Cust. Stock";
                        lRecSalesLine: Record "Sales Line";
                        lIntLineNo: Integer;
                    begin

                        lRecCustStock.SetFilter("Cust. No.", Rec."Sell-to Customer No.");
                        if not lRecCustStock.FINDLAST() then exit;
                        lRecCustStock.SetFilter("Check Date", Format(lRecCustStock."Check Date"));
                        lRecCustStock.FINDFIRST();
                        repeat
                            lRecSalesLine.Validate("Document Type", lRecSalesLine."Document Type"::Order);
                            lRecSalesLine.Validate("Document No.", Rec."No.");
                            lIntLineNo += 10000;
                            lRecSalesLine.Validate("Line No.", lIntLineNo);
                            lRecSalesLine.Validate("Sell-to Customer No.", Rec."Sell-to Customer No.");
                            lRecSalesLine.Validate(Type, lRecSalesLine.Type::Item);
                            lRecSalesLine.Validate("No.", lRecCustStock."Item No.");
                            lRecSalesLine.INSERT();
                        until lRecCustStock.Next() = 0;
                    end;
                }
                action(Post2)
                {
                    ApplicationArea = all;
                    Caption = 'P&ost';
                    Image = PostOrder;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ShortCutKey = 'F9';
                    ToolTip = 'Finalize the document or journal by posting the amounts and quantities to the related accounts in your company books.';

                    trigger OnAction()
                    var
                        lPgeDPSalesOrder: Page "DP Sales Order#";
                        lRecSalesHeader: Record "Sales Header";
                        lRecSalesLine: Record "Sales Line";
                        lRecSalesInvoiceHeader: Record "Sales Invoice Header";
                        lRecCustomer: Record Customer;
                    begin

                        /*
                        if "Payment Method Code" <> '01' THEN
                          if CONFIRM('Contante betaling ?',FALSE) THEN BEGIN
                            "Payment Method Code" := '01';
                            "Payment Terms Code" := '01';
                          END;
                        
                        Post(CODEUNIT::"Sales-Post (Yes/No)",NavigateAfterPost::"Posted Document");
                        */

                        lRecSalesLine.SetRange("Document Type", Rec."Document Type");
                        lRecSalesLine.SetFilter("Document No.", Rec."No.");
                        lRecSalesLine.SetFilter(Type, '>0');
                        lRecSalesLine.FINDFIRST();
                        repeat
                            if (lRecSalesLine.Quantity = 0) and not lRecSalesLine."Store stock" then
                                lRecSalesLine.DELETE();
                        until lRecSalesLine.Next() = 0;

                        // lRecSalesLine.SETRANGE(Quantity,0);
                        // lRecSalesLine.DELETEALL();
                        Rec.InPosting := false;
                        Commit;

                        lRecSalesHeader.SetRange("Document Type", lRecSalesHeader."Document Type"::Order);
                        lRecSalesHeader.SetFilter("No.", Rec."No.");
                        lRecSalesHeader.FINDFIRST();
                        lPgeDPSalesOrder.SETTABLEVIEW(lRecSalesHeader);
                        lPgeDPSalesOrder.RUNMODAL;


                        //ERROR('x %1 %2',"No.",Posting);
                        Commit;
                        lRecSalesHeader.SetRange("Document Type", lRecSalesHeader."Document Type"::Order);
                        lRecSalesHeader.SetFilter("No.", Rec."No.");
                        lRecSalesHeader.FINDFIRST();
                        Rec.SetRange("Document Type", lRecSalesHeader."Document Type"::Order);
                        Rec.SetFilter("No.", Rec."No.");
                        Rec.FINDFIRST();

                        if Rec.InPosting then begin
                            // if "Payment Method Code" <> '01' THEN
                            if Confirm('Contante betaling ?', false) then begin
                                Rec.Validate("Payment Method Code", '01');
                                Rec.Validate("Payment Terms Code", '01');
                                Rec.MODIFY();
                            end;

                            if lRecCustomer.Get(lRecSalesHeader."Bill-to Customer No.") then begin
                                if lRecCustomer."E-Mail" = '' then begin
                                    lRecCustomer."E-Mail" := 'Marc.vanOudheusden@coffee3.nl';
                                    lRecCustomer.MODIFY();
                                    Commit;
                                end;
                            end;

                            Post(CODEUNIT::"Sales-Post (Yes/No)", NavigateAfterPost::"Posted Document");
                            Commit;

                        end;

                        /*
                        lRecSalesInvoiceHeader.SETFILTER("No.",lRecSalesHeader."No.");
                        if lRecSalesInvoiceHeader.FINDFIRST() THEN BEGIN
                          lRecSalesInvoiceHeader.EmailRecords(FALSE);
                        END;
                        */

                    end;
                }
                action(PostAndNew)
                {
                    ApplicationArea = all;
                    Caption = 'Post and New';
                    Ellipsis = true;
                    Image = PostOrder;
                    Promoted = true;
                    PromotedCategory = Category5;
                    ShortCutKey = 'Shift+F9';
                    Visible = false;

                    trigger OnAction()
                    begin
                        Post(CODEUNIT::"Sales-Post (Yes/No)", NavigateAfterPost::"New Document");
                    end;
                }
                action(PostAndSend)
                {
                    ApplicationArea = all;
                    Caption = 'Post and &Send';
                    Ellipsis = true;
                    Image = PostSendTo;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedOnly = true;
                    ToolTip = 'Finalize and prepare to send the document according to the customer''s sending profile, such as attached to an email. The Send document to window opens first so you can confirm or select a sending profile.';
                    Visible = false;

                    trigger OnAction()
                    begin
                        Post(CODEUNIT::"Sales-Post and Send", NavigateAfterPost::Nowhere);
                    end;
                }
            }
            action("Service &Items")
            {
                Caption = 'Service &Items';
                Image = ServiceItem;
                ApplicationArea = all;
                RunObject = Page "Service Items";
                RunPageLink = "Customer No." = field("Sell-to Customer No.");
                RunPageView = sorting("Customer No.", "Ship-to Code", "Item No.", "Serial No.");
            }
        }
    }

    var
        CustomerName: Text[50];
        CustomerEmail: Text[50];
        ApplicationAreaMgmtSetupFacage: Codeunit "Application Area Mgmt. Facade";

        LinesInstructionMgt: Codeunit "Lines Instruction Mgt.";
        DocumentIsPosted: Boolean;
        NavigateAfterPost: Option "Posted Document","New Document",Nowhere;
        OpenPostedSalesInvQst: Label 'The invoice has been posted and moved to the Posted Sales Invoices window.\\Do you want to open the posted invoice?';

    local procedure Post(PostingCodeunitID: Integer; Navigate: Option)
    var
        SalesHeader: Record "Sales Header";
        LinesInstructionMgt: Codeunit "Lines Instruction Mgt.";
        InstructionMgt: Codeunit "Instruction Mgt.";
    begin
        //if ApplicationAreaMgmtSetupFacage.IsFoundationEnabled() then                 // JvH 22-01-2024
        //    LinesInstructionMgt.SalesCheckAllLinesHaveQuantityAssigned(Rec);         // JvH 22-01-2024

        Rec.SendToPosting(PostingCodeunitID);
        DocumentIsPosted := not SalesHeader.Get(Rec."Document Type", Rec."No.");

        if Rec."Job Queue Status" = Rec."Job Queue Status"::"Scheduled for Posting" then
            CurrPage.CLOSE();
        CurrPage.Update(false);

        if PostingCodeunitID <> CODEUNIT::"Sales-Post (Yes/No)" then
            exit;

        /*
        CASE Navigate OF
          NavigateAfterPost::"Posted Document":
            if InstructionMgt.IsEnabled(InstructionMgt.ShowPostedConfirmationMessageCode) THEN
              ShowPostedConfirmationMessage;
          NavigateAfterPost::"New Document":
            if DocumentIsPosted THEN BEGIN
              SalesHeader.INIT();
              SalesHeader.VALIDATE("Document Type",SalesHeader."Document Type"::Order);
              SalesHeader.INSERT(TRUE);
              PAGE.RUN(PAGE::"Sales Order",SalesHeader);
            END;
        END;
        */

    end;

    local procedure ShowPostedConfirmationMessage(PreAssignedNo: Code[20])
    var
        SalesInvoiceHeader: Record "Sales Invoice Header";
        InstructionMgt: Codeunit "Instruction Mgt.";
    begin
        SalesInvoiceHeader.SetCurrentKey("Pre-Assigned No.");
        SalesInvoiceHeader.SetRange("Pre-Assigned No.", PreAssignedNo);
        if SalesInvoiceHeader.FINDFIRST() then
            if InstructionMgt.ShowConfirm(OpenPostedSalesInvQst, InstructionMgt.ShowPostedConfirmationMessageCode) then
                PAGE.Run(PAGE::"Posted Sales Invoice", SalesInvoiceHeader);
    end;
}

