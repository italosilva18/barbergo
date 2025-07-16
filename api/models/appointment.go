package models

import (
	"time"

	"gorm.io/gorm"
)

type Appointment struct {
	gorm.Model
	UserID    uint      `json:"user_id"`
	ServiceID uint      `json:"service_id"`
	DateTime  time.Time `json:"date_time"`
}
