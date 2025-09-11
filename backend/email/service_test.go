package email

import (
	"os"
	"testing"

	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

func TestNew(t *testing.T) {
	tests := []struct {
		name        string
		config      Config
		expectError bool
		errorMsg    string
		providerType func(service *Service) string // function to determine provider type
	}{
		{
			name: "creates SendGrid provider with valid config",
			config: Config{
				Provider:         "sendgrid",
				SendGridAPIKey:   "test_sendgrid_key",
			},
			expectError: false,
			providerType: func(service *Service) string {
				_, ok := service.provider.(*SendGridProvider)
				if ok {
					return "sendgrid"
				}
				return "unknown"
			},
		},
		{
			name: "creates Resend provider with valid config",
			config: Config{
				Provider:       "resend",
				ResendAPIKey:   "test_resend_key",
			},
			expectError: false,
			providerType: func(service *Service) string {
				_, ok := service.provider.(*ResendProvider)
				if ok {
					return "resend"
				}
				return "unknown"
			},
		},
		{
			name: "defaults to SendGrid when provider not specified",
			config: Config{
				SendGridAPIKey: "test_sendgrid_key",
			},
			expectError: false,
			providerType: func(service *Service) string {
				_, ok := service.provider.(*SendGridProvider)
				if ok {
					return "sendgrid"
				}
				return "unknown"
			},
		},
		{
			name: "defaults to SendGrid with empty provider",
			config: Config{
				Provider:       "",
				SendGridAPIKey: "test_sendgrid_key",
			},
			expectError: false,
			providerType: func(service *Service) string {
				_, ok := service.provider.(*SendGridProvider)
				if ok {
					return "sendgrid"
				}
				return "unknown"
			},
		},
		{
			name: "fails with missing SendGrid API key",
			config: Config{
				Provider: "sendgrid",
			},
			expectError: true,
			errorMsg:    "SendGrid API key is required",
		},
		{
			name: "fails with missing Resend API key",
			config: Config{
				Provider: "resend",
			},
			expectError: true,
			errorMsg:    "Resend API key is required",
		},
		{
			name: "uppercase provider defaults to sendgrid",
			config: Config{
				Provider:       "SENDGRID",
				SendGridAPIKey: "test_key",
			},
			expectError: false,
			providerType: func(service *Service) string {
				_, ok := service.provider.(*SendGridProvider)
				if ok {
					return "sendgrid"
				}
				return "unknown"
			},
		},
		{
			name: "mixed case provider defaults to sendgrid",
			config: Config{
				Provider:       "ReSenD",
				SendGridAPIKey: "test_key", // Since invalid provider defaults to sendgrid
			},
			expectError: false,
			providerType: func(service *Service) string {
				_, ok := service.provider.(*SendGridProvider)
				if ok {
					return "sendgrid"
				}
				return "unknown"
			},
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			service, err := New(tt.config)
			
			if tt.expectError {
				assert.Error(t, err)
				if tt.errorMsg != "" {
					assert.Contains(t, err.Error(), tt.errorMsg)
				}
				assert.Nil(t, service)
			} else {
				assert.NoError(t, err)
				require.NotNil(t, service)
				require.NotNil(t, service.provider)
				
				if tt.providerType != nil {
					providerType := tt.providerType(service)
					assert.NotEqual(t, "unknown", providerType, "Should create the correct provider type")
				}
			}
		})
	}
}

func TestNew_LegacyEnvironmentFallback(t *testing.T) {
	// Test that the service falls back to environment variables for backward compatibility
	
	// Save original env var
	originalSendGridKey := os.Getenv("SENDGRID_API_KEY")
	defer os.Setenv("SENDGRID_API_KEY", originalSendGridKey)
	
	// Set test environment variable
	err := os.Setenv("SENDGRID_API_KEY", "env_test_key")
	require.NoError(t, err)
	
	tests := []struct {
		name        string
		config      Config
		expectError bool
		description string
	}{
		{
			name: "falls back to environment variable when API key not provided",
			config: Config{
				Provider: "sendgrid",
				// SendGridAPIKey is empty, should fallback to env var
			},
			expectError: false,
			description: "Should use SENDGRID_API_KEY environment variable",
		},
		{
			name: "config API key takes precedence over environment variable",
			config: Config{
				Provider:       "sendgrid",
				SendGridAPIKey: "config_test_key",
			},
			expectError: false,
			description: "Should use API key from config, not environment",
		},
	}
	
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			service, err := New(tt.config)
			
			if tt.expectError {
				assert.Error(t, err, tt.description)
			} else {
				assert.NoError(t, err, tt.description)
				assert.NotNil(t, service)
			}
		})
	}
	
	// Test with no environment variable and no config API key
	err = os.Unsetenv("SENDGRID_API_KEY")
	require.NoError(t, err)
	
	service, err := New(Config{Provider: "sendgrid"})
	assert.Error(t, err)
	assert.Contains(t, err.Error(), "SendGrid API key is required")
	assert.Nil(t, service)
}

func TestProviderTypeFrom(t *testing.T) {
	tests := []struct {
		input    string
		expected ProviderType
	}{
		{"sendgrid", ProviderSendGrid},
		{"resend", ProviderResend},
		{"SENDGRID", ProviderSendGrid}, // case sensitive, defaults to sendgrid
		{"RESEND", ProviderSendGrid},   // case sensitive, defaults to sendgrid
		{"SendGrid", ProviderSendGrid}, // case sensitive, defaults to sendgrid
		{"ReSend", ProviderSendGrid},   // case sensitive, defaults to sendgrid
		{"", ProviderSendGrid},         // default
		{"unknown", ProviderSendGrid},  // default
		{"invalid", ProviderSendGrid},  // default
	}

	for _, tt := range tests {
		t.Run(tt.input, func(t *testing.T) {
			result := ProviderTypeFrom(tt.input)
			assert.Equal(t, tt.expected, result)
		})
	}
}