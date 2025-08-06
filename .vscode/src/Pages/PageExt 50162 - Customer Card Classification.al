pageextension 50162 "Customer Card Classification" extends "Customer Card"
{
    layout
    {
        addafter("Salesperson Code")
        {
            group("Customer Classification")
            {
                Caption = 'Customer Classification';
                
                field("Customer Classification_"; Rec."Customer Classification")
                {
                    ApplicationArea = All;
                    ToolTip = 'Shows the customer classification based on number of sales orders';
                    StyleExpr = ClassificationStyle;
                }
                field("Total Sales Orders"; Rec."Total Sales Orders")
                {
                    ApplicationArea = All;
                    ToolTip = 'Shows the total number of sales orders for this customer';
                }
                field("Last Classification Update"; Rec."Last Classification Update")
                {
                    ApplicationArea = All;
                    ToolTip = 'Shows when the classification was last updated';
                }
            }
        }
    }

    actions
    {
        addafter("Ledger E&ntries")
        {
            action("Update Classification")
            {
                ApplicationArea = All;
                Caption = 'Update Classification';
                Image = Refresh;
                ToolTip = 'Updates the customer classification based on current sales orders';
                
                trigger OnAction()
                var
                    CustomerClassificationMgt: Codeunit "Customer Classification Mgt.";
                begin
                    CustomerClassificationMgt.UpdateCustomerClassification(Rec."No.");
                    CurrPage.Update();
                    Message('Customer classification has been updated.');
                end;
            }
            action("Order Details")
            {
                ApplicationArea = All;
                Caption = 'Order Details';
                Image = OrderList;
                ToolTip = 'Shows detailed order history for this customer';
                
                trigger OnAction()
                var
                    CustomerOrderDetails: Record "Customer Order Details";
                begin
                    CustomerOrderDetails.SetRange("Customer No.", Rec."No.");
                    Page.Run(Page::"Customer Order Details List", CustomerOrderDetails);
                end;
            }
        }
    }

    var
        ClassificationStyle: Text;

    trigger OnAfterGetRecord()
    begin
        SetClassificationStyle();
    end;

    local procedure SetClassificationStyle()
    begin
        case Rec."Customer Classification" of
            Rec."Customer Classification"::"New":
                ClassificationStyle := 'Unfavorable';
            Rec."Customer Classification"::"Bronze":
                ClassificationStyle := 'Ambiguous';
            Rec."Customer Classification"::"Silver":
                ClassificationStyle := 'Attention';
            Rec."Customer Classification"::"Gold":
                ClassificationStyle := 'Favorable';
        end;
    end;
}