tableextension 50174 "Customer Classification Ext" extends Customer
{
    fields
    {
        field(50120; "Customer Classification"; Enum "Customer Classification")
        {
            Caption = 'Customer Classification';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50121; "Total Sales Orders"; Integer)
        {
            Caption = 'Total Sales Orders';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = count("Sales Header" where("Document Type" = const(Order), "Sell-to Customer No." = field("No.")));
        }
        field(50122; "Last Classification Update"; DateTime)
        {
            Caption = 'Last Classification Update';
            DataClassification = CustomerContent;
            Editable = false;
        }
    }
}