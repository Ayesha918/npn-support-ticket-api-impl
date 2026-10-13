%dw 2.0
import fromSalesforce from dwl::StatusMap
fun toContract(t) = {
  sfId: t.Id,
  ticketId: t.Name,
  requestId: t.Request_ID__c,
  status: fromSalesforce(t.Ticket_Status__c default "NEW"),
  priority: t.Priority__c,
  team: t.Assigned_Team__c,
  customerTier: t.Customer_Tier__c default "STANDARD",
  ackDueAt: if (t.Acknowledgement_Due_At__c != null) (t.Acknowledgement_Due_At__c as String) else null,
  resolutionDueAt: if (t.Resolution_Due_At__c != null) (t.Resolution_Due_At__c as String) else null,
  createdAt: if (t.CreatedDate != null) (t.CreatedDate as String) else (now() as String)
}