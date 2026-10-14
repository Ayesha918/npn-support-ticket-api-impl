%dw 2.0
import fromSalesforce from dwl::StatusMap

fun toIst(val) =
  if (val == null) null
  else do {
    var dt = (val as DateTime default null)
    ---
    if (dt != null) ((dt >> "+05:30") as String {format: "yyyy-MM-dd'T'HH:mm:ss.SSSXXX"})
    else (val as String)
  }

fun toContract(t) = {
  sfId: t.Id,
  ticketId: t.Name,
  requestId: t.Request_ID__c,
  status: fromSalesforce(t.Ticket_Status__c default "NEW"),
  priority: t.Priority__c,
  team: t.Assigned_Team__c,
  customerTier: t.Customer_Tier__c default "STANDARD",
  ackDueAt: toIst(t.Acknowledgement_Due_At__c),
  resolutionDueAt: toIst(t.Resolution_Due_At__c),
  createdAt: toIst(t.CreatedDate default (now() >> "+05:30"))
}