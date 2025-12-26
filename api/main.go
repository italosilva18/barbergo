package main

import (
	"log"
	"net/http"
	"barbergo/api/config"
	"barbergo/api/controllers"
	"barbergo/api/middleware"
	"barbergo/api/models"

	"github.com/gin-contrib/cors"
	"github.com/gin-gonic/gin"
)

func main() {
	config.ConnectDatabase()
	config.DB.AutoMigrate(&models.Appointment{}, &models.Service{}, &models.Customer{})

	r := gin.Default()

	// CORS configuration
	r.Use(cors.New(cors.Config{
		AllowOrigins:     []string{"*"},
		AllowMethods:     []string{"GET", "POST", "PUT", "DELETE", "OPTIONS"},
		AllowHeaders:     []string{"Origin", "Content-Type", "Authorization"},
		ExposeHeaders:    []string{"Content-Length"},
		AllowCredentials: true,
	}))

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

		auth.POST("/customers", controllers.CreateCustomer)
		auth.GET("/customers", controllers.GetCustomers)
		auth.GET("/customers/:id", controllers.GetCustomer)
		auth.PUT("/customers/:id", controllers.UpdateCustomer)
		auth.DELETE("/customers/:id", controllers.DeleteCustomer)

		auth.GET("/analytics", controllers.GetAnalytics)
	}

	log.Println("Server started on port 8080")
	log.Fatal(r.Run(":8080"))
}
