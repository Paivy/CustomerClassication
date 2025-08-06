report 50160 "Customer Classification Report"
{
    Caption = 'Customer Classification Report';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = 'CustomerClassificationReport.rdl';

    dataset
    {
        dataitem(Customer; Customer)
        {
            RequestFilterFields = "No.", "Customer Classification", "Salesperson Code";
            
            column(CompanyName; CompanyProperty.DisplayName())
            {
            }
            column(ReportTitle; 'Customer Classification Report')
            {
            }
            column(PrintDate; Format(Today()))
            {
            }
            column(CustomerNo; "No.")
            {
            }
            column(CustomerName; Name)
            {
            }
            column(Classification; Format("Customer Classification"))
            {
            }
            column(TotalSalesOrders; "Total Sales Orders")
            {
            }
            column(LastUpdate; Format("Last Classification Update"))
            {
            }
            column(SalespersonCode; "Salesperson Code")
            {
            }
            column(City; City)
            {
            }
            column(PhoneNo; "Phone No.")
            {
            }

            trigger OnPreDataItem()
            begin
                CalcFields("Total Sales Orders");
            end;

            trigger OnAfterGetRecord()
            begin
                CalcFields("Total Sales Orders");
            end;
        }

        dataitem(ClassificationSummary; Integer)
        {
            DataItemTableView = sorting(Number) where(Number = filter(1..4));
            
            column(ClassificationName; ClassificationName)
            {
            }
            column(CustomerCount; CustomerCount)
            {
            }
            column(Percentage; Percentage)
            {
            }

            trigger OnAfterGetRecord()
            var
                TempCustomer: Record Customer temporary;
                TotalCustomers: Integer;
            begin
                Customer.CopyFilters(TempCustomer);
                TotalCustomers := Customer.Count();
                
                case Number of
                    1:
                        begin
                            ClassificationName := 'New';
                            Customer.SetRange("Customer Classification", "Customer Classification"::"New");
                            CustomerCount := Customer.Count();
                        end;
                    2:
                        begin
                            ClassificationName := 'Bronze';
                            Customer.SetRange("Customer Classification", "Customer Classification"::"Bronze");
                            CustomerCount := Customer.Count();
                        end;
                    3:
                        begin
                            ClassificationName := 'Silver';
                            Customer.SetRange("Customer Classification", "Customer Classification"::"Silver");
                            CustomerCount := Customer.Count();
                        end;
                    4:
                        begin
                            ClassificationName := 'Gold';
                            Customer.SetRange("Customer Classification", "Customer Classification"::"Gold");
                            CustomerCount := Customer.Count();
                        end;
                end;

                if TotalCustomers > 0 then
                    Percentage := Round((CustomerCount / TotalCustomers) * 100, 0.1)
                else
                    Percentage := 0;

                Customer.CopyFilters(TempCustomer);
            end;
        }
    }

    var
        ClassificationName: Text[50];
        CustomerCount: Integer;
        Percentage: Decimal;
}