package controllers

import (
	"net/http"
	"time"
	"barbergo/api/config"
	"barbergo/api/models"

	"github.com/gin-gonic/gin"
)

type CreateAppointmentInput struct {
	ServiceID uint      `json:"service_id" binding:"required"`
	DateTime  time.Time `json:"date_time" binding:"required"`
}

func CreateAppointment(c *gin.Context) {
	var input CreateAppointmentInput

	if err := c.ShouldBindJSON(&input); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	userID, exists := c.Get("userID")
	if !exists {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "User not authenticated"})
		return
	}

	appointment := models.Appointment{
		UserID:    userID.(uint),
		ServiceID: input.ServiceID,
		DateTime:  input.DateTime,
	}

	if err := config.DB.Create(&appointment).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to create appointment"})
		return
	}

	c.JSON(http.StatusCreated, gin.H{"message": "Appointment created successfully", "appointment": appointment})
}

func GetAppointments(c *gin.Context) {
	userID, exists := c.Get("userID")
	if !exists {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "User not authenticated"})
		return
	}

	var appointments []models.Appointment
	if err := config.DB.Where("user_id = ?", userID).Find(&appointments).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to fetch appointments"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"appointments": appointments})
}

func DeleteAppointment(c *gin.Context) {
	id := c.Param("id")

	var appointment models.Appointment
	if err := config.DB.First(&appointment, id).Error; err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Appointment not found"})
		return
	}

	userID, exists := c.Get("userID")
	if !exists || appointment.UserID != userID.(uint) {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "Unauthorized to delete this appointment"})
		return
	}

	if err := config.DB.Delete(&appointment).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to delete appointment"})
		return
	}

	c.JSON(http.StatusNoContent, nil)
}
