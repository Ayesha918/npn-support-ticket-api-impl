%dw 2.0
var transitions = {
  NEW: ["UNASSIGNED", "ASSIGNED", "CANCELLED"],
  UNASSIGNED: ["ASSIGNED", "CANCELLED"],
  ASSIGNED: ["IN_PROGRESS", "UNASSIGNED", "CANCELLED"],
  IN_PROGRESS: ["PENDING_CUSTOMER", "RESOLVED", "CANCELLED"],
  PENDING_CUSTOMER: ["IN_PROGRESS", "RESOLVED", "CANCELLED"],
  RESOLVED: ["CLOSED", "IN_PROGRESS"],
  CLOSED: [],
  CANCELLED: []
}
fun isAllowed(fromStatus: String, toStatus: String): Boolean =
  (transitions[upper(fromStatus default "")] default []) contains upper(toStatus default "")