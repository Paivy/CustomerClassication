pageextension 50163 "Customer List Classification" extends "Customer List"
{
    layout
    {
        addafter("Salesperson Code")
        {
            field("Customer Classification"; Rec."Customer Classification")
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
        }
    }

    actions
    {
        addafter("Return Orders")
        {
           
                action("Update All Classifications")
                {
                    ApplicationArea = All;
                    Caption = 'Update All Classifications';
                    Image = UpdateUnitCost;
                    ToolTip = 'Updates classification for all customers based on their sales orders';
                    
                    trigger OnAction()
                    var
                        CustomerClassificationMgt: Codeunit "Customer Classification Mgt.";
                    begin
                        CustomerClassificationMgt.UpdateAllCustomerClassifications();
                        CurrPage.Update();
                    end;
                }
                
                action("Classification Report")
                {
                    ApplicationArea = All;
                    Caption = 'Classification Report';
                    Image = Report;
                    
                    trigger OnAction()
                    var
                        Customer: Record Customer;
                    begin
                        Customer := Rec;
                        Report.RunModal(Report::"Customer Classification Report", true, false, Customer);
                    end;
                }
            
        }
    }

    var
        ClassificationStyle: Text;

    trigger OnAfterGetRecord()
    begin
        case Rec."Customer Classification" of
            Rec."Customer Classification"::New:
                ClassificationStyle := 'Unfavorable';
            Rec."Customer Classification"::Bronze:
                ClassificationStyle := 'Ambiguous';
            Rec."Customer Classification"::Silver:
                ClassificationStyle := 'Attention';
            Rec."Customer Classification"::Gold:
                ClassificationStyle := 'Favorable';
        end;
    end;
}