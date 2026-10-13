%dw 2.0
var toSf = {
  NEW: "NEW",
  UNASSIGNED: "UNASSIGNED",
  ASSIGNED: "ASSIGNED",
  IN_PROGRESS: "IN_PROGRESS",
  PENDING_CUSTOMER: "PENDING_CUSTOMER",
  RESOLVED: "RESOLVED",
  CLOSED: "CLOSED",
  CANCELLED: "CANCELLED"
}
fun toSalesforce(s: String) = toSf[upper(s default "")] default upper(s default "NEW")
fun fromSalesforce(s: String) = upper(s default "NEW")
