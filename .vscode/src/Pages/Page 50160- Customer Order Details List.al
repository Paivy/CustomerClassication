page 50160 "Customer Order Details List"
{
    Caption = 'Customer Order Details List';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Customer Order Details";
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(Control1)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = All;
                }
                field("Customer Name"; Rec."Customer Name")
                {
                    ApplicationArea = All;
                }
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = All;
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                }
                field("Order Date"; Rec."Order Date")
                {
                    ApplicationArea = All;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                }
                field("Order Amount (LCY)"; Rec."Order Amount (LCY)")
                {
                    ApplicationArea = All;
                }
                field("Salesperson Code"; Rec."Salesperson Code")
                {
                    ApplicationArea = All;
                }
                field("Customer Classification"; Rec."Customer Classification")
                {
                    ApplicationArea = All;
                    StyleExpr = ClassificationStyle;
                }
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