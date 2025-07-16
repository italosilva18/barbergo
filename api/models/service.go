package models

import (
	"gorm.io/gorm"
)

type Service struct {
	gorm.Model
	Name        string  `json:"name"`
	Description string  `json:"description"`
	Price       float64 `json:"price"`
	Duration    int     `json:"duration"` // Duration in minutes
}
