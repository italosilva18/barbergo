package controllers

import (
	"net/http"
	"barbergo/api/config"
	"barbergo/api/models"

	"github.com/gin-gonic/gin"
)

type CreateServiceInput struct {
	Name        string  `json:"name" binding:"required"`
	Description string  `json:"description"`
	Price       float64 `json:"price" binding:"required"`
	Duration    int     `json:"duration" binding:"required"`
}

func CreateService(c *gin.Context) {
	var input CreateServiceInput

	if err := c.ShouldBindJSON(&input); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	service := models.Service{
		Name:        input.Name,
		Description: input.Description,
		Price:       input.Price,
		Duration:    input.Duration,
	}

	if err := config.DB.Create(&service).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to create service"})
		return
	}

	c.JSON(http.StatusCreated, gin.H{"message": "Service created successfully", "service": service})
}

func GetServices(c *gin.Context) {
	var services []models.Service
	if err := config.DB.Find(&services).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to fetch services"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"services": services})
}

func GetService(c *gin.Context) {
	id := c.Param("id")

	var service models.Service
	if err := config.DB.First(&service, id).Error; err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Service not found"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"service": service})
}

func UpdateService(c *gin.Context) {
	id := c.Param("id")

	var service models.Service
	if err := config.DB.First(&service, id).Error; err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Service not found"})
		return
	}

	var input CreateServiceInput // Reusing for update, consider a dedicated UpdateServiceInput if fields differ
	if err := c.ShouldBindJSON(&input); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	config.DB.Model(&service).Updates(models.Service{
		Name:        input.Name,
		Description: input.Description,
		Price:       input.Price,
		Duration:    input.Duration,
	})

	c.JSON(http.StatusOK, gin.H{"message": "Service updated successfully", "service": service})
}

func DeleteService(c *gin.Context) {
	id := c.Param("id")

	var service models.Service
	if err := config.DB.First(&service, id).Error; err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Service not found"})
		return
	}

	if err := config.DB.Delete(&service).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to delete service"})
		return
	}

	c.JSON(http.StatusNoContent, nil)
}
