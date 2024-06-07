page 50017 "DP Sales Order#"
{
    Caption = 'Sales Order';
    PageType = Document;
    RefreshOnActivate = true;
    SourceTable = "Sales Header";
    SourceTableView = where("Document Type" = filter(Order));
    ApplicationArea = All;

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
                    Editable = false;
                    Importance = Additional;
                    ToolTip = 'Specifies the number of the record.';
                }
                field("Sell-to Customer No."; Rec."Sell-to Customer No.")
                {
                    Editable = false;
                }
                field("Sell-to Customer Name"; Rec."Sell-to Customer Name")
                {
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
                    Caption = 'Address';
                    Editable = false;
                    Importance = Additional;
                    ToolTip = 'Specifies the customer''s sell-to address.';
                }
                field("Sell-to Address 2"; Rec."Sell-to Address 2")
                {
                    Caption = 'Address 2';
                    Editable = false;
                    Importance = Additional;
                    ToolTip = 'Specifies an additional part of the customer''s sell-to address.';
                }
                field("Sell-to City"; Rec."Sell-to City")
                {
                    Caption = 'City';
                    Editable = false;
                    Importance = Additional;
                }
                field("Sell-to Post Code"; Rec."Sell-to Post Code")
                {
                    Caption = 'Post Code';
                    Editable = false;
                    Importance = Additional;
                }
                field("Sell-to County"; Rec."Sell-to County")
                {
                    Caption = 'County';
                    Editable = false;
                    Importance = Additional;
                }
                field("Sell-to Country/Region Code"; Rec."Sell-to Country/Region Code")
                {
                    Caption = 'Country/Region';
                    Editable = false;
                    Importance = Additional;
                }
                field("Document Date"; Rec."Document Date")
                {
                    Caption = 'Invoice Date';
                    Editable = false;
                    Importance = Additional;
                }
                field("Due Date"; Rec."Due Date")
                {
                    Editable = false;
                    Importance = Additional;
                    ToolTip = 'Specifies when the sales invoice must be paid.';
                }
                field(Verzendprofiel; Rec.Verzendprofiel)
                {
                }
                field("E-mail"; gRecCustomer."E-Mail")
                {
                    Caption = 'E-mail';
                }
                field("Payment Method Code"; Rec."Payment Method Code")
                {
                }
                field(IBAN; gRecCustomerBankAccount.IBAN)
                {
                    Caption = 'IBAN';
                }
                field("Amount Including VAT"; Rec."Amount Including VAT")
                {
                }
            }
            part("DP Sales Order Line"; "DP Sales Order Line")
            {
                Caption = 'Lines';
                SubPageLink = "Document Type" = field("Document Type"),
                              "Document No." = field("No.");
                UpdatePropagation = Both;
            }
            field("CSSignature"; RecSignature."Signature")
            {
                Caption = 'Signature';
                Editable = false;
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("P&osting")
            {
                Caption = 'Boeken';
                Image = Post;
                action(Items)
                {
                    Caption = '&Artikelen';
                    Image = Item;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Category5;
                    //The property 'PromotedIsBig' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedIsBig = true;
                    //The property 'PromotedOnly' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedOnly = true;

                    trigger OnAction()
                    var
                        lRecCustStock: Record "Cust. Stock";
                        lRecSalesLine: Record "Sales Line";
                        lIntLineNo: Integer;
                    begin

                        lRecCustStock.SETFILTER("Cust. No.", Rec."Sell-to Customer No.");
                        if not lRecCustStock.FINDLAST() then exit;
                        lRecCustStock.SETFILTER("Check Date", FORMAT(lRecCustStock."Check Date"));
                        lRecCustStock.FINDFIRST();
                        repeat
                            lRecSalesLine.VALIDATE("Document Type", lRecSalesLine."Document Type"::Order);
                            lRecSalesLine.VALIDATE("Document No.", Rec."No.");
                            lIntLineNo += 10000;
                            lRecSalesLine.VALIDATE("Line No.", lIntLineNo);
                            lRecSalesLine.VALIDATE("Sell-to Customer No.", Rec."Sell-to Customer No.");
                            lRecSalesLine.VALIDATE(Type, lRecSalesLine.Type::Item);
                            lRecSalesLine.VALIDATE("No.", lRecCustStock."Item No.");
                            lRecSalesLine.INSERT();
                        until lRecCustStock.NEXT() = 0;
                    end;
                }
                action("Post#")
                {
                    Caption = 'Boeken'; // jvh
                    Image = PostOrder;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ShortCutKey = 'F9';
                    ToolTip = 'Finalize the document or journal by posting the amounts and quantities to the related accounts in your company books.';

                    trigger OnAction()
                    begin
                        if HasSignature() = false then begin
                            AddSignature();
                            SelectLatestVersion();
                        end;

                        if HasSignature() then begin
                            Rec.InPosting := true; // COFF-1
                            Rec.MODIFY();
                            COMMIT();
                            CurrPage.CLOSE();
                        end;
                    end;
                }
                action(PostAndNew)
                {
                    Caption = 'Post and New';
                    Ellipsis = true;
                    Image = PostOrder;
                    Promoted = true;
                    PromotedCategory = Process;
                    ShortCutKey = 'Shift+F9';
                    Visible = false;

                    trigger OnAction()
                    begin
                        Post(CODEUNIT::"Sales-Post (Yes/No)", NavigateAfterPost::"New Document");
                    end;
                }
                action(PostAndSend)
                {
                    Caption = 'Post and &Send';
                    Ellipsis = true;
                    Image = PostSendTo;
                    Promoted = true;
                    PromotedCategory = Process;
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
                RunObject = Page "Service Items";
                RunPageLink = "Customer No." = field("Sell-to Customer No.");
                RunPageView = sorting("Customer No.", "Ship-to Code", "Item No.", "Serial No.");
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        HasSignature();
    end;

    trigger OnAfterGetCurrRecord()
    begin

        if not gRecCustomer.GET(Rec."Bill-to Customer No.") then gRecCustomer.INIT();
        if not gRecCustomerBankAccount.GET(gRecCustomer."No.", gRecCustomer."Preferred Bank Account Code") then gRecCustomerBankAccount.INIT();
    end;

    trigger OnNextRecord(Steps: Integer): Integer
    begin
        //lFncClear;
    end;

    var
        RecSignature: Record "CS Signature";
        CustomerName: Text[50];
        CustomerEmail: Text[50];
        ApplicationAreaMgmtFacade: Codeunit "Application Area Mgmt. Facade";
        LinesInstructionMgt: Codeunit "Instruction Mgt.";
        DocumentIsPosted: Boolean;
        NavigateAfterPost: Option "Posted Document","New Document",Nowhere;
        OpenPostedSalesInvQst: Label 'The invoice has been posted and moved to the Posted Sales Invoices window.\\Do you want to open the posted invoice?';
        gBlnCanClose: Boolean;
        gBlnSignatureDataSet: Boolean;
        gRecCustomer: Record Customer;
        gRecCustomerBankAccount: Record "Customer Bank Account";

    local procedure HasSignature(): Boolean;
    begin
        if RecSignature.GET(database::"Sales Header", rec."No.", rec."Document Type".AsInteger()) then
            RecSignature.CalcFields("Signature");
        exit(RecSignature.Signature.HasValue());
    end;

    local procedure AddSignature();
    var
        Signature: Page Signature;
    begin
        Signature.SetDocNo(rec."No.");
        Signature.SetDocType(rec."Document Type".AsInteger());
        Signature.SetTable(Database::"Sales Header");
        Signature.SetWithExit();
        Signature.RunModal();
    end;

    local procedure Post(PostingCodeunitID: Integer; Navigate: Option)
    var
        SalesHeader: Record "Sales Header";
        LinesInstructionMgt: Codeunit "Lines Instruction Mgt.";
        InstructionMgt: Codeunit "Instruction Mgt.";
    begin
        // BVE. Wanneer wordt deze functie gebruikt? Kan deze weg?
        if ApplicationAreaMgmtFacade.IsFoundationEnabled then
            LinesInstructionMgt.SalesCheckAllLinesHaveQuantityAssigned(Rec);

        Rec.SendToPosting(PostingCodeunitID);
        DocumentIsPosted := not SalesHeader.GET(Rec."Document Type", Rec."No.");

        if Rec."Job Queue Status" = Rec."Job Queue Status"::"Scheduled for Posting" then
            CurrPage.CLOSE();
        CurrPage.UPDATE(false);

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
        SalesInvoiceHeader.SETCURRENTKEY("Pre-Assigned No.");
        SalesInvoiceHeader.SETRANGE("Pre-Assigned No.", PreAssignedNo);
        if SalesInvoiceHeader.FINDFIRST() then
            if InstructionMgt.ShowConfirm(OpenPostedSalesInvQst, InstructionMgt.ShowPostedConfirmationMessageCode) then
                PAGE.RUN(PAGE::"Posted Sales Invoice", SalesInvoiceHeader);
    end;

    local procedure lFncPostDocument()
    var
        lRecSalesLine: Record "Sales Line";
    begin
        /*
        if "Payment Method Code" <> '01' THEN
          if CONFIRM('Contante betaling ?',FALSE) THEN BEGIN
            "Payment Method Code" := '01';
            "Payment Terms Code" := '01';
          END;
        */
        lRecSalesLine.SETRANGE("Document Type", Rec."Document Type");
        lRecSalesLine.SETFILTER("Document No.", Rec."No.");
        lRecSalesLine.SETRANGE(Quantity, 0);
        lRecSalesLine.DELETEALL();

        Post(CODEUNIT::"Sales-Post (Yes/No)", NavigateAfterPost::"Posted Document");

    end;
}

