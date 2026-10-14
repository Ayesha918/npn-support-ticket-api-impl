%dw 2.0
input payload application/java
output application/json skipNullOn="everywhere"

var ackDueStr = (payload.ackDueAt default null) as String default null
var ackedStr = (payload.acknowledgedAt default null) as String default null

var ackDue = if (ackDueStr != null and ackDueStr != "") (ackDueStr as DateTime default null) else null
var acked = if (ackedStr != null and ackedStr != "") (ackedStr as DateTime default null) else null
---
{
  ticketId: payload.ticketId,
  status: payload.status,
  priority: payload.priority,
  team: payload.team,
  assignedTo: payload.assignedTo,
  assignedAt: payload.assignedAt,
  acknowledgedAt: payload.acknowledgedAt,
  ackDueAt: payload.ackDueAt,
  ackBreached: if (ackDue == null) false else if (acked != null) (acked > ackDue) else (now() > ackDue)
}
