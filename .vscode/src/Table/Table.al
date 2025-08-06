
table 50165 "Customer Order Details"
{
    Caption = 'Customer Order Details';
    DataClassification = CustomerContent;
    LookupPageId = "Customer Order Details List";
    DrillDownPageId = "Customer Order Details List";

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            AutoIncrement = true;
        }
        field(10; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            TableRelation = Customer;
        }
        field(11; "Customer Name"; Text[100])
        {
            Caption = 'Customer Name';
            FieldClass = FlowField;
            CalcFormula = lookup(Customer.Name where("No." = field("Customer No.")));
            Editable = false;
        }
        field(20; "Document Type"; Enum "Sales Document Type")
        {
            Caption = 'Document Type';
        }
        field(21; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(22; "Order Date"; Date)
        {
            Caption = 'Order Date';
        }
        field(23; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(30; "Order Amount"; Decimal)
        {
            Caption = 'Order Amount';
            AutoFormatType = 1;
        }
        field(31; "Order Amount (LCY)"; Decimal)
        {
            Caption = 'Order Amount (LCY)';
            AutoFormatType = 1;
        }
        field(40; "Salesperson Code"; Code[20])
        {
            Caption = 'Salesperson Code';
            TableRelation = "Salesperson/Purchaser";
        }
        field(50; "Customer Classification"; Enum "Customer Classification")
        {
            Caption = 'Customer Classification';
        }
        field(51; "Created Date Time"; DateTime)
        {
            Caption = 'Created Date Time';
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
        key(Customer; "Customer No.", "Posting Date")
        {
        }
        key(Classification; "Customer Classification", "Customer No.")
        {
        }
    }
}