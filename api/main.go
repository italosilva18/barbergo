package main

import (
	"log"
	"net/http"
	"barbergo/api/config"
	"barbergo/api/controllers"
	"barbergo/api/middleware"
	"barbergo/api/models"

	"github.com/gin-gonic/gin"
)

func main() {
	config.ConnectDatabase()
	config.DB.AutoMigrate(&models.Appointment{}, &models.Service{})

	r := gin.Default()

	// Authentication routes
	r.POST("/api/login", controllers.Login)
	r.POST("/api/signup", controllers.Signup)
	r.POST("/api/forgot-password", controllers.ForgotPassword)

	// Protected routes
	auth := r.Group("/api")
	auth.Use(middleware.AuthMiddleware())
	{
		auth.GET("/protected", func(c *gin.Context) {
			c.JSON(http.StatusOK, gin.H{"message": "This is a protected route!"})
		})
		auth.POST("/appointments", controllers.CreateAppointment)
		auth.GET("/appointments", controllers.GetAppointments)
		auth.DELETE("/appointments/:id", controllers.DeleteAppointment)

		auth.POST("/services", controllers.CreateService)
		auth.GET("/services", controllers.GetServices)
		auth.GET("/services/:id", controllers.GetService)
		auth.PUT("/services/:id", controllers.UpdateService)
		auth.DELETE("/services/:id", controllers.DeleteService)
	}

	log.Println("Server started on port 8080")
	log.Fatal(r.Run(":8080"))
}
