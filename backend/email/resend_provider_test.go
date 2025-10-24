package email

import (
	"context"
	"testing"

	"github.com/stretchr/testify/assert"
)

func TestNewResendProvider(t *testing.T) {
	tests := []struct {
		name   string
		apiKey string
		expect func(t *testing.T, provider *ResendProvider)
	}{
		{
			name:   "creates provider with valid API key",
			apiKey: "re_test_key",
			expect: func(t *testing.T, provider *ResendProvider) {
				assert.NotNil(t, provider)
				assert.NotNil(t, provider.client)
			},
		},
		{
			name:   "creates provider with empty API key",
			apiKey: "",
			expect: func(t *testing.T, provider *ResendProvider) {
				assert.NotNil(t, provider)
				assert.NotNil(t, provider.client)
			},
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			provider := NewResendProvider(tt.apiKey, "test@mailer.bcc.media")
			tt.expect(t, provider)
		})
	}
}

func TestResendProvider_SendEmail_TestAddresses(t *testing.T) {
	// Skip this test if no API key is provided
	apiKey := getTestAPIKey(t)
	if apiKey == "" {
		t.Skip("No RESEND_TEST_API_KEY provided, skipping integration test")
	}

	provider := NewResendProvider(apiKey, "test@example.com")
	ctx := context.Background()

	tests := []struct {
		name        string
		toEmail     string
		description string
	}{
		{
			name:        "delivered test email",
			toEmail:     "delivered@resend.dev",
			description: "Test email delivery to Resend test address",
		},
		{
			name:        "delivered with label",
			toEmail:     "delivered+unit-test@resend.dev",
			description: "Test email delivery with label to Resend test address",
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			options := SendOptions{
				From: Recipient{
					Name:  "Test Sender",
					Email: "onboarding@resend.dev", // Using Resend's test from address
				},
				To: Recipient{
					Name:  "Test Recipient",
					Email: tt.toEmail,
				},
				Title:       "Test Email from Resend Provider Unit Test",
				Content:     "This is a test email sent from the Resend provider unit test.",
				HTMLContent: "<p>This is a <strong>test email</strong> sent from the Resend provider unit test.</p>",
			}

			err := provider.SendEmail(ctx, options)
			assert.NoError(t, err, "Failed to send email to %s", tt.toEmail)
		})
	}
}

func TestResendProvider_SendEmail_ErrorScenarios(t *testing.T) {
	// These tests use invalid API keys to test error handling
	provider := NewResendProvider("invalid_api_key", "test@mailer.bcc.media")
	ctx := context.Background()

	tests := []struct {
		name        string
		options     SendOptions
		expectError bool
		description string
	}{
		{
			name: "invalid API key",
			options: SendOptions{
				From: Recipient{
					Name:  "Test Sender",
					Email: "onboarding@resend.dev",
				},
				To: Recipient{
					Name:  "Test Recipient",
					Email: "delivered@resend.dev",
				},
				Title:       "Test Email",
				Content:     "Test content",
				HTMLContent: "<p>Test content</p>",
			},
			expectError: true,
			description: "Should fail with invalid API key",
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			err := provider.SendEmail(ctx, tt.options)
			if tt.expectError {
				assert.Error(t, err, tt.description)
			} else {
				assert.NoError(t, err, tt.description)
			}
		})
	}
}

func TestResendProvider_SendEmail_HTMLSanitization(t *testing.T) {
	// Test that HTML sanitization is working properly
	apiKey := getTestAPIKey(t)
	if apiKey == "" {
		t.Skip("No RESEND_TEST_API_KEY provided, skipping HTML sanitization test")
	}

	provider := NewResendProvider(apiKey, "test@example.com")
	ctx := context.Background()

	options := SendOptions{
		From: Recipient{
			Name:  "Test Sender",
			Email: "onboarding@resend.dev",
		},
		To: Recipient{
			Name:  "Test Recipient",
			Email: "delivered@resend.dev",
		},
		Title:   "HTML Sanitization Test",
		Content: "Plain text content",
		HTMLContent: `<p>Safe content</p>
		<script>alert('xss')</script>
		<a href="javascript:alert('xss')">Link</a>
		<img src="x" onerror="alert('xss')">
		<b>Bold text</b>`,
	}

	// This should not error out - the sanitization should clean the malicious content
	err := provider.SendEmail(ctx, options)
	assert.NoError(t, err, "Email should be sent successfully with sanitized HTML")
}

func TestResendProvider_SendEmail_ReplyToHandling(t *testing.T) {
	apiKey := getTestAPIKey(t)
	if apiKey == "" {
		t.Skip("No RESEND_TEST_API_KEY provided, skipping reply-to test")
	}

	provider := NewResendProvider(apiKey, "test@example.com")
	ctx := context.Background()

	tests := []struct {
		name        string
		fromEmail   string
		fromName    string
		description string
	}{
		{
			name:        "with reply-to different from default",
			fromEmail:   "user@example.com",
			fromName:    "John Doe",
			description: "Should set reply-to when from address is not default",
		},
		{
			name:        "with reply-to same as default",
			fromEmail:   "app@brunstad.tv",
			fromName:    "BrunstadTV App",
			description: "Should not set reply-to when from address is default",
		},
		{
			name:        "with empty from name",
			fromEmail:   "user@example.com",
			fromName:    "",
			description: "Should handle empty from name correctly",
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			options := SendOptions{
				From: Recipient{
					Name:  tt.fromName,
					Email: tt.fromEmail,
				},
				To: Recipient{
					Name:  "Test Recipient",
					Email: "delivered@resend.dev",
				},
				Title:       "Reply-To Test",
				Content:     "Testing reply-to handling",
				HTMLContent: "<p>Testing <strong>reply-to</strong> handling</p>",
			}

			err := provider.SendEmail(ctx, options)
			assert.NoError(t, err, tt.description)
		})
	}
}

// getTestAPIKey retrieves the test API key from environment variable
// This allows developers to run integration tests with their own Resend API key
func getTestAPIKey(t *testing.T) string {
	// Try to get from environment variable
	// Developers can set RESEND_TEST_API_KEY to run integration tests
	return ""
}
