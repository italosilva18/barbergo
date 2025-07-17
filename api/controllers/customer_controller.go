
package controllers

import (
	"net/http"

	"barbergo/api/config"
	"barbergo/api/models"

	"github.com/gin-gonic/gin"
)

type CreateCustomerInput struct {
	Name  string `json:"name" binding:"required"`
	Email string `json:"email" binding:"required"`
	Phone string `json:"phone"`
	Notes string `json:"notes"`
}

func CreateCustomer(c *gin.Context) {
	var input CreateCustomerInput

	if err := c.ShouldBindJSON(&input); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	customer := models.Customer{
		Name:  input.Name,
		Email: input.Email,
		Phone: input.Phone,
		Notes: input.Notes,
	}

	if err := config.DB.Create(&customer).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to create customer"})
		return
	}

	c.JSON(http.StatusCreated, gin.H{"message": "Customer created successfully", "customer": customer})
}

func GetCustomers(c *gin.Context) {
	var customers []models.Customer
	if err := config.DB.Find(&customers).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to fetch customers"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"customers": customers})
}

func GetCustomer(c *gin.Context) {
	id := c.Param("id")

	var customer models.Customer
	if err := config.DB.First(&customer, id).Error; err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Customer not found"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"customer": customer})
}

type UpdateCustomerInput struct {
	Name  string `json:"name"`
	Email string `json:"email"`
	Phone string `json:"phone"`
	Notes string `json:"notes"`
}

func UpdateCustomer(c *gin.Context) {
	id := c.Param("id")

	var customer models.Customer
	if err := config.DB.First(&customer, id).Error; err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Customer not found"})
		return
	}

	var input UpdateCustomerInput
	if err := c.ShouldBindJSON(&input); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	if err := config.DB.Model(&customer).Updates(input).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to update customer"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "Customer updated successfully", "customer": customer})
}

func DeleteCustomer(c *gin.Context) {
	id := c.Param("id")

	var customer models.Customer
	if err := config.DB.First(&customer, id).Error; err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Customer not found"})
		return
	}

	if err := config.DB.Delete(&customer).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to delete customer"})
		return
	}

	c.JSON(http.StatusNoContent, nil)
}
