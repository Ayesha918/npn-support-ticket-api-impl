%dw 2.0
output text/plain

/*
  Daily Ticket Report CSV Generator
  Header row: H,TICKET_REPORT,report_date,generated_at,version
  Column header row
  Data rows
  Trailer row: T,record_count,ack_breaches,res_breaches,default_routes,nil_report_flag,generated_at
*/

var reportDate = (vars.windowEnd as DateTime) as String {format: "yyyy-MM-dd"}
var generatedAtStr = vars.generatedAt as String {format: "yyyy-MM-dd'T'HH:mm:ssXXX"}
var tickets = payload default []
var recordCount = sizeOf(tickets)
var isNil = recordCount == 0

var ackBreaches = sizeOf(tickets filter ($.ack_breached == "Y" or $.ack_breached == true))
var resBreaches = sizeOf(tickets filter ($.res_breached == "Y" or $.res_breached == true))
var defaultRoutes = sizeOf(tickets filter ($.is_default_route == "Y" or $.is_default_route == true))
var nilFlag = if (isNil) 1 else 0

var headerLine = "H,TICKET_REPORT," ++ reportDate ++ "," ++ generatedAtStr ++ ",v1"
var columnHeaderLine = "ticketId,createdAt,customerId,tier,product,category,priority,team,assignedTo,status,ackDueAt,acknowledgedAt,ackBreached,resolutionDueAt,resolvedAt,resBreached,ruleId"

var dataLines = if (isNil) [] else (tickets default []) map ((t, idx) -> 
    [
        t.ticket_id default "",
        if (t.created_at != null) (t.created_at as String {format: "yyyy-MM-dd'T'HH:mm:ssXXX"}) else "",
        t.customer_id default "",
        t.customer_tier default "",
        t.product_code default "",
        t.category_code default "",
        t.priority default "",
        t.team default "",
        t.assigned_to default "",
        t.status default "",
        if (t.ack_due_at != null) (t.ack_due_at as String {format: "yyyy-MM-dd'T'HH:mm:ssXXX"}) else "",
        if (t.acknowledged_at != null) (t.acknowledged_at as String {format: "yyyy-MM-dd'T'HH:mm:ssXXX"}) else "",
        if (t.ack_breached == "Y" or t.ack_breached == true) "Y" else "N",
        if (t.resolution_due_at != null) (t.resolution_due_at as String {format: "yyyy-MM-dd'T'HH:mm:ssXXX"}) else "",
        if (t.resolved_at != null) (t.resolved_at as String {format: "yyyy-MM-dd'T'HH:mm:ssXXX"}) else "",
        if (t.res_breached == "Y" or t.res_breached == true) "Y" else "N",
        t.matched_rule_id default ""
    ] joinBy ","
)

var trailerLine = "T," ++ (recordCount as String) ++ "," ++ 
                  (ackBreaches as String) ++ "," ++ 
                  (resBreaches as String) ++ "," ++ 
                  (defaultRoutes as String) ++ "," ++ 
                  (nilFlag as String) ++ "," ++ 
                  generatedAtStr
---
(([headerLine, columnHeaderLine] ++ dataLines ++ [trailerLine]) joinBy "\n")
