page 50171 "Customer Classification Part"
{
    Caption = 'Customer Classification Overview';
    PageType = CardPart;
    SourceTable = Customer;
    Editable = false;

    layout
    {
        area(Content)
        {
            cuegroup("Classification Summary")
            {
                Caption = 'Customer Classification Summary';
                
                field("New Customers"; NewCustomers)
                {
                    ApplicationArea = All;
                    Caption = 'New Customers';
                    DrillDownPageId = "Customer List";
                    StyleExpr = 'Unfavorable';
                    
                    trigger OnDrillDown()
                    var
                        Customer: Record Customer;
                    begin
                        Customer.SetRange("Customer Classification", "Customer Classification"::"New");
                        Page.Run(Page::"Customer List", Customer);
                    end;
                }
                
                field("Bronze Customers"; BronzeCustomers)
                {
                    ApplicationArea = All;
                    Caption = 'Bronze Customers';
                    DrillDownPageId = "Customer List";
                    StyleExpr = 'Ambiguous';
                    
                    trigger OnDrillDown()
                    var
                        Customer: Record Customer;
                    begin
                        Customer.SetRange("Customer Classification", "Customer Classification"::"Bronze");
                        Page.Run(Page::"Customer List", Customer);
                    end;
                }
                
                field("Silver Customers"; SilverCustomers)
                {
                    ApplicationArea = All;
                    Caption = 'Silver Customers';
                    DrillDownPageId = "Customer List";
                    StyleExpr = 'Attention';
                    
                    trigger OnDrillDown()
                    var
                        Customer: Record Customer;
                    begin
                        Customer.SetRange("Customer Classification", "Customer Classification"::"Silver");
                        Page.Run(Page::"Customer List", Customer);
                    end;
                }
                
                field("Gold Customers"; GoldCustomers)
                {
                    ApplicationArea = All;
                    Caption = 'Gold Customers';
                    DrillDownPageId = "Customer List";
                    StyleExpr = 'Favorable';
                    
                    trigger OnDrillDown()
                    var
                        Customer: Record Customer;
                    begin
                        Customer.SetRange("Customer Classification", "Customer Classification"::"Gold");
                        Page.Run(Page::"Customer List", Customer);
                    end;
                }
            }
        }
    }

    var
        NewCustomers: Integer;
        BronzeCustomers: Integer;
        SilverCustomers: Integer;
        GoldCustomers: Integer;

    trigger OnOpenPage()
    begin
        UpdateCounts();
    end;

    trigger OnAfterGetCurrRecord()
    begin
        UpdateCounts();
    end;

    local procedure UpdateCounts()
    var
        Customer: Record Customer;
    begin
        Customer.SetRange("Customer Classification", "Customer Classification"::"New");
        NewCustomers := Customer.Count();

        Customer.SetRange("Customer Classification", "Customer Classification"::"Bronze");
        BronzeCustomers := Customer.Count();

        Customer.SetRange("Customer Classification", "Customer Classification"::"Silver");
        SilverCustomers := Customer.Count();

        Customer.SetRange("Customer Classification", "Customer Classification"::"Gold");
        GoldCustomers := Customer.Count();
    end;
}