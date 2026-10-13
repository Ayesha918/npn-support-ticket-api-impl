%dw 2.0

/*
  Email Templates Generator
  Customer acknowledgement and team notification emails according to specification.
*/

fun buildCustomerAckSubject(ticketId: String, priority: String) =
    "[" ++ (ticketId default "TICKET") ++ "] " ++ (priority default "P3") ++ " – we have your request"

fun buildCustomerAckBody(ticket: Object) =
    "Dear " ++ (ticket.customerName default "Valued Customer") ++ ",\n\n" ++
    "We have logged your support request and assigned it to our " ++ (ticket.teamDisplayName default ticket.team default "Support") ++ " team.\n\n" ++
    " Ticket Reference : " ++ (ticket.ticketId default "") ++ "\n" ++
    " Logged At        : " ++ ((ticket.createdAt as String) default "") ++ "\n" ++
    " Priority         : " ++ (ticket.priority default "") ++ "\n" ++
    " Product          : " ++ (ticket.productName default ticket.productCode default "") ++ "\n" ++
    " Category         : " ++ (ticket.categoryDisplayName default ticket.categoryCode default "") ++ "\n\n" ++
    "What you told us\n " ++ (ticket.subject default "") ++ "\n\n" ++
    "We will respond by " ++ ((ticket.ackDueAt as String) default "N/A") ++ ". Our current target for a resolution is " ++ ((ticket.resolutionDueAt as String) default "N/A") ++ ".\n\n" ++
    "To add information, reply to this email leaving the subject line unchanged so that it reaches the same ticket. You can also check progress at " ++ (ticket.statusUrl default ("/api/v1/tickets/" ++ (ticket.ticketId default ""))) ++ ".\n\n" ++
    (if ((ticket.priority default "") == "P1") "This request is being handled as a priority one incident. Our on-call engineer has been paged.\n\n" else "") ++
    "Regards,\n" ++
    "NPN Customer Support\n"

fun buildTeamNoticeSubject(priority: String, ticketId: String, categoryCode: String) =
    (priority default "P3") ++ " " ++ (ticketId default "") ++ " – " ++ (categoryCode default "")

fun buildTeamNoticeBody(ticket: Object) =
    "Ticket   : " ++ (ticket.ticketId default "") ++ "\n" ++
    "Priority : " ++ (ticket.priority default "") ++ " (rule " ++ (ticket.matchedRuleId default "DEFAULT") ++ ")\n" ++
    "Customer : " ++ (ticket.customerName default "Customer") ++ " (" ++ (ticket.customerId default "") ++ ") – " ++ (ticket.customerTier default "STANDARD") ++ "\n" ++
    "Product  : " ++ (ticket.productCode default "") ++ "\n" ++
    "Category : " ++ (ticket.categoryCode default "") ++ "\n" ++
    "Impact   : " ++ ((ticket.affectedUserCount default 0) as String) ++ " users reported affected\n\n" ++
    "Subject\n " ++ (ticket.subject default "") ++ "\n\n" ++
    "Acknowledge by : " ++ ((ticket.ackDueAt as String) default "N/A") ++ "\n" ++
    "Resolve by     : " ++ ((ticket.resolutionDueAt as String) default "N/A") ++ "\n" ++
    "Assigned to    : " ++ (ticket.assignedTo default "UNASSIGNED") ++ "\n\n" ++
    "Open in console : " ++ (ticket.agentConsoleUrl default ("/console/tickets/" ++ (ticket.ticketId default ""))) ++ "\n\n" ++
    (if (ticket.isDefaultRoute == "Y") 
        "NOTE: no routing rule matched this ticket. It has been sent to the triage queue and the rule set needs review.\n" ++
        " category " ++ (ticket.categoryCode default "") ++ " / product " ++ (ticket.productCode default "") ++ "\n" ++
        " tier " ++ (ticket.customerTier default "UNKNOWN") ++ " / severity " ++ (ticket.statedSeverity default "UNKNOWN") ++ "\n\n"
     else "") ++
    (if (ticket.isUnassigned == true or ticket.status == "UNASSIGNED")
        "NOTE: no agent in " ++ (ticket.team default "Support") ++ " was available. This ticket is UNASSIGNED and needs a manual pick-up.\n\n"
     else "")
