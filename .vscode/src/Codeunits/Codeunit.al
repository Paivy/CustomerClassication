codeunit 50167 "Customer Classification Mgt."
{
    var
    procedure UpdateCustomerClassification(CustomerNo: Code[20])
    var
        Customer: Record Customer;
        SalesOrderCount: Integer;
        NewClassification: Enum "Customer Classification";
    begin
        if not Customer.Get(CustomerNo) then
            exit;

        SalesOrderCount := GetSalesOrderCount(CustomerNo);
        NewClassification := DetermineClassification(SalesOrderCount);
        
        if Customer."Customer Classification" <> NewClassification then begin
            Customer."Customer Classification" := NewClassification;
            Customer."Last Classification Update" := CurrentDateTime();
            Customer.Modify();
        end;
    end;

    procedure UpdateAllCustomerClassifications()
    var
        Customer: Record Customer;
        ProgressDialog: Dialog;
        Counter: Integer;
        TotalCount: Integer;
    begin
        Customer.SetRange(Blocked, Customer.Blocked::" ");
        TotalCount := Customer.Count();
        
        if TotalCount = 0 then
            exit;

        ProgressDialog.Open('Updating customer classifications...\' +
                           'Customer #1##################\' +
                           'Progress: #2########## of #3##########');

        if Customer.FindSet() then
            repeat
                Counter += 1;
                ProgressDialog.Update(1, Customer."No.");
                ProgressDialog.Update(2, Counter);
                ProgressDialog.Update(3, TotalCount);
                
                UpdateCustomerClassification(Customer."No.");
            until Customer.Next() = 0;

        ProgressDialog.Close();
        Message('Classification updated for %1 customers.', TotalCount);
    end;

    local procedure GetSalesOrderCount(CustomerNo: Code[20]): Integer
    var
        SalesHeader: Record "Sales Header";
    begin
        SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Order);
        SalesHeader.SetRange("Sell-to Customer No.", CustomerNo);
        exit(SalesHeader.Count());
    end;

    local procedure DetermineClassification(SalesOrderCount: Integer): Enum "Customer Classification"
    begin
        case SalesOrderCount of
            0:
                exit("Customer Classification"::"New");
            1..5:
                exit("Customer Classification"::"Bronze");
            6..15:
                exit("Customer Classification"::"Silver");
            else
                exit("Customer Classification"::"Gold");
        end;
    end;

    procedure CreateOrderDetailsEntry(SalesHeader: Record "Sales Header")
    var
        CustomerOrderDetails: Record "Customer Order Details";
        Customer: Record Customer;
        SalesLine: Record "Sales Line";
        TotalAmount: Decimal;
    begin
        if not Customer.Get(SalesHeader."Sell-to Customer No.") then
            exit;

        SalesLine.SetRange("Document Type", SalesHeader."Document Type");
        SalesLine.SetRange("Document No.", SalesHeader."No.");
        SalesLine.CalcSums("Amount Including VAT");
        TotalAmount := SalesLine."Amount Including VAT";

        CustomerOrderDetails.Init();
        CustomerOrderDetails."Customer No." := SalesHeader."Sell-to Customer No.";
        CustomerOrderDetails."Document Type" := SalesHeader."Document Type";
        CustomerOrderDetails."Document No." := SalesHeader."No.";
        CustomerOrderDetails."Order Date" := SalesHeader."Order Date";
        CustomerOrderDetails."Posting Date" := SalesHeader."Posting Date";
        CustomerOrderDetails."Order Amount" := TotalAmount;
        CustomerOrderDetails."Order Amount (LCY)" := TotalAmount;
        CustomerOrderDetails."Salesperson Code" := SalesHeader."Salesperson Code";
        CustomerOrderDetails."Customer Classification" := Customer."Customer Classification";
        CustomerOrderDetails."Created Date Time" := CurrentDateTime();
        CustomerOrderDetails.Insert();
    end;



    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterInsertEvent', '', false, false)]
    local procedure OnAfterInsertSalesOrder(var Rec: Record "Sales Header")
    begin
        if Rec.IsTemporary() then
            exit;
            
        if Rec."Document Type" = Rec."Document Type"::Order then
            UpdateCustomerClassification(Rec."Sell-to Customer No.");
    end;

   

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterPostSalesDoc', '', false, false)]
    local procedure OnAfterPostSalesDocument(
        var SalesHeader: Record "Sales Header";
        var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
        SalesShptHdrNo: Code[20];
        SalesInvHdrNo: Code[20];
        SalesCrMemoHdrNo: Code[20];
        CommitIsSuppressed: Boolean)
    begin
        if SalesHeader."Document Type" = SalesHeader."Document Type"::Order then begin
            CreateOrderDetailsEntry(SalesHeader);
            // UpdateCustomerClassification(SalesHeader."Sell-to Customer No.");
        end;
    end;
}