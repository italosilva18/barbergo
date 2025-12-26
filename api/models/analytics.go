
package models

type AnalyticsData struct {
	TotalAppointments int     `json:"total_appointments"`
	TotalCustomers    int     `json:"total_customers"`
	TotalRevenue      float64 `json:"total_revenue"`
}
