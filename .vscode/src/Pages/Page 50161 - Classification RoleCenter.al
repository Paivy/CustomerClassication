pageextension 50161 "Classification" extends "Sales Manager Role Center"
{
    layout
    {
        addafter(Control1907692008)
        {
            part("Customer Classification"; "Customer Classification Part")
            {
                ApplicationArea = All;
                Caption = 'Customer Classification Overview';
            }
        }
    }

    actions
    {
        addafter("Sales Analysis Reports")
        {
            action("Customer Classification Report")
            {
                ApplicationArea = All;
                Caption = 'Customer Classification Report';
                Image = Report;
                RunObject = report "Customer Classification Report";
                ToolTip = 'View detailed customer classification report';
            }
            action("Customer Order Details")
            {
                ApplicationArea = All;
                Caption = 'Customer Order Details';
                Image = OrderList;
                RunObject = page "Customer Order Details List";
                ToolTip = 'View customer order history and details';
            }
        }
    }
}