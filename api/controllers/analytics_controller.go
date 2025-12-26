
package controllers

import (
	"net/http"

	"barbergo/api/config"
	"barbergo/api/models"

	"github.com/gin-gonic/gin"
)

func GetAnalytics(c *gin.Context) {
	var totalAppointments int64
	var totalCustomers int64
	var totalRevenue float64

	// Calculate Total Appointments
	if err := config.DB.Model(&models.Appointment{}).Count(&totalAppointments).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to fetch appointment count"})
		return
	}

	// Calculate Total Customers
	if err := config.DB.Model(&models.Customer{}).Count(&totalCustomers).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to fetch customer count"})
		return
	}

	// Calculate Total Revenue
	rows, err := config.DB.Model(&models.Appointment{}).Joins("join services on services.id = appointments.service_id").Select("sum(services.price) as total_revenue").Rows()
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to calculate revenue"})
		return
	}
	defer rows.Close()

	if rows.Next() {
		rows.Scan(&totalRevenue)
	}

	analyticsData := models.AnalyticsData{
		TotalAppointments: int(totalAppointments),
		TotalCustomers:    int(totalCustomers),
		TotalRevenue:      totalRevenue,
	}

	c.JSON(http.StatusOK, analyticsData)
}
